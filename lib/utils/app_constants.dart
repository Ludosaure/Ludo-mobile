class AppConstants {
  static const String APP_NAME = "La Ludosaure";
  static const String APP_LOGO = "assets/images/ludosaure_icn.png";
  static const String ADMIN_ROLE = "ADMIN";
  static const String CLIENT_ROLE = "CLIENT";
  static const String API_URL = String.fromEnvironment(
    "API_URL",
    defaultValue: 'http://api-ludosaure-load-balancer-2124171361.eu-west-1.elb.amazonaws.com',
  );

  static final RegExp UUID_V4 = RegExp(
      r'^\/game\/[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$');
  
  static const String STRIPE_MERCHANT_ID = "laludosaure.fr";
  static const String STRIPE_PAYMENT_ID = "pm_card_fr";
  static const String DATE_TIME_FORMAT = 'dd MMMM yyyy';
}
