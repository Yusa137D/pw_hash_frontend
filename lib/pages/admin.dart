import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../api_services.dart';
import 'login.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  List<dynamic> _users = [];
  bool _isLoading = true;

  int _totalUsers = 0;
  int _md5Users = 0;
  int _argon2Users = 0;

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
        _argon2Users = data
            .where((u) => u['hashing_method'] == 'Argon2')
            .length;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message']), backgroundColor: Colors.red),
      );
    }
  }

  // Fungsi untuk menentukan warna badge berdasarkan teks kekuatan password
  Color _getStrengthColor(String strength) {
    switch (strength) {
      case 'Very Strong':
        return Colors.green[800]!;
      case 'Strong':
        return Colors.green;
      case 'Fair':
        return Colors.orange;
      case 'Weak':
        return Colors.redAccent;
      case 'Very Weak':
        return Colors.red[900]!;
      default:
        return Colors.grey;
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Hash disalin ke clipboard!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DASHBOARD ADMIN'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchUsers,
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Row Metric Cards
                  Row(
                    children: [
                      _buildMetricCard(
                        'Total User',
                        _totalUsers.toString(),
                        Colors.blue,
                      ),
                      _buildMetricCard(
                        'MD5 User',
                        _md5Users.toString(),
                        Colors.orange,
                      ),
                      _buildMetricCard(
                        'Argon2 User',
                        _argon2Users.toString(),
                        Colors.green,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  const Text(
                    'DATABASE USER & PASSWORD ANALYSIS (zxcvbn)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  // Tabel Data Utama
                  Card(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Username')),
                          DataColumn(label: Text('Algoritma')),
                          DataColumn(label: Text('Strength (zxcvbn)')),
                          DataColumn(label: Text('Hash Password')),
                          DataColumn(label: Text('Aksi')),
                        ],
                        rows: _users.map((user) {
                          String strengthLabel =
                              user['password_strength'] ?? 'Unknown';
                          String hash = user['password_hash'].toString();
                          String shortHash = hash.length > 15
                              ? '${hash.substring(0, 15)}...'
                              : hash;

                          return DataRow(
                            cells: [
                              DataCell(Text(user['username'])),
                              DataCell(Text(user['hashing_method'])),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStrengthColor(strengthLabel),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    strengthLabel,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(Text(shortHash)),
                              DataCell(
                                IconButton(
                                  icon: const Icon(
                                    Icons.copy,
                                    size: 18,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => _copyToClipboard(hash),
                                  tooltip: 'Salin Hash',
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Informasi Tambahan
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[50],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blueGrey[100]!),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Catatan Analisis:",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "• Strength dihitung secara real-time menggunakan library zxcvbn pada sisi backend.",
                        ),
                        Text(
                          "• MD5 tanpa salt sangat rentan terhadap Rainbow Table attack meskipun password berstatus 'Strong'.",
                        ),
                        Text(
                          "• Argon2 memberikan perlindungan terbaik terhadap brute-force dan cracking.",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Export Security Report'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Fitur Export PDF akan segera hadir!'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMetricCard(String title, String count, Color color) {
    return Expanded(
      child: Card(
        color: color.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: color, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                count,
                style: TextStyle(
                  fontSize: 22,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
