import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/app_constants.dart';
import 'package:responsive_framework/responsive_framework.dart';

class CustomAppBar extends StatelessWidget {
  final User? user;

  const CustomAppBar({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  PreferredSizeWidget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: screenSize.height * 0.075,
      title: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Image(
          image: const AssetImage(AppConstants.APP_LOGO),
          width: ResponsiveValue(
            context,
            defaultValue: 50.0,
            valueWhen: [
              const Condition.largerThan(name: MOBILE, value: 75.0),
              const Condition.largerThan(name: TABLET, value: 75.0),
              const Condition.largerThan(name: DESKTOP, value: 80.0),
            ],
          ).value,
          height: ResponsiveValue(
            context,
            defaultValue: 50.0,
            valueWhen: [
              const Condition.largerThan(name: MOBILE, value: 75.0),
              const Condition.largerThan(name: TABLET, value: 75.0),
              const Condition.largerThan(name: DESKTOP, value: 80.0),
            ],
          ).value,
          fit: BoxFit.contain,
        ),
      ),
      centerTitle: true,
      leading: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Text(
            'shop-address',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ).tr(),
        ),
      ),
      leadingWidth: screenSize.width * 0.35,
      actions: [
        SizedBox(
          width: screenSize.width * 0.35,
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'shop-opening-hours-1'.tr(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'shop-opening-hours-2'.tr(),
                  ),
                ],
              ),
            ),
          ),
        ),
        _buildShoppingCartButton(context),
      ],
    );
  }

  Widget _buildShoppingCartButton(BuildContext context) {
    if (user != null) {
      return IconButton(
        onPressed: () {
          context.go(Routes.cart.path);
        },
        padding: const EdgeInsets.all(3.0),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            const CircleBorder(),
          ),
          backgroundColor: MaterialStateProperty.all(
            Theme.of(context).colorScheme.primary,
          ),
        ),
        icon: const Icon(
          Icons.shopping_cart_outlined,
          color: Colors.black,
        ),
      );
    }

    return Container();
  }
}
