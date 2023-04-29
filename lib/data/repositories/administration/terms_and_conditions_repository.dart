import 'package:injectable/injectable.dart';

import '../../models/terms_and_conditions.dart';

@injectable
class TermsAndConditionsRepository {
  //TODO provider

  TermsAndConditions getTermsAndConditions() {
    DateTime createdAt = DateTime.now();
    DateTime lastUpdatedAt = DateTime.now();
    //TODO passer par quill
    String termsAndConditions = "Terms and conditions";
    return TermsAndConditions(
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
      content: termsAndConditions,
    );
  }
}
