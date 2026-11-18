import 'package:flutter/material.dart';

import '../api/admin_api.dart';
import 'texts.dart';
import 'theme.dart';

/// A section page: header with title, optional subtitle and actions, then
/// the content, scrolling, at a readable maximum width.
class AdminPage extends StatelessWidget {
  const AdminPage({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
    required this.children,
    this.maxWidth = 1200,
    this.leading,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final List<Widget> children;
  final double maxWidth;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < 700;
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: narrow ? 16 : 40,
        vertical: narrow ? 20 : 32,
      ),
      children: [
        Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PageHeader(
                  title: title,
                  subtitle: subtitle,
                  actions: actions,
                  leading: leading,
                ),
                const SizedBox(height: 24),
                ...children,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions = const [],
    this.leading,
  });

  final String title;
  final String? subtitle;
  final List<Widget> actions;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: text.headlineMedium),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(
            subtitle!,
            style: text.bodyMedium?.copyWith(color: AdminColors.muted),
          ),
        ],
      ],
    );
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: 16,
      runSpacing: 16,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 8)],
            Flexible(child: heading),
          ],
        ),
        if (actions.isNotEmpty)
          Wrap(spacing: 10, runSpacing: 10, children: actions),
      ],
    );
  }
}

/// A white card with an optional title row.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    this.title,
    this.trailing,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final String? title;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null)
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AdminColors.line)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      title!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
        Padding(padding: padding, child: child),
      ],
    ),
  );
}

/// The colours of a status: background, dot and text differ in lightness,
/// not hue alone.
typedef PillTone = ({Color background, Color dot, Color text});

const PillTone neutralTone = (
  background: AdminColors.hover,
  dot: Color(0xFF8C8172),
  text: Color(0xFF4A4136),
);
const PillTone reviewTone = (
  background: Color(0xFFFFF0B8),
  dot: Color(0xFFC99700),
  text: Color(0xFF5E4100),
);
const PillTone approvedTone = (
  background: Color(0xFFE3ECFA),
  dot: Color(0xFF2F62B5),
  text: Color(0xFF1D3F73),
);
const PillTone liveTone = (
  background: Color(0xFFE2F2E5),
  dot: Color(0xFF2E8A45),
  text: Color(0xFF1E5A2C),
);
const PillTone dangerTone = (
  background: AdminColors.dangerSoft,
  dot: Color(0xFFB4492A),
  text: Color(0xFF7A2E12),
);

PillTone statusTone(ContentStatus s) => switch (s) {
  ContentStatus.draft => neutralTone,
  ContentStatus.inReview => reviewTone,
  ContentStatus.approved => approvedTone,
  ContentStatus.published => liveTone,
};

/// A small rounded label with a dot.
class Pill extends StatelessWidget {
  const Pill(this.label, {super.key, this.tone = neutralTone});

  final String label;
  final PillTone tone;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: tone.background,
      borderRadius: BorderRadius.circular(AdminRadius.pill),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: tone.dot,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: tone.text,
            ),
          ),
        ),
      ],
    ),
  );
}

class StatusPill extends StatelessWidget {
  const StatusPill(this.status, {super.key});

  final ContentStatus status;

  @override
  Widget build(BuildContext context) =>
      Pill(statusLabel(status), tone: statusTone(status));
}

