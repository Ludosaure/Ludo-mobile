import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/use_cases/cart/cart_cubit.dart';
import 'package:ludo_mobile/utils/app_constants.dart';
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
  late DateTimeRange _bookingPeriod;
  late bool _isInCart = false;
  late bool _showDatePicker = false;

  Game get _game => widget.game;

  @override
  void initState() {
    _isInCart = context.read<CartCubit>().isGameInCart(_game.id);
    _bookingPeriod = context.read<CartCubit>().getBookingPeriod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_showDatePicker) {
      return _showReservationCalendar(context);
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, bottom: 8.0, top: 4.0),
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
              Condition.largerThan(
                  name: AppDimensions.LARGE_DESKTOP, value: 350.0),
              //4k
            ],
          ).value,
          width: ResponsiveValue(
            context,
            defaultValue: MediaQuery.of(context).size.width * 0.95,
            valueWhen: [
              Condition.smallerThan(
                name: DESKTOP,
                value: MediaQuery.of(context).size.width * 0.95,
              ),
              Condition.largerThan(
                name: TABLET,
                value: MediaQuery.of(context).size.width * 0.60,
              ),
            ],
          ).value,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.88),
            borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30), bottom: Radius.circular(30)),
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
                  _buildReservationIcon(context),
                  Text(
                    _bookingPeriodText(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
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
                    "amount",
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
                child: _game.isAvailable
                    ? _buildAddToCartButton(context)
                    : const Text(
                        "game-unavailable-label",
                        style: TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ).tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReservationIcon(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(2.0),
      visualDensity: VisualDensity.compact,
      onPressed: () {
        setState(() {
          _showDatePicker = true;
        });
      },
      icon: const Icon(
        Icons.calendar_month_outlined,
        color: Colors.white,
      ),
    );
  }

  Widget _showReservationCalendar(BuildContext parentContext) {
    return Center(
      child: Column(
        verticalDirection: VerticalDirection.down,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "pick-booking-date-label",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ).tr(),
          const SizedBox(height: 8),
          Form(
            key: _formKey,
            child: RangePicker(
              initiallyShowDate: DateTime.now(),
              datePickerLayoutSettings: const DatePickerLayoutSettings(
                showPrevMonthEnd: true,
                showNextMonthStart: true,
              ),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(
                const Duration(days: 365),
              ),
              selectedPeriod: DatePeriod(
                _bookingPeriod.start,
                _bookingPeriod.end,
              ),
              onChanged: (value) {
                setState(() {
                  _bookingPeriod =
                      DateTimeRange(start: value.start, end: value.end);
                });
                parentContext.read<CartCubit>().onChangeDate(_bookingPeriod);
              },
              onSelectionError: (UnselectablePeriodException error) {
                DatePeriod wantedPeriod = error.period;
                DateTime problematicDate =
                    error.customDisabledDates.where((element) {
                  return wantedPeriod.start.isBefore(element) &&
                      wantedPeriod.end.isAfter(element);
                }).first;
                setState(() {
                  _bookingPeriod = DateTimeRange(
                    start: problematicDate.add(
                      const Duration(days: 1),
                    ),
                    end: wantedPeriod.end,
                  );
                });
              },
              selectableDayPredicate: (DateTime day) {
                return _game.unavailableDates.contains(day) ? false : true;
              },
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
              onPressed: () {
                setState(() {
                  _showDatePicker = false;
                });
              },
              child: const Text("validate-label").tr(),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  BlocConsumer _buildAddToCartButton(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      builder: (BuildContext context, CartState state) {
        if (state is BookingOperationLoading) {
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
              context.read<CartCubit>().removeFromCart(_game.id);

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
              context.read<CartCubit>().addToCart(_game, _bookingPeriod);
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
            context.read<CartCubit>().addToCart(
                  _game,
                  _bookingPeriod,
                );
            setState(() {
              _isInCart = true;
            });
          },
          "add-to-cart-label".tr(),
        );
      },
      listener: (BuildContext context, CartState state) {
        if (state is BookingOperationSuccess && _isInCart) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("add-to-cart-success-label").tr(),
              duration: const Duration(seconds: 2),
            ),
          );
        }

        if (state is BookingOperationSuccess && !_isInCart) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("remove-from-cart-success-label").tr(),
              duration: const Duration(seconds: 2),
            ),
          );
        }

        if (state is BookingOperationFailure) {
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

  String _bookingPeriodText() {
    final String start =
        DateFormat(AppConstants.DATE_TIME_FORMAT_DAY_MONTH, 'FR')
            .format(_bookingPeriod.start);
    final String end = DateFormat(AppConstants.DATE_TIME_FORMAT_DAY_MONTH, 'FR')
        .format(_bookingPeriod.end);

    return "$start - $end";
  }
}
