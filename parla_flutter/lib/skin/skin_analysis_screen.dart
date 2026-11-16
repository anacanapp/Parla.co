import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../home/widgets/home_cards.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/common.dart';
import '../ui/parla_icons.dart';
import 'camera_capture_screen.dart';
import 'skin_photo_analysis.dart';

enum _Stage { choose, notice, analysing, problem, result }

/// Face skin analysis, by questions (the quiz) or by one make-up-free
/// photo. The photo is analysed in memory on the phone and dropped right
/// after: it is never stored, sent or exported. The photo result is only
/// a cosmetic first suggestion that prefills the quiz, where the user
/// confirms or changes it.
class SkinAnalysisScreen extends StatefulWidget {
  const SkinAnalysisScreen({super.key});

  /// Opens the camera and returns the photo bytes, or `null` when the user
  /// backs out. Replaced in tests.
  static Future<Uint8List?> Function(BuildContext context) takePhoto =
      _openCamera;

  /// Runs the analysis away from the UI thread. Replaced in tests.
  static Future<SkinPhotoResult> Function(Uint8List bytes) analyse = (bytes) =>
      compute(analyseSkinPhoto, bytes);

  static Future<Uint8List?> _openCamera(BuildContext context) =>
      Navigator.of(context).push<Uint8List>(
        MaterialPageRoute(builder: (_) => const CameraCaptureScreen()),
      );

  @override
  State<SkinAnalysisScreen> createState() => _SkinAnalysisScreenState();
}

class _SkinAnalysisScreenState extends State<SkinAnalysisScreen> {
  _Stage _stage = _Stage.choose;
  bool _agreed = false;
  SkinPhotoResult? _result;

  String get _language =>
      ParlaScope.of(context).settings.language ?? defaultLanguage;

  Future<void> _photo() async {
    var bytes = await SkinAnalysisScreen.takePhoto(context);
    if (!mounted || bytes == null) return;
    setState(() => _stage = _Stage.analysing);
    SkinPhotoResult result;
    try {
      result = await SkinAnalysisScreen.analyse(bytes);
    } on Object {
      result = const SkinPhotoResult(problem: PhotoProblem.unreadable);
    }
    // Drop the only reference to the photo; nothing else kept it.
    bytes = null;
    if (!mounted) return;
    setState(() {
      _result = result;
      _stage = result.ok ? _Stage.result : _Stage.problem;
    });
  }

  void _toQuiz({Map<String, List<String>>? prefill}) =>
      context.go(Routes.quiz, extra: prefill);

  Map<String, List<String>> _prefill(SkinPhotoResult r) => {
    if (r.skinType != null) 'skin_type': [r.skinType!],
    if (r.concerns.isNotEmpty) 'concerns': r.concerns,
  };

  String _label(String questionId, String optionId) =>
      quizQuestion(questionId)?.option(optionId)?.text[_language] ?? optionId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    void back() => context.go(Routes.habits);

