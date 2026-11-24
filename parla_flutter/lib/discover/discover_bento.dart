import 'package:flutter/material.dart';

import '../services/parla_api.dart';
import '../ui/brand.dart';
import '../ui/night.dart';
import '../ui/warm.dart';
import '../ui/parla_icons.dart';
import 'blog_widgets.dart';
import '../ui/text_case.dart';

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

/// The Discover tiles of the warm day design (prototype `X3DiscoverW`): a
/// coral glass Blogs card with the article count and the newest title, a
/// lime sport card and a rose nutrition card, glass capsules for experts
/// and the shop, a wide reminders capsule and two small capsules (shopping
/// list, journal). Each tile is one button whose words are read together;
/// tiles keep minimum heights and grow with the user's text size.
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
    this.sportFraction,
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

  /// This week's finished share of the sport plan, for the dots.
  final double? sportFraction;

  static const _gap = 10.0;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _BlogsCard(
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
              child: _SquircleTile(
                section: sport,
                tone: SquircleTone.lime,
                meter: DotsMeter(fraction: sportFraction ?? 0),
              ),
            ),
            const SizedBox(width: _gap),
            Expanded(
              child: _SquircleTile(
                section: nutrition,
                tone: SquircleTone.rose,
                meter: const TicksMeter(fraction: .35),
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
            Expanded(child: _InfoPill(section: experts)),
            const SizedBox(width: _gap),
            Expanded(
              child: _InfoPill(section: shop, tint: SmokyTint.burnt),
            ),
          ],
        ),
      ),
      if (reminders case final reminders?) ...[
        const SizedBox(height: _gap),
        _WidePill(section: reminders),
      ],
      const SizedBox(height: _gap),
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _SmallCapsule(section: shopping)),
            const SizedBox(width: _gap),
            Expanded(child: _SmallCapsule(section: journal)),
          ],
        ),
      ),
    ],
  );
}

/// One button for a whole tile, read out as [BentoSection.semantics].
class _TileSemantics extends StatelessWidget {
  const _TileSemantics({required this.section, required this.child});

  final BentoSection section;
  final Widget child;

  @override
  Widget build(BuildContext context) => Semantics(
    key: section.id == null ? null : ValueKey('discover-${section.id}'),
    button: true,
    label: section.semantics,
    excludeSemantics: true,
    child: child,
  );
}

/// The coral glass Blogs card: title and "New articles", an outlined
/// arrow, the newest title and the article count with its caption.
class _BlogsCard extends StatelessWidget {
  const _BlogsCard({
    required this.section,
    this.latestLabel,
    this.latestTitle,
  });

  final BentoSection section;
  final String? latestLabel;
  final String? latestTitle;

  @override
  Widget build(BuildContext context) => _TileSemantics(
    section: section,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 168),
      child: SmokyGlass(
        radius: 44,
        tint: SmokyTint.coral,
        onTap: section.onTap,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      Text(
                        latestLabel ?? section.hint,
                        style: const TextStyle(
                          fontSize: kMinTextSize,
                          color: Warm.onCardSoft,
                        ),
                      ),
                    ],
                  ),
                ),
                const _ArrowRing(),
              ],
            ),
            const SizedBox(height: 22),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    latestTitle ?? section.hint,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 17, height: 1.25),
                  ),
                ),
                if (section.value != null) ...[
                  const SizedBox(width: 12),
                  Text(
                    section.value!,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w300,
                      height: 1,
                    ),
                  ),
                  if (section.caption != null) ...[
                    const SizedBox(width: 8),
                    OutlineBadge(section.caption!),
                  ],
                ],
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

/// The 48 px outlined arrow of glass cards (decoration; the card is the
/// button).
class _ArrowRing extends StatelessWidget {
  const _ArrowRing();

  @override
  Widget build(BuildContext context) => Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: const Color(0x66FFFFFF)),
    ),
    alignment: Alignment.center,
    child: const ParlaIcon(
      ParlaIconName.arrowRight,
      size: 18,
      color: Warm.onCard,
    ),
  );
}

/// A lime or rose card: ring icon, title and caption, a black arrow, the
/// large number (or the hint), a meter and the hint at the foot.
class _SquircleTile extends StatelessWidget {
  const _SquircleTile({
    required this.section,
    required this.tone,
    required this.meter,
  });

