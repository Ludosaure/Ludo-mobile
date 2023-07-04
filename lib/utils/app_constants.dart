class AppConstants {
  static const String APP_NAME = "La Ludosaure";
  static const String APP_LOGO = "assets/images/ludosaure_icn.png";
  static const String ADMIN_ROLE = "ADMIN";
  static const String CLIENT_ROLE = "CLIENT";
  static const String API_URL = String.fromEnvironment(
    "API_URL",
    defaultValue: 'https://api-ludosaure.not24get.fr',
  );

  static final RegExp GAME_DETAILS_REGEX = RegExp(
      r'^\/game\/[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$');
  static final RegExp GAME_UPDATE_REGEX = RegExp(
      r'^\/game\/[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\/edit');

  static const String STRIPE_MERCHANT_ID = "laludosaure.fr";
  static const String STRIPE_PAYMENT_ID = "pm_card_fr";
  static const String DATE_TIME_FORMAT_LONG = 'dd MMMM yyyy';
  static const String DATE_TIME_FORMAT_DAY_MONTH = 'dd MMMM';
  static const int MAX_TOTAL_AMOUNT = 999999;
}