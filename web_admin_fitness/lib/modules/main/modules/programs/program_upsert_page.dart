import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:adaptive_selector/adaptive_selector.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web_admin_fitness/global/extensions/body_part_extension.dart';
import 'package:web_admin_fitness/global/extensions/workout_level_extension.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';
import 'package:web_admin_fitness/global/graphql/cache_handler/upsert_program_cache_handler.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/category_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/program_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_program.req.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_category.req.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/utils/dialogs.dart';
import 'package:web_admin_fitness/global/widgets/loading_overlay.dart';
import 'package:web_admin_fitness/global/widgets/selected_image.dart';
import 'package:web_admin_fitness/global/widgets/upsert_form_button.dart';
import 'package:web_admin_fitness/modules/main/modules/programs/widgets/exercise_list_dialog.dart';

import '../../../../../../global/gen/i18n.dart';
import '../../../../../../global/themes/app_colors.dart';
import '../../../../../../global/utils/file_helper.dart';
import '../../../../../../global/widgets/dialogs/confirmation_dialog.dart';
import '../../../../../../global/widgets/label.dart';
import '../../../../../../global/widgets/pick_image_field.dart';
import '../../../../../../global/widgets/right_sheet_appbar.dart';
import '../../../../../../global/widgets/shimmer_image.dart';
import '../../../../../../global/widgets/toast/multi_toast.dart';
import 'widgets/category_selector.dart';

class ProgramUpsertPage extends StatefulWidget {
  const ProgramUpsertPage({
    super.key,
    this.program,
    this.initialCategoryId,
  });

  final GProgram? program;
  final String? initialCategoryId;

  @override
  State<ProgramUpsertPage> createState() => _ProgramUpsertPageState();
}

