import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/app_constants.dart';

class CartContent extends StatelessWidget {
  final List<Game> cartContent;
  final double totalAmount;
  final DateTimeRange bookingPeriod;
  final int reduction;

  const CartContent({
    Key? key,
    required this.cartContent,
    required this.totalAmount,
    required this.bookingPeriod,
    required this.reduction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cartContent.length + 1, // +1 for the total amount
      itemBuilder: (context, index) {
        if (index == cartContent.length) {
          return _buildSummary(context);
        }
        final Game game = cartContent[index];
        return _buildCartItem(context, game);
      },
    );
  }

  Widget _buildCartItem(BuildContext context, Game game) {
    Widget leading = const FaIcon(
      FontAwesomeIcons.diceD20,
      color: Colors.grey,
    );

    return ListTile(
      leading: leading,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onTap: () {
              context.push('${Routes.game.path}/${game.id}');
            },
            child: Text(
              game.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const Spacer(),
          Text(
            '${(game.weeklyAmount * (1 - reduction / 100)).toStringAsFixed(2)} €',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    int nbWeeks = (bookingPeriod.duration.inDays / 7).ceil();

    if (nbWeeks == 0) {
      nbWeeks = 1;
    }

    final String start = DateFormat(AppConstants.DATE_TIME_FORMAT_LONG, 'FR')
        .format(bookingPeriod.start);
    final String end = DateFormat(AppConstants.DATE_TIME_FORMAT_LONG, 'FR')
        .format(bookingPeriod.end);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Divider(),
        const SizedBox(height: 15),
        RichText(
          textAlign: TextAlign.start,
          text: TextSpan(
            text: "booking-period-label-1".tr(),
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                text: start,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "booking-period-label-2".tr(),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              TextSpan(
                text: end,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: size.width,
          child: Wrap(
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.spaceBetween,
            children: [
              const Text(
                "booking-duration-label",
                style: TextStyle(
                  fontSize: 18,
                ),
              ).tr(),
              Text(
                "booking-nb-weeks-label".plural(nbWeeks),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(namedArgs: {
                'nbWeeks': nbWeeks.toString(),
              }),
            ],
          ),
        ),
        SizedBox(height: reduction > 0 ? 15 : 0),
        reduction > 0
            ? Row(
                children: [
                  const Text(
                    "applied-reduction-label",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ).tr(),
                  const Spacer(),
                  Text(
                    "${reduction.toString()} %",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            : const SizedBox(),
        const SizedBox(height: 15),
        SizedBox(
          width: size.width,
          child: Wrap(
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.spaceBetween,
            children: [
              const Text(
                "booking-total-amount-label",
                style: TextStyle(
                  fontSize: 20,
                ),
              ).tr(),
              const Text(
                "amount",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(
                namedArgs: {
                  'amount': totalAmount.toString(),
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
