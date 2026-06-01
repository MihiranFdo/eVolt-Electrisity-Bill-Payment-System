import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../l10n/app_strings.dart';

// ─── History Screen ────────────────────────────────────────────────────────────
class HistoryScreen extends StatefulWidget {
  final AppLanguage language;
  const HistoryScreen({super.key, this.language = AppLanguage.english});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _filterIndex = 0; // 0=All, 1=Paid, 2=Unpaid

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final _bills = const [
    _BillRecord(
        month: 'May 2025',
        units: 187,
        amount: 9420,
        status: 'paid',
        date: '01 Jun 2025',
        billId: 'BILL-2025-05'),
    _BillRecord(
        month: 'April 2025',
        units: 163,
        amount: 7850,
        status: 'paid',
        date: '01 May 2025',
        billId: 'BILL-2025-04'),
    _BillRecord(
        month: 'March 2025',
        units: 210,
        amount: 11200,
        status: 'paid',
        date: '01 Apr 2025',
        billId: 'BILL-2025-03'),
    _BillRecord(
        month: 'February 2025',
        units: 142,
        amount: 6100,
        status: 'paid',
        date: '01 Mar 2025',
        billId: 'BILL-2025-02'),
    _BillRecord(
        month: 'January 2025',
        units: 155,
        amount: 6800,
        status: 'paid',
        date: '01 Feb 2025',
        billId: 'BILL-2025-01'),
    _BillRecord(
        month: 'December 2024',
        units: 230,
        amount: 13500,
        status: 'paid',
        date: '01 Jan 2025',
        billId: 'BILL-2024-12'),
  ];

  final _payments = const [
    _PaymentRecord(
        billId: 'BILL-2025-05',
        amount: 9420,
        date: '15 May 2025',
        method: 'Visa •••• 4821',
        txnId: 'TXN-5512-20250515'),
    _PaymentRecord(
        billId: 'BILL-2025-04',
        amount: 7850,
        date: '12 Apr 2025',
        method: 'Visa •••• 4821',
        txnId: 'TXN-4891-20250412'),
    _PaymentRecord(
        billId: 'BILL-2025-03',
        amount: 11200,
        date: '18 Mar 2025',
        method: 'Bank Transfer',
        txnId: 'TXN-3340-20250318'),
    _PaymentRecord(
        billId: 'BILL-2025-02',
        amount: 6100,
        date: '10 Feb 2025',
        method: 'Mobile Wallet',
        txnId: 'TXN-2211-20250210'),
    _PaymentRecord(
        billId: 'BILL-2025-01',
        amount: 6800,
        date: '08 Jan 2025',
        method: 'Mastercard •••• 7392',
        txnId: 'TXN-1035-20250108'),
  ];

  List<_BillRecord> get _filteredBills {
    if (_filterIndex == 1) {
      return _bills.where((b) => b.status == 'paid').toList();
    }
    if (_filterIndex == 2) {
      return _bills.where((b) => b.status == 'unpaid').toList();
    }
    return _bills;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.bgPrimary,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 18, color: AppColors.textPrimary),
        ),
        title: const Text('History'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.accentBlue,
          indicatorWeight: 2,
          labelColor: AppColors.accentBlue,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 13),
          tabs: const [
            Tab(text: 'Bills'),
            Tab(text: 'Payments'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _BillsTab(
              bills: _filteredBills,
              filterIndex: _filterIndex,
              onFilter: (i) => setState(() => _filterIndex = i),
            ),
            _PaymentsTab(payments: _payments),
          ],
        ),
      ),
    );
  }
}

// ─── Bills Tab ─────────────────────────────────────────────────────────────────
class _BillsTab extends StatelessWidget {
  final List<_BillRecord> bills;
  final int filterIndex;
  final ValueChanged<int> onFilter;

