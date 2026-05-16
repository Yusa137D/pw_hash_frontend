import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../api_services.dart';
import '../pdf_launcher.dart';
import 'app_visuals.dart';
import 'login.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  List<dynamic> _users = [];
  bool _isLoading = true;
  bool _isExporting = false;

  int _totalUsers = 0;
  int _md5Users = 0;
  int _sha256Users = 0;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);

    final result = await ApiService.fetchUsers();

    if (!mounted) return;

    if (result['success']) {
      List<dynamic> data = result['data'];
      setState(() {
        _users = data;
        _totalUsers = data.length;
        _md5Users = data.where((u) => u['hashing_method'] == 'MD5').length;
        _sha256Users =
            data.where((u) => u['hashing_method'] == 'SHA-256').length;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
      );
    }
  }

  Color _getStrengthColor(String strength) {
    switch (strength) {
      case 'Very Strong':
        return Colors.green.shade800;
      case 'Strong':
        return Colors.green;
      case 'Fair':
        return AppPalette.orange;
      case 'Weak':
        return Colors.redAccent;
      case 'Very Weak':
        return Colors.red.shade900;
      default:
        return Colors.grey;
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hash disalin ke clipboard!')),
    );
  }

  Future<void> _openSecurityReportPdf() async {
    setState(() => _isExporting = true);

    final pdfUri = Uri.parse(ApiService.exportPdfUrl);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final opened = await openPdfUrl(pdfUri.toString());

      if (!opened && mounted) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('PDF gagal dibuka. Pastikan backend Flask berjalan.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text('PDF gagal dibuka: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSecurityBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth >= 900;
              return Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 48 : 20,
                    vertical: 28,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _AdminTopBar(onRefresh: _fetchUsers),
                        const SizedBox(height: 28),
                        _isLoading
                            ? const _LoadingPanel()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _AdminHeroPanel(
                                    totalUsers: _totalUsers,
                                    isExporting: _isExporting,
                                    onExport: _openSecurityReportPdf,
                                  ),
                                  const SizedBox(height: 20),
                                  _MetricGrid(
                                    totalUsers: _totalUsers,
                                    md5Users: _md5Users,
                                    sha256Users: _sha256Users,
                                  ),
                                  const SizedBox(height: 24),
                                  _UsersTablePanel(
                                    users: _users,
                                    getStrengthColor: _getStrengthColor,
                                    onCopyHash: _copyToClipboard,
                                  ),
                                  const SizedBox(height: 20),
                                  const _AnalysisNotePanel(),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AdminTopBar extends StatelessWidget {
  final VoidCallback onRefresh;

  const _AdminTopBar({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const BrandBadge(icon: Icons.admin_panel_settings, label: 'Admin Vault'),
        const Spacer(),
        Tooltip(
          message: 'Refresh Data',
          child: IconButton.filledTonal(
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: .12),
              foregroundColor: AppPalette.yellow,
            ),
            icon: const Icon(Icons.refresh),
            onPressed: onRefresh,
          ),
        ),
        const SizedBox(width: 10),
        Tooltip(
          message: 'Logout',
          child: IconButton.filled(
            style: IconButton.styleFrom(
              backgroundColor: AppPalette.orange,
              foregroundColor: AppPalette.navy,
            ),
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingPanel extends StatelessWidget {
  const _LoadingPanel();

  @override
  Widget build(BuildContext context) {
    return const GlassPanel(
      child: SizedBox(
        height: 260,
        child: Center(
          child: CircularProgressIndicator(color: AppPalette.orange),
        ),
      ),
    );
  }
}

class _AdminHeroPanel extends StatelessWidget {
  final int totalUsers;
  final bool isExporting;
  final VoidCallback onExport;

  const _AdminHeroPanel({
    required this.totalUsers,
    required this.isExporting,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 720),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 24 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GlassPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 78,
              width: 78,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppPalette.yellow, AppPalette.orange],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppPalette.orange.withValues(alpha: .28),
                    blurRadius: 22,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: const Icon(
                Icons.dashboard_customize_rounded,
                color: AppPalette.navy,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Dashboard Admin',
              style: TextStyle(
                color: AppPalette.ink,
                fontSize: 32,
                fontWeight: FontWeight.w900,
                height: 1.12,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Pantau $totalUsers akun, metode hashing, dan kekuatan password dalam satu panel analisis yang responsif.',
              style: TextStyle(
                color: AppPalette.ink.withValues(alpha: .64),
                height: 1.55,
              ),
            ),
            const SizedBox(height: 24),
            PrimaryGradientButton(
              label: isExporting ? 'Membuka PDF...' : 'Export Security Report',
              icon: Icons.picture_as_pdf,
              isLoading: isExporting,
              onPressed: onExport,
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricGrid extends StatelessWidget {
  final int totalUsers;
  final int md5Users;
  final int sha256Users;

  const _MetricGrid({
    required this.totalUsers,
    required this.md5Users,
    required this.sha256Users,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: .92, end: 1),
      duration: const Duration(milliseconds: 760),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cards = [
            _MetricCard(
              title: 'Total User',
              count: totalUsers.toString(),
              icon: Icons.groups_2,
              color: AppPalette.yellow,
            ),
            _MetricCard(
              title: 'MD5 User',
              count: md5Users.toString(),
              icon: Icons.memory,
              color: AppPalette.orange,
            ),
            _MetricCard(
              title: 'SHA-256 User',
              count: sha256Users.toString(),
              icon: Icons.security,
              color: Colors.green,
            ),
          ];

          if (constraints.maxWidth < 720) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (int index = 0; index < cards.length; index++) ...[
                    SizedBox(width: 210, child: cards[index]),
                    if (index != cards.length - 1) const SizedBox(width: 14),
                  ],
                ],
              ),
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int index = 0; index < cards.length; index++) ...[
                Expanded(child: cards[index]),
                if (index != cards.length - 1) const SizedBox(width: 16),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppPalette.navy.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: .12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .20),
            blurRadius: 26,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 18),
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 34,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: .68),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _UsersTablePanel extends StatelessWidget {
  final List<dynamic> users;
  final Color Function(String strength) getStrengthColor;
  final void Function(String hash) onCopyHash;

  const _UsersTablePanel({
    required this.users,
    required this.getStrengthColor,
    required this.onCopyHash,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppPalette.navy.withValues(alpha: .94),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: .12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .22),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Database User & Password Analysis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Hasil strength dihitung dari backend menggunakan zxcvbn.',
            style: TextStyle(color: Colors.white.withValues(alpha: .62)),
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final tableWidth =
                  constraints.maxWidth < 860 ? 860.0 : constraints.maxWidth;

              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minWidth: tableWidth),
                      child: DataTable(
                        columnSpacing: 20,
                        horizontalMargin: 22,
                        headingRowHeight: 58,
                        headingRowColor: WidgetStateProperty.all(
                          AppPalette.softBlue,
                        ),
                        dataRowMinHeight: 60,
                        dataRowMaxHeight: 68,
                        columns: const [
                          DataColumn(
                            label: _TableHeader(width: 150, label: 'Username'),
                          ),
                          DataColumn(
                            label: _TableHeader(width: 118, label: 'Algoritma'),
                          ),
                          DataColumn(
                            label: _TableHeader(width: 136, label: 'Strength'),
                          ),
                          DataColumn(
                            label: _TableHeader(
                              width: 260,
                              label: 'Hash Password',
                            ),
                          ),
                          DataColumn(
                            label: _TableHeader(
                              width: 70,
                              label: 'Aksi',
                              centered: true,
                            ),
                          ),
                        ],
                        rows: users.map((user) {
                          final strengthLabel =
                              user['password_strength'] ?? 'Unknown';
                          final hash = user['password_hash'].toString();
                          final shortHash = hash.length > 28
                              ? '${hash.substring(0, 28)}...'
                              : hash;

                          return DataRow(
                            cells: [
                              DataCell(
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    user['username'].toString(),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 118,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: _MethodBadge(
                                      method:
                                          user['hashing_method'].toString(),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 136,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: _StrengthBadge(
                                      label: strengthLabel,
                                      color: getStrengthColor(strengthLabel),
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 260,
                                  child: Text(
                                    shortHash,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFeatures: [
                                        FontFeature.tabularFigures(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                SizedBox(
                                  width: 70,
                                  child: Center(
                                    child: Tooltip(
                                      message: 'Salin Hash',
                                      child: IconButton(
                                        icon:
                                            const Icon(Icons.copy, size: 19),
                                        color: AppPalette.orange,
                                        onPressed: () => onCopyHash(hash),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final double width;
  final String label;
  final bool centered;

  const _TableHeader({
    required this.width,
    required this.label,
    this.centered = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        label,
        textAlign: centered ? TextAlign.center : TextAlign.left,
        style: const TextStyle(
          color: AppPalette.ink,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _MethodBadge extends StatelessWidget {
  final String method;

  const _MethodBadge({required this.method});

  @override
  Widget build(BuildContext context) {
    final isSha = method == 'SHA-256';
    final color = isSha ? Colors.green : AppPalette.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: .45)),
      ),
      child: Text(
        method,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

// PERBAIKAN: Class _StrengthBadge yang hilang ditambahkan kembali di sini.
class _StrengthBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StrengthBadge({
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _AnalysisNotePanel extends StatelessWidget {
  const _AnalysisNotePanel();

  @override
  Widget build(BuildContext context) {
    const notes = [
      'Strength dihitung secara real-time menggunakan library zxcvbn pada sisi backend.',
      "MD5 tanpa salt sangat rentan terhadap Rainbow Table attack meskipun password berstatus 'Strong'.",
      'SHA-256 adalah algoritma modern, namun tanpa penggunaan salt, hash-nya tetap dapat diprediksi.',
    ];

    return GlassPanel(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.tips_and_updates, color: AppPalette.orange),
              SizedBox(width: 10),
              Text(
                'Catatan Analisis',
                style: TextStyle(
                  color: AppPalette.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...notes.map(
            (note) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppPalette.orange,
                    size: 18,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      note,
                      style: TextStyle(
                        color: AppPalette.ink.withValues(alpha: .70),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
