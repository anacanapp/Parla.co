import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../ui/brand.dart';
import 'temp_file.dart';

/// Takes one front-camera photo and returns its bytes. The temporary file
/// the camera writes is deleted at once: the photo exists only in memory,
/// is never saved to the gallery and never leaves the phone.
class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({super.key});

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _controller;
  bool _failed = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _open();
  }

  Future<void> _open() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw CameraException('none', 'No camera');
      final camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() => _controller = controller);
    } on Object {
      if (mounted) setState(() => _failed = true);
    }
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || _busy) return;
    setState(() => _busy = true);
    Uint8List? bytes;
    try {
      final file = await controller.takePicture();
      try {
        bytes = await file.readAsBytes();
      } finally {
        await deleteTempFile(file.path);
      }
    } on Object {
      if (mounted) setState(() => _failed = true);
    }
    if (!mounted) return;
    setState(() => _busy = false);
    if (bytes != null) Navigator.of(context).pop(bytes);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final controller = _controller;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(l10n.skinCameraTitle),
      ),
      body: SafeArea(
        child: _failed
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.skinCameraFailed,
                    textAlign: TextAlign.center,
                    style: text.bodyLarge?.copyWith(color: Colors.white),
                  ),
                ),
              )
            : controller == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 1 / controller.value.aspectRatio,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CameraPreview(controller),
                            const CustomPaint(painter: FaceGuidePainter()),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.skinCameraHint,
                      textAlign: TextAlign.center,
                      style: text.bodyMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Semantics(
                      button: true,
                      label: l10n.skinCameraShoot,
                      child: GestureDetector(
                        key: const ValueKey('skin-camera-shoot'),
                        onTap: _busy ? null : _capture,
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _busy ? Colors.white54 : Colors.white,
                            border: Border.all(
                              color: ParlaColors.cream,
                              width: 4,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// The oval the face should fill; the analysis reads the same oval
/// (centred, 60 % of the width, 75 % of the height).
class FaceGuidePainter extends CustomPainter {
  const FaceGuidePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final oval = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: size.width * 0.6,
      height: size.height * 0.75,
    );
    final shade = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size)
      ..addOval(oval);
    canvas
      ..drawPath(shade, Paint()..color = Colors.black45)
      ..drawOval(
        oval,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..color = Colors.white,
      );
  }

  @override
  bool shouldRepaint(FaceGuidePainter oldDelegate) => false;
}
