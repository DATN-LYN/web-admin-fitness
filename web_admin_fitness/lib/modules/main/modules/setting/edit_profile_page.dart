import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/loading_overlay.dart';
import 'package:web_admin_fitness/global/widgets/toast/multi_toast.dart';

import '../../../../global/graphql/__generated__/schema.schema.gql.dart';
import '../../../../global/graphql/mutation/__generated__/mutation_upsert_user.req.gql.dart';
import '../../../../global/models/hive/user.dart';
import '../../../../global/utils/file_helper.dart';
import '../../../../global/widgets/avatar.dart';
import '../../../../global/widgets/dialogs/confirmation_dialog.dart';
import '../../../../global/widgets/label.dart';
import '../../../../global/widgets/right_sheet_appbar.dart';
import '../../../../global/widgets/selected_image.dart';
import '../../../../global/widgets/shimmer_image.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> with ClientMixin {
  bool loading = false;
  XFile? image;
  var formKey = GlobalKey<FormBuilderState>();

  void handleSubmit() {
    final i18n = I18n.of(context)!;
    final user = hiveService.getUserCredentials();
    String? imageUrl;

    if (formKey.currentState!.saveAndValidate()) {
      final formValue = formKey.currentState!.value;

      showAlertDialog(
        context: context,
        builder: (dialogContext, child) {
          return ConfirmationDialog(
            titleText: i18n.editProfile_Title,
            contentText: i18n.editProfile_EditDes,
            onTapPositiveButton: () async {
              dialogContext.popRoute(true);
              setState(() => loading = true);

              if (image != null) {
                imageUrl = await FileHelper.uploadImage(image!, 'user');
              } else {
                imageUrl = user.user?.avatar;
              }

              final input = GUpsertUserInputDto(
                (b) => b
                  ..age = double.parse(formValue['age'] ?? '0')
                  ..avatar = imageUrl
                  ..id = user.id
                  ..email = formValue['email']
                  ..fullName = formValue['fullName'],
              );

              final request =
                  GUpsertUserReq((b) => b..vars.input.replace(input));

              final response = await client.request(request).first;

              setState(() => loading = false);
              if (response.hasErrors) {
                if (mounted) {
                  showErrorToast(
                    context,
                    response.graphqlErrors?.first.message ??
                        i18n.toast_Subtitle_Error,
                  );
                }
              } else {
                hiveService.saveUserCredentials(user.copyWith(
                  user: User(
                    email: formValue['email'],
                    fullName: formValue['fullName'],
                    age: double.parse(formValue['age']),
                    avatar: imageUrl,
                  ),
                ));

                if (mounted) {
                  showSuccessToast(
                    context,
                    i18n.editProfile_UpdateSuccess,
                  );
                  context.popRoute();
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
    final user = hiveService.getUserCredentials().user;
    final errorAvatar = Avatar(
      name: user?.fullName,
      size: 100,
    );
    return LoadingOverlay(
      loading: loading,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: RightSheetAppBar(
          title: Text(i18n.editProfile_Title),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            user?.avatar != null && image == null
                                ? ShimmerImage(
                                    imageUrl: user!.avatar!,
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
                      initialValue: user!.email,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.login_EmailIsRequired,
                      ),
                      decoration:
                          InputDecoration(hintText: i18n.login_EmailHint),
                      enabled: false,
                    ),
                    Label(i18n.upsertUser_FullName),
                    FormBuilderTextField(
                      name: 'fullName',
                      initialValue: user.fullName!,
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
                      initialValue: user.age!.round().toString(),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.upsertUser_AgeRequired,
                      ),
                      decoration: InputDecoration(
                        hintText: i18n.upsertUser_AgeHint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
              child: ElevatedButton(
                onPressed: handleSubmit,
                child: Text(i18n.button_Apply),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
