import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/game.dart';
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
  void initState() {
    super.initState();
  }

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
            SizedBox(
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                ),
                onPressed: () async {
                  var choosedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(
                      const Duration(days: 365),
                    ),
                  );
                  // TODO create unavailability
                },
                child: const Text("add-unavailability-label").tr(),
              ),
            ),
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
                    child: _buildCalendar(context))
                : SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: _buildCalendar(context),
                  ),
          ],
        ),
      ),
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
        if (_isUnavailableDay(game.unavailableDates, selectedDay)) {
          _showDeleteConfirmationDialog(selectedDay);
        }
      },
    );
  }

  void _showDeleteConfirmationDialog(DateTime date) {
    showDialog(
      context: context,
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
              // TODO delete unavailability
              setState(() {
                _removeDateFromGameUnavailableDates(date);
              });
              Navigator.of(context).pop(); // Fermer la boîte de dialogue
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
