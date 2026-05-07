class AppUrl {
  // static const String baseUrl = 'http://10.0.2.2:5000/api/v1';
  static const String baseUrl =
      'http://192.168.1.7:5000/api/v1'; // Replace with YOUR IP

  static const String loginApi = '$baseUrl/auth/login';
  static const String registerApi = '$baseUrl/auth/register';

  // Test route added earlier
  static const String testDbApi = 'http://10.0.2.2:5000/test-db';
}
