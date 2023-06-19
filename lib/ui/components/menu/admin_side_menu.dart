import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/firebase/service/firebase_database_service.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/menu_items.dart';
import 'package:responsive_framework/responsive_row_column.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class AdminSideMenu extends StatefulWidget {
  const AdminSideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminSideMenu> createState() => _AdminSideMenuState();
}

class _AdminSideMenuState extends State<AdminSideMenu> {
  bool _hasUnseenConversations = false;

  @override
  void initState() {
    super.initState();
    _initHasUnseenConversations();
  }

  _initHasUnseenConversations() {
    final unreadConversationsStream =
    FirebaseDatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .hasUnseenConversationsStream();
    unreadConversationsStream.listen((hasUnreadConversations) {
      setState(() => _hasUnseenConversations = hasUnreadConversations);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ResponsiveVisibility(
        visible: false,
        visibleWhen: const [Condition.largerThan(name: MOBILE)],
        replacement: const SizedBox.shrink(),
        child: ResponsiveRowColumn(
          columnCrossAxisAlignment: CrossAxisAlignment.start,
          columnMainAxisAlignment: MainAxisAlignment.start,
          columnMainAxisSize: MainAxisSize.max,
          columnPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          layout: ResponsiveRowColumnType.COLUMN,
          children: [
            _buildItem(
              context,
              AdminMenuItems.Home.label,
              Routes.homeAdmin.path,
              AdminMenuItems.Home.icon,
            ),
            _buildItem(
              context,
              AdminMenuItems.Dashboard.label,
              Routes.adminDashboard.path,
              AdminMenuItems.Dashboard.icon,
            ),
            _buildItem(
              context,
              AdminMenuItems.AddGame.label,
              Routes.addGame.path,
              AdminMenuItems.AddGame.icon,
            ),
            _buildItem(
              context,
              AdminMenuItems.Profile.label,
              Routes.profile.path,
              AdminMenuItems.Profile.icon,
            ),
            _buildItem(
              context,
              AdminMenuItems.Messages.label,
              Routes.inbox.path,
              AdminMenuItems.Messages.icon,
            ),
          ],
        ),
      ),
    );
  }

  ResponsiveRowColumnItem _buildItem(
    BuildContext context,
    String label,
    String route,
    IconData icon,
  ) {
    Color selectedColor = (GoRouter.of(context).location == route)
        ? Theme.of(context).colorScheme.secondary
        : Colors.transparent;
    Color color = (_hasUnseenConversations && label == MenuItems.Messages.label)
        ? Theme.of(context).colorScheme.primary
        : Colors.black;
    Color backgroundColor =
    (_hasUnseenConversations && label == MenuItems.Messages.label)
        ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
        : selectedColor;
    return ResponsiveRowColumnItem(
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ResponsiveRowColumn(
            layout: ResponsiveRowColumnType.ROW,
            rowCrossAxisAlignment: CrossAxisAlignment.center,
            rowMainAxisAlignment: MainAxisAlignment.start,
            rowMainAxisSize: MainAxisSize.min,
            rowVerticalDirection: VerticalDirection.down,
            children: [
              ResponsiveRowColumnItem(
                child: Icon(
                  size: ResponsiveValue(
                    context,
                    defaultValue: 20.0,
                    valueWhen: [
                      const Condition.largerThan(name: MOBILE, value: 14.0),
                      const Condition.largerThan(name: TABLET, value: 20.0),
                      const Condition.largerThan(name: DESKTOP, value: 24.0),
                    ],
                  ).value,
                  color: color,
                  icon,
                ),
              ),
              ResponsiveRowColumnItem(
                rowFit: FlexFit.tight,
                child: TextButton(
                  onPressed: () {
                    context.go(route);
                  },
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: ResponsiveValue(
                        context,
                        defaultValue: 14.0,
                        valueWhen: [
                          const Condition.largerThan(name: MOBILE, value: 11.0),
                          const Condition.largerThan(name: TABLET, value: 14.0),
                          const Condition.largerThan(
                              name: DESKTOP, value: 16.0),
                        ],
                      ).value,
                      fontWeight: FontWeight.w400,
                      color: color,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
