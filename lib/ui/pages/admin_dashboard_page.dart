import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/ui/components/scaffold/admin_scaffold.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/menu_items.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AdminDashboardPage extends StatelessWidget {
  final User user;

  const AdminDashboardPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: _buildBody(context),
      ),
      navBarIndex: AdminMenuItems.Dashboard.index,
      onSortPressed: null,
      onSearch: null,
      user: user,
    );
  }

  List<Widget> _buildDashboardCards(BuildContext context) {
    return [
      _buildCard(
        title: 'Bibliothèque de jeux',
        icon: FontAwesomeIcons.gamepad,
        onTap: () {
          context.push(Routes.adminGames.path);
        },
      ),
      _buildCard(
        title: 'Suivi des réservervations',
        icon: Icons.calendar_month_outlined,
        onTap: () {},
      ),
      _buildCard(
        title: 'Gestion des réductions',
        icon: Icons.money_off_csred_sharp,
        onTap: () {},
      ),
      _buildCard(
        title: 'Gestion des catégories',
        icon: Icons.list_alt,
        onTap: () {},
      ),
    ];
  }

  Widget _buildBody(BuildContext context) {
    List<Widget> dashboardCards = _buildDashboardCards(context);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getItemNb(context),
      ),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: dashboardCards.length,
      itemBuilder: (context, index) {
        final Widget dashboardCard = dashboardCards[index];
        return dashboardCard;
      },
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 100,
      width: 100,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        surfaceTintColor: Colors.blue,
        child: Container(
          decoration: _buildCardDecoration(),
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  children: [
                    FaIcon(
                      icon,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      gradient: const RadialGradient(
        center: Alignment.bottomLeft,
        focalRadius: 0.9,
        focal: Alignment.topRight,
        colors: [
          Color(0xffEA6EFB),
          Color(0xff8A4094),
        ],
      ),
    );
  }

  int _getItemNb(BuildContext context) {
    if (ResponsiveWrapper.of(context).isSmallerThan(MOBILE)) {
      return 2;
    } else if (ResponsiveWrapper.of(context).isSmallerThan(TABLET)) {
      return 3;
    } else if (ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)) {
      return 4;
    } else if (ResponsiveWrapper.of(context).isSmallerThan("4K")) {
      return 5;
    }
    return 6;
  }
}
