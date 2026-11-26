import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parla/ui/brand.dart';
import 'package:parla/ui/night.dart';

/// WCAG 2 contrast ratio of two opaque colours.
double contrast(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final (hi, lo) = la > lb ? (la, lb) : (lb, la);
  return (hi + .05) / (lo + .05);
}

void main() {
  const surfaces = {
    'cream': ParlaColors.cream,
    'white': ParlaColors.white,
    'lemon': ParlaColors.lemon,
    'sky': ParlaColors.sky,
    'sage': ParlaColors.sage,
    'sageTint': ParlaColors.sageTint,
    'blush': ParlaColors.blush,
    'lilac': ParlaColors.lilac,
  };
  const inks = {
    'espresso': ParlaColors.espresso,
    'sunInk': ParlaColors.sunInk,
    'muted': ParlaColors.muted,
  };

  test('every text colour passes AA on every surface', () {
    for (final ink in inks.entries) {
      for (final surface in surfaces.entries) {
        expect(
          contrast(ink.value, surface.value),
          greaterThanOrEqualTo(4.5),
          reason: '${ink.key} on ${surface.key}',
        );
      }
    }
  });

  test('paired surfaces and inks pass AA', () {
    const pairs = [
      (ParlaColors.white, ParlaColors.espresso, 'white on espresso'),
      (ParlaColors.espresso, ParlaColors.sun, 'espresso on sun'),
      (ParlaColors.sportBlueText, ParlaColors.sportBlue, 'sport blue'),
      (ParlaColors.sportBlue, ParlaColors.sportBlueText, 'sport button'),
    ];
    for (final (ink, surface, name) in pairs) {
      expect(contrast(ink, surface), greaterThanOrEqualTo(4.5), reason: name);
    }
  });

  test('controls and fills reach 3:1', () {
    expect(contrast(ParlaColors.outline, ParlaColors.white), greaterThan(3));
    // Banana (sun) is the brand fill of the light design; a chosen state
    // in banana always carries espresso ink and a dark outline or tick,
    // so the state never rests on the yellow alone.
    expect(contrast(ParlaColors.espresso, ParlaColors.sun), greaterThan(4.5));
    expect(contrast(ParlaColors.waterFill, ParlaColors.sky), greaterThan(3));
    expect(
      contrast(ParlaColors.moveFill, ParlaColors.moveTrack),
      greaterThan(3),
    );
  });

  test('each mesh tone ink passes AA on both gradient stops', () {
    for (final tone in MeshTone.values) {
      expect(
        contrast(tone.ink, tone.from),
        greaterThanOrEqualTo(4.5),
        reason: '${tone.name} top',
      );
      expect(
        contrast(tone.ink, tone.to),
        greaterThanOrEqualTo(4.5),
        reason: '${tone.name} bottom',
      );
      expect(
        contrast(tone.ink, tone.deep),
        greaterThanOrEqualTo(4.5),
        reason: '${tone.name} deepest',
      );
    }
  });

  test('light ink passes AA on every pebble stop', () {
    for (final stop in PebbleCard.stops) {
      expect(
        contrast(const Color(0xFFFFFFFF), stop),
        greaterThanOrEqualTo(4.5),
        reason: '$stop',
      );
    }
  });
}
