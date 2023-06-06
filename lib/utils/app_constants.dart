class AppConstants {
  static const String APP_NAME = "La Ludosaure";
  static const String APP_LOGO = "assets/images/ludosaure_icn.png";
  static const String ADMIN_ROLE = "ADMIN";
  static const String CLIENT_ROLE = "CLIENT";
  static const String API_URL = String.fromEnvironment(
    "API_URL",
    // defaultValue: 'http://api-ludosaure-load-balancer-2124171361.eu-west-1.elb.amazonaws.com',
    defaultValue: 'http://10.33.4.15:3000',
    // defaultValue: 'http://192.168.1.181:3000',
  );
  static final RegExp UUID_V4 = RegExp(
      r'^\/game\/[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$');
}
