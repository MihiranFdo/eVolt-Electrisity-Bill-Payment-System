import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

// ─── Admin Panel ──────────────────────────────────────────────────────────────
class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _navIndex = 0;

  final _pages = const [
    _AdminDashboardTab(),
    _AdminCustomersTab(),
    _AdminMetersTab(),
    _AdminBillsTab(),
    _AdminReportsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: _pages[_navIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgPrimary,
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(icon: Icons.dashboard_rounded,      label: 'Dashboard', index: 0, current: _navIndex, onTap: (i) => setState(() => _navIndex = i)),
            _NavItem(icon: Icons.people_rounded,          label: 'Customers', index: 1, current: _navIndex, onTap: (i) => setState(() => _navIndex = i)),
            _NavItem(icon: Icons.electric_meter_rounded,  label: 'Meters',    index: 2, current: _navIndex, onTap: (i) => setState(() => _navIndex = i)),
            _NavItem(icon: Icons.receipt_long_rounded,    label: 'Bills',     index: 3, current: _navIndex, onTap: (i) => setState(() => _navIndex = i)),
            _NavItem(icon: Icons.bar_chart_rounded,       label: 'Reports',   index: 4, current: _navIndex, onTap: (i) => setState(() => _navIndex = i)),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;

  const _NavItem({required this.icon, required this.label, required this.index, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final active = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: active ? AppColors.accentBlue : AppColors.textMuted),
          const SizedBox(height: 3),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: active ? FontWeight.w600 : FontWeight.w400, color: active ? AppColors.accentBlue : AppColors.textMuted)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 1 — DASHBOARD
// ─────────────────────────────────────────────────────────────────────────────
class _AdminDashboardTab extends StatelessWidget {
  const _AdminDashboardTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admin Panel', style: AppTextStyles.headlineLarge),
                    const SizedBox(height: 2),
                    Text('eVolt System Overview', style: AppTextStyles.bodyMedium),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border, width: 0.5),
                  ),
                  child: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.accentBlue, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Stats grid
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                _StatCard(label: 'Total Customers', value: '1,284', icon: Icons.people_rounded, color: AppColors.accentBlue),
                _StatCard(label: 'Active Meters',   value: '1,271', icon: Icons.electric_meter_rounded, color: AppColors.successGreen),
                _StatCard(label: 'Unpaid Bills',    value: '143',   icon: Icons.receipt_long_rounded, color: AppColors.warningOrange),
                _StatCard(label: 'This Month (LKR)','value': '2.4M', icon: Icons.payments_rounded, color: AppColors.supportPurple),
              ],
            ),
            const SizedBox(height: 20),

            // Recent activity
            Text('Recent Activity', style: AppTextStyles.titleLarge),
            const SizedBox(height: 10),
            SurfaceCard(
              child: Column(
                children: const [
                  ActivityRow(icon: Icons.person_add_rounded,       iconColor: AppColors.accentBlue,    iconBg: Color(0xFF0E2A4A), title: 'New customer registered', subtitle: 'Nimal Perera — Meter #1043',    amount: 'Just now',   amountColor: AppColors.textSecondary),
                  ActivityRow(icon: Icons.receipt_rounded,          iconColor: AppColors.successGreen,  iconBg: Color(0xFF0A2E1A), title: 'Bill generated',          subtitle: 'Account #2087 — May 2025',   amount: 'LKR 4,850',  amountColor: AppColors.successGreen),
                  ActivityRow(icon: Icons.warning_amber_rounded,    iconColor: AppColors.warningOrange, iconBg: Color(0xFF2E1A0A), title: 'Anomaly detected',        subtitle: 'Meter #0892 — 320% spike',   amount: 'Alert',      amountColor: AppColors.warningOrange),
                  ActivityRow(icon: Icons.payments_rounded,         iconColor: AppColors.successGreen,  iconBg: Color(0xFF0A2E1A), title: 'Payment received',        subtitle: 'Account #1156 — Apr bill',   amount: 'LKR 3,200',  amountColor: AppColors.successGreen),
                  ActivityRow(icon: Icons.electric_meter_rounded,   iconColor: AppColors.textSecondary, iconBg: Color(0xFF112240), title: 'Reading submitted',       subtitle: 'Meter #0341 — Colombo 07',   amount: '218 kWh',    amountColor: AppColors.textSecondary, isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick actions
            Text('Quick Actions', style: AppTextStyles.titleLarge),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _QuickAction(icon: Icons.person_add_rounded,      label: 'Add Customer', color: AppColors.accentBlue)),
                const SizedBox(width: 10),
                Expanded(child: _QuickAction(icon: Icons.electric_meter_rounded,  label: 'Add Meter',    color: AppColors.successGreen)),
                const SizedBox(width: 10),
                Expanded(child: _QuickAction(icon: Icons.tune_rounded,            label: 'Set Tariff',   color: AppColors.warningOrange)),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 2 — CUSTOMERS
// ─────────────────────────────────────────────────────────────────────────────
class _AdminCustomersTab extends StatelessWidget {
  const _AdminCustomersTab();

  static const _customers = [
    {'name': 'Nimal Perera',    'account': '#1001', 'meter': '#0341', 'status': 'Active',   'paid': true},
    {'name': 'Kamala Silva',    'account': '#1002', 'meter': '#0892', 'status': 'Active',   'paid': false},
    {'name': 'Ruwan Fernando',  'account': '#1003', 'meter': '#1043', 'status': 'Active',   'paid': true},
    {'name': 'Saman Bandara',   'account': '#1004', 'meter': '#0561', 'status': 'Inactive', 'paid': false},
    {'name': 'Priya Jayasena',  'account': '#1005', 'meter': '#0774', 'status': 'Active',   'paid': true},
    {'name': 'Dilshan Weerasinghe','account': '#1006','meter': '#0229','status': 'Active',  'paid': false},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Customers', style: AppTextStyles.headlineLarge),
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(gradient: AppColors.actionGradient, borderRadius: BorderRadius.circular(9)),
                    child: const Row(children: [Icon(Icons.add, size: 14, color: Colors.white), SizedBox(width: 4), Text('Add', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
              decoration: BoxDecoration(color: AppColors.surfaceRaised, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border, width: 0.5)),
              child: const Row(children: [
                Icon(Icons.search_rounded, size: 16, color: AppColors.textMuted),
                SizedBox(width: 8),
                Text('Search customers...', style: TextStyle(fontSize: 13, color: AppColors.textMuted)),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _customers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final c = _customers[i];
                final paid = c['paid'] as bool;
                final active = c['status'] == 'Active';
                return SurfaceCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(color: const Color(0xFF0E2A4A), borderRadius: BorderRadius.circular(10)),
                        child: Center(child: Text((c['name'] as String)[0], style: const TextStyle(color: AppColors.accentBlue, fontWeight: FontWeight.w700, fontSize: 16))),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c['name'] as String, style: AppTextStyles.titleMedium),
                            const SizedBox(height: 2),
                            Text('Account ${c['account']}  ·  Meter ${c['meter']}', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _StatusBadge(label: c['status'] as String, color: active ? AppColors.successGreen : AppColors.textMuted),
                          const SizedBox(height: 4),
                          _StatusBadge(label: paid ? 'Paid' : 'Unpaid', color: paid ? AppColors.successGreen : AppColors.dangerRed),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 3 — METERS
// ─────────────────────────────────────────────────────────────────────────────
class _AdminMetersTab extends StatelessWidget {
  const _AdminMetersTab();

  static const _meters = [
    {'id': '#0341', 'address': '42 Galle Road, Colombo 03',    'customer': 'Nimal Perera',       'reading': '4,218 kWh', 'status': 'Normal'},
    {'id': '#0892', 'address': '15 Kandy Road, Kurunegala',    'customer': 'Kamala Silva',        'reading': '6,031 kWh', 'status': 'Anomaly'},
    {'id': '#1043', 'address': '7 Temple Lane, Negombo',       'customer': 'Ruwan Fernando',     'reading': '2,874 kWh', 'status': 'Normal'},
    {'id': '#0561', 'address': '88 High Level Rd, Maharagama', 'customer': 'Saman Bandara',      'reading': '1,540 kWh', 'status': 'Inactive'},
    {'id': '#0774', 'address': '23 Flower Road, Colombo 07',   'customer': 'Priya Jayasena',     'reading': '3,762 kWh', 'status': 'Normal'},
    {'id': '#0229', 'address': '5 Station Rd, Gampaha',        'customer': 'Dilshan Weerasinghe','reading': '5,109 kWh', 'status': 'Normal'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Meters', style: AppTextStyles.headlineLarge),
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(gradient: AppColors.actionGradient, borderRadius: BorderRadius.circular(9)),
                    child: const Row(children: [Icon(Icons.add, size: 14, color: Colors.white), SizedBox(width: 4), Text('Add', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))]),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _meters.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final m = _meters[i];
                final statusColor = switch (m['status']) {
                  'Anomaly'  => AppColors.dangerRed,
                  'Inactive' => AppColors.textMuted,
                  _          => AppColors.successGreen,
                };
                return SurfaceCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(color: const Color(0xFF0E2A4A), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.electric_meter_rounded, color: AppColors.accentBlue, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Meter ${m['id']}', style: AppTextStyles.titleMedium),
                            const SizedBox(height: 2),
                            Text(m['customer'] as String, style: AppTextStyles.bodyMedium),
                            const SizedBox(height: 1),
                            Text(m['address'] as String, style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _StatusBadge(label: m['status'] as String, color: statusColor),
                          const SizedBox(height: 4),
                          Text(m['reading'] as String, style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 4 — BILLS
// ─────────────────────────────────────────────────────────────────────────────
class _AdminBillsTab extends StatelessWidget {
  const _AdminBillsTab();

  static const _bills = [
    {'id': 'B-2025-001', 'customer': 'Nimal Perera',        'period': 'May 2025', 'amount': 'LKR 4,850', 'status': 'Paid'},
    {'id': 'B-2025-002', 'customer': 'Kamala Silva',        'period': 'May 2025', 'amount': 'LKR 8,120', 'status': 'Unpaid'},
    {'id': 'B-2025-003', 'customer': 'Ruwan Fernando',      'period': 'May 2025', 'amount': 'LKR 2,960', 'status': 'Paid'},
    {'id': 'B-2025-004', 'customer': 'Saman Bandara',       'period': 'May 2025', 'amount': 'LKR 1,740', 'status': 'Overdue'},
    {'id': 'B-2025-005', 'customer': 'Priya Jayasena',      'period': 'May 2025', 'amount': 'LKR 5,310', 'status': 'Paid'},
    {'id': 'B-2025-006', 'customer': 'Dilshan Weerasinghe', 'period': 'May 2025', 'amount': 'LKR 6,670', 'status': 'Unpaid'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Bills', style: AppTextStyles.headlineLarge),
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(gradient: AppColors.actionGradient, borderRadius: BorderRadius.circular(9)),
                    child: const Row(children: [Icon(Icons.add, size: 14, color: Colors.white), SizedBox(width: 4), Text('Generate', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))]),
                  ),
                ),
              ],
            ),
          ),
          // Summary row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: const [
              Expanded(child: _MiniStat(label: 'Total',   value: '1,284', color: AppColors.textSecondary)),
              SizedBox(width: 8),
              Expanded(child: _MiniStat(label: 'Paid',    value: '941',   color: AppColors.successGreen)),
              SizedBox(width: 8),
              Expanded(child: _MiniStat(label: 'Unpaid',  value: '201',   color: AppColors.warningOrange)),
              SizedBox(width: 8),
              Expanded(child: _MiniStat(label: 'Overdue', value: '142',   color: AppColors.dangerRed)),
            ]),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _bills.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final b = _bills[i];
                final statusColor = switch (b['status']) {
                  'Paid'    => AppColors.successGreen,
                  'Overdue' => AppColors.dangerRed,
                  _         => AppColors.warningOrange,
                };
                return SurfaceCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(color: const Color(0xFF0E2A4A), borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.receipt_long_rounded, color: AppColors.accentBlue, size: 18),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(b['customer'] as String, style: AppTextStyles.titleMedium),
                            const SizedBox(height: 2),
                            Text('${b['id']}  ·  ${b['period']}', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(b['amount'] as String, style: AppTextStyles.titleMedium.copyWith(color: AppColors.accentBlue)),
                          const SizedBox(height: 4),
                          _StatusBadge(label: b['status'] as String, color: statusColor),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 5 — REPORTS
// ─────────────────────────────────────────────────────────────────────────────
class _AdminReportsTab extends StatelessWidget {
  const _AdminReportsTab();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text('Reports', style: AppTextStyles.headlineLarge),
            const SizedBox(height: 4),
            Text('May 2025 Summary', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),

            // Revenue card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.billGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Revenue', style: TextStyle(fontSize: 11, color: Color(0xFFA8D8F0), fontWeight: FontWeight.w500)),
                  const SizedBox(height: 4),
                  const Text('LKR 2,418,500', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.5)),
                  const SizedBox(height: 8),
                  Row(children: const [
                    Icon(Icons.trending_up_rounded, size: 14, color: AppColors.successGreen),
                    SizedBox(width: 4),
                    Text('+12.4% from last month', style: TextStyle(fontSize: 11, color: AppColors.successGreen)),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Consumption bar chart
            Text('Monthly Consumption (kWh)', style: AppTextStyles.titleLarge),
            const SizedBox(height: 10),
            SurfaceCard(child: _SimpleBarChart()),
            const SizedBox(height: 16),

            // Tariff config
            Text('Tariff Configuration', style: AppTextStyles.titleLarge),
            const SizedBox(height: 10),
            SurfaceCard(
              child: Column(
                children: const [
                  BillDetailRow(label: 'Block 1 (0–30 units)',   value: 'LKR 4.00 / unit'),
                  BillDetailRow(label: 'Block 2 (31–60 units)',  value: 'LKR 10.00 / unit'),
                  BillDetailRow(label: 'Block 3 (61–90 units)',  value: 'LKR 27.75 / unit'),
                  BillDetailRow(label: 'Block 4 (91–180 units)', value: 'LKR 32.00 / unit'),
                  BillDetailRow(label: 'Block 5 (181+ units)',   value: 'LKR 45.00 / unit'),
                  BillDetailRow(label: 'Fixed Charge',           value: 'LKR 400.00'),
                  BillDetailRow(label: 'VAT',                    value: '15%', isLast: true),
                ],
              ),
            ),
            const SizedBox(height: 16),
            PrimaryButton(label: 'Update Tariff Rates', onTap: () {}),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, size: 20, color: color),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
              Text(label,  style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickAction({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Column(
        children: [
          Icon(icon, size: 22, color: color),
          const SizedBox(height: 6),
          Text(label, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(fontSize: 9, color: color, fontWeight: FontWeight.w600)),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 2),
          Text(label, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

class _SimpleBarChart extends StatelessWidget {
  final _data = const [180, 210, 195, 240, 175, 260];
  final _months = const ['Dec', 'Jan', 'Feb', 'Mar', 'Apr', 'May'];

  const _SimpleBarChart();

  @override
  Widget build(BuildContext context) {
    final max = _data.reduce((a, b) => a > b ? a : b).toDouble();
    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_data.length, (i) {
          final ratio = _data[i] / max;
          final isLast = i == _data.length - 1;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('${_data[i]}', style: const TextStyle(fontSize: 8, color: AppColors.textMuted)),
              const SizedBox(height: 4),
              Container(
                width: 28,
                height: 80 * ratio,
                decoration: BoxDecoration(
                  color: isLast ? AppColors.accentBlue : AppColors.border,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ),
              const SizedBox(height: 4),
              Text(_months[i], style: TextStyle(fontSize: 9, color: isLast ? AppColors.accentBlue : AppColors.textMuted, fontWeight: isLast ? FontWeight.w600 : FontWeight.w400)),
            ],
          );
        }),
      ),
    );
  }
}
