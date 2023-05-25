import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ludo_mobile/utils/app_constants.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: MediaQuery.of(context).size.height * 0.075,
      title: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Image(
          image: const AssetImage(AppConstants.APP_LOGO),
          width: MediaQuery.of(context).size.width * 0.15,
          height: MediaQuery.of(context).size.width * 0.15,
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
      leadingWidth: MediaQuery.of(context).size.width * 0.35,
      actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.35,
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
          )),
        ),
      ],
    );
  }
}
