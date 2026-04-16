class ApiConstants {
  // GANTI dengan IP laptop Anda. Jika pakai Android Emulator: http://10.0.2.2:8080/v1
  static const String baseUrl = 'http://192.168.0.28:8080/v1';
  static const String verifyToken = '/auth/verify-token';
  static const String products = '/products';
  static const int connectTimeout = 15000;
  static const int receiveTimeout = 15000;
}