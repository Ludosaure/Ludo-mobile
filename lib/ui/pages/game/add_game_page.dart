import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/ui/components/scaffold/admin_scaffold.dart';
import 'package:ludo_mobile/utils/menu_items.dart';

class AddGamePage extends StatefulWidget {
  final User user;

  const AddGamePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<AddGamePage> createState() => _AddGamePageState();
}

class _AddGamePageState extends State<AddGamePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: SingleChildScrollView(
          child: _buildForm(context),
        ),
      ),
      navBarIndex: AdminMenuItems.AddGame.index,
      onSortPressed: null,
      onSearch: null,
      user: widget.user,
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        verticalDirection: VerticalDirection.down,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'game-name-field'.tr(),
              hintText: 'game-name-placeholder'.tr(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the game name';
              }
              return null;
            },
          ),
          TextFormField(
            maxLines: 10,
            decoration: InputDecoration(
              labelText: 'game-description-field'.tr(),
              hintText: 'game-description-placeholder'.tr(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the game description';
              }
              return null;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'game-weekly-amount-field'.tr(),
              hintText: 'game-weekly-amount-placeholder'.tr(),
              suffix: const Text('€'),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the game price';
              }
              return null;
            },
          ),
          //TODO récuperer les catégories de la BDD -> cubit
          DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: 'game-category-field'.tr(),
              hintText: 'game-category-placeholder'.tr(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the game category';
              }
              return null;
            },
            items: const [
              DropdownMenuItem(
                value: 'identifiant ici jimagine',
                child: Text('Adresse'),
              ),
              DropdownMenuItem(
                value: 'identifiant ici 1',
                child: Text('Dés'),
              ),
              DropdownMenuItem(
                value: 'identifiant ici 2',
                child: Text('Cartes'),
              ),
            ],
            onChanged: (value) {
              print("selected category: $value");
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'min-age-field'.tr(),
              hintText: 'min-age-placeholder'.tr(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter min age';
              }
              return null;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'average-duration-field'.tr(),
              hintText: 'average-duration-placeholder'.tr(),
              isDense: true,
              suffix: const Text('min'),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter average duration';
              }
              return null;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'min-players-field'.tr(),
              hintText: 'min-players-placeholder'.tr(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter min players';
              }
              return null;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'max-players-field'.tr(),
              hintText: 'max-players-placeholder'.tr(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter max players';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
