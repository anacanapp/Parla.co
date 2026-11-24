import 'package:flutter/material.dart';

import '../services/parla_api.dart';
import '../ui/brand.dart';
import '../ui/night.dart';
import '../ui/parla_icons.dart';
import 'blog_widgets.dart';

/// One section of the Discover tiles.
class BentoSection {
  const BentoSection({
    required this.title,
    required this.hint,
    required this.icon,
    required this.onTap,
    this.id,
    this.value,
    this.valueSuffix,
    this.caption,
  });

  /// Names the tile for tests (`discover-<id>`).
  final String? id;
  final String title;

  /// What the section holds; read out with the title, and shown when the
  /// tile has no [value].
  final String hint;
  final ParlaIconName icon;
  final VoidCallback onTap;

  /// A large number on the tile (e.g. "76"), with an optional smaller
  /// [valueSuffix] ("/ 3") and the [caption] under it ("recipes").
  final String? value;
  final String? valueSuffix;
  final String? caption;

  /// What a screen reader says for the whole tile.
  String get semantics => [
    title,
    if (value != null)
      [value, valueSuffix, caption].whereType<String>().join(' '),
    hint,
  ].join('. ');
}

/// The Discover tiles of the night design (prototype "Alətlər"): a pink
/// Blogs tile with the article count and the newest title, a 2×2 grid of
/// gradient tiles (sport, nutrition, experts, shop), a wide reminders tile
/// and two glass capsules (shopping list, journal). Tiles have minimum
/// heights and grow with the user's text size instead of clipping.
class DiscoverBento extends StatelessWidget {
  const DiscoverBento({
    super.key,
    required this.blogs,
    required this.nutrition,
    required this.sport,
    required this.experts,
    required this.shopping,
    required this.shop,
    required this.journal,
    this.reminders,
    this.latestLabel,
    this.latestTitle,
  });

  final BentoSection blogs;
  final BentoSection nutrition;
  final BentoSection sport;
  final BentoSection experts;
  final BentoSection shopping;
  final BentoSection shop;
  final BentoSection journal;

  /// The reminders tile; `null` where the phone has no local reminders.
  final BentoSection? reminders;

  /// "New articles" and the newest article's title, on the Blogs tile.
  final String? latestLabel;
  final String? latestTitle;

  static const _gap = 10.0;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _BlogsTile(
        section: blogs,
        latestLabel: latestLabel,
        latestTitle: latestTitle,
      ),
      const SizedBox(height: _gap),
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _GridTile(
                section: sport,
                tone: MeshTone.sage,
                blobAt: const Alignment(0.6, 0.35),
              ),
            ),
            const SizedBox(width: _gap),
            Expanded(
              child: _GridTile(
                section: nutrition,
                tone: MeshTone.rose,
                blobAt: const Alignment(0.2, 0.15),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: _gap),
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _GridTile(
                section: experts,
                tone: MeshTone.blue,
                blobAt: const Alignment(-0.2, 0.7),
              ),
            ),
            const SizedBox(width: _gap),
            Expanded(
              child: _GridTile(
                section: shop,
                tone: MeshTone.orange,
                blobAt: const Alignment(0.55, -0.1),
              ),
            ),
          ],
        ),
      ),
      if (reminders case final reminders?) ...[
        const SizedBox(height: _gap),
        _WideTile(section: reminders),
      ],
      const SizedBox(height: _gap),
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _GlassCapsule(section: shopping)),
            const SizedBox(width: _gap),
            Expanded(child: _GlassCapsule(section: journal)),
          ],
        ),
      ),
    ],
  );
}

/// The wide pink Blogs tile: title, the article count in a thin circle,
/// and the newest article's title.
class _BlogsTile extends StatelessWidget {
  const _BlogsTile({
    required this.section,
    this.latestLabel,
    this.latestTitle,
  });

  final BentoSection section;
  final String? latestLabel;
  final String? latestTitle;

