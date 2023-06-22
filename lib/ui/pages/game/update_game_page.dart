import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/domain/models/game.dart';
import 'package:ludo_mobile/domain/models/game_category.dart';
import 'package:ludo_mobile/domain/use_cases/get_categories/get_categories_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/update_game/update_game_bloc.dart';
import 'package:ludo_mobile/ui/components/custom_file_picker.dart';
import 'package:ludo_mobile/ui/components/form_field_decoration.dart';
import 'package:ludo_mobile/ui/router/routes.dart';

class UpdateGamePage extends StatefulWidget {
  final Game game;

  const UpdateGamePage({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  State<UpdateGamePage> createState() => _UpdateGamePageState();
}

class _UpdateGamePageState extends State<UpdateGamePage> {
  final _formKey = GlobalKey<FormState>();
  late List<GameCategory> _categories;

  Game get game => widget.game;

  @override
  void initState() {
    context.read<UpdateGameBloc>().add(GameIdChangedEvent(game.id));
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
          "update-game-title",
        ).tr(
          namedArgs: {
            "name": game.name,
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: BlocConsumer<GetCategoriesCubit, GetCategoriesState>(
          listener: (context, state) {
            if (state is GetCategoriesError) {
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
            if (state is GetCategoriesInitial) {
              BlocProvider.of<GetCategoriesCubit>(context).getCategories();
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is GetCategoriesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is UserNotLogged) {
              context.go(Routes.login.path);
            }

            if (state is GetCategoriesSuccess) {
              _categories = state.categories;
              return _buildBody(context);
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CustomFilePicker(
            initialImage: game.imageUrl,
            onFileSelected: _onFileSelected,
          ),
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
            initialValue: game.name,
            decoration: FormFieldDecoration.textField('game-name-field'.tr()),
            onChanged: (value) {
              context.read<UpdateGameBloc>().add(GameNameChangedEvent(value));
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: game.description,
            maxLines: 10,
            decoration:
                FormFieldDecoration.textField('game-description-field'.tr()),
            onChanged: (value) {
              context
                  .read<UpdateGameBloc>()
                  .add(GameDescriptionChangedEvent(value));
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: game.weeklyAmount.toString(),
            decoration: FormFieldDecoration.textField(
              'weekly-amount-field'.tr(),
              suffixText: 'currency-symbol'.tr(),
            ),
            onChanged: (value) {
              context.read<UpdateGameBloc>().add(
                    GameWeeklyAmountChangedEvent(double.parse(value)),
                  );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButtonFormField(
            decoration:
                FormFieldDecoration.textField('game-category-field'.tr()),
            items: _categories.map((category) {
              return DropdownMenuItem(
                value: category.id,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (value) {
              context.read<UpdateGameBloc>().add(
                    GameCategoryChangedEvent(value!),
                  );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: game.minAge.toString(),
            keyboardType: TextInputType.number,
            decoration: FormFieldDecoration.textField('min-age-field'.tr()),
            onChanged: (value) {
              context
                  .read<UpdateGameBloc>()
                  .add(GameMinAgeChangedEvent(int.parse(value)));
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: game.averageDuration.toString(),
            keyboardType: TextInputType.number,
            decoration: FormFieldDecoration.textField(
              'average-duration-field'.tr(),
              suffixText: 'min',
            ),
            onChanged: (value) {
              context.read<UpdateGameBloc>().add(
                    GameAverageDurationChangedEvent(
                      int.parse(value),
                    ),
                  );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: game.minPlayers.toString(),
            keyboardType: TextInputType.number,
            decoration: FormFieldDecoration.textField(
              'min-players-field'.tr(),
            ),
            onChanged: (value) {
              context.read<UpdateGameBloc>().add(
                    GameMinPlayersChangedEvent(
                      int.parse(value),
                    ),
                  );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            initialValue: game.maxPlayers.toString(),
            keyboardType: TextInputType.number,
            decoration: FormFieldDecoration.textField(
              'max-players-field'.tr(),
            ),
            onChanged: (value) {
              context.read<UpdateGameBloc>().add(
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
    return BlocConsumer<UpdateGameBloc, UpdateGameInitial>(
      listener: (context, state) {
        if (state.status is FormSubmissionSuccessful) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'game-updated-successfully',
              ).tr(),
            ),
          );
          context.go(Routes.adminGames.path);
        } else if (state.status is FormSubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                (state.status as FormSubmissionFailed).message,
              ),
              backgroundColor: Theme.of(context).errorColor,
            ),
          );
        } else if (state is UserMustLog) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'user-must-log'.tr(),
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

        if (state is UserMustLog) {
          context.go(Routes.login.path);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context
                    .read<UpdateGameBloc>()
                    .add(const UpdateGameSubmitEvent());
              }
            },
            child: const Text('update-game-btn').tr(),
          ),
        );
      },
    );
  }

  void _onFileSelected(File? file) {
    context.read<UpdateGameBloc>().add(GamePictureChangedEvent(file!));
  }
}