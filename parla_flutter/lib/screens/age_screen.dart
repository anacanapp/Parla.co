import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../routes.dart';
import '../ui/common.dart';

/// M-03: the 18+ age gate. Only the birth year is asked.
///
/// The server checks the same rule again when the profile is created.
class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  final _yearController = TextEditingController();
  bool? _birthdayPassed;

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }

  AgeCheck? get _check {
    final year = int.tryParse(_yearController.text);
    if (year == null || _yearController.text.length != 4) return null;
    return checkAge(
      birthYear: year,
      today: ParlaScope.of(context).clock(),
      birthdayPassedThisYear: _birthdayPassed,
    );
  }

  void _continue() {
    final scope = ParlaScope.of(context);
    switch (_check) {
      case AgeCheck.adult:
        scope.onboarding
          ..birthYear = int.parse(_yearController.text)
          ..birthdayPassedThisYear = _birthdayPassed;
        context.go(scope.api.isSignedIn ? Routes.country : Routes.signIn);
      case AgeCheck.minor:
        scope.onboarding.clear();
        _yearController.clear();
        context.go(Routes.underage);
      case AgeCheck.needsBirthdayConfirmation:
      case AgeCheck.invalid:
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final check = _check;
    final yearComplete = _yearController.text.length == 4;
    final askBirthday =
        check == AgeCheck.needsBirthdayConfirmation || _birthdayPassed != null;

    return ParlaPage(
      title: l10n.ageTitle,
      primaryLabel: l10n.continueButton,
      onPrimary: check == AgeCheck.adult || check == AgeCheck.minor
          ? _continue
          : null,
      children: [
        Text(l10n.ageWhy),
        const SizedBox(height: 24),
        TextField(
          key: const ValueKey('birth-year'),
          controller: _yearController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(4),
          ],
          decoration: InputDecoration(
            labelText: l10n.ageYearLabel,
            border: const OutlineInputBorder(),
            errorText: yearComplete && check == AgeCheck.invalid
                ? l10n.ageInvalid
                : null,
          ),
          onChanged: (_) => setState(() => _birthdayPassed = null),
        ),
        if (askBirthday) ...[
          const SizedBox(height: 24),
          Text(l10n.ageBirthdayQuestion),
          const SizedBox(height: 8),
          SegmentedButton<bool>(
            key: const ValueKey('birthday-passed'),
            emptySelectionAllowed: true,
            segments: [
              ButtonSegment(value: true, label: Text(l10n.yes)),
              ButtonSegment(value: false, label: Text(l10n.no)),
            ],
            selected: {?_birthdayPassed},
            onSelectionChanged: (value) =>
                setState(() => _birthdayPassed = value.firstOrNull),
          ),
        ],
      ],
    );
  }
}
