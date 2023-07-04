import 'package:injectable/injectable.dart';
import 'package:ludo_mobile/domain/models/terms_and_conditions.dart';

@injectable
class TermsAndConditionsRepository {
  //TODO provider

  TermsAndConditions getTermsAndConditions() {
    DateTime createdAt = DateTime.now();
    DateTime lastUpdatedAt = DateTime.now();
    //TODO passer par quill
    String termsAndConditions = "ARTICLE 1 — CHAMP D’APPLICATION";
    return TermsAndConditions(
      createdAt: createdAt,
      lastUpdatedAt: lastUpdatedAt,
      content: termsAndConditions,
    );
  }
}