    Widget point(String value) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ParlaIcon(ParlaIconName.check, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(value, style: text.bodyMedium)),
        ],
      ),
    );

    return switch (_stage) {
      _Stage.choose => ParlaPage(
        title: l10n.skinTitle,
        onBack: back,
        children: [
          Text(l10n.skinIntro, style: text.bodyLarge),
          const SizedBox(height: 20),
          _PathCard(
            key: const ValueKey('skin-by-questions'),
            icon: ParlaIconName.routine,
            title: l10n.skinByQuestions,
            body: l10n.skinByQuestionsBody,
            onTap: () => _toQuiz(),
          ),
          const SizedBox(height: 12),
          _PathCard(
            key: const ValueKey('skin-by-photo'),
            icon: ParlaIconName.scan,
            title: l10n.skinByPhoto,
            body: l10n.skinByPhotoBody,
            onTap: () => setState(() => _stage = _Stage.notice),
          ),
          const SizedBox(height: 20),
          Text(
            l10n.skinNotMedical,
            style: text.bodySmall?.copyWith(color: ParlaColors.muted),
          ),
        ],
      ),
      _Stage.notice => ParlaPage(
        title: l10n.skinNoticeTitle,
        onBack: () => setState(() => _stage = _Stage.choose),
        primaryLabel: l10n.skinTakePhoto,
        onPrimary: _agreed ? _photo : null,
        children: [
          point(l10n.skinNoticeDevice),
          point(l10n.skinNoticeWhat),
          point(l10n.skinNoticeAccuracy),
          point(l10n.skinNoticeHow),
          const SizedBox(height: 8),
          CheckboxListTile(
            key: const ValueKey('skin-agree'),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _agreed,
            onChanged: (v) => setState(() => _agreed = v ?? false),
            title: Text(l10n.skinNoticeAgree, style: text.bodyMedium),
          ),
        ],
      ),
      _Stage.analysing => Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(l10n.skinAnalysing, style: text.bodyLarge),
            ],
          ),
        ),
      ),
      _Stage.problem => ParlaPage(
        title: l10n.skinRetakeTitle,
        onBack: () => setState(() => _stage = _Stage.choose),
        primaryLabel: l10n.skinRetake,
        onPrimary: _photo,
        secondary: [
          TextButton(
            key: const ValueKey('skin-problem-questions'),
            onPressed: () => _toQuiz(),
            child: Text(l10n.skinUseQuestions),
          ),
        ],
        children: [
          Text(
            switch (_result?.problem) {
              PhotoProblem.tooDark => l10n.skinProblemDark,
              PhotoProblem.tooBright => l10n.skinProblemBright,
              PhotoProblem.blurry => l10n.skinProblemBlurry,
              _ => l10n.skinProblemUnreadable,
            },
            key: const ValueKey('skin-problem'),
            style: text.bodyLarge,
          ),
          const SizedBox(height: 12),
          Text(l10n.skinNoticeHow, style: text.bodyMedium),
        ],
      ),
      _Stage.result => _resultPage(l10n, text, point),
    };
  }

  Widget _resultPage(
    AppLocalizations l10n,
    TextTheme text,
    Widget Function(String) point,
  ) {
    final r = _result!;
    final type = r.skinType;
    return ParlaPage(
      title: l10n.skinResultTitle,
      onBack: () => setState(() => _stage = _Stage.choose),
      primaryLabel: l10n.skinContinue,
      onPrimary: () => _toQuiz(prefill: _prefill(r)),
      secondary: [
        TextButton(
          key: const ValueKey('skin-retake'),
          onPressed: _photo,
          child: Text(l10n.skinRetake),
        ),
      ],
      children: [
        Text(l10n.skinResultIntro, style: text.bodyLarge),
        const SizedBox(height: 16),
        SoftCard(
          key: const ValueKey('skin-result'),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.skinResultType, style: text.titleMedium),
              const SizedBox(height: 4),
              Text(
                type == null
                    ? l10n.skinResultTypeUnknown
                    : _label('skin_type', type),
                style: text.bodyLarge,
              ),
              const SizedBox(height: 14),
              Text(l10n.skinResultConcerns, style: text.titleMedium),
              const SizedBox(height: 4),
              Text(
                r.concerns.isEmpty
                    ? l10n.skinResultNoConcerns
                    : r.concerns.map((c) => _label('concerns', c)).join(', '),
                style: text.bodyLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        point(l10n.skinResultDeleted),
        point(l10n.skinNotMedical),
      ],
    );
  }
}

class _PathCard extends StatelessWidget {
  const _PathCard({
    super.key,
    required this.icon,
    required this.title,
    required this.body,
    required this.onTap,
  });

  final ParlaIconName icon;
  final String title;
  final String body;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return SoftCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              ParlaIcon(icon, size: 28),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: text.titleMedium),
                    const SizedBox(height: 2),
                    Text(body, style: text.bodyMedium),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
