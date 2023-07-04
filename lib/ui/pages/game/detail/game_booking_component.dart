import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/cart/cart_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/list_reduction_plan/list_reduction_plan_cubit.dart';
import 'package:ludo_mobile/utils/app_constants.dart';

class GameBookingComponent extends StatefulWidget {
  final User? user;
  final Game game;

  const GameBookingComponent({
    Key? key,
    required this.game,
    this.user,
  }) : super(key: key);

  @override
  State<GameBookingComponent> createState() => _GameBookingComponentState();
}

class _GameBookingComponentState extends State<GameBookingComponent> {
  final _formKey = GlobalKey<FormState>();
  late DateTimeRange _bookingPeriod;
  late bool _isInCart = false;
  late bool _showDatePicker = false;
  int _reduction = 0;

  User? get _user => widget.user;

  Game get _game => widget.game;

  double get _price =>
      _game.weeklyAmount - (_game.weeklyAmount * _reduction / 100);

  @override
  void initState() {
    _isInCart = context.read<CartCubit>().isGameInCart(_game.id);
    _bookingPeriod = context.read<CartCubit>().getBookingPeriod();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool displayPaymentBar = _user != null && !_user!.isAdmin();
    final Color primary = Theme.of(context).colorScheme.primary;

    if (_showDatePicker && !kIsWeb) {
      return _showReservationCalendar(context);
    }

    if (displayPaymentBar) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        verticalDirection: VerticalDirection.down,
        children: [
          _buildDatePicker(primary, context),
          const SizedBox(
            width: 8,
          ),
          _buildWeeklyAmount(primary, displayPaymentBar, context),
          const SizedBox(
            width: 8,
          ),
          _buildAddGameButton(context),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      verticalDirection: VerticalDirection.down,
      children: [
        _buildWeeklyAmount(primary, displayPaymentBar, context),
      ],
    );
  }

  Widget _buildDatePicker(Color primary, BuildContext context) {
    return Column(
      verticalDirection: VerticalDirection.down,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildReservationIcon(primary, context),
        const SizedBox(
          height: 8.0,
        ),
        Text(
          _bookingPeriodText(),
          softWrap: true,
          overflow: TextOverflow.visible,
          style: TextStyle(
            color: primary,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildWeeklyAmount(
      Color primary, bool isClient, BuildContext context) {
    if (isClient) {
      return Column(
        verticalDirection: VerticalDirection.down,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 8),
          Text(
            "weekly-amount-label",
            style: TextStyle(
              color: primary,
              fontSize: 12,
            ),
          ).tr(),
          const SizedBox(height: 8),
          Text(
            "amount",
            style: TextStyle(
              color: primary,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ).tr(
            namedArgs: {
              "amount": _price.toString(),
            },
          ),
        ],
      );
    }

    return Row(
      verticalDirection: VerticalDirection.down,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          "weekly-amount-label",
          style: TextStyle(
            color: primary,
            fontSize: 14,
          ),
        ).tr(),
        const SizedBox(width: 8),
        Text(
          "amount",
          style: TextStyle(
            color: primary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ).tr(
          namedArgs: {
            "amount": _price.toString(),
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildAddGameButton(BuildContext context) {
    return _game.isAvailable!
        ? _buildAddToCartButton(context)
        : Text(
            "game-unavailable-label",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w400,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ).tr();
  }

  Widget _buildReservationIcon(Color primary, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: !kIsWeb ? primary.withOpacity(0.88) : primary.withOpacity(0.5),
        borderRadius: const BorderRadius.all(
          Radius.circular(30.0),
        ),
      ),
      child: IconButton(
        padding: const EdgeInsets.all(2.0),
        visualDensity: VisualDensity.compact,
        onPressed: kIsWeb ? null : _onCalendarPressed,
        icon: const Icon(
          Icons.calendar_month_outlined,
          color: Colors.white,
        ),
      ),
    );
  }

  void _onCalendarPressed() {
    if (!context.read<CartCubit>().isCartEmpty() && !context.read<CartCubit>().wasWarningDisplayed()) {
      showDialog(
        context: context,
        builder: (childContext) => AlertDialog(
          title: const Text("booking-date-changed-dialog-title").tr(),
          content: const Text(
              "booking-date-changed-dialog-content").tr(),
          actions: [
            TextButton(
              onPressed: () {
                context.read<CartCubit>().changeWarningDisplayed(true);
                Navigator.of(childContext).pop();
              },
              child: const Text("dialog-ok").tr(),
            ),
          ],
        ),
      );
    }

    setState(() {
      _showDatePicker = !_showDatePicker;
    });
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
              onChanged: (value) async {
                setState(() {
                  _bookingPeriod =
                      DateTimeRange(start: value.start, end: value.end);
                });
                final int nbWeeks = (_bookingPeriod.duration.inDays / 7).ceil();
                _reduction = await parentContext
                    .read<ListReductionPlanCubit>()
                    .getReductionForNbWeeks(nbWeeks);

                parentContext
                    .read<CartCubit>()
                    .onChangeDate(_bookingPeriod, _reduction);
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
              context
                  .read<CartCubit>()
                  .addToCart(_game, _bookingPeriod, _reduction);
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
                  _reduction,
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
          BlocProvider.of<CartCubit>(context).getCartContent();
        }

        if (state is BookingOperationSuccess && !_isInCart) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("remove-from-cart-success-label").tr(),
              duration: const Duration(seconds: 2),
            ),
          );
          BlocProvider.of<CartCubit>(context).getCartContent();
        }

        if (state is BookingOperationFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
    );
  }

  Widget _button(BuildContext context, Function()? callback, String label) {
    if (kIsWeb) {
      return Tooltip(
        message: "not-available-on-web-label".tr(),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            visualDensity: VisualDensity.compact,
            backgroundColor:
                Theme.of(context).colorScheme.primary.withOpacity(0.88),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: null,
          child: Text(
            overflow: TextOverflow.visible,
            softWrap: true,
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
      );
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        visualDensity: VisualDensity.compact,
        elevation: 2,
        backgroundColor:
            Theme.of(context).colorScheme.primary.withOpacity(0.88),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: !kIsWeb ? callback : null,
      child: Text(
        label,
        textAlign: TextAlign.center,
        overflow: TextOverflow.visible,
        softWrap: true,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
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