  @override
  Widget build(BuildContext context) {
    const tone = MeshTone.pink;
    return MeshTile(
      key: section.id == null ? null : ValueKey('discover-${section.id}'),
      tone: tone,
      padding: const EdgeInsets.all(18),
      blobAt: const Alignment(0.75, -0.1),
      onTap: section.onTap,
      semanticLabel: [
        section.semantics,
        if (latestTitle != null) '$latestLabel: $latestTitle',
      ].join('. '),
      child: ExcludeSemantics(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 102),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      section.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  if (section.value case final value?)
                    Container(
                      width: 74,
                      height: 74,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: tone.ink.withValues(alpha: .35),
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          value,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w200,
                            color: Color(0xFFFFE6F0),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              if (latestTitle case final title?) ...[
                if (latestLabel case final label?)
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: kMinTextSize,
                      color: tone.softInk,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 90),
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ),
              ] else
                Text(
                  section.hint,
                  style: TextStyle(fontSize: 13, color: tone.softInk),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A gradient tile of the 2×2 grid: the title at the top, a faint icon,
/// and a large thin number with its caption (or the hint) at the bottom.
class _GridTile extends StatelessWidget {
  const _GridTile({
    required this.section,
    required this.tone,
    required this.blobAt,
  });

  final BentoSection section;
  final MeshTone tone;
  final Alignment blobAt;

  @override
  Widget build(BuildContext context) => MeshTile(
    key: section.id == null ? null : ValueKey('discover-${section.id}'),
    tone: tone,
    blobAt: blobAt,
    onTap: section.onTap,
    semanticLabel: section.semantics,
    child: ExcludeSemantics(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 118),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    section.title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ParlaIcon(
                  section.icon,
                  size: 20,
                  color: tone.ink.withValues(alpha: .7),
                ),
              ],
            ),
            const SizedBox(height: 18),
            if (section.value case final value?)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: value,
                      children: [
                        if (section.valueSuffix case final suffix?)
                          TextSpan(
                            text: ' $suffix',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: tone.softInk,
                            ),
                          ),
                      ],
                    ),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w200,
                      height: 1,
                    ),
                  ),
                  if (section.caption case final caption?) ...[
                    const SizedBox(height: 4),
                    Text(
                      caption,
                      style: TextStyle(
                        fontSize: kMinTextSize,
                        color: tone.softInk,
                      ),
                    ),
                  ],
                ],
              )
            else
              Text(
                section.hint,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.3,
                  color: tone.softInk,
                ),
              ),
          ],
        ),
      ),
    ),
  );
}

/// The wide pink tile (reminders): title and state on the left, a dark
/// capsule with a white knob on the right.
class _WideTile extends StatelessWidget {
  const _WideTile({required this.section});

  final BentoSection section;

  @override
  Widget build(BuildContext context) {
    const tone = MeshTone.pink;
    return MeshTile(
      key: section.id == null ? null : ValueKey('discover-${section.id}'),
      tone: tone,
      padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
      blobAt: const Alignment(0.1, 1.2),
      onTap: section.onTap,
      semanticLabel: section.semantics,
      child: ExcludeSemantics(
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      section.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      section.hint,
                      style: TextStyle(
                        fontSize: kMinTextSize,
                        color: tone.softInk,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (section.caption case final action?)
                Container(
                  constraints: const BoxConstraints(minHeight: 38),
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 4, 4, 4),
                  decoration: const ShapeDecoration(
                    color: Color(0x592A0A1C),
                    shape: StadiumBorder(),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        action,
                        style: const TextStyle(
                          fontSize: kMinTextSize,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFFF0F7),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFFFFF),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: ParlaIcon(
                          section.icon,
                          size: 16,
                          color: const Color(0xFF1A0B2A),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A glass capsule with an icon and a title (shopping list, journal).
class _GlassCapsule extends StatelessWidget {
  const _GlassCapsule({required this.section});

  final BentoSection section;

  @override
  Widget build(BuildContext context) => Semantics(
    key: section.id == null ? null : ValueKey('discover-${section.id}'),
    container: true,
    button: true,
    label: section.semantics,
    excludeSemantics: true,
    child: GlassSurface(
      radius: 28,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          onTap: section.onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 56),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  ParlaIcon(section.icon, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      section.title,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

/// A compact row for an article or a recipe: square cover, the kicker
/// (category and minutes, or the recipe's meta) and the title.
class ArticleRow extends StatelessWidget {
  const ArticleRow({
    super.key,
    required this.item,
    required this.onTap,
    this.meta,
  });

  final PublishedItem item;
  final VoidCallback onTap;

  /// The line above the title; the article kicker when `null`.
  final String? meta;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final language = Localizations.localeOf(context).languageCode;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GlassSurface(
        radius: 28,
        child: Material(
          type: MaterialType.transparency,
          borderRadius: BorderRadius.circular(28),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            key: ValueKey('${item.kind}-${item.slug}'),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  SizedBox(
                    width: 84,
                    child: ArticleCover(
                      item: item,
                      radius: 20,
                      aspectRatio: 1,
                      iconSize: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (meta case final meta?)
                          Text(
                            meta.toUpperCase(),
                            style: text.labelMedium?.copyWith(
                              color: ParlaColors.sunInk,
                              letterSpacing: .6,
                            ),
                          )
                        else
                          ArticleKicker(item: item),
                        const SizedBox(height: 4),
                        Text(
                          item.text('title', language),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: text.titleMedium,
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
