import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/use_cases/unavailabilities/game_unavailabilities_cubit.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/app_constants.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:table_calendar/table_calendar.dart';

class GameUnavailabilitiesPage extends StatefulWidget {
  final Game game;

  GameUnavailabilitiesPage({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  State<GameUnavailabilitiesPage> createState() =>
      _GameUnavailabilitiesPageState();
}

class _GameUnavailabilitiesPageState extends State<GameUnavailabilitiesPage> {
  Game get game => widget.game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "game-unavailabilities-title",
          softWrap: true,
          overflow: TextOverflow.visible,
        ).tr(
          namedArgs: {
            "name": game.name,
          },
        ),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          verticalDirection: VerticalDirection.down,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              "action-create-unavailability",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ).tr(),
            const SizedBox(height: 15),
            Text(
              "action-delete-unavailability",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ).tr(),
            const SizedBox(height: 8),
            ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: _buildCalendarCubit(context))
                : SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: _buildCalendarCubit(context),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCubit(BuildContext context) {
    return BlocConsumer<GameUnavailabilitiesCubit, GameUnavailabilitiesState>(
      listener: (context, state) {
        if (state is GameUnavailabilitiesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
        if (state is UserNotLogged) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                "errors.user-must-log-for-access",
              ).tr(),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is GameUnavailabilitiesInitial) {
          return _buildCalendar(context);
        }

        if (state is GameUnavailabilitiesLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is GameUnavailabilitiesSuccess) {
          if (state.isCreation) {
            game.unavailableDates.add(state.date);
          } else {
            _removeDateFromGameUnavailableDates(state.date);
          }
        }

        if (state is UserNotLogged) {
          context.go(Routes.login.path);
        }

        return _buildCalendar(context);
      },
    );
  }

  Widget _buildCalendar(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(DateTime.now().year - 1),
      lastDay: DateTime.utc(DateTime.now().year + 1),
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.month,
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, _) {
          if (_isUnavailableDay(game.unavailableDates, date)) {
            return Container(
              margin: const EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  date.day.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            );
          }
          return null;
        },
      ),
      onDaySelected: (selectedDay, focusedDay) {
        bool isAlreadyUnavailable =
            _isUnavailableDay(game.unavailableDates, selectedDay);
        if (isAlreadyUnavailable) {
          _showDeleteConfirmationDialog(context, selectedDay);
        } else {
          BlocProvider.of<GameUnavailabilitiesCubit>(context)
              .createUnavailability(game.id, selectedDay);
        }
      },
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext parentContext, DateTime date) {
    showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        title: const Text('delete-unavailability-label').tr(),
        content: const Text('confirm-delete-unavailability').tr(),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('cancel-label').tr(),
          ),
          TextButton(
            onPressed: () {
              BlocProvider.of<GameUnavailabilitiesCubit>(parentContext)
                  .deleteUnavailability(game.id, date);
              Navigator.of(context).pop();
            },
            child: const Text('delete-label').tr(),
          ),
        ],
      ),
    );
  }

  void _removeDateFromGameUnavailableDates(DateTime date) {
    game.unavailableDates.removeWhere((unavailableDate) =>
        DateFormat(AppConstants.DATE_TIME_FORMAT_LONG).format(date) ==
        DateFormat(AppConstants.DATE_TIME_FORMAT_LONG).format(unavailableDate));
  }

  bool _isUnavailableDay(List<DateTime> unavailableDates, DateTime date) {
    final formattedDate =
        DateFormat(AppConstants.DATE_TIME_FORMAT_LONG).format(date);
    return unavailableDates.any((unavailableDate) =>
        formattedDate ==
        DateFormat(AppConstants.DATE_TIME_FORMAT_LONG).format(unavailableDate));
  }
}
