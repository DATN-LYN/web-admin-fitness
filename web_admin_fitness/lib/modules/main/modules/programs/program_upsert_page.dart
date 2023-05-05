import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_selector/adaptive_selector.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web_admin_fitness/global/enums/workout_body_part.dart';
import 'package:web_admin_fitness/global/enums/workout_level.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';
import 'package:web_admin_fitness/global/graphql/cache_handler/upsert_program_cache_handler.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/category_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/program_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_program.req.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_category.req.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/utils/dialogs.dart';
import 'package:web_admin_fitness/global/widgets/loading_overlay.dart';
import 'package:web_admin_fitness/modules/main/modules/selectors/category_selector.dart';

import '../../../../global/gen/i18n.dart';
import '../../../../global/themes/app_colors.dart';
import '../../../../global/utils/file_helper.dart';
import '../../../../global/widgets/dialogs/confirmation_dialog.dart';
import '../../../../global/widgets/label.dart';
import '../../../../global/widgets/right_sheet_appbar.dart';
import '../../../../global/widgets/shimmer_image.dart';
import '../../../../global/widgets/toast/multi_toast.dart';

class ProgramUpsertPage extends StatefulWidget {
  const ProgramUpsertPage({
    super.key,
    this.program,
  });

  final GProgram? program;

  @override
  State<ProgramUpsertPage> createState() => _ProgramUpsertPageState();
}

