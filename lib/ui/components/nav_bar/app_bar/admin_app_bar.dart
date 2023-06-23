import 'package:flutter/material.dart';
import 'package:ludo_mobile/ui/components/search_bar.dart';
import 'package:ludo_mobile/utils/app_constants.dart';

class AdminAppBar extends StatelessWidget {
  // final void Function<T>(T selectedFilter)? onSortPressed;
  // final void Function(String toSearch)? onSearch;

  const AdminAppBar({
    Key? key,
    // required this.onSearch,
    // required this.onSortPressed,
  }) : super(key: key);

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: MediaQuery.of(context).size.height * 0.08,
      title: const Text(
        AppConstants.APP_NAME,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Image(
          image: const AssetImage(AppConstants.APP_LOGO),
          width: MediaQuery.of(context).size.width * 0.15,
          height: MediaQuery.of(context).size.width * 0.15,
        ),
      ),
      leadingWidth: MediaQuery.of(context).size.width * 0.25,
      // actions: [
      //   IconButton(
      //     onPressed: () {
      //       //TODO
      //       // onSortPressed?.call(ReservationStatus.all);
      //     },
      //     icon: const Icon(
      //       Icons.filter_list_sharp,
      //       color: Colors.black,
      //     ),
      //   ),
      //   IconButton(
      //     onPressed: () {
      //       showDialog(
      //         context: context,
      //         builder: (context) {
      //           return SearchBar(
      //             showFilter: false,
      //             onSearch: onSearch,
      //           );
      //         },
      //       );
      //     },
      //     icon: const Icon(
      //       Icons.search,
      //       color: Colors.black,
      //     ),
      //   ),
      // ],
      elevation: 1.0,
    );
  }
}
