import 'package:date_range_form_field/date_range_form_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/reservation.dart';
import 'package:ludo_mobile/domain/use_cases/cart/cart_cubit.dart';
import 'package:ludo_mobile/utils/app_dimensions.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class GameDetailsBottomBar extends StatefulWidget {
  final Game game;

  const GameDetailsBottomBar({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  State<GameDetailsBottomBar> createState() => _GameDetailsBottomBarState();
}

class _GameDetailsBottomBarState extends State<GameDetailsBottomBar> {
  final _formKey = GlobalKey<FormState>();
  late bool _isInCart = false;

  get _game => widget.game;

  @override
  void initState() {
    _isInCart = context.read<CartCubit>().isGameInCart(_game.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ResponsiveValue(
        context,
        defaultValue: 150.0,
        valueWhen: [
          const Condition.smallerThan(name: TABLET, value: 175.0),
          //mobile
          const Condition.largerThan(name: MOBILE, value: 225.0),
          //tablet
          const Condition.largerThan(name: TABLET, value: 250.0),
          //desktop
          const Condition.largerThan(name: DESKTOP, value: 300.0),
          //large desktop
          Condition.largerThan(name: AppDimensions.LARGE_DESKTOP, value: 350.0),
          //4k
        ],
      ).value,
      width: ResponsiveValue(
        context,
        defaultValue: MediaQuery.of(context).size.width,
        valueWhen: [
          Condition.smallerThan(
            name: DESKTOP,
            value: MediaQuery.of(context).size.width,
          ),
          Condition.largerThan(
            name: TABLET,
            value: MediaQuery.of(context).size.width * 0.60,
          ),
        ],
      ).value,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.88),
        borderRadius: BorderRadius.vertical(
          top: const Radius.circular(30),
          bottom: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
              ? const Radius.circular(0)
              : const Radius.circular(30),
        ),
      ),
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: ResponsiveValue(
            context,
            defaultValue: 1.5,
            valueWhen: [
              const Condition.smallerThan(name: TABLET, value: 1.5),
              // mobile
              const Condition.largerThan(name: MOBILE, value: 2.5),
              // tablet
              const Condition.largerThan(name: TABLET, value: 2.0),
              // desktop
              const Condition.largerThan(name: DESKTOP, value: 2.7),
              // large desktop
              Condition.largerThan(
                  name: AppDimensions.LARGE_DESKTOP, value: 3.0),
              // 4k
            ],
          ).value!,
        ),
        children: [
          Column(
            verticalDirection: VerticalDirection.down,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.groups,
                color: Colors.white,
              ),
              const Text(
                "nb-players-label-long",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ).tr(),
              const SizedBox(height: 8),
              const Text(
                "min-max-players-label",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ).tr(namedArgs: {
                "minPlayers": _game.minPlayers.toString(),
                "maxPlayers": _game.maxPlayers.toString(),
              }),
            ],
          ),
          Column(
            verticalDirection: VerticalDirection.down,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(
                  Icons.elderly_woman,
                  color: Colors.white,
                ),
              ),
              const Text(
                "min-age-label",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ).tr(),
              const SizedBox(height: 8),
              const Text(
                "min-age",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ).tr(namedArgs: {
                "age": _game.minAge.toString(),
              }),
            ],
          ),
          Column(
            verticalDirection: VerticalDirection.down,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(2.0),
                child: Icon(
                  Icons.timer_outlined,
                  color: Colors.white,
                ),
              ),
              const Text(
                "game-duration-label",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ).tr(),
              const SizedBox(height: 8),
              const Text(
                "game-duration",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ).tr(namedArgs: {
                "duration": _game.averageDuration.toString(),
              }),
            ],
          ),
          Column(
            verticalDirection: VerticalDirection.down,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildReservationIcon(context), //TODO réservation
            ],
          ),
          Column(
            verticalDirection: VerticalDirection.down,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "weekly-amount-label",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ).tr(),
              const SizedBox(height: 8),
              const Text(
                "weekly-amount",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ).tr(namedArgs: {
                "amount": _game.weeklyAmount.toString(),
              }),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 27.0, horizontal: 5.0),
            child: _buildAddToCartButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationIcon(BuildContext context) {
    return Form(
      key: _formKey,
      child: DateRangeField(
        enabled: true,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(
          const Duration(days: 365),
        ),
        initialEntryMode: DatePickerEntryMode.input,
        initialValue: DateTimeRange(
          start: DateTime.now(),
          end: DateTime.now().add(
            const Duration(days: 7),
          ),
        ),
        validator: (value) {
          // doit être un datetimerange
          if (value == null) {
            return "date-range-required-label".tr();
          }

          DateTimeRange range =
              DateTimeRange(start: value.start, end: value.end);
          Duration duration = range.end.difference(range.start);
          if (duration > Reservation.MAX_DURATION ||
              duration < Reservation.MAX_DURATION) {
            //La durée de la réservation doit être de 7 jours
            return "date-range-max-7-days-label".tr();
          }

          return null;
        },
      ),
    );
  }

  BlocConsumer _buildAddToCartButton(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      builder: (BuildContext context, CartState state) {
        print(state);
        if (state is AddToCartLoading) {
          return _button(
            context,
            null,
            "add-to-cart-label".tr(),
          );
        }

        if (_isInCart) {
          return _button(
            context,
            () {
              context
                  .read<CartCubit>()
                  .removeFromCart(_game.id);

              setState(() {
                _isInCart = false;
              });
            },
            "remove-from-cart-label".tr(),
          );
        }

        if (!_isInCart) {
          return _button(
            context,
            () {
              context
                  .read<CartCubit>()
                  .addToCart(_game);
              setState(() {
                _isInCart = true;
              });
            },
            "add-to-cart-label".tr(),
          );
        }

        return _button(
          context,
          () {
            context.read<CartCubit>().addToCart(_game);
            setState(() {
              _isInCart = true;
            });
          },
          "add-to-cart-label".tr(),
        );
      },
      listener: (BuildContext context, CartState state) {
        if (state is AddToCartSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("add-to-cart-success-label").tr(),
              duration: const Duration(seconds: 2),
            ),
          );
        }

        if (state is RemoveFromCartSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("remove-from-cart-success-label").tr(),
              duration: const Duration(seconds: 2),
            ),
          );
        }

        if (state is AddToCartFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }

  Widget _button(BuildContext context, Function()? callback, String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        visualDensity: VisualDensity.compact,
        backgroundColor:
            Theme.of(context).colorScheme.primary.withOpacity(0.88),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: callback,
      child: Text(
        label,
        textAlign: TextAlign.center,
      ),
    );
  }
}
