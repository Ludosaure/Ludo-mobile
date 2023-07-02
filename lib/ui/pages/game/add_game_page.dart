import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/domain/models/game_category.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/create_game/create_game_bloc.dart';
import 'package:ludo_mobile/domain/use_cases/get_categories/get_categories_cubit.dart';
import 'package:ludo_mobile/ui/components/custom_mobile_file_picker.dart';
import 'package:ludo_mobile/ui/components/custom_web_file_picker.dart';
import 'package:ludo_mobile/ui/components/form_field_decoration.dart';
import 'package:ludo_mobile/ui/components/scaffold/admin_scaffold.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
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
  late List<GameCategory> _categories;

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
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
          kIsWeb
              ? CustomWebFilePicker(onFileSelected: _onFileSelected)
              : CustomMobileFilePicker(onFileSelected: _onFileSelected),
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
            decoration: FormFieldDecoration.textField('game-name-field'.tr()),
            validator: RequiredValidator(
              errorText: "form.field-required-msg".tr(),
            ),
            onChanged: (value) {
              context.read<CreateGameBloc>().add(GameNameChangedEvent(value));
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            maxLines: 10,
            decoration:
                FormFieldDecoration.textField('game-description-field'.tr()),
            onChanged: (value) {
              context
                  .read<CreateGameBloc>()
                  .add(GameDescriptionChangedEvent(value));
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            decoration: FormFieldDecoration.textField(
                'weekly-amount-field'.tr(),
                suffixText: 'currency-symbol'.tr()),
            keyboardType: TextInputType.number,
            validator: RequiredValidator(
              errorText: "form.field-required-msg".tr(),
            ),
            onChanged: (value) {
              context.read<CreateGameBloc>().add(
                    GameWeeklyAmountChangedEvent(
                      double.parse(value),
                    ),
                  );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          DropdownButtonFormField(
            decoration:
                FormFieldDecoration.textField('game-category-field'.tr()),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "form.field-required-msg".tr();
              }
              return null;
            },
            items: _categories.map((category) {
              return DropdownMenuItem(
                value: category.id,
                child: Text(category.name),
              );
            }).toList(),
            onChanged: (value) {
              context.read<CreateGameBloc>().add(
                    GameCategoryChangedEvent(value!),
                  );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: FormFieldDecoration.textField('min-age-field'.tr()),
            validator: RequiredValidator(
              errorText: "form.field-required-msg".tr(),
            ),
            onChanged: (value) {
              context
                  .read<CreateGameBloc>()
                  .add(GameMinAgeChangedEvent(int.parse(value)));
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: FormFieldDecoration.textField(
              'average-duration-field'.tr(),
              suffixText: 'min',
            ),
            validator: RequiredValidator(
              errorText: "form.field-required-msg".tr(),
            ),
            onChanged: (value) {
              context.read<CreateGameBloc>().add(
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
            keyboardType: TextInputType.number,
            decoration: FormFieldDecoration.textField('min-players-field'.tr()),
            validator: RequiredValidator(
              errorText: "form.field-required-msg".tr(),
            ),
            onChanged: (value) {
              context.read<CreateGameBloc>().add(
                    GameMinPlayersChangedEvent(int.parse(value)),
                  );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: FormFieldDecoration.textField('max-players-field'.tr()),
            validator: RequiredValidator(
              errorText: "form.field-required-msg".tr(),
            ),
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
              ).tr(
                namedArgs: {
                  "game": state.name,
                },
              ),
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
                    .read<CreateGameBloc>()
                    .add(const CreateGameSubmitEvent());
              }
            },
            child: const Text('add-label').tr(),
          ),
        );
      },
    );
  }

  void _onFileSelected(dynamic file) {
    context.read<CreateGameBloc>().add(GamePictureChangedEvent(file));
  }
}