class _ProgramUpsertPageState extends State<ProgramUpsertPage>
    with ClientMixin {
  var formKey = GlobalKey<FormBuilderState>();
  bool loading = false;
  bool initLoading = true;

  late final isCreateNew = widget.program == null;
  XFile? image;
  GCategory? initialCategory;

  @override
  void initState() {
    initData();
    super.initState();
  }

  initData() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isCreateNew || widget.initialCategoryId != null) {
        getCategory();
      }
    });
  }

  void getCategory() async {
    if (!isCreateNew || widget.initialCategoryId != null) {
      final request = GGetCategoryReq(
        (b) => b
          ..vars.categoryId =
              widget.initialCategoryId ?? widget.program!.categoryId,
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
        initialCategory = response.data!.getCategory;
      }
    }
    if (mounted) {
      setState(() {
        initLoading = false;
        formKey = GlobalKey<FormBuilderState>();
      });
    }
  }

  void handleReset() {
    setState(() {
      formKey = GlobalKey<FormBuilderState>();
      image = null;
    });
  }

  void onPickImage() async {
    final pickedFile = await FileHelper.pickImage();

    if (pickedFile != null) {
      setState(() => image = pickedFile);
      formKey.currentState?.fields['imgUrl']?.didChange(image!.name);
    }
  }

  Future<GUpsertProgramInputDto> getInput() async {
    final formValue = formKey.currentState!.value;
    String? imageUrl = '';

    if (image != null) {
      imageUrl = await FileHelper.uploadImage(image!, 'program');
    } else {
      imageUrl = widget.program?.imgUrl;
    }

    return GUpsertProgramInputDto(
      (b) => b
        ..id = widget.program?.id
        ..name = formValue['name']
        ..imgUrl = imageUrl
        ..bodyPart = formValue['bodyPart']
        ..description = formValue['description'] ?? widget.program?.description
        ..level = formValue['level']
        ..categoryId = formValue['categoryId'] ?? widget.program?.categoryId
        ..view = widget.program?.view ?? 0,
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
    } else {
      showWarningToast(context, i18n.toast_Subtitle_InvalidInformation);
    }
  }

  void showDialogExerciseList() {
    showDialog(
      context: context,
      builder: (context) {
        return ExerciseListDialog(programId: widget.program!.id!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    final theme = Theme.of(context);
    final responsive = ResponsiveWrapper.of(context);
    final isDesktopView = responsive.isLargerThan(MOBILE);

    return LoadingOverlay(
      loading: loading,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: RightSheetAppBar(
          title: Text(
            isCreateNew
                ? i18n.upsertProgram_CreateNewTitle
                : i18n.upsertProgram_ProgramDetail,
          ),
        ),
        body: initLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                          if (!isCreateNew)
                            OutlinedButton(
                              onPressed: showDialogExerciseList,
                              child: Text(i18n.upsertProgram_ViewExercises),
                            ),
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.required(
                              errorText: i18n.upsertProgram_NameIsRequired,
                            ),
                          ),
                          Label(i18n.upsertProgram_Image),
                          FormBuilderField<String>(
                            name: 'imgUrl',
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.required(
                              errorText: i18n.upsertProgram_ImageIsRequired,
                            ),
                            initialValue: widget.program?.imgUrl,
                            builder: (field) {
                              return PickImageField(
                                errorText: field.errorText,
                                onPickImage: onPickImage,
                                fieldValue: !isCreateNew && image == null
                                    ? widget.program?.imgUrl ?? ''
                                    : image != null
                                        ? image!.name
                                        : i18n.upsertExercise_ImageHint,
                                textColor: image != null || !isCreateNew
                                    ? AppColors.grey1
                                    : AppColors.grey4,
                              );
                            },
                          ),
                          if (image != null) ...[
                            const SizedBox(height: 12),
                            SelectedImage(image: image!),
                          ],
                          if (!isCreateNew && image == null) ...[
                            const SizedBox(height: 12),
                            ShimmerImage(
                              imageUrl: widget.program!.imgUrl!,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ],
                          Label(i18n.upsertProgram_Level),
                          FormBuilderField<GWORKOUT_LEVEL>(
                            name: 'level',
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.required(
                              errorText: i18n.upsertProgram_LevelRequired,
                            ),
                            initialValue: widget.program?.level ??
                                GWORKOUT_LEVEL.Beginner,
                            builder: (field) {
                              late GWORKOUT_LEVEL initialData;
                              final options = GWORKOUT_LEVEL.values
                                  .map(
                                    (e) => AdaptiveSelectorOption(
                                        label: e.label(i18n), value: e),
                                  )
                                  .toList();
                              if (!isCreateNew) {
                                initialData = widget.program!.level!;
                              }
                              return AdaptiveSelector(
                                options: options,
                                type: isDesktopView
                                    ? SelectorType.menu
                                    : SelectorType.bottomSheet,
                                initialOption: !isCreateNew
                                    ? AdaptiveSelectorOption(
                                        label: initialData.label(i18n),
                                        value: initialData,
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
                          FormBuilderField<GBODY_PART>(
                            name: 'bodyPart',
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.required(
                              errorText: i18n.upsertProgram_BodyPartRequired,
                            ),
                            initialValue:
                                widget.program?.bodyPart ?? GBODY_PART.Upper,
                            builder: (field) {
                              late GBODY_PART initialData;

                              final options = GBODY_PART.values
                                  .map(
                                    (e) => AdaptiveSelectorOption(
                                        label: e.label(i18n), value: e),
                                  )
                                  .toList();
                              if (!isCreateNew) {
                                initialData = widget.program!.bodyPart!;
                              }
                              return AdaptiveSelector(
                                options: options,
                                type: isDesktopView
                                    ? SelectorType.menu
                                    : SelectorType.bottomSheet,
                                initialOption: !isCreateNew
                                    ? AdaptiveSelectorOption(
                                        label: initialData.label(i18n),
                                        value: initialData,
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
                            initialValue:
                                widget.initialCategoryId ?? initialCategory?.id,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.required(
                              errorText: i18n.upsertProgram_CategoryRequired,
                            ),
                            builder: (field) {
                              return CategorySelector(
                                initial: isCreateNew &&
                                        widget.initialCategoryId == null
                                    ? const []
                                    : [initialCategory!],
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: FormBuilderValidators.required(
                              errorText: i18n.upsertProgram_DescriptionRequired,
                            ),
                            maxLines: 7,
                            maxLength: 255,
                          ),
                        ],
                      ),
                    ),
                  ),
                  UpsertFormButton(
                    onPressPositiveButton: handleSubmit,
                    onPressNegativeButton: handleReset,
                    positiveButtonText:
                        isCreateNew ? i18n.button_Confirm : i18n.button_Save,
                    negativeButtonText: i18n.button_Reset,
                  ),
                ],
              ),
      ),
    );
  }
}
