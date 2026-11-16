import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../api/admin_api.dart';
import '../staff_session.dart';
import '../ui/texts.dart';
import '../ui/theme.dart';

enum _Mode { login, register, reset }

/// Email and password; registration and password reset with an emailed
/// code. Passwords need at least 12 characters.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.state});

  final StaffState state;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  static const minPassword = 12;

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _code = TextEditingController();
  _Mode _mode = _Mode.login;
  UuidValue? _requestId;
  bool _busy = false;
  String? _message;

  AdminApi get _api => widget.state.api;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _code.dispose();
    super.dispose();
  }

  void _switch(_Mode mode) => setState(() {
    _mode = mode;
    _requestId = null;
    _message = null;
    _code.clear();
    _password.clear();
  });

  Future<void> _run(Future<void> Function() call) async {
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      await call();
    } on Object catch (e) {
      if (mounted) setState(() => _message = errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _submit() => _run(() async {
    final requestId = _requestId;
    switch (_mode) {
      case _Mode.login:
        await _api.login(_email.text, _password.text);
        await widget.state.refresh();
      case _Mode.register || _Mode.reset when requestId == null:
        final id = _mode == _Mode.register
            ? await _api.startRegistration(_email.text)
            : await _api.startPasswordReset(_email.text);
        setState(() {
          _requestId = id;
          _message = 'Kodu e-poçtunuza göndərdik.';
        });
      case _Mode.register:
        _checkPassword();
        final token = await _api.verifyRegistrationCode(
          requestId!,
          _code.text,
        );
        await _api.finishRegistration(token, _password.text);
        await widget.state.refresh();
      case _Mode.reset:
        _checkPassword();
        final token = await _api.verifyPasswordResetCode(
          requestId!,
          _code.text,
        );
        await _api.finishPasswordReset(token, _password.text);
        _switch(_Mode.login);
        setState(() => _message = 'Şifrə yeniləndi. İndi daxil olun.');
    }
  });

  void _checkPassword() {
    if (_password.text.length < minPassword) {
      throw const AdminError('auth.short_password');
    }
  }

  @override
  Widget build(BuildContext context) {
    final codeStep = _mode != _Mode.login && _requestId != null;
    final title = switch (_mode) {
      _Mode.login => 'Daxil ol',
      _Mode.register => 'Qeydiyyat',
      _Mode.reset => 'Şifrəni yenilə',
    };
    final button = switch (_mode) {
      _Mode.login => 'Daxil ol',
      _ when !codeStep => 'Kod göndər',
      _Mode.register => 'Hesab yarat',
      _Mode.reset => 'Şifrəni yenilə',
    };
    return AuthCard(
      title: title,
      children: [
        const Text(
          'Yalnız Parla komandası üçün. Dəvət aldığınız e-poçt ünvanından '
          'istifadə edin.',
        ),
        const SizedBox(height: 16),
        TextField(
          key: const ValueKey('email'),
          controller: _email,
          enabled: !codeStep,
          keyboardType: TextInputType.emailAddress,
          autofillHints: const [AutofillHints.email],
          decoration: const InputDecoration(labelText: 'E-poçt'),
        ),
        if (codeStep) ...[
          const SizedBox(height: 12),
          TextField(
            key: const ValueKey('email-code'),
            controller: _code,
            decoration: const InputDecoration(labelText: 'E-poçtdakı kod'),
          ),
        ],
        if (_mode == _Mode.login || codeStep) ...[
          const SizedBox(height: 12),
          TextField(
            key: const ValueKey('password'),
            controller: _password,
            obscureText: true,
            autofillHints: [
              _mode == _Mode.login
                  ? AutofillHints.password
                  : AutofillHints.newPassword,
            ],
            decoration: InputDecoration(
              labelText: _mode == _Mode.login ? 'Şifrə' : 'Yeni şifrə',
              helperText: _mode == _Mode.login
                  ? null
                  : 'Ən azı $minPassword simvol',
            ),
            onSubmitted: (_) => _submit(),
          ),
        ],
        if (_message != null) ...[
          const SizedBox(height: 12),
          Semantics(liveRegion: true, child: Text(_message!)),
        ],
        const SizedBox(height: 16),
        FilledButton(
          key: const ValueKey('auth-submit'),
          onPressed: _busy ? null : _submit,
          child: Text(button),
        ),
        const SizedBox(height: 8),
        if (_mode != _Mode.login)
          TextButton(
            onPressed: () => _switch(_Mode.login),
            child: const Text('Girişə qayıt'),
          )
        else ...[
          TextButton(
            key: const ValueKey('to-register'),
            onPressed: () => _switch(_Mode.register),
            child: const Text('Hesabım yoxdur: qeydiyyat'),
          ),
          TextButton(
            key: const ValueKey('to-reset'),
            onPressed: () => _switch(_Mode.reset),
            child: const Text('Şifrəni unutmuşam'),
          ),
        ],
      ],
    );
  }
}

/// For a signed-in account that is not staff yet: the invitation code.
class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key, required this.state});

  final StaffState state;

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final _code = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _run(Future<StaffMe> Function() call) async {
    setState(() => _busy = true);
    try {
      widget.state.update(await call());
    } on Object catch (e) {
      if (mounted) _snack(context, errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => AuthCard(
    title: 'Dəvət kodu',
    children: [
      const Text('E-poçtunuza gələn dəvət kodunu yazın.'),
      const SizedBox(height: 16),
      TextField(
        key: const ValueKey('invite-code'),
        controller: _code,
        textCapitalization: TextCapitalization.characters,
        decoration: const InputDecoration(labelText: 'Kod'),
        onSubmitted: (_) =>
            _run(() => widget.state.api.acceptInvite(_code.text)),
      ),
      const SizedBox(height: 12),
      FilledButton(
        key: const ValueKey('invite-accept'),
        onPressed: _busy
            ? null
            : () => _run(() => widget.state.api.acceptInvite(_code.text)),
        child: const Text('Qoşul'),
      ),
      const SizedBox(height: 8),
      TextButton(
        key: const ValueKey('first-admin'),
        onPressed: _busy ? null : () => _run(widget.state.api.claimFirstAdmin),
        child: const Text('İlk admin kimi qoşul (yalnız quraşdırmada)'),
      ),
      TextButton(
        onPressed: widget.state.signOut,
        child: const Text('Çıxış'),
      ),
    ],
  );
}

/// Setting up the authenticator app (QR code and the secret as text).
class TotpSetupScreen extends StatefulWidget {
  const TotpSetupScreen({super.key, required this.state});

  final StaffState state;

  @override
  State<TotpSetupScreen> createState() => _TotpSetupScreenState();
}

class _TotpSetupScreenState extends State<TotpSetupScreen> {
  TotpEnrollment? _enrollment;
  Object? _error;

  @override
  void initState() {
    super.initState();
    widget.state.api.startTotp().then(
      (e) => mounted ? setState(() => _enrollment = e) : null,
      onError: (Object e) => mounted ? setState(() => _error = e) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final enrollment = _enrollment;
    return AuthCard(
      title: 'İkinci addım (2FA)',
      children: [
        const Text(
          'Telefonunuzda authenticator tətbiqini açın (Google Authenticator, '
          'Microsoft Authenticator və ya oxşarı) və bu QR kodu skan edin.',
        ),
        const SizedBox(height: 16),
        if (_error != null) Text(errorText(_error!)),
        if (enrollment == null && _error == null)
          const Center(child: CircularProgressIndicator()),
        if (enrollment != null) ...[
          Center(
            child: Semantics(
              label: 'QR kod',
              child: QrImageView(data: enrollment.uri, size: 200),
            ),
          ),
          const SizedBox(height: 8),
          const Text('Skan edə bilmirsinizsə, bu açarı əl ilə yazın:'),
          SelectableText(
            enrollment.secret,
            key: const ValueKey('totp-secret'),
            style: const TextStyle(fontFamily: 'monospace', letterSpacing: 2),
          ),
          const SizedBox(height: 16),
          CodeForm(
            label: 'Tətbiqdəki 6 rəqəmli kod',
            button: 'Təsdiqlə',
            submit: (code) async =>
                widget.state.update(await widget.state.api.confirmTotp(code)),
          ),
        ],
      ],
    );
  }
}

/// The second factor at every sign-in.
class TotpScreen extends StatelessWidget {
  const TotpScreen({super.key, required this.state});

  final StaffState state;

  @override
  Widget build(BuildContext context) => AuthCard(
    title: 'Təsdiq kodu',
    children: [
      const Text('Authenticator tətbiqindəki 6 rəqəmli kodu yazın.'),
      const SizedBox(height: 16),
      CodeForm(
        label: 'Kod',
        button: 'Davam et',
        submit: (code) async => state.update(await state.api.verifyTotp(code)),
      ),
      TextButton(onPressed: state.signOut, child: const Text('Çıxış')),
    ],
  );
}

/// A six-digit code field with its button.
class CodeForm extends StatefulWidget {
  const CodeForm({
    super.key,
    required this.label,
    required this.button,
    required this.submit,
  });

  final String label;
  final String button;
  final Future<void> Function(String code) submit;

  @override
  State<CodeForm> createState() => _CodeFormState();
}

class _CodeFormState extends State<CodeForm> {
  final _code = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _go() async {
    setState(() => _busy = true);
    try {
      await widget.submit(_code.text);
    } on Object catch (e) {
      _code.clear();
      if (mounted) _snack(context, errorText(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      TextField(
        key: const ValueKey('totp-code'),
        controller: _code,
        keyboardType: TextInputType.number,
        autofillHints: const [AutofillHints.oneTimeCode],
        maxLength: 6,
        decoration: InputDecoration(labelText: widget.label, counterText: ''),
        onSubmitted: (_) => _go(),
      ),
      const SizedBox(height: 12),
      FilledButton(
        key: const ValueKey('totp-submit'),
        onPressed: _busy ? null : _go,
        child: Text(widget.button),
      ),
    ],
  );
}

void _snack(BuildContext context, String text) => ScaffoldMessenger.of(context)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(text)));
