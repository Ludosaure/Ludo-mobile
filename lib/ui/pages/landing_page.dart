import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/ui/components/sized_box_20.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/app_constants.dart';
import 'package:ludo_mobile/utils/app_dimensions.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Container(
          child: _buildLandingPage(_size, context),
        ),
      ),
    );
  }

  Widget _buildLandingPage(Size size, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Image(
              image: const AssetImage(AppConstants.APP_LOGO),
              width: size.width * 0.6,
              height: 250,
            ),
          ),
          Flexible(
            child: SizedBox(
              height: size.height * 0.06,
            ),
          ),
          const Text(
            AppConstants.APP_NAME,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "landing-page-subtitle",
            style: TextStyle(
              fontSize: ResponsiveValue(
                context,
                defaultValue: 15.0,
                valueWhen: [
                  const Condition.smallerThan(name: MOBILE, value: 10.0),
                  const Condition.largerThan(name: TABLET, value: 20.0),
                ],
              ).value,
              color: const Color(0xFF838486),
            ),
            textAlign: TextAlign.center,
          ).tr(),
          Flexible(
            child: SizedBox(
              height: size.height * 0.02,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.go(Routes.login.path);
            },
            style: ElevatedButton.styleFrom(
              maximumSize: AppDimensions.largeButtonSize,
              minimumSize: AppDimensions.largeButtonSize,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              'login-label',
            ).tr(),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          ElevatedButton(
            onPressed: () {
              context.go(Routes.register.path);
            },
            style: ElevatedButton.styleFrom(
              maximumSize: AppDimensions.largeButtonSize,
              minimumSize: AppDimensions.largeButtonSize,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: Colors.grey[300],
            ),
            child: const Text(
              'create-account-label',
              style: TextStyle(color: Colors.black),
            ).tr(),
          ),
          const SizedBox(
            height: 10,
          ),
          TextButton(
            onPressed: () {
              context.go(Routes.home.path);
            },
            style: TextButton.styleFrom(
              alignment: Alignment.centerRight,
              minimumSize: AppDimensions.largeButtonSize,
              maximumSize: AppDimensions.largeButtonSize,
            ),
            child: Text(
              'proceed-as-guest-label',
              style: TextStyle(
                fontSize: ResponsiveValue(
                  context,
                  defaultValue: 15.0,
                  valueWhen: [
                    const Condition.smallerThan(name: MOBILE, value: 10.0),
                    const Condition.largerThan(name: TABLET, value: 20.0),
                  ],
                ).value,
              ),
            ).tr(),
          ),
        ],
      ),
    );
  }
}
