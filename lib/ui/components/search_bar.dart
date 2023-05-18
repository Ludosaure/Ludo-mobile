import 'package:flutter/material.dart';

//WIP
class SearchBar extends StatelessWidget {
  final bool showFilter;
  final void Function(String toSearch)? onSearch;

  const SearchBar({
    Key? key,
    required this.onSearch,
    required this.showFilter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String searched = "";

    return SimpleDialog(
      alignment: Alignment.topCenter,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      contentPadding: const EdgeInsets.all(8),
      children: [
        Row(
          verticalDirection: VerticalDirection.down,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  searched = value;
                },
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Search',
                  prefixIcon: IconButton(
                    onPressed: () {
                      onSearch?.call(searched);
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.search),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            if (showFilter)
              IconButton(
                onPressed: () {
                },
                icon: const Icon(Icons.filter_list_sharp),
              ),
          ],
        ),
      ],
    );
  }
}
