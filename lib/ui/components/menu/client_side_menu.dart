import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/menu_items.dart';
import 'package:responsive_framework/responsive_row_column.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

class ClientSideMenu extends StatelessWidget {
  const ClientSideMenu({
    Key? key,
  }) : super(key: key);

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
              MenuItems.Home.label,
              Routes.home.path,
              MenuItems.Home.icon,
            ),
            _buildItem(
              context,
              MenuItems.Favorites.label,
              Routes.favorites.path,
              MenuItems.Favorites.icon,
            ),
            _buildItem(
              context,
              MenuItems.Profile.label,
              Routes.profile.path,
              MenuItems.Profile.icon,
            ),
            _buildItem(
              context,
              MenuItems.Messages.label,
              Routes.inbox.path,
              MenuItems.Messages.icon,
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
    bool isSelected = GoRouter.of(context).location == route;
    return ResponsiveRowColumnItem(
      child: Container(
        color: isSelected ? Colors.grey.shade200 : Colors.transparent,
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
                      color: Colors.black,
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
