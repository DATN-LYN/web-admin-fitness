import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:ionicons/ionicons.dart';
import 'package:web_admin_fitness/global/routers/app_router.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/toast/multi_toast.dart';

import '../../../../../global/gen/i18n.dart';
import '../../../../../global/graphql/cache_handler/__generated__/mutation_change_password.req.gql.dart';
import '../../../../../global/themes/app_colors.dart';
import '../../../../../global/widgets/dialogs/confirmation_dialog.dart';
import '../../../../../global/widgets/label.dart';

class ChangePasswordDialog extends StatefulWidget {
  const ChangePasswordDialog({super.key});

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog>
    with ClientMixin {
  final formKey = GlobalKey<FormBuilderState>();
  bool passwordObscure = true;
  bool newPasswordObscure = true;
  bool confirmNewPasswordObscure = true;

  void changePass() {
    if (formKey.currentState!.saveAndValidate()) {
      final data = formKey.currentState!.value;
      final i18n = I18n.of(context)!;

      showDialog(
        context: context,
        builder: (context) {
          return ConfirmationDialog(
            titleText: i18n.setting_ChangePassword,
            contentText: i18n.setting_ChangePasswordConfirm,
            onTapPositiveButton: () async {
              final req = GChangePasswordReq(
                (b) => b
                  ..vars.input.oldPassword = data['oldPassword']
                  ..vars.input.newPassword = data['newPassword'],
              );

              final res = await client.request(req).first;

              if (res.hasErrors) {
                if (mounted) {
                  showErrorToast(
                      context, res.graphqlErrors?.first.message.toString());
                }
              } else {
                if (mounted) {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return ConfirmationDialog(
                        titleText: i18n.common_Success,
                        contentText: i18n.setting_ChangePasswordSuccess,
                        showNegativeButton: false,
                        image: const Icon(
                          Ionicons.checkmark_circle,
                          color: AppColors.primaryBold,
                        ),
                      );
                    },
                  );
                  if (mounted) {
                    AutoRouter.of(context)
                        .popUntilRouteWithName(SettingsRoute.name);
                  }
                }
              }
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: FormBuilder(
          key: formKey,
          child: ListView(
            padding: mediaQueryData.viewInsets +
                EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom: max(mediaQueryData.padding.bottom, 16),
                ),
            shrinkWrap: true,
            children: [
              const SizedBox(height: 12),
              Text(
                i18n.setting_ChangePassword,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(i18n.setting_ChangePasswordDes),
              Label(i18n.setting_OldPassword),
              FormBuilderTextField(
                name: 'oldPassword',
                obscureText: passwordObscure,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(
                      errorText: i18n.setting_OldPasswordRequired,
                    ),
                  ],
                ),
                autofocus: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  hintText: i18n.setting_OldPasswordHint,
                  suffixIconConstraints: const BoxConstraints(),
                  suffixIcon: SizedBox.square(
                    dimension: 40,
                    child: IconButton(
                      onPressed: () => setState(() {
                        passwordObscure = !passwordObscure;
                      }),
                      icon: Icon(
                        passwordObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.grey2,
                      ),
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
                autocorrect: false,
              ),
              Label(i18n.setting_NewPassword),
              FormBuilderTextField(
                name: 'newPassword',
                obscureText: newPasswordObscure,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(
                      errorText: i18n.setting_NewPasswordRequired,
                    ),
                    FormBuilderValidators.minLength(
                      6,
                      errorText: i18n.login_PasswordMustBeAtLeastSixCharacters,
                    ),
                  ],
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  hintText: i18n.setting_NewPasswordHint,
                  suffixIconConstraints: const BoxConstraints(),
                  suffixIcon: SizedBox.square(
                    dimension: 40,
                    child: IconButton(
                      onPressed: () => setState(() {
                        newPasswordObscure = !newPasswordObscure;
                      }),
                      icon: Icon(
                        newPasswordObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.grey2,
                      ),
                    ),
                  ),
                ),
                textInputAction: TextInputAction.next,
                autocorrect: false,
              ),
              Label(i18n.setting_ConfirmNewPassword),
              FormBuilderTextField(
                name: 'confirmNewPassword',
                obscureText: confirmNewPasswordObscure,
                validator: FormBuilderValidators.compose(
                  [
                    FormBuilderValidators.required(
                      errorText: i18n.setting_ConfirmNewPasswordRequired,
                    ),
                    (value) {
                      if (value !=
                          formKey.currentState?.fields['newPassword']?.value) {
                        return i18n.setting_PasswordNotMatch;
                      }
                      return null;
                    },
                  ],
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: InputDecoration(
                  hintText: i18n.setting_ConfirmNewPasswordHint,
                  suffixIconConstraints: const BoxConstraints(),
                  suffixIcon: SizedBox.square(
                    dimension: 40,
                    child: IconButton(
                      onPressed: () => setState(() {
                        confirmNewPasswordObscure = !confirmNewPasswordObscure;
                      }),
                      icon: Icon(
                        confirmNewPasswordObscure
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: AppColors.grey2,
                      ),
                    ),
                  ),
                ),
                autocorrect: false,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: context.popRoute,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.grey6,
                      ),
                      child: Text(i18n.button_Cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: changePass,
                      child: Text(i18n.button_Ok),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