  final BentoSection section;
  final SquircleTone tone;
  final Widget meter;

  @override
  Widget build(BuildContext context) => _TileSemantics(
    section: section,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 176),
      child: SquircleCard(
        tone: tone,
        onTap: section.onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                RingIcon(icon: section.icon),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          section.title,
                          maxLines: 1,
                          style: const TextStyle(fontSize: 13, height: 1.15),
                        ),
                      ),
                      if (section.caption != null)
                        Text(
                          section.caption!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13, height: 1.15),
                        ),
                    ],
                  ),
                ),
                const _BlackArrow(),
              ],
            ),
            const SizedBox(height: 12),
            const Spacer(),
            if (section.value != null)
              Text.rich(
                TextSpan(
                  text: section.value,
                  children: [
                    if (section.valueSuffix != null)
                      TextSpan(
                        text: section.valueSuffix!.replaceAll(' ', ''),
                      ),
                  ],
                ),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  height: 1.1,
                ),
              ),
            meter,
            Text(
              section.hint,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: kMinTextSize,
                color: Warm.onCardSoft,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// The black round arrow of a card (decoration; the card is the button).
class _BlackArrow extends StatelessWidget {
  const _BlackArrow();

  @override
  Widget build(BuildContext context) => Container(
    width: 38,
    height: 38,
    decoration: const BoxDecoration(color: Warm.black, shape: BoxShape.circle),
    alignment: Alignment.center,
    child: const ParlaIcon(
      ParlaIconName.arrowRight,
      size: 16,
      color: Colors.white,
    ),
  );
}

/// A glass stadium: title and icon, then the large number with its badge,
/// or the hint when there is no number.
class _InfoPill extends StatelessWidget {
  const _InfoPill({required this.section, this.tint = SmokyTint.none});

  final BentoSection section;
  final SmokyTint tint;

  @override
  Widget build(BuildContext context) => _TileSemantics(
    section: section,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 100),
      child: SmokyGlass(
        shape: const StadiumBorder(),
        tint: tint,
        onTap: section.onTap,
        padding: const EdgeInsets.fromLTRB(22, 14, 20, 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    section.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
                ParlaIcon(section.icon, size: 18, color: Warm.onCard),
              ],
            ),
            const SizedBox(height: 4),
            if (section.value != null)
              Row(
                children: [
                  Text(
                    section.value!,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  if (section.caption != null) ...[
                    const SizedBox(width: 8),
                    Flexible(child: OutlineBadge(section.caption!)),
                  ],
                ],
              )
            else
              Text(
                section.hint,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 13, height: 1.3),
              ),
          ],
        ),
      ),
    ),
  );
}

/// The wide reminders capsule: title and state, and a white capsule with
/// the action and an arrow.
class _WidePill extends StatelessWidget {
  const _WidePill({required this.section});

  final BentoSection section;

  @override
  Widget build(BuildContext context) => _TileSemantics(
    section: section,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 88),
      child: SmokyGlass(
        shape: const StadiumBorder(),
        tint: SmokyTint.coral,
        onTap: section.onTap,
        padding: const EdgeInsets.fromLTRB(24, 12, 14, 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    section.hint,
                    style: const TextStyle(
                      fontSize: kMinTextSize,
                      color: Warm.onCardSoft,
                    ),
                  ),
                ],
              ),
            ),
            if (section.caption != null)
              Container(
                padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
                decoration: const ShapeDecoration(
                  color: Color(0x33FFFFFF),
                  shape: StadiumBorder(),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      section.caption!,
                      style: const TextStyle(fontSize: kMinTextSize),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const ParlaIcon(
                        ParlaIconName.arrowRight,
                        size: 16,
                        color: Warm.black,
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

/// A small glass capsule: icon and title.
class _SmallCapsule extends StatelessWidget {
  const _SmallCapsule({required this.section});

  final BentoSection section;

  @override
  Widget build(BuildContext context) => _TileSemantics(
    section: section,
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 54),
      child: SmokyGlass(
        shape: const StadiumBorder(),
        shadow: false,
        onTap: section.onTap,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            ParlaIcon(section.icon, size: 18, color: Warm.onCard),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                section.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
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
                            meta.upperIn(context),
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
