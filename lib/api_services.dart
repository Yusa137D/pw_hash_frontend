import 'package:dio/dio.dart';

class ApiService {
  // Gunakan 10.0.2.2 jika menggunakan Android Emulator
  // Gunakan 127.0.0.1 jika menggunakan Chrome/Windows
  static const String _baseUrl = 'http://127.0.0.1:5000';
  static const String exportPdfUrl = '$_baseUrl/export-pdf';
  static final Dio _dio = Dio(BaseOptions(baseUrl: _baseUrl));

  // Fungsi Register
  static Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String method,
  }) async {
    try {
      Response response = await _dio.post('/register', data: {
        "username": username,
        "email": email,
        "password": password,
        "method": method,
      });
      return {"success": true, "message": response.data['message']};
    } on DioException catch (e) {
      return {
        "success": false,
        "message": e.response?.data['message'] ?? 'Terjadi kesalahan jaringan'
      };
    }
  }

  // Fungsi Login (Menerima Email dan Password)
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String method,
  }) async {
    try {
      Response response = await _dio.post('/login', data: {
        "email": email,
        "password": password,
        "method": method,
      });
      return {
        "success": true,
        "message": response.data['message'],
        "method": response.data['method'],
        "role": response.data['role'],
        "username": response.data['username'],
        "strength": response.data['strength'], // Mengambil hasil zxcvbn dari backend
      };
    } on DioException catch (e) {
      return {
        "success": false,
        "message": e.response?.data['message'] ?? 'Login gagal. Cek kredensial Anda.'
      };
    }
  }

  // Fungsi Ambil Data User (Hanya untuk Admin)
  static Future<Map<String, dynamic>> fetchUsers() async {
    try {
      Response response = await _dio.get('/admin/users');
      return {"success": true, "data": response.data};
    } catch (e) {
      return {"success": false, "message": "Gagal mengambil data dari server: $e"};
    }
  }
}
