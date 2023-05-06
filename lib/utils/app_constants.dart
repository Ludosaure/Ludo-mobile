class AppConstants {
  static const String ADMIN_ROLE = "ADMIN";
  static const String CLIENT_ROLE = "CLIENT";
  static const String API_URL = String.fromEnvironment("API_URL", defaultValue: 'http://10.0.2.2:3000');
}