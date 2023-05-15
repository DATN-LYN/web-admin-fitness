import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';
import 'package:web_admin_fitness/global/graphql/auth/__generated__/mutation_register.req.gql.dart';
import 'package:web_admin_fitness/global/graphql/cache_handler/upsert_user_cache_handler.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/user_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_user.req.gql.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/utils/file_helper.dart';
import 'package:web_admin_fitness/global/widgets/avatar.dart';
import 'package:web_admin_fitness/global/widgets/label.dart';
import 'package:web_admin_fitness/global/widgets/loading_overlay.dart';
import 'package:web_admin_fitness/global/widgets/selected_image.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';
import 'package:web_admin_fitness/global/widgets/upsert_form_button.dart';

import '../../../../../../global/gen/i18n.dart';
import '../../../../../../global/widgets/dialogs/confirmation_dialog.dart';
import '../../../../../../global/widgets/right_sheet_appbar.dart';
import '../../../../../../global/widgets/toast/multi_toast.dart';

class UserUpsertPage extends StatefulWidget {
  const UserUpsertPage({
    super.key,
    this.user,
  });

  final GUser? user;

  @override
  State<UserUpsertPage> createState() => _UserUpsertPageState();
}

class _UserUpsertPageState extends State<UserUpsertPage> with ClientMixin {
  late final isCreateNew = widget.user == null;
  var formKey = GlobalKey<FormBuilderState>();
  XFile? image;
  bool loading = false;

  void handleReset() {
    setState(() {
      formKey = GlobalKey<FormBuilderState>();
      image = null;
    });
  }

  Future<String?> getImageUrl() async {
    if (image != null) {
      return await FileHelper.uploadImage(image!, 'user');
    } else {
      return widget.user?.avatar;
    }
  }

  Future<GRegisterInputDto> getInputCreate() async {
    final formValue = formKey.currentState!.value;
    String? imageUrl = await getImageUrl();

    return GRegisterInputDto(
      (b) => b
        ..age = double.parse(formValue['age'])
        ..email = formValue['email']
        ..avatar = imageUrl
        ..fullName = formValue['fullName']
        ..password = formValue['password'],
    );
  }

  Future<GUpsertUserInputDto> getInputUpdate() async {
    final formValue = formKey.currentState!.value;
    String? imageUrl = await getImageUrl();

    return GUpsertUserInputDto(
      (b) => b
        ..age = double.parse(formValue['age'])
        ..email = formValue['email']
        ..avatar = imageUrl
        ..fullName = formValue['fullName'],
    );
  }

  void handleCreate() {
    final i18n = I18n.of(context)!;

    if (formKey.currentState!.saveAndValidate()) {
      showAlertDialog(
        context: context,
        builder: (dialogContext, child) {
          return ConfirmationDialog(
            titleText: i18n.upsertUser_CreateNewTitle,
            contentText: i18n.upsertUser_CreateNewDes,
            onTapPositiveButton: () async {
              dialogContext.popRoute(true);
              setState(() => loading = true);

              final upsertData = await getInputCreate();

              final request =
                  GRegisterReq((b) => b..vars.input.replace(upsertData));

              final response = await client.request(request).first;

              setState(() => loading = false);
              if (response.hasErrors) {
                if (mounted) {
                  showErrorToast(
                    context,
                    response.graphqlErrors?.first.message,
                  );
                  // DialogUtils.showError(context: context, response: response);
                }
              } else {
                if (mounted) {
                  showSuccessToast(context, i18n.toast_Subtitle_CreateUser);
                  context.popRoute(response);
                }
              }
            },
          );
        },
      );
    } else {
      showWarningToast(context, i18n.toast_Subtitle_InvalidInformation);
    }
  }

