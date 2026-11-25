import 'package:flutter/material.dart';
import 'package:parla_shared/parla_shared.dart';

import '../ui/warm.dart';

/// The photo of a workout card, by the workout's type (owner 2026-11-25:
/// a photo per workout, warm style A). The photos are AI images made for
/// Parla (no real person), shipped with the app; each type has one to three
/// and the workout number picks one so neighbouring cards differ.
String workoutPhoto(Workout w) {
  const counts = {
    'fitness': 3,
    'stretching': 2,
    'cardio': 2,
    'pilates': 2,
    'wall_pilates': 1,
    'yoga': 3,
    'face_yoga': 1,
  };
  final type = counts.containsKey(w.type) ? w.type : 'yoga';
  final number = switch (w.id) {
    'yoga_morning' => 0,
    'yoga_evening' => 1,
    'yoga_stretch' => 2,
    _ => (int.tryParse(w.id.replaceAll(RegExp(r'\D'), '')) ?? 1) - 1,
  };
  return 'assets/images/workouts/${type}_${number % counts[type]! + 1}.jpg';
}

/// A workout as a photo card: the photo, a dark fade at the bottom with
/// the title and a line under it, an optional badge at the top and a tick
/// when it is done. The photos leave room above the head, so the crop
/// keeps the upper part of the picture.
class WorkoutPhotoCard extends StatelessWidget {
  const WorkoutPhotoCard({
    super.key,
    required this.workout,
    required this.title,
    required this.subtitle,
    this.badge,
    this.done = false,
    this.doneLabel,
    this.height = 200,
    this.width,
    this.titleSize = 22,
    this.onTap,
  });

  final Workout workout;
  final String title;
  final String subtitle;
  final String? badge;
  final bool done;

  /// Read out with a done card ("Done").
  final String? doneLabel;
  final double height;
  final double? width;
  final double titleSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(width == null ? 28 : 22);
    return Semantics(
      button: onTap != null,
      label: [
        title,
        subtitle,
        ?badge,
        if (done && doneLabel != null) doneLabel!,
      ].join(', '),
      excludeSemantics: true,
      child: SizedBox(
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: radius,
          child: Material(
            color: Warm.black,
            child: InkWell(
              onTap: onTap,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    workoutPhoto(workout),
                    fit: BoxFit.cover,
                    alignment: const Alignment(0, -0.35),
                    excludeFromSemantics: true,
                    errorBuilder: (_, _, _) =>
                        const ColoredBox(color: Warm.black),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.35, 1],
                        colors: [Color(0x00140A06), Color(0xD6140A06)],
                      ),
                    ),
                  ),
                  if (badge != null)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xE6FFFFFF),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          badge!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Warm.black,
                          ),
                        ),
                      ),
                    ),
                  if (done)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 18,
                          color: Warm.black,
                        ),
                      ),
                    ),
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 14,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: titleSize,
                            height: 1.15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xE6FFFFFF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
