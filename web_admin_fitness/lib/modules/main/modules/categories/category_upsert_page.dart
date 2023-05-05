import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';
import 'package:web_admin_fitness/global/graphql/cache_handler/upsert_category_cache_handler.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/category_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_category.req.gql.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/utils/dialogs.dart';
import 'package:web_admin_fitness/global/widgets/dialogs/confirmation_dialog.dart';
import 'package:web_admin_fitness/global/widgets/loading_overlay.dart';
import 'package:web_admin_fitness/global/widgets/right_sheet_appbar.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';

import '../../../../global/utils/file_helper.dart';
import '../../../../global/widgets/label.dart';
import '../../../../global/widgets/toast/multi_toast.dart';

class CategoryUpsertPage extends StatefulWidget {
  const CategoryUpsertPage({
    super.key,
    @queryParam this.category,
  });
  final GCategory? category;

  @override
  State<CategoryUpsertPage> createState() => _CategoryUpsertPageState();
}

class _CategoryUpsertPageState extends State<CategoryUpsertPage>
    with ClientMixin {
  var formKey = GlobalKey<FormBuilderState>();
  bool loading = false;
  XFile? image;
  late final isCreateNew = widget.category == null;

  void handleReset() {
    setState(() {
      formKey = GlobalKey<FormBuilderState>();
      image = null;
    });
  }

  void handleCancel() {
    context.popRoute();
  }

  void handleSubmit() {
    final i18n = I18n.of(context)!;

    if (formKey.currentState!.saveAndValidate()) {
      final formValue = formKey.currentState!.value;

      showAlertDialog(
        context: context,
        builder: (dialogContext, child) {
          return ConfirmationDialog(
            titleText: isCreateNew
                ? i18n.upsertCategory_CreateNewTitle
                : i18n.upsertCategory_UpdateTitle,
            contentText: isCreateNew
                ? i18n.upsertCategory_CreateNewDes
                : i18n.upsertCategory_UpdateDes,
            onTapPositiveButton: () async {
              dialogContext.popRoute(true);
              setState(() => loading = true);
              String? imageUrl = '';

              if (image != null) {
                imageUrl = await FileHelper.uploadImage(image!);
              } else {
                imageUrl = widget.category?.imgUrl;
              }

              final request = GUpsertCategoryReq(
                (b) => b
                  ..vars.input.name = formValue['name']
                  ..vars.input.id = widget.category?.id
                  ..vars.input.imgUrl = imageUrl
                  ..updateCacheHandlerKey = UpsertCategoryCacheHandler.key
                  ..updateCacheHandlerContext = {
                    'upsertData': GUpsertCategoryInputDto(
                      (b) => b
                        ..id = widget.category?.id
                        ..imgUrl = imageUrl
                        ..name = formValue['name'],
                    ),
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
                  DialogUtils.showError(context: context, response: response);
                }
              } else {
                if (mounted) {
                  showSuccessToast(
                    context,
                    isCreateNew
                        ? i18n.toast_Subtitle_CreateCategory
                        : i18n.toast_Subtitle_UpdateCategory,
                  );
                  context.popRoute(response);
                }
              }
            },
          );
        },
      );
    } else {
      if (mounted) {
        showWarningToast(
          context,
          i18n.toast_Subtitle_InvalidInformation,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    return LoadingOverlay(
      loading: loading,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: RightSheetAppBar(
          title: Text(
            isCreateNew
                ? i18n.upsertCategory_CreateNewTitle
                : i18n.upsertCategory_UpdateTitle,
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
                    if (!isCreateNew) ...[
                      Label(i18n.upsertCategory_CategoryID),
                      FormBuilderTextField(
                        name: 'id',
                        enabled: false,
                        readOnly: true,
                        initialValue: widget.category?.id,
                      ),
                    ],
                    Label(i18n.upsertCategory_CategoryName),
                    FormBuilderTextField(
                      name: 'name',
                      initialValue: widget.category?.name,
                      decoration: InputDecoration(
                        hintText: i18n.upsertCategory_NameHint,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.upsertCategory_NameIsRequired,
                      ),
                    ),
                    Label(i18n.upsertCategory_CategoryImage),
                    FormBuilderField<String>(
                      name: 'imgUrl',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.upsertCategory_ImageIsRequired,
                      ),
                      initialValue: widget.category?.imgUrl,
                      builder: (field) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            constraints: const BoxConstraints(minHeight: 48),
                            errorText: field.errorText,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          child: GestureDetector(
                            child: Text(
                              !isCreateNew && image == null
                                  ? widget.category!.imgUrl!
                                  : image != null
                                      ? image!.name
                                      : i18n.upsertCategory_ImageHint,
                              style: TextStyle(
                                color: image != null || !isCreateNew
                                    ? AppColors.grey1
                                    : AppColors.grey4,
                              ),
                            ),
                            onTap: () async {
                              final pickedFile = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );
                              if (pickedFile != null) {
                                setState(
                                  () {
                                    image = pickedFile;
                                    field.didChange(image!.name);
                                  },
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    if (image != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: !kIsWeb
                            ? Image.file(
                                File(image!.path),
                                fit: BoxFit.fitWidth,
                              )
                            : FutureBuilder(
                                future: image!.readAsBytes(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    final bytes = snapshot.data;
                                    return Image.memory(bytes!);
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                      ),
                    if (!isCreateNew && image == null)
                      ShimmerImage(
                        imageUrl: widget.category!.imgUrl!,
                        borderRadius: BorderRadius.circular(8),
                      )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isCreateNew ? handleReset : handleCancel,
                      child: Text(
                        isCreateNew ? i18n.button_Reset : i18n.button_Cancel,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: handleSubmit,
                      child: Text(
                        isCreateNew ? i18n.button_Confirm : i18n.button_Save,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
