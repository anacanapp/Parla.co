import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parla_shared/parla_shared.dart';

import '../api/admin_api.dart';
import '../staff_session.dart';
import '../ui/texts.dart';
import '../ui/theme.dart';
import '../ui/widgets.dart';

String orderStatusLabel(ShopOrderStatus s) => switch (s) {
  ShopOrderStatus.created => 'Ödəniş gözlənilir',
  ShopOrderStatus.paid => 'Ödənilib',
  ShopOrderStatus.failed => 'Ödəniş alınmadı',
  ShopOrderStatus.shipped => 'Göndərilib',
  ShopOrderStatus.delivered => 'Çatdırılıb',
  ShopOrderStatus.cancelled => 'Ləğv edilib',
  ShopOrderStatus.refunded => 'Pul qaytarılıb',
};

PillTone orderStatusTone(ShopOrderStatus s) => switch (s) {
  ShopOrderStatus.paid => reviewTone,
  ShopOrderStatus.shipped => approvedTone,
  ShopOrderStatus.delivered => liveTone,
  ShopOrderStatus.failed ||
  ShopOrderStatus.cancelled ||
  ShopOrderStatus.refunded => dangerTone,
  ShopOrderStatus.created => neutralTone,
};

String manatText(int qepik) =>
    '${qepik ~/ 100}.${(qepik % 100).toString().padLeft(2, '0')} ₼';

/// Shop orders sold in the app (admins only). Only the order itself is
/// shown: product, amount and status, never the buyer's account.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key, required this.state});

  final StaffState state;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<ShopOrderView>? _orders;
  Object? _error;

  AdminApi get _api => widget.state.api;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final orders = await _api.shopOrders();
      if (mounted) setState(() => _orders = orders);
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _act(Future<void> Function() call, String done) async {
    try {
      await call();
      if (mounted) showToast(context, done);
      await _load();
    } on Object catch (e) {
      if (mounted) showToast(context, errorText(e));
    }
  }

  Future<bool> _confirm(String text) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Ləğv et'),
            ),
            FilledButton(
              key: const ValueKey('confirm-yes'),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Bəli'),
            ),
          ],
        ),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final orders = _orders;
    final date = DateFormat('dd.MM.yyyy HH:mm');
    return AdminPage(
      title: 'Sifarişlər',
      subtitle:
          'Tətbiqdə satılan məhsulların sifarişləri. Kart məlumatı Parla-ya '
          'gəlmir: ödəniş Epoint səhifəsində olur. Alıcının hesabı burada '
          'görünmür. Hər əməliyyat audit jurnalına yazılır.',
      maxWidth: 1000,
      children: [
        if (_error != null)
          Notice(
            tone: NoticeTone.danger,
            icon: Icons.error_outline,
            title: errorText(_error!),
          ),
        if (orders == null && _error == null) const LoadingBlock(),
        if (orders != null)
          Card(
            child: orders.isEmpty
                ? const EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'Hələ sifariş yoxdur',
                    body:
                        'Tətbiqdə satış Epoint açarları daxil edilib satış '
                        'açılandan sonra başlayır.',
                  )
                : Column(
                    children: [
                      for (final o in orders)
                        ListTile(
                          key: ValueKey('order-${o.number}'),
                          leading: const Icon(Icons.receipt_long_outlined),
                          title: Text(
                            '${o.number} · ${ContentRules.pick(_title(o), 'az')}',
                          ),
                          subtitle: Text(
                            '${o.brand} · ${o.quantity} əd. · '
                            '${manatText(o.totalQepik)} · '
                            '${o.seller == 'parla' ? 'Parla satır' : 'Brend satır'} · '
                            '${date.format(o.createdAt.toLocal())}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Pill(
                                orderStatusLabel(o.status),
                                tone: orderStatusTone(o.status),
                              ),
                              PopupMenuButton<String>(
                                key: ValueKey('order-menu-${o.number}'),
                                tooltip: 'Əməliyyatlar',
                                onSelected: (v) async {
                                  if (v == 'refund') {
                                    if (await _confirm(
                                      '${o.number}: ${manatText(o.totalQepik)} '
                                      'karta qaytarılsın? Geri almaq olmur.',
                                    )) {
                                      await _act(
                                        () => _api.refundShopOrder(o.number),
                                        'Pul qaytarıldı.',
                                      );
                                    }
                                    return;
                                  }
                                  final status = ShopOrderStatus.values.byName(
                                    v,
                                  );
                                  await _act(
                                    () => _api.setShopOrderStatus(
                                      o.number,
                                      status,
                                    ),
                                    'Status dəyişdi.',
                                  );
                                },
                                itemBuilder: (_) => [
                                  if (o.status == ShopOrderStatus.paid)
                                    const PopupMenuItem(
                                      value: 'shipped',
                                      child: Text('Göndərildi'),
                                    ),
                                  if (o.status == ShopOrderStatus.shipped)
                                    const PopupMenuItem(
                                      value: 'delivered',
                                      child: Text('Çatdırıldı'),
                                    ),
                                  if (o.status == ShopOrderStatus.created ||
                                      o.status == ShopOrderStatus.failed)
                                    const PopupMenuItem(
                                      value: 'cancelled',
                                      child: Text('Ləğv et'),
                                    ),
                                  if (const {
                                    ShopOrderStatus.paid,
                                    ShopOrderStatus.shipped,
                                    ShopOrderStatus.delivered,
                                  }.contains(o.status))
                                    const PopupMenuItem(
                                      value: 'refund',
                                      child: Text('Pulu qaytar'),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
          ),
        const SizedBox(height: 12),
        const Text(
          'Çatdırılma məlumatları (ünvan, telefon) növbəti mərhələdə '
          'şifrəli şəkildə əlavə olunacaq.',
          style: TextStyle(color: AdminColors.muted),
        ),
      ],
    );
  }

  static Object? _title(ShopOrderView o) {
    try {
      return jsonDecode(o.productTitle);
    } on FormatException {
      return o.productTitle;
    }
  }
}