  const _BillsTab({
    required this.bills,
    required this.filterIndex,
    required this.onFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Filter chips
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              _FilterChip(
                  label: 'All',
                  selected: filterIndex == 0,
                  onTap: () => onFilter(0)),
              const SizedBox(width: 8),
              _FilterChip(
                  label: 'Paid',
                  selected: filterIndex == 1,
                  onTap: () => onFilter(1)),
              const SizedBox(width: 8),
              _FilterChip(
                  label: 'Unpaid',
                  selected: filterIndex == 2,
                  onTap: () => onFilter(2)),
            ],
          ),
        ),

        // Stats summary
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Expanded(
                  child: _StatBox(
                label: 'Total Paid',
                value: 'LKR 54,870',
                color: AppColors.successGreen,
              )),
              const SizedBox(width: 8),
              const Expanded(
                  child: _StatBox(
                label: 'Avg Monthly',
                value: '174 kWh',
                color: AppColors.accentBlue,
              )),
              const SizedBox(width: 8),
              Expanded(
                  child: _StatBox(
                label: 'Total Bills',
                value: '${bills.length}',
                color: AppColors.supportPurple,
              )),
            ],
          ),
        ),

        // Bill list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            itemCount: bills.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final bill = bills[i];
              final isPaid = bill.status == 'paid';
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  border: Border.all(color: AppColors.border, width: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isPaid
                            ? const Color(0xFF0A2A1A)
                            : const Color(0xFF2A1A0A),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        isPaid
                            ? Icons.check_circle_rounded
                            : Icons.pending_rounded,
                        size: 20,
                        color: isPaid
                            ? AppColors.successGreen
                            : AppColors.warningOrange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bill.month,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text('${bill.units} kWh · ${bill.billId}',
                              style: const TextStyle(
                                  fontSize: 10, color: AppColors.textMuted)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('LKR ${_fmt(bill.amount)}',
                            style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: isPaid
                                ? const Color(0xFF0A2A1A)
                                : const Color(0xFF2A1A0A),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            isPaid ? 'Paid' : 'Unpaid',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: isPaid
                                  ? AppColors.successGreen
                                  : AppColors.warningOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _fmt(int v) {
    final s = v.toString();
    if (s.length <= 3) return s;
    return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
  }
}

// ─── Payments Tab ──────────────────────────────────────────────────────────────
class _PaymentsTab extends StatelessWidget {
  final List<_PaymentRecord> payments;
  const _PaymentsTab({required this.payments});

  String _fmt(int v) {
    final s = v.toString();
    if (s.length <= 3) return s;
    return '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}';
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      itemCount: payments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final p = payments[i];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            border: Border.all(color: AppColors.border, width: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A1E3A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.payment_rounded,
                        size: 20, color: AppColors.accentBlue),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(p.billId,
                            style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600)),
                        Text(p.method,
                            style: const TextStyle(
                                fontSize: 10, color: AppColors.textMuted)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('LKR ${_fmt(p.amount)}',
                          style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.successGreen,
                              fontWeight: FontWeight.w700)),
                      Text(p.date,
                          style: const TextStyle(
                              fontSize: 10, color: AppColors.textMuted)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(color: AppColors.border, height: 1, thickness: 0.5),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.receipt_rounded,
                      size: 11, color: AppColors.textMuted),
                  const SizedBox(width: 5),
                  Text(p.txnId,
                      style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textMuted,
                          fontFamily: 'monospace')),
                  const Spacer(),
                  const Icon(Icons.download_rounded,
                      size: 13, color: AppColors.accentBlue),
                  const SizedBox(width: 3),
                  const Text('Receipt',
                      style: TextStyle(
                          fontSize: 10,
                          color: AppColors.accentBlue,
                          fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─── Data models ──────────────────────────────────────────────────────────────
class _BillRecord {
  final String month, status, date, billId;
  final int units, amount;
  const _BillRecord(
      {required this.month,
      required this.units,
      required this.amount,
      required this.status,
      required this.date,
      required this.billId});
}

class _PaymentRecord {
  final String billId, date, method, txnId;
  final int amount;
  const _PaymentRecord(
      {required this.billId,
      required this.amount,
      required this.date,
      required this.method,
      required this.txnId});
}

// ─── Small widgets ─────────────────────────────────────────────────────────────
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          gradient: selected ? AppColors.actionGradient : null,
          color: selected ? null : AppColors.surfaceRaised,
          border: Border.all(
              color: selected ? Colors.transparent : AppColors.border,
              width: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: selected ? Colors.white : AppColors.textSecondary)),
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatBox(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceRaised,
        border: Border.all(color: AppColors.border, width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 9, color: AppColors.textMuted)),
          const SizedBox(height: 3),
          Text(value,
              style: TextStyle(
                  fontSize: 11, color: color, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
