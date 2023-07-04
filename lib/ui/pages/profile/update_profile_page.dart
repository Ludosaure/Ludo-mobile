import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ludo_mobile/core/form_status.dart';
import 'package:ludo_mobile/domain/models/user.dart';
import 'package:ludo_mobile/domain/use_cases/session/session_cubit.dart';
import 'package:ludo_mobile/domain/use_cases/update_user/update_user_bloc.dart';
import 'package:ludo_mobile/ui/components/custom_mobile_file_picker.dart';
import 'package:ludo_mobile/ui/components/custom_web_file_picker.dart';
import 'package:ludo_mobile/ui/components/form_field_decoration.dart';
import 'package:ludo_mobile/ui/router/routes.dart';
import 'package:ludo_mobile/utils/validator_utils.dart';

class UpdateProfilePage extends StatefulWidget {
  final User user;

  const UpdateProfilePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();

  User get user => widget.user;

  @override
  void initState() {
    context.read<UpdateUserBloc>().add(UserIdChangedEvent(user.id));
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
          "update-user-title",
          softWrap: true,
          overflow: TextOverflow.visible,
        ).tr(
          namedArgs: {
            "firstname": user.firstname,
            "lastname": user.lastname,
          },
        ),
      ),
      body: _updateUserForm(context),
    );
  }

  Widget _updateUserForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        children: [
          const SizedBox(height: 20),
          kIsWeb
              ? CustomWebFilePicker(
                  onFileSelected: _onFileSelected,
                  initialImage: user.profilePicturePath,
                )
              : CustomMobileFilePicker(
                  initialImage: user.profilePicturePath,
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
            validator: ValidatorUtils.validatePhoneNumber,
            initialValue: user.phone,
            onChanged: (value) {
              context
                  .read<UpdateUserBloc>()
                  .add(UserPhoneNumberChangedEvent(value));
            },
            decoration: FormFieldDecoration.textField("phone-label".tr()),
          ),
          const SizedBox(height: 20),
          TextFormField(
            initialValue: user.pseudo,
            decoration: FormFieldDecoration.textField(
              'pseudo-field'.tr(),
            ),
            onChanged: (value) {
              context.read<UpdateUserBloc>().add(
                    UserPseudoChangedEvent(value),
                  );
            },
          ),
          const SizedBox(height: 20),
          ListTile(
            title: Text(
              'activate-mail-notifications-label'.tr(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Switch(
              activeColor: Theme.of(context).colorScheme.primary,
              value: user.hasEnabledMailNotifications,
              onChanged: (value) {
                setState(() {
                  user.hasEnabledMailNotifications = value;
                });
                context.read<UpdateUserBloc>().add(
                      UserHasEnabledMailNotificationsChangedEvent(value),
                    );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return BlocConsumer<UpdateUserBloc, UpdateUserInitial>(
      listener: (context, state) {
        if (state.status is FormSubmissionSuccessful) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'user-updated-successfully',
              ).tr(),
            ),
          );
          BlocProvider.of<SessionCubit>(context).checkSession();
          context.go(Routes.profile.path);
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
                    .read<UpdateUserBloc>()
                    .add(const UpdateUserSubmitEvent());
              }
            },
            child: const Text('update-label').tr(),
          ),
        );
      },
    );
  }

  void _onFileSelected(dynamic file) {
    context.read<UpdateUserBloc>().add(UserPictureChangedEvent(file!));
  }
}
