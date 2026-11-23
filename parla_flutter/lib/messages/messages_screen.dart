import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parla_shared/parla_shared.dart';

import '../discover/banner_strip.dart';
import '../discover/content_library.dart';
import '../discover/discover_widgets.dart';
import '../l10n/app_localizations.dart';
import '../parla_scope.dart';
import '../push/push_client.dart';
import '../routes.dart';
import '../services/parla_api.dart';
import '../ui/brand.dart';
import '../ui/night.dart';
import '../ui/common.dart';

/// Messages: the team's announcements and the user's own support
/// conversation. Support messages are stored encrypted on the server and
/// deleted 12 months after the last one; read state stays on the phone.
class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _text = TextEditingController();
  List<SupportItem>? _support;
  bool _busy = false;
  bool _started = false;

  /// Whether this phone has notifications on (`null` until read).
  bool? _push;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    _load();
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _togglePush(bool on) async {
    final client = PushService.client;
    if (client == null) return;
    final l10n = AppLocalizations.of(context);
    final api = ParlaScope.of(context).api;
    try {
      if (on) {
        if (!await client.requestPermission()) {
          if (mounted) showError(context, l10n.pushDenied);
          return;
        }
        final token = await client.token();
        if (token == null) return;
        await api.registerPush(token, client.platform);
        await PushPrefs.setToken(token);
      } else {
        final token = await PushPrefs.token();
        if (token != null) await api.unregisterPush(token);
        await PushPrefs.setToken(null);
      }
      if (mounted) setState(() => _push = on);
    } on Object catch (error) {
      if (mounted) showError(context, errorMessage(l10n, error));
    }
  }

  Future<void> _load() async {
    final api = ParlaScope.of(context).api;
    final token = await PushPrefs.token();
    if (mounted) setState(() => _push = token != null);
    try {
      final items = await api.supportMessages();
      if (mounted) setState(() => _support = items);
    } on Object {
      if (mounted) setState(() => _support = const []);
    }
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    final text = _text.text.trim();
    if (text.isEmpty) return;
    setState(() => _busy = true);
    try {
      await ParlaScope.of(context).api.sendSupport(text);
      _text.clear();
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(l10n.supportSent)));
      }
      await _load();
    } on Object catch (error) {
      if (mounted) showError(context, errorMessage(l10n, error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scope = ParlaScope.of(context);
    final language = Localizations.localeOf(context).languageCode;
    final today = scope.clock();
    return SubPage(
      title: l10n.messagesTitle,
      onBack: () => context.go(Routes.home),
      children: [
        if (PushService.client != null && _push != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Material(
              color: NightColors.glass,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
                side: const BorderSide(color: NightColors.glassLine),
              ),
              clipBehavior: Clip.antiAlias,
              child: SwitchListTile(
                key: const ValueKey('push-switch'),
                title: Text(l10n.pushTitle),
                subtitle: Text(l10n.pushBody),
                value: _push!,
                onChanged: _togglePush,
              ),
            ),
          ),
        Semantics(
          header: true,
          child: Text(l10n.messagesFromParla, style: text.titleLarge),
        ),
        const SizedBox(height: 8),
        ListenableBuilder(
          listenable: scope.content,
          builder: (context, _) {
            final notes = [
              for (final m in scope.content.items('message'))
                if (ContentRules.bannerVisible(
                  m.data,
                  today,
                  language: language,
                  country: ContentLibrary.country,
                ))
                  m,
            ];
            if (notes.isEmpty) {
              return Text(l10n.messagesNone, style: text.bodyMedium);
            }
            return Column(
              children: [
                for (final m in notes)
                  Container(
                    key: ValueKey('message-${m.slug}'),
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: NightColors.glass,
                      border: Border.all(color: NightColors.glassLine),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.text('title', language),
                          style: text.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(m.text('body', language), style: text.bodyMedium),
                        if (m.data['link'] case final String link)
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: TextButton(
                              onPressed: () => openBannerLink(context, link),
                              child: const Icon(Icons.arrow_forward),
                            ),
                          ),
                      ],
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        Semantics(
          header: true,
          child: Text(l10n.supportTitle, style: text.titleLarge),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.supportIntro,
          style: text.bodySmall?.copyWith(color: ParlaColors.muted),
        ),
        const SizedBox(height: 12),
        if (_support == null)
          const Center(child: CircularProgressIndicator())
        else
          for (final m in _support!)
            Align(
              alignment: m.fromTeam
                  ? AlignmentDirectional.centerStart
                  : AlignmentDirectional.centerEnd,
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                constraints: const BoxConstraints(maxWidth: 320),
                decoration: BoxDecoration(
                  color: m.fromTeam ? NightColors.glass : ParlaColors.lemon,
                  border: Border.all(color: NightColors.glassLine),
                  borderRadius: BorderRadius.circular(ParlaSpace.cardRadius),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m.fromTeam ? l10n.supportTeam : l10n.supportYou,
                      style: text.labelMedium,
                    ),
                    Text(m.text, style: text.bodyMedium),
                  ],
                ),
              ),
            ),
        const SizedBox(height: 8),
        TextField(
          key: const ValueKey('support-text'),
          controller: _text,
          minLines: 2,
          maxLines: 6,
          maxLength: 2000,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(hintText: l10n.supportHint),
        ),
        Align(
          alignment: AlignmentDirectional.centerEnd,
          child: FilledButton(
            key: const ValueKey('support-send'),
            onPressed: _busy ? null : _send,
            child: Text(l10n.supportSend),
          ),
        ),
      ],
    );
  }
}
