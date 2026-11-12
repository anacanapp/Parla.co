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

enum _Stage { loading, intro, question, healthGate, redFlag, result }

/// M-09 to M-13: the onboarding quiz in one screen.
///
/// Health questions are only asked with the health consent: without it the
/// user sees the consent gate (M-11) first and can skip the section.
/// Warning-sign answers stay on the device; they only decide whether the
/// "see a doctor" screen (M-12) appears.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  _Stage _stage = _Stage.loading;
  bool _healthConsent = false;
  bool _gateDone = false;
  bool _busy = false;

  /// Questions still to be asked, in order. Health questions are removed
  /// when the user skips the section.
  late List<QuizQuestion> _questions = [
    ...quizQuestions.where((q) => !q.sensitive && q.stored),
    ...quizQuestions.where((q) => q.sensitive),
    ...quizQuestions.where((q) => !q.stored),
  ];
  int _index = 0;
  final Map<String, List<String>> _chosen = {};
  final Set<String> _declined = {};
  Set<String> _selection = {};

  QuizAnswers get _answers =>
      QuizAnswers(chosen: Map.of(_chosen), declined: Set.of(_declined));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final api = ParlaScope.of(context).api;
    var consent = false;
    try {
      consent = await api.hasHealthConsent();
    } on Object {
      consent = false;
    }
    if (!mounted) return;
    setState(() {
      _healthConsent = consent;
      _stage = _Stage.intro;
    });
  }

  String get _language =>
      ParlaScope.of(context).settings.language ?? defaultLanguage;

  QuizQuestion get _current => _questions[_index];

  void _showQuestion(int index) {
    final q = _questions[index];
    setState(() {
      _index = index;
      _stage = _Stage.question;
      _selection = {..._chosen[q.id] ?? const <String>[]};
    });
  }

  void _toggle(QuizOption option) {
    final q = _current;
    setState(() {
      if (!q.multiple) {
        _selection = {option.id};
      } else if (_selection.contains(option.id)) {
        _selection.remove(option.id);
      } else if (option.exclusive) {
        _selection = {option.id};
      } else {
        _selection
          ..removeWhere((id) => q.option(id)?.exclusive ?? false)
          ..add(option.id);
      }
    });
  }

  void _answer({bool decline = false}) {
    final q = _current;
    if (decline) {
      _chosen.remove(q.id);
      _declined.add(q.id);
    } else {
      _chosen[q.id] = q.options
          .where((o) => _selection.contains(o.id))
          .map((o) => o.id)
          .toList();
      _declined.remove(q.id);
    }
    _advance();
  }

  void _advance() {
    final next = _index + 1;
    if (next >= _questions.length) {
      _finishQuestions();
      return;
    }
    if (_questions[next].sensitive && !_healthConsent && !_gateDone) {
      setState(() {
        _index = next;
        _stage = _Stage.healthGate;
      });
      return;
    }
    _showQuestion(next);
  }

  void _back() {
    if (_stage == _Stage.healthGate) {
      _showQuestion(_index - 1);
      return;
    }
    if (_index == 0) {
      setState(() => _stage = _Stage.intro);
      return;
    }
    _showQuestion(_index - 1);
  }

  Future<void> _agreeToHealth() async {
    final scope = ParlaScope.of(context);
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await scope.api.decideConsent(
        kind: ConsentKind.health,
        granted: true,
        textVersion: currentConsentText(ConsentKind.health).version,
        language: _language,
      );
      _healthConsent = true;
      _gateDone = true;
      _showQuestion(_index);
    } on Object catch (error) {
      if (mounted) showError(context, errorMessage(l10n, error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _skipHealth() {
    _gateDone = true;
    final firstHealth = _index;
    setState(() {
      _questions = _questions.where((q) => !q.sensitive).toList();
      _index = firstHealth;
    });
    if (_index >= _questions.length) {
      _finishQuestions();
    } else {
      _showQuestion(_index);
    }
  }

  void _finishQuestions() {
    if (hasRedFlag(_answers)) {
      setState(() => _stage = _Stage.redFlag);
    } else {
      _save();
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await ParlaScope.of(context).api.saveQuizAnswers(_answers);
      if (mounted) setState(() => _stage = _Stage.result);
    } on Object catch (error) {
      if (mounted) showError(context, errorMessage(l10n, error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return switch (_stage) {
      _Stage.loading => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      _Stage.intro => ParlaPage(
        title: l10n.quizIntroTitle,
        primaryLabel: l10n.quizStart,
        onPrimary: () => _showQuestion(0),
        secondary: [
          TextButton(
            onPressed: () => context.go(Routes.home),
            child: Text(l10n.quizLater),
          ),
        ],
        children: [
          Text(l10n.quizIntroBody),
          const SizedBox(height: 24),
          const Center(child: _BigSmile()),
        ],
      ),
      _Stage.question => _QuestionView(
        question: _current,
        number: _index + 1,
        total: _questions.length,
        language: _language,
        selection: _selection,
        onToggle: _toggle,
        onNext: _selection.isEmpty ? null : () => _answer(),
        onDecline: _current.declinable ? () => _answer(decline: true) : null,
        onBack: _back,
        isLast: _index == _questions.length - 1,
        busy: _busy,
      ),
      _Stage.healthGate => ParlaPage(
        title: l10n.healthGateTitle,
        primaryLabel: l10n.healthGateAgree,
        onPrimary: _agreeToHealth,
        busy: _busy,
        secondary: [
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: _busy ? null : _skipHealth,
            child: Text(l10n.healthGateSkip),
          ),
          TextButton(onPressed: _back, child: Text(l10n.quizBack)),
        ],
        children: [
          Text(l10n.healthGateBody),
          const SizedBox(height: 16),
          SoftCard(
            padding: const EdgeInsets.all(16),
            child: Text(
              currentConsentText(ConsentKind.health).bodyFor(_language) ?? '',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.healthGateSkipNote,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: ParlaColors.muted),
          ),
        ],
      ),
      _Stage.redFlag => ParlaPage(
        title: l10n.redFlagTitle,
        primaryLabel: l10n.redFlagOk,
        onPrimary: _save,
        busy: _busy,
        children: [Text(l10n.redFlagBody)],
      ),
      _Stage.result => _ResultView(
        answers: _answers,
        language: _language,
        onDone: () => context.go(Routes.home),
      ),
    };
  }
}

class _QuestionView extends StatelessWidget {
  const _QuestionView({
    required this.question,
    required this.number,
    required this.total,
    required this.language,
    required this.selection,
    required this.onToggle,
    required this.onNext,
    required this.onDecline,
    required this.onBack,
    required this.isLast,
    required this.busy,
  });

  final QuizQuestion question;
  final int number;
  final int total;
  final String language;
  final Set<String> selection;
  final ValueChanged<QuizOption> onToggle;
  final VoidCallback? onNext;
  final VoidCallback? onDecline;
  final VoidCallback onBack;
  final bool isLast;
  final bool busy;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                children: [
                  Text(
                    l10n.quizProgress(number, total),
                    style: text.labelMedium?.copyWith(
                      color: ParlaColors.sunInk,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ExcludeSemantics(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: number / total,
                        minHeight: 10,
                        backgroundColor: ParlaColors.lemon,
                        color: ParlaColors.sun,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Semantics(
                    header: true,
                    child: Text(
                      question.text[language] ?? question.text['az']!,
                      style: text.headlineSmall,
                    ),
                  ),
                  if (question.multiple) ...[
                    const SizedBox(height: 8),
                    Text(
                      l10n.quizMultipleHint,
                      style: text.bodyMedium?.copyWith(
                        color: ParlaColors.muted,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  for (final option in question.options) ...[
                    _OptionTile(
                      key: ValueKey('option-${question.id}-${option.id}'),
                      label: option.text[language] ?? option.text['az']!,
                      selected: selection.contains(option.id),
                      multiple: question.multiple,
                      onTap: () => onToggle(option),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton(
                    onPressed: busy ? null : onNext,
                    child: Text(isLast ? l10n.quizFinish : l10n.quizNext),
                  ),
                  if (onDecline != null)
                    TextButton(
                      onPressed: busy ? null : onDecline,
                      child: Text(l10n.quizDecline),
                    ),
                  TextButton(onPressed: onBack, child: Text(l10n.quizBack)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    super.key,
    required this.label,
    required this.selected,
    required this.multiple,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool multiple;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: !multiple,
      child: Material(
        color: selected ? ParlaColors.lemon : ParlaColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: selected ? ParlaColors.espresso : ParlaColors.outline,
            width: selected ? 2 : 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 60),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: selected ? ParlaColors.sun : Colors.transparent,
                      shape: multiple ? BoxShape.rectangle : BoxShape.circle,
                      borderRadius: multiple ? BorderRadius.circular(8) : null,
                      border: selected
                          ? null
                          : Border.all(color: ParlaColors.outline, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: selected
                        ? const ParlaIcon(
                            ParlaIconName.check,
                            size: 18,
                            strokeWidth: 2.5,
                          )
                        : null,
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

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.answers,
    required this.language,
    required this.onDone,
  });

  final QuizAnswers answers;
  final String language;
  final VoidCallback onDone;

  String _optionText(String questionId) {
    final q = quizQuestion(questionId)!;
    return answers
        .of(questionId)
        .map((id) => q.option(id)?.text[language] ?? id)
        .join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final plan = planRoutine(answers);
    final rows = [
      if (answers.answered('skin_type'))
        (l10n.resultSkin, _optionText('skin_type')),
      if (answers.answered('hair_type'))
        (l10n.resultHair, _optionText('hair_type')),
      if (answers.answered('skin_goals'))
        (l10n.resultGoals, _optionText('skin_goals')),
    ];
    final pregnancy = plan.exclusions.contains(
      RoutineExclusion.retinoidPregnancy,
    );
    final medication = plan.exclusions.contains(
      RoutineExclusion.retinoidMedication,
    );
    final notes = [
      if (pregnancy && medication)
        l10n.resultExclusionRetinoidBoth
      else if (pregnancy)
        l10n.resultExclusionPregnancy
      else if (medication)
        l10n.resultExclusionMedication,
      if (plan.exclusions.contains(RoutineExclusion.sensitiveSkin))
        l10n.resultExclusionSensitive,
    ];
    return ParlaPage(
      title: l10n.resultTitle,
      primaryLabel: l10n.resultSeeRoutine,
      onPrimary: onDone,
      children: [
        const Center(child: _BigSmile()),
        const SizedBox(height: 24),
        if (rows.isNotEmpty)
          SoftCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (label, value) in rows) ...[
                  EyebrowText(label),
                  const SizedBox(height: 2),
                  Text(value, style: text.titleMedium),
                  const SizedBox(height: 14),
                ],
              ],
            ),
          ),
        for (final note in notes) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ParlaColors.sky,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(note, style: text.bodyMedium),
          ),
        ],
      ],
    );
  }
}

/// The brand's smile mark, drawn large on the intro and result screens.
class _BigSmile extends StatelessWidget {
  const _BigSmile();

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: 120,
      height: 120,
      decoration: const BoxDecoration(
        color: ParlaColors.espresso,
        shape: BoxShape.circle,
      ),
      child: CustomPaint(painter: _SmileMarkPainter()),
    ),
  );
}

class _SmileMarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.24, h * 0.5)
      ..quadraticBezierTo(w / 2, h * 0.95, w * 0.76, h * 0.5)
      ..quadraticBezierTo(w / 2, h * 0.72, w * 0.24, h * 0.5)
      ..close();
    canvas.drawPath(path, Paint()..color = ParlaColors.sun);
  }

  @override
  bool shouldRepaint(_SmileMarkPainter oldDelegate) => false;
}
