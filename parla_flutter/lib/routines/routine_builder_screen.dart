import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:parla_shared/parla_shared.dart';

import '../home/routine.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/common.dart';
import '../ui/parla_icons.dart';
import 'custom_routines.dart';
import 'routine_section.dart';
import '../ui/locale_text.dart';

/// Ready step titles for [area] in [language]: every care step of that
/// area from the content sheet.
List<String> stepSuggestions(RoutineArea area, String language) => [
  for (final s in routineSteps([
    for (final info in routineStepCatalogue)
      if (info.area == area) info.id,
  ], language))
    s.title,
];

/// Makes or edits one of the user's own routines. The name and steps are
/// free text: they are kept encrypted (on the server only with the health
/// consent) and never used for recommendations.
class RoutineBuilderScreen extends StatefulWidget {
  const RoutineBuilderScreen({super.key, this.routineId});

  /// The routine to edit, or `null` for a new one.
  final String? routineId;

  @override
  State<RoutineBuilderScreen> createState() => _RoutineBuilderScreenState();
}

class _RoutineBuilderScreenState extends State<RoutineBuilderScreen> {
  final _name = TextEditingController();
  final _newStep = TextEditingController();
  late CustomRoutineBook _book;
  CustomRoutine? _editing;
  RoutineArea _area = RoutineArea.face;
  int? _weekday;
  final List<CustomStep> _steps = [];
  String? _error;
  bool _ready = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_ready) return;
    _ready = true;
    _book = ParlaScope.of(context).routines;
    final id = widget.routineId;
    final existing = id == null ? null : _book.byId(id);
    if (existing != null) {
      _editing = existing;
      _name.text = existing.name;
      _area = existing.area;
      _weekday = existing.weekday;
      _steps.addAll([
        for (final s in existing.steps)
          CustomStep(id: s.id, title: s.title, note: s.note),
      ]);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _newStep.dispose();
    super.dispose();
  }

  void _addStep(String title) {
    final l10n = AppLocalizations.of(context);
    final clean = title.trim();
    if (clean.isEmpty) return;
    if (_steps.length >= CustomRoutine.maxSteps) {
      setState(() => _error = l10n.builderLimit(CustomRoutine.maxSteps));
      return;
    }
    setState(() {
      _steps.add(
        CustomStep(
          id: _book.newId(),
          title: clean.length > CustomRoutine.maxStepLength
              ? clean.substring(0, CustomRoutine.maxStepLength)
              : clean,
        ),
      );
      _newStep.clear();
      _error = null;
    });
  }

  void _move(int from, int to) => setState(() {
    final step = _steps.removeAt(from);
    _steps.insert(to, step);
  });

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final name = _name.text.trim();
    if (name.isEmpty) {
      setState(() => _error = l10n.builderNeedName);
      return;
    }
    if (_steps.isEmpty) {
      setState(() => _error = l10n.builderNeedStep);
      return;
    }
    await _book.save(
      CustomRoutine(
        id: _editing?.id ?? _book.newId(),
        name: name,
        area: _area,
        weekday: _weekday,
        steps: List.of(_steps),
      ),
    );
    if (mounted) context.go(Routes.habits);
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final routine = _editing;
    if (routine == null) return;
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.builderDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.builderCancel),
          ),
          TextButton(
            key: const ValueKey('builder-delete-yes'),
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.builderDeleteYes),
          ),
        ],
      ),
    );
    if (yes != true) return;
    await _book.delete(routine.id);
    if (mounted) context.go(Routes.habits);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final weekdayName = DateFormat.EEEE(dateLocaleOf(context));
    final suggestions = stepSuggestions(
      _area,
      contentLanguageOf(context),
    ).where((t) => !_steps.any((s) => s.title == t)).toList();

    Widget label(String value) => Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 8),
      child: Semantics(
        header: true,
        child: Text(value, style: text.titleMedium),
      ),
    );

    return ParlaPage(
      title: _editing == null ? l10n.builderTitleNew : l10n.builderTitleEdit,
      onBack: () => context.go(Routes.habits),
      primaryLabel: l10n.builderSave,
      onPrimary: _save,
      secondary: [
        if (_editing != null)
          TextButton(
            key: const ValueKey('builder-delete'),
            onPressed: _delete,
            child: Text(l10n.builderDelete),
          ),
      ],
      children: [
        label(l10n.builderName),
        TextField(
          key: const ValueKey('builder-name'),
          controller: _name,
          maxLength: CustomRoutine.maxNameLength,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: l10n.builderNameHint),
        ),
        label(l10n.builderArea),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final area in RoutineArea.values)
              ChoiceChip(
                key: ValueKey('builder-area-${area.name}'),
                label: Text(areaLabel(l10n, area)),
                selected: area == _area,
                onSelected: (_) => setState(() => _area = area),
              ),
          ],
        ),
        label(l10n.builderWhen),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ChoiceChip(
              key: const ValueKey('builder-every-day'),
              label: Text(l10n.builderEveryDay),
              selected: _weekday == null,
              onSelected: (_) => setState(() => _weekday = null),
            ),
            ChoiceChip(
              key: const ValueKey('builder-once-week'),
              label: Text(l10n.builderOnceWeek),
              selected: _weekday != null,
              onSelected: (_) => setState(() => _weekday ??= DateTime.sunday),
            ),
          ],
        ),
        if (_weekday != null) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (var day = DateTime.monday; day <= DateTime.sunday; day++)
                ChoiceChip(
                  key: ValueKey('builder-day-$day'),
                  // 2024-01-01 was a Monday.
                  label: Text(weekdayName.format(DateTime(2024, 1, day))),
                  selected: _weekday == day,
                  onSelected: (_) => setState(() => _weekday = day),
                ),
            ],
          ),
        ],
        label(l10n.builderSteps),
        for (var i = 0; i < _steps.length; i++)
          Container(
            key: ValueKey('builder-step-${_steps[i].id}'),
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.only(left: 14),
            decoration: BoxDecoration(
              color: ParlaColors.white,
              borderRadius: BorderRadius.circular(ParlaSpace.controlRadius),
              border: Border.all(color: ParlaColors.line),
            ),
            child: Row(
              children: [
                Text('${i + 1}.', style: text.titleMedium),
                const SizedBox(width: 8),
                Expanded(child: Text(_steps[i].title, style: text.bodyLarge)),
                IconButton(
                  tooltip: l10n.builderMoveUp(_steps[i].title),
                  onPressed: i == 0 ? null : () => _move(i, i - 1),
                  icon: const Icon(Icons.arrow_upward, size: 20),
                ),
                IconButton(
                  tooltip: l10n.builderMoveDown(_steps[i].title),
                  onPressed: i == _steps.length - 1
                      ? null
                      : () => _move(i, i + 1),
                  icon: const Icon(Icons.arrow_downward, size: 20),
                ),
                IconButton(
                  tooltip: l10n.builderRemoveStep(_steps[i].title),
                  onPressed: () => setState(() => _steps.removeAt(i)),
                  icon: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
          ),
        TextField(
          key: const ValueKey('builder-new-step'),
          controller: _newStep,
          maxLength: CustomRoutine.maxStepLength,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: l10n.builderStepHint),
          onSubmitted: _addStep,
        ),
        OutlinedButton.icon(
          key: const ValueKey('builder-add-step'),
          onPressed: () => _addStep(_newStep.text),
          icon: const ParlaIcon(ParlaIconName.plus, size: 18),
          label: Text(l10n.builderAddStep),
        ),
        if (suggestions.isNotEmpty) ...[
          label(l10n.builderSuggestions),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final title in suggestions)
                ActionChip(
                  label: Text(title),
                  onPressed: () => _addStep(title),
                ),
            ],
          ),
        ],
        if (_error != null) ...[
          const SizedBox(height: 16),
          Semantics(
            liveRegion: true,
            child: Text(
              _error!,
              key: const ValueKey('builder-error'),
              style: text.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ],
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ParlaIcon(ParlaIconName.check, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                _book.isSynced
                    ? l10n.builderPrivacySynced
                    : l10n.builderPrivacyDevice,
                style: text.bodySmall?.copyWith(color: ParlaColors.muted),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