class _ProgramUpsertPageState extends State<ProgramUpsertPage>
    with ClientMixin {
  var formKey = GlobalKey<FormBuilderState>();
  bool loading = true;
  late final isCreateNew = widget.program == null;
  XFile? image;
  GCategory? initalCategory;

  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() async {
    if (!isCreateNew) {
      await Future.wait([
        getCategory(),
      ]);
    }
    setState(() => loading = false);
  }

  Future getCategory() async {
    final request = GGetCategoryReq(
      (b) => b..vars.categoryId = widget.program!.categoryId,
    );
    final response = await client.request(request).first;
    if (response.hasErrors) {
      if (mounted) {
        showErrorToast(
          context,
          response.graphqlErrors?.first.message,
        );
      }
    } else {
      setState(() {
        initalCategory = response.data!.getCategory;
      });
    }
  }

  void handleReset() {
    setState(() {
      formKey = GlobalKey<FormBuilderState>();
      image = null;
    });
  }

  void handleCancel() {
    context.popRoute();
  }

  Future<GUpsertProgramInputDto> getInput() async {
    final formValue = formKey.currentState!.value;
    String? imageUrl = '';

    if (image != null) {
      imageUrl = await FileHelper.uploadImage(image!);
    } else {
      imageUrl = widget.program?.imgUrl;
    }

    return GUpsertProgramInputDto(
      (b) => b
        ..id = widget.program?.id
        ..name = formValue['name']
        ..imgUrl = imageUrl
        ..bodyPart = formValue['bodyPart']
        ..calo = isCreateNew ? 0 : widget.program!.calo
        ..description = formValue['description']
        ..duration = isCreateNew ? 0 : widget.program!.calo
        ..level = formValue['level']
        ..categoryId = formValue['categoryId'],
    );
  }

  void handleSubmit() {
    final i18n = I18n.of(context)!;

    if (formKey.currentState!.saveAndValidate()) {
      showAlertDialog(
        context: context,
        builder: (dialogContext, child) {
          return ConfirmationDialog(
            titleText: isCreateNew
                ? i18n.upsertProgram_CreateNewTitle
                : i18n.upsertProgram_UpdateTitle,
            contentText: isCreateNew
                ? i18n.upsertProgram_CreateNewDes
                : i18n.upsertProgram_UpdateDes,
            onTapPositiveButton: () async {
              dialogContext.popRoute(true);
              setState(() => loading = true);
              final upsertData = await getInput();

              final request = GUpsertProgramReq(
                (b) => b
                  ..vars.input.replace(upsertData)
                  ..updateCacheHandlerKey = UpsertProgramCacheHandler.key
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
                  DialogUtils.showError(context: context, response: response);
                }
              } else {
                if (mounted) {
                  showSuccessToast(
                    context,
                    isCreateNew
                        ? i18n.toast_Subtitle_CreateProgram
                        : i18n.toast_Subtitle_UpdateProgram,
                  );
                  context.popRoute(response);
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
    final theme = Theme.of(context);

    return LoadingOverlay(
      loading: loading,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: RightSheetAppBar(
          title: Text(
            isCreateNew
                ? i18n.upsertProgram_CreateNewTitle
                : i18n.upsertProgram_UpdateTitle,
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
                      Label(i18n.upsertProgram_ID),
                      FormBuilderTextField(
                        name: 'id',
                        enabled: false,
                        readOnly: true,
                        initialValue: widget.program?.id,
                      ),
                    ],
                    Label(i18n.upsertProgram_Name),
                    FormBuilderTextField(
                      name: 'name',
                      initialValue: widget.program?.name,
                      decoration: InputDecoration(
                        hintText: i18n.upsertProgram_NameHint,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.upsertProgram_NameIsRequired,
                      ),
                    ),
                    Label(i18n.upsertProgram_Image),
                    FormBuilderField<String>(
                      name: 'imgUrl',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.upsertProgram_ImageIsRequired,
                      ),
                      initialValue: widget.program?.imgUrl,
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
                                  ? widget.program!.imgUrl!
                                  : image != null
                                      ? image!.name
                                      : i18n.upsertProgram_ImageHint,
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
                                  },
                                );
                                field.didChange(image!.name);
                              }
                            },
                          ),
                        );
                      },
                    ),
                    if (image != null) ...[
                      const SizedBox(height: 12),
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
                    ],
                    if (!isCreateNew && image == null) ...[
                      const SizedBox(height: 12),
                      ShimmerImage(
                        imageUrl: widget.program!.imgUrl!,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ],
                    Label(i18n.upsertProgram_Level),
                    FormBuilderField<double>(
                      name: 'level',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.upsertProgram_LevelRequired,
                      ),
                      initialValue: widget.program?.level,
                      builder: (field) {
                        late WorkoutLevel initialData;
                        final options = WorkoutLevel.values
                            .map(
                              (e) => AdaptiveSelectorOption(
                                  label: e.label(i18n), value: e.value),
                            )
                            .toList();
                        if (!isCreateNew) {
                          initialData =
                              WorkoutLevel.getLevel(widget.program!.level!);
                        }
                        return AdaptiveSelector(
                          options: options,
                          type: kIsWeb
                              ? SelectorType.menu
                              : SelectorType.bottomSheet,
                          initialOption: !isCreateNew
                              ? AdaptiveSelectorOption(
                                  label: initialData.label(i18n),
                                  value: initialData.value,
                                )
                              : options.first,
                          allowClear: false,
                          onChanged: (selectedItem) {
                            if (selectedItem != null) {
                              field.didChange(selectedItem.value);
                            }
                          },
                        );
                      },
                    ),
                    Label(i18n.upsertProgram_BodyPart),
                    FormBuilderField<double>(
                      name: 'bodyPart',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.upsertProgram_BodyPartRequired,
                      ),
                      initialValue: widget.program?.bodyPart,
                      builder: (field) {
                        late WorkoutBodyPart initialData;

                        final options = WorkoutBodyPart.values
                            .map(
                              (e) => AdaptiveSelectorOption(
                                  label: e.label(i18n), value: e.value),
                            )
                            .toList();
                        if (!isCreateNew) {
                          initialData = WorkoutBodyPart.getBodyPart(
                              widget.program!.bodyPart!);
                        }
                        return AdaptiveSelector(
                          options: options,
                          type: kIsWeb
                              ? SelectorType.menu
                              : SelectorType.bottomSheet,
                          initialOption: !isCreateNew
                              ? AdaptiveSelectorOption(
                                  label: initialData.label(i18n),
                                  value: initialData.value,
                                )
                              : options.first,
                          allowClear: false,
                          onChanged: (selectedItem) {
                            if (selectedItem != null) {
                              field.didChange(selectedItem.value);
                            }
                          },
                        );
                      },
                    ),
                    Label(i18n.upsertProgram_Category),
                    FormBuilderField<String>(
                      name: 'categoryId',
                      initialValue: isCreateNew ? null : initalCategory!.id,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.upsertProgram_CategoryRequired,
                      ),
                      builder: (field) {
                        return CategorySelector(
                          initial: isCreateNew ? const [] : [initalCategory!],
                          hintText: i18n.upsertProgram_CategoryHint,
                          errorText: field.errorText,
                          onChanged: (option) {
                            field.didChange(option.first.key);
                          },
                        );
                      },
                    ),
                    Label(i18n.upsertProgram_Description),
                    FormBuilderTextField(
                      name: 'description',
                      initialValue: widget.program?.description,
                      decoration: InputDecoration(
                        hintText: i18n.upsertProgram_DescriptionHint,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.upsertProgram_DescriptionRequired,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 26),
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