/// A number with its label, tappable when [onTap] is set.
class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.hint,
    this.highlight = false,
    this.onTap,
    this.valueKey,
  });

  final String label;
  final String value;
  final Key? valueKey;
  final String? hint;
  final bool highlight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      color: highlight ? AdminColors.sunSoft : AdminColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AdminRadius.card),
        side: BorderSide(
          color: highlight ? AdminColors.sunLine : AdminColors.line,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: text.titleSmall?.copyWith(
                  color: highlight ? AdminColors.ink : AdminColors.muted,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                key: valueKey,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                  height: 1.1,
                ),
              ),
              if (hint != null) ...[
                const SizedBox(height: 8),
                Text(
                  hint!,
                  style: text.bodySmall?.copyWith(
                    color: highlight ? AdminColors.ink : AdminColors.subtle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Lays children out in equal columns that wrap on narrow screens.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 220,
    this.spacing = 16,
  });

  final List<Widget> children;
  final double minItemWidth;
  final double spacing;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, c) {
      final columns = ((c.maxWidth + spacing) / (minItemWidth + spacing))
          .floor()
          .clamp(1, children.isEmpty ? 1 : children.length);
      final width = (c.maxWidth - spacing * (columns - 1)) / columns;
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        children: [
          for (final child in children) SizedBox(width: width, child: child),
        ],
      );
    },
  );
}

/// Tone of a [Notice].
enum NoticeTone { info, warning, danger }

/// A highlighted message inside a page.
class Notice extends StatelessWidget {
  const Notice({
    super.key,
    required this.title,
    this.body,
    this.icon = Icons.info_outline,
    this.tone = NoticeTone.warning,
  });

  final String title;
  final String? body;
  final IconData icon;
  final NoticeTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, line, fg) = switch (tone) {
      NoticeTone.info => (
        AdminColors.white,
        AdminColors.line,
        AdminColors.ink,
      ),
      NoticeTone.warning => (
        const Color(0xFFFFF8E1),
        AdminColors.sunLine,
        const Color(0xFF4A3500),
      ),
      NoticeTone.danger => (
        AdminColors.dangerSoft,
        const Color(0xFFF1C2AE),
        const Color(0xFF6E2A10),
      ),
    };
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: fg),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: fg,
                  ),
                ),
                if (body != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    body!,
                    style: TextStyle(fontSize: 14, height: 1.5, color: fg),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown when a list has nothing in it.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.body,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  final String title;
  final String? body;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: AdminColors.sunSoft,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AdminColors.ink),
          ),
          const SizedBox(height: 14),
          Text(title, style: text.titleMedium, textAlign: TextAlign.center),
          if (body != null) ...[
            const SizedBox(height: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Text(
                body!,
                style: text.bodyMedium?.copyWith(color: AdminColors.muted),
                textAlign: TextAlign.center,
              ),
            ),
          ],
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    );
  }
}

/// A row of rounded, single-choice buttons (kinds, languages).
class PillTabs extends StatelessWidget {
  const PillTabs({
    super.key,
    required this.labels,
    required this.selected,
    required this.onSelected,
    this.keys,
    this.badges,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onSelected;
  final List<Key>? keys;

  /// A short note after a label (for example "boş").
  final List<String?>? badges;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 6,
    runSpacing: 6,
    children: [
      for (var i = 0; i < labels.length; i++)
        Semantics(
          selected: i == selected,
          button: true,
          child: InkWell(
            key: keys?[i],
            borderRadius: BorderRadius.circular(AdminRadius.pill),
            onTap: () => onSelected(i),
            child: Container(
              constraints: const BoxConstraints(minHeight: 40),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: i == selected ? AdminColors.espresso : AdminColors.white,
                borderRadius: BorderRadius.circular(AdminRadius.pill),
                border: Border.all(
                  color: i == selected
                      ? AdminColors.espresso
                      : AdminColors.field,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    labels[i],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: i == selected
                          ? AdminColors.white
                          : AdminColors.ink,
                    ),
                  ),
                  if (badges?[i] != null) ...[
                    const SizedBox(width: 6),
                    Text(
                      badges![i]!,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: i == selected
                            ? AdminColors.sun
                            : AdminColors.danger,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
    ],
  );
}

/// A loading placeholder for a section.
class LoadingBlock extends StatelessWidget {
  const LoadingBlock({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 48),
    child: Center(child: CircularProgressIndicator()),
  );
}

/// The panel's small confirmation messages.
void showToast(BuildContext context, String text) =>
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
