import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';

// ─── Meter Reader Screen ──────────────────────────────────────────────────────
class MeterReaderScreen extends StatefulWidget {
  const MeterReaderScreen({super.key});

  @override
  State<MeterReaderScreen> createState() => _MeterReaderScreenState();
}

class _MeterReaderScreenState extends State<MeterReaderScreen> {
  int _navIndex = 0;

  final _pages = const [
    _ReaderDashboardTab(),
    _ReaderSubmitTab(),
    _ReaderHistoryTab(),
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
            _NavItem(icon: Icons.home_rounded,          label: 'Home',    index: 0, current: _navIndex, onTap: (i) => setState(() => _navIndex = i)),
            _NavItem(icon: Icons.qr_code_scanner_rounded, label: 'Submit', index: 1, current: _navIndex, onTap: (i) => setState(() => _navIndex = i)),
            _NavItem(icon: Icons.history_rounded,        label: 'History', index: 2, current: _navIndex, onTap: (i) => setState(() => _navIndex = i)),
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
// TAB 1 — DASHBOARD (Assigned Meters)
// ─────────────────────────────────────────────────────────────────────────────
class _ReaderDashboardTab extends StatelessWidget {
  const _ReaderDashboardTab();

  static const _meters = [
    {'id': '#0341', 'name': 'Nimal Perera',        'address': '42 Galle Road, Colombo 03',    'lastReading': '4,100 kWh', 'submitted': true},
    {'id': '#0892', 'name': 'Kamala Silva',        'address': '15 Kandy Road, Kurunegala',    'lastReading': '5,880 kWh', 'submitted': false},
    {'id': '#1043', 'name': 'Ruwan Fernando',      'address': '7 Temple Lane, Negombo',       'lastReading': '2,710 kWh', 'submitted': false},
    {'id': '#0561', 'name': 'Saman Bandara',       'address': '88 High Level Rd, Maharagama', 'lastReading': '1,480 kWh', 'submitted': true},
    {'id': '#0774', 'name': 'Priya Jayasena',      'address': '23 Flower Road, Colombo 07',   'lastReading': '3,600 kWh', 'submitted': false},
    {'id': '#0229', 'name': 'Dilshan Weerasinghe', 'address': '5 Station Rd, Gampaha',        'lastReading': '4,970 kWh', 'submitted': true},
  ];

  int get _pendingCount => _meters.where((m) => !(m['submitted'] as bool)).length;
  int get _doneCount    => _meters.where((m) =>  (m['submitted'] as bool)).length;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Meter Reader', style: AppTextStyles.headlineLarge),
                    SizedBox(height: 2),
                    Text('May 2025 — Assigned Meters', style: AppTextStyles.bodyMedium),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.surfaceRaised, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border, width: 0.5)),
                  child: const Icon(Icons.person_rounded, color: AppColors.accentBlue, size: 22),
                ),
              ],
            ),
          ),

          // Progress summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SurfaceCard(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Submission Progress', style: AppTextStyles.titleMedium),
                      Text('$_doneCount / ${_meters.length}', style: AppTextStyles.titleMedium.copyWith(color: AppColors.accentBlue)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: _doneCount / _meters.length,
                      backgroundColor: AppColors.border,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accentBlue),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(children: [
                    _ProgressPill(label: 'Submitted', value: '$_doneCount',    color: AppColors.successGreen),
                    const SizedBox(width: 8),
                    _ProgressPill(label: 'Pending',   value: '$_pendingCount', color: AppColors.warningOrange),
                  ]),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Meter list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _meters.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final m = _meters[i];
                final submitted = m['submitted'] as bool;
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
                            const SizedBox(height: 1),
                            Text(m['name'] as String,    style: AppTextStyles.bodyMedium),
                            Text(m['address'] as String, style: AppTextStyles.bodySmall, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _StatusBadge(
                            label: submitted ? 'Done' : 'Pending',
                            color: submitted ? AppColors.successGreen : AppColors.warningOrange,
                          ),
                          const SizedBox(height: 4),
                          Text('Prev: ${m['lastReading']}', style: AppTextStyles.bodySmall),
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
// TAB 2 — SUBMIT READING
// ─────────────────────────────────────────────────────────────────────────────
class _ReaderSubmitTab extends StatefulWidget {
  const _ReaderSubmitTab();

  @override
  State<_ReaderSubmitTab> createState() => _ReaderSubmitTabState();
}

class _ReaderSubmitTabState extends State<_ReaderSubmitTab> {
  final _controller = TextEditingController();
  bool _scanned = false;
  bool _submitted = false;

  // Simulated scanned meter info
  static const _scannedMeter = {
    'id': '#0892',
    'name': 'Kamala Silva',
    'address': '15 Kandy Road, Kurunegala',
    'prevReading': '5,880',
    'prevDate': 'Apr 2025',
  };

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _simulateScan() => setState(() { _scanned = true; _submitted = false; _controller.clear(); });
  void _resetScan()    => setState(() { _scanned = false; _submitted = false; _controller.clear(); });

  void _submitReading() {
    if (_controller.text.isEmpty) return;
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text('Submit Reading', style: AppTextStyles.headlineLarge),
            const SizedBox(height: 4),
            const Text('Scan QR code then enter the meter reading', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 20),

            if (!_submitted) ...[
              // QR Scanner area
              GestureDetector(
                onTap: _simulateScan,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _scanned ? AppColors.successGreen : AppColors.border, width: _scanned ? 1.5 : 0.5),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _scanned ? Icons.check_circle_rounded : Icons.qr_code_scanner_rounded,
                          size: 56,
                          color: _scanned ? AppColors.successGreen : AppColors.textMuted,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _scanned ? 'Meter #0892 scanned' : 'Tap to scan QR code',
                          style: TextStyle(fontSize: 14, color: _scanned ? AppColors.successGreen : AppColors.textMuted, fontWeight: FontWeight.w500),
                        ),
                        if (!_scanned) ...[
                          const SizedBox(height: 4),
                          const Text('Point camera at meter QR code', style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Meter info card (shown after scan)
              if (_scanned) ...[
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Meter Info', style: AppTextStyles.titleMedium),
                          GestureDetector(
                            onTap: _resetScan,
                            child: const Text('Re-scan', style: TextStyle(fontSize: 11, color: AppColors.accentBlue, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(color: AppColors.border, height: 1),
                      const SizedBox(height: 10),
                      _InfoRow(label: 'Meter ID',       value: _scannedMeter['id']!),
                      _InfoRow(label: 'Customer',       value: _scannedMeter['name']!),
                      _InfoRow(label: 'Address',        value: _scannedMeter['address']!),
                      _InfoRow(label: 'Prev. Reading',  value: '${_scannedMeter['prevReading']} kWh'),
                      _InfoRow(label: 'Prev. Period',   value: _scannedMeter['prevDate']!, isLast: true),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Reading input
                SurfaceCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Current Reading (kWh)', style: AppTextStyles.titleMedium),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.bgPrimary,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border, width: 0.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.electric_bolt_rounded, size: 16, color: AppColors.accentBlue),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(fontSize: 18, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
                                decoration: const InputDecoration(
                                  hintText: 'e.g. 6,120',
                                  hintStyle: TextStyle(fontSize: 15, color: AppColors.textMuted, fontWeight: FontWeight.w400),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            const Text('kWh', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(label: 'Submit Reading', onTap: _submitReading),
              ],
            ],

            // Success state
            if (_submitted) ...[
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 72, height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.successGreen.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_rounded, size: 38, color: AppColors.successGreen),
                    ),
                    const SizedBox(height: 16),
                    Text('Reading Submitted!', style: AppTextStyles.headlineLarge.copyWith(color: AppColors.successGreen)),
                    const SizedBox(height: 8),
                    Text('Meter #0892 — ${_controller.text} kWh', style: AppTextStyles.bodyMedium),
                    const SizedBox(height: 4),
                    const Text('Bill has been generated automatically', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    const SizedBox(height: 32),
                    PrimaryButton(label: 'Scan Next Meter', onTap: _resetScan),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TAB 3 — SUBMISSION HISTORY
// ─────────────────────────────────────────────────────────────────────────────
class _ReaderHistoryTab extends StatelessWidget {
  const _ReaderHistoryTab();

  static const _history = [
    {'meter': '#0341', 'name': 'Nimal Perera',        'reading': '4,218 kWh', 'units': '118 kWh', 'date': 'Today, 09:14 AM'},
    {'meter': '#0561', 'name': 'Saman Bandara',       'reading': '1,540 kWh', 'units': '60 kWh',  'date': 'Today, 08:47 AM'},
    {'meter': '#0229', 'name': 'Dilshan Weerasinghe', 'reading': '5,109 kWh', 'units': '139 kWh', 'date': 'Today, 08:22 AM'},
    {'meter': '#0774', 'name': 'Priya Jayasena',      'reading': '3,762 kWh', 'units': '162 kWh', 'date': 'Yesterday, 04:10 PM'},
    {'meter': '#1043', 'name': 'Ruwan Fernando',      'reading': '2,874 kWh', 'units': '164 kWh', 'date': 'Yesterday, 03:45 PM'},
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
                const Text('My Submissions', style: AppTextStyles.headlineLarge),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(color: AppColors.surfaceRaised, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border, width: 0.5)),
                  child: const Text('May 2025', style: TextStyle(fontSize: 11, color: AppColors.accentBlue, fontWeight: FontWeight.w500)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _history.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final h = _history[i];
                return SurfaceCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          color: AppColors.successGreen.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.check_rounded, color: AppColors.successGreen, size: 20),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Meter ${h['meter']}', style: AppTextStyles.titleMedium),
                            const SizedBox(height: 1),
                            Text(h['name'] as String, style: AppTextStyles.bodyMedium),
                            Text(h['date']  as String, style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(h['reading'] as String, style: AppTextStyles.titleMedium.copyWith(color: AppColors.accentBlue)),
                          const SizedBox(height: 2),
                          Text('+${h['units']}', style: const TextStyle(fontSize: 10, color: AppColors.successGreen, fontWeight: FontWeight.w500)),
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
// REUSABLE WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

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

class _ProgressPill extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _ProgressPill({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text('$value $label', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500)),
    ]);
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  const _InfoRow({required this.label, required this.value, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
