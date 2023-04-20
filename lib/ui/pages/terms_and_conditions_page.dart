import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:ludo_mobile/data/repositories/administration/terms_and_conditions_repository.dart';
import 'package:ludo_mobile/ui/components/sized_box_20.dart';

import '../../data/models/terms_and_conditions.dart';
import '../components/custom_back_button.dart';
import 'package:intl/intl.dart';

//TODO
class TermsAndConditionsPage extends StatelessWidget {
  final TermsAndConditionsRepository _termsAndConditionsRepository =
      TermsAndConditionsRepository();
  final TermsAndConditions _termsAndConditions =
      TermsAndConditionsRepository().getTermsAndConditions();

  TermsAndConditionsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            verticalDirection: VerticalDirection.down,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const CustomBackButton(),
              const SizedBox20(),
              const Text(
                "Terms and Conditions",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Flexible(child: SizedBox(height: 10)),
              Text(
                getLastModified(),
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF838486),
                ),
              ),
              const SizedBox20(),
              Flexible(
                flex: 35,
                fit: FlexFit.tight,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    verticalDirection: VerticalDirection.down,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        _termsAndConditions.content,
                        style: const TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean interdum eget leo et iaculis. Morbi sed lectus convallis, molestie magna finibus, suscipit sem. Mauris maximus turpis ut libero pulvinar, in pulvinar elit ornare. Sed luctus condimentum tortor vel interdum. Fusce euismod urna ipsum, et mattis risus elementum vitae.",
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF838486),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Praesent faucibus mi eros, vel finibus magna porta ac. Nam dignissim augue id elit pretium interdum. Donec tempor euismod purus eu tincidunt. Vestibulum consectetur velit non mollis mollis.",
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF838486),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Mauris maximum turpis",
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean interdum eget leo et iaculis. Morbi sed lectus convallis, molestie magna finibus, suscipit sem. Mauris maximus turpis ut libero pulvinar, in pulvinar elit ornare. Sed luctus condimentum tortor vel interdum. Fusce euismod urna ipsum, et mattis risus elementum vitae.",
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF838486),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Praesent faucibus mi eros, vel finibus magna porta ac. Nam dignissim augue id elit pretium interdum. Donec tempor euismod purus eu tincidunt. Vestibulum consectetur velit non mollis mollis.",
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF838486),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Mauris maximus turpis ut libero pulvinar, in pulvinar elit ornare. Sed luctus condimentum tortor vel interdum. Fusce euismod urna ipsum, et mattis risus elementum vitae.",
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF838486),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Mauris maximum turpis",
                        style: TextStyle(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Text(
                        "Praesent faucibus mi eros, vel finibus magna porta ac. Nam dignissim augue id elit pretium interdum. Donec tempor euismod purus eu tincidunt. Vestibulum consectetur velit non mollis mollis.",
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF838486),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getLastModified() {
    initializeDateFormatting();
    return "Modifié le ${DateFormat('dd MMMM yyyy', 'FR').format(_termsAndConditions.lastUpdatedAt)}";
  }

}
