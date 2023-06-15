import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/create_game/create_game_bloc.dart';
import 'package:ludo_mobile/ui/components/custom_file_picker.dart';
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
        child: _buildBody(context),
      ),
      navBarIndex: AdminMenuItems.AddGame.index,
      onSortPressed: null,
      onSearch: null,
      user: widget.user,
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const CustomFilePicker(),
          _buildForm(context),
          _buildSubmitButton(context),
        ],
      ),
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
            onChanged: (value) {
              context.read<CreateGameBloc>().add(GameNameChangedEvent(value));
            },
          ),
          TextFormField(
            maxLines: 10,
            decoration: InputDecoration(
              labelText: 'game-description-field'.tr(),
              hintText: 'game-description-placeholder'.tr(),
            ),
            onChanged: (value) {
              context
                  .read<CreateGameBloc>()
                  .add(GameDescriptionChangedEvent(value));
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'weekly-amount-field'.tr(),
              hintText: 'weekly-amount-placeholder'.tr(),
              suffix: const Text('€'),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the game price';
              }
              return null;
            },
            onChanged: (value) {
              context.read<CreateGameBloc>().add(
                    GameWeeklyAmountChangedEvent(
                      double.parse(value),
                    ),
                  );
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
                value: '5b2b9c6e-9d6a-464d-b7db-23e70de019c3',
                child: Text('Plateau'),
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
              context
                  .read<CreateGameBloc>()
                  .add(GameCategoryChangedEvent(value!));
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
            onChanged: (value) {
              context
                  .read<CreateGameBloc>()
                  .add(GameMinAgeChangedEvent(int.parse(value)));
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
            onChanged: (value) {
              context.read<CreateGameBloc>().add(
                    GameAverageDurationChangedEvent(
                      int.parse(value),
                    ),
                  );
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
              onChanged: (value) {
                context.read<CreateGameBloc>().add(
                      GameMinPlayersChangedEvent(
                        int.parse(value),
                      ),
                    );
              }),
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
            onChanged: (value) {
              context.read<CreateGameBloc>().add(
                    GameMaxPlayersChangedEvent(
                      int.parse(value),
                    ),
                  );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocConsumer<CreateGameBloc, CreateGameInitial>(
      listener: (context, state) {
        if (state.status is FormSubmissionSuccessful) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'game-created-successfully',
              ).tr(),
            ),
          );
        } else if (state.status is FormSubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                (state.status as FormSubmissionFailed).message,
              ),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status is FormSubmitting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context
                    .read<CreateGameBloc>()
                    .add(const CreateGameSubmitEvent());
              }
            },
            child: const Text('Créer'),
          ),
        );
      },
    );
  }
}