  void handleUpdate() {
    final i18n = I18n.of(context)!;

    if (formKey.currentState!.saveAndValidate()) {
      showAlertDialog(
        context: context,
        builder: (dialogContext, child) {
          return ConfirmationDialog(
            titleText: i18n.upsertUser_CreateNewTitle,
            contentText: i18n.upsertUser_CreateNewDes,
            onTapPositiveButton: () async {
              dialogContext.popRoute(true);
              setState(() => loading = true);

              final upsertData = await getInputUpdate();

              final request = GUpsertUserReq(
                (b) => b
                  ..vars.input.replace(upsertData)
                  ..updateCacheHandlerKey = UpsertUserCacheHandler.key
                  ..updateCacheHandlerContext = {
                    'upsertData': upsertData,
                  },
              );

              final response = await client.request(request).first;

              setState(() => loading = false);
              if (response.hasErrors) {
                if (mounted) {
                  showErrorToast(
                    context,
                    response.graphqlErrors?.first.message,
                  );
                  // DialogUtils.showError(context: context, response: response);
                }
              } else {
                if (mounted) {
                  showSuccessToast(context, i18n.toast_Subtitle_CreateUser);
                  context.popRoute(response);
                }
              }
            },
          );
        },
      );
    } else {
      showWarningToast(context, i18n.toast_Subtitle_InvalidInformation);
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    final errorAvatar = Avatar(
      name: widget.user?.fullName,
      size: 100,
    );

    return LoadingOverlay(
      loading: loading,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: RightSheetAppBar(
          title: Text(
            isCreateNew
                ? i18n.upsertUser_CreateNewTitle
                : i18n.upsertUser_UserDetail,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: FormBuilder(
                key: formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    const SizedBox(height: 16),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final file = await FileHelper.pickImage();
                          setState(() {
                            image = file;
                          });
                        },
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            !isCreateNew && image == null
                                ? ShimmerImage(
                                    imageUrl: widget.user?.avatar ?? '_',
                                    width: 100,
                                    height: 100,
                                    borderRadius: BorderRadius.circular(100),
                                    errorWidget: errorAvatar,
                                  )
                                : image != null
                                    ? SelectedImage(
                                        image: image!,
                                        borderRadius: 100,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      )
                                    : errorAvatar,
                            Container(
                              width: 30,
                              height: 30,
                              margin:
                                  const EdgeInsets.only(bottom: 4, right: 4),
                              decoration: BoxDecoration(
                                color: AppColors.grey1,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: AppColors.white,
                                size: 17,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Label(i18n.login_Email),
                    FormBuilderTextField(
                      name: 'email',
                      initialValue: widget.user?.email,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.login_EmailIsRequired,
                      ),
                      decoration:
                          InputDecoration(hintText: i18n.upsertUser_EmailHint),
                      enabled: isCreateNew ? true : false,
                    ),
                    Label(i18n.upsertUser_FullName),
                    FormBuilderTextField(
                      name: 'fullName',
                      initialValue: widget.user?.fullName,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.upsertUser_FullNameRequired,
                      ),
                      decoration: InputDecoration(
                        hintText: i18n.upsertUser_FullNameHint,
                      ),
                    ),
                    Label(i18n.upsertUser_Age),
                    FormBuilderTextField(
                      name: 'age',
                      initialValue: widget.user?.age?.round().toString(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.upsertUser_AgeRequired,
                      ),
                      decoration: InputDecoration(
                        hintText: i18n.upsertUser_AgeHint,
                      ),
                    ),
                    if (isCreateNew) ...[
                      Label(i18n.login_Password),
                      FormBuilderTextField(
                        name: 'password',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.required(
                          errorText: i18n.login_PasswordIsRequired,
                        ),
                        decoration: InputDecoration(
                          hintText: i18n.upsertUser_PasswordHint,
                        ),
                      ),
                      Label(i18n.upsertUser_ConfirmPassword),
                      FormBuilderTextField(
                        name: 'confirmPassword',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.compose(
                          [
                            FormBuilderValidators.required(
                              errorText:
                                  i18n.upsertUser_ConfirmPasswordRequired,
                            ),
                            (value) {
                              if (value !=
                                  formKey.currentState?.fields['password']
                                      ?.value) {
                                return i18n.setting_PasswordNotMatch;
                              } else {
                                return null;
                              }
                            }
                          ],
                        ),
                        decoration: InputDecoration(
                          hintText: i18n.upsertUser_ConfirmPasswordHint,
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
            UpsertFormButton(
              onPressPositiveButton: isCreateNew ? handleCreate : handleUpdate,
              onPressNegativeButton: handleReset,
              positiveButtonText:
                  isCreateNew ? i18n.button_Confirm : i18n.button_Save,
              negativeButtonText: i18n.button_Reset,
            )
          ],
        ),
      ),
    );
  }
}
