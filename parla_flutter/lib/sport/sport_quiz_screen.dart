import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/brand.dart';
import '../ui/common.dart';
import 'sport_labels.dart';
import 'sport_night.dart';

/// The questions of one sport section, one topic per page. Earlier
/// answers are filled in (another section's when this one is new). Only
/// fitness asks for workout types; pilates and wall pilates are their own.
class SportQuizScreen extends StatefulWidget {
  const SportQuizScreen({super.key, this.section = 'fitness'});

  /// One of [SportOptions.sections].
  final String section;

  @override
  State<SportQuizScreen> createState() => _SportQuizScreenState();
}

enum _Page { goals, areas, types, level, schedule, safety }

class _SportQuizScreenState extends State<SportQuizScreen> {
  late final _pages = [
    for (final p in _Page.values)
      if (p != _Page.types || widget.section == 'fitness') p,
  ];

  int get _steps => _pages.length;

  int _step = 0;
  String? _error;
  final _goals = <String>[];
  final _areas = <String>{};
  final _types = <String>[];
  String _level = 'beginner';
  int _days = 3;
  int _minutes = 25;
  bool _dumbbells = false;
  String _pregnancy = 'no';
  final _injuries = <String>{};
  bool _doctorLimit = false;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loaded) return;
    _loaded = true;
    final book = ParlaScope.of(context).sport;
    final own = book.answersOf(widget.section);
    final a = own ?? book.answers;
    if (a == null) return;
    _goals.addAll(a.goals);
    _areas.addAll(a.areas);
    if (own != null) _types.addAll(own.types);
    _level = a.level;
    _days = a.days;
    _minutes = a.minutes;
    _dumbbells = a.dumbbells;
    _pregnancy = a.pregnancy;
    _injuries.addAll(a.injuries);
    _doctorLimit = a.doctorLimit;
  }

  bool get _stepFilled => switch (_pages[_step]) {
    _Page.goals => _goals.isNotEmpty,
    _Page.areas => _areas.isNotEmpty,
    _Page.types => _types.isNotEmpty,
    _ => true,
  };

  Future<void> _next() async {
    if (!_stepFilled) {
      setState(() => _error = AppLocalizations.of(context).sportNeedOne);
      return;
    }
    if (_step < _steps - 1) {
      setState(() {
        _step++;
        _error = null;
      });
      return;
    }
    final book = ParlaScope.of(context).sport;
    await book.setAnswers(
      SportAnswers(
        goals: List.of(_goals),
        areas: Set.of(_areas),
        types: widget.section == 'fitness'
            ? [
                for (final t in SportOptions.typesOf('fitness'))
                  if (_types.contains(t)) t,
              ]
            : [widget.section],
        level: _level,
        days: _days,
        minutes: _minutes,
        dumbbells: _dumbbells,
        pregnancy: _pregnancy,
        injuries: Set.of(_injuries),
        doctorLimit: _doctorLimit,
      ),
      section: widget.section,
    );
    if (mounted) context.go(Routes.sport, extra: widget.section);
  }

  void _back() {
    if (_step == 0) {
      context.go(Routes.sport, extra: widget.section);
    } else {
      setState(() {
        _step--;
        _error = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final (title, subtitle, body) = switch (_pages[_step]) {
      _Page.goals => (
        l10n.sportQGoals,
        l10n.sportQGoalsHint,
        _multi(SportOptions.goals, _goals.contains, (id, on) {
          if (on && _goals.length >= SportOptions.maxGoals) {
            _goals.removeAt(0);
          }
          on ? _goals.add(id) : _goals.remove(id);
        }, (id) => goalLabel(l10n, id)),
      ),
      _Page.areas => (
        l10n.sportQAreas,
        l10n.sportAreasNote,
        _multi(SportOptions.areas, _areas.contains, (id, on) {
          on ? _areas.add(id) : _areas.remove(id);
        }, (id) => sportAreaLabel(l10n, id)),
      ),
      _Page.types => (
        l10n.sportQTypes,
        null,
        _multi(SportOptions.typesOf('fitness'), _types.contains, (id, on) {
          on ? _types.add(id) : _types.remove(id);
        }, (id) => sportTypeLabel(l10n, id)),
      ),
      _Page.level => (
        l10n.sportQLevel,
        null,
        <Widget>[
          for (final id in SportOptions.levels)
            _single(
              'level-$id',
              levelLabel(l10n, id),
              _level == id,
              () => _level = id,
            ),
        ],
      ),
      _Page.schedule => (
        l10n.sportQSchedule,
        null,
        <Widget>[
          Text(l10n.sportDaysLabel, style: text.titleMedium),
          const SizedBox(height: 8),
          _chips(
            SportOptions.days,
            _days,
            (v) => _days = v,
            (v) => l10n.sportDays(v),
            'days',
          ),
          const SizedBox(height: 16),
          Text(l10n.sportMinutesLabel, style: text.titleMedium),
          const SizedBox(height: 8),
          _chips(
            SportOptions.minutes,
            _minutes,
            (v) => _minutes = v,
            (v) => l10n.sportMinutes(v),
            'minutes',
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            key: const ValueKey('sport-dumbbells'),
            contentPadding: EdgeInsets.zero,
            value: _dumbbells,
            onChanged: (v) => setState(() => _dumbbells = v),
            title: Text(l10n.sportDumbbells),
          ),
        ],
      ),
      _Page.safety => (
        l10n.sportQSafety,
        l10n.sportSafetyIntro,
        <Widget>[
          Text(l10n.sportPregnancyLabel, style: text.titleMedium),
          const SizedBox(height: 8),
          for (final id in SportOptions.pregnancy)
            _single(
              'pregnancy-$id',
              pregnancyLabel(l10n, id),
              _pregnancy == id,
              () => _pregnancy = id,
            ),
          const SizedBox(height: 8),
          Text(l10n.sportInjuriesLabel, style: text.titleMedium),
          const SizedBox(height: 8),
          ..._multi(SportOptions.injuries, _injuries.contains, (id, on) {
            on ? _injuries.add(id) : _injuries.remove(id);
          }, (id) => injuryLabel(l10n, id)),
          const SizedBox(height: 8),
          CheckboxListTile(
            key: const ValueKey('sport-doctor'),
            contentPadding: EdgeInsets.zero,
            value: _doctorLimit,
            onChanged: (v) => setState(() => _doctorLimit = v ?? false),
            title: Text(l10n.sportDoctorLimit),
          ),
        ],
      ),
    };
    return ParlaPage(
      eyebrow: sportTypeLabel(l10n, widget.section),
      title: title,
      subtitle: subtitle,
      step: _step + 1,
      steps: _steps,
      onBack: _back,
      primaryLabel: _step == _steps - 1 ? l10n.sportBuildPlan : l10n.sportNext,
      onPrimary: _next,
      children: [
        ...body,
        if (_error != null)
          Semantics(
            liveRegion: true,
            child: Text(
              _error!,
              style: text.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
      ],
    );
  }

  List<Widget> _multi(
    List<String> ids,
    bool Function(String) selected,
    void Function(String id, bool on) change,
    String Function(String) label,
  ) => [
    for (final id in ids)
      ParlaOptionCard(
        selected: selected(id),
        child: CheckboxListTile(
          key: ValueKey('opt-$id'),
          value: selected(id),
          onChanged: (on) => setState(() {
            change(id, on ?? false);
            _error = null;
          }),
          title: Text(label(id)),
        ),
      ),
  ];

  Widget _single(String key, String label, bool selected, VoidCallback pick) =>
      ParlaOptionCard(
        selected: selected,
        child: ListTile(
          key: ValueKey(key),
          selected: selected,
          selectedColor: ParlaColors.espresso,
          title: Text(label),
          trailing: selected ? const Icon(Icons.check) : null,
          onTap: () => setState(pick),
        ),
      );

  Widget _chips(
    List<int> values,
    int current,
    void Function(int) pick,
    String Function(int) label,
    String key,
  ) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      for (final v in values)
        // Night pill chips: the chosen one light with dark ink, the rest
        // glass (prototype "Gecə · İdman").
        Semantics(
          button: true,
          selected: current == v,
          child: Material(
            key: ValueKey('$key-$v'),
            color: current == v ? SportNight.ink : SportNight.glass,
            shape: StadiumBorder(
              side: current == v
                  ? BorderSide.none
                  : const BorderSide(color: Color(0x2EFFFFFF)),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => setState(() => pick(v)),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 44),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    widthFactor: 1,
                    child: Text(
                      label(v),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: current == v
                            ? FontWeight.w600
                            : FontWeight.w400,
                        color: current == v
                            ? SportNight.inkDark
                            : SportNight.ink,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
    ],
  );
}
