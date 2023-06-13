import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:web_admin_fitness/global/graphql/__generated__/schema.schema.gql.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/exercise_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/mutation/__generated__/mutation_upsert_exercise.req.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_program.req.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/loading_overlay.dart';
import 'package:web_admin_fitness/global/widgets/pick_image_field.dart';
import 'package:web_admin_fitness/global/widgets/selected_image.dart';

import '../../../../../../global/gen/i18n.dart';
import '../../../../../../global/graphql/cache_handler/upsert_exercise_cache_handler.dart';
import '../../../../../../global/graphql/fragment/__generated__/program_fragment.data.gql.dart';
import '../../../../../../global/themes/app_colors.dart';
import '../../../../../../global/utils/dialogs.dart';
import '../../../../../../global/utils/duration_time.dart';
import '../../../../../../global/utils/file_helper.dart';
import '../../../../../../global/widgets/dialogs/confirmation_dialog.dart';
import '../../../../../../global/widgets/label.dart';
import '../../../../../../global/widgets/right_sheet_appbar.dart';
import '../../../../../../global/widgets/shimmer_image.dart';
import '../../../../../../global/widgets/toast/multi_toast.dart';
import '../../../../../../global/widgets/upsert_form_button.dart';
import 'widgets/exercise_video.dart';
import 'widgets/program_selector.dart';

class ExerciseUpsertPage extends StatefulWidget {
  const ExerciseUpsertPage({
    super.key,
    this.exercise,
    this.initialProgramId,
  });

  final GExercise? exercise;
  final String? initialProgramId;

  @override
  State<ExerciseUpsertPage> createState() => _ExerciseUpsertPageState();
}

class _ExerciseUpsertPageState extends State<ExerciseUpsertPage>
    with ClientMixin {
  var formKey = GlobalKey<FormBuilderState>();
  bool loading = true;
  XFile? image;
  XFile? video;
  late final isCreateNew = widget.exercise == null;
  VideoPlayerController? controller;
  GProgram? initialProgram;
  var key = GlobalKey();

  @override
  void initState() {
    initData();

    super.initState();
  }

  initData() async {
    if (!isCreateNew || widget.initialProgramId != null) {
      try {
        getProgram();
        if (mounted) {
          setState(
            () {
              Uri initialUri = Uri.parse(widget.exercise!.videoUrl!);
              Uri replaceUri = initialUri.replace(scheme: 'https');
              controller = VideoPlayerController.network(replaceUri.toString());
            },
          );
        }
        await controller!.initialize();
      } catch (e) {
        if (mounted) {
          setState(() => loading = false);
        }
      }
    }
    if (mounted) {
      setState(() => loading = false);
    }
  }

  void getProgram() async {
    final request = GGetProgramReq(
      (b) => b
        ..vars.programId =
            widget.initialProgramId ?? widget.exercise!.programId,
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
      if (mounted) {
        setState(() {
          initialProgram = response.data!.getProgram;
        });
        print(initialProgram);
      }
    }
  }

  void handleReset() {
    setState(() {
      formKey = GlobalKey<FormBuilderState>();
      image = null;
      controller = null;
    });
  }

  void setDuration() {
    formKey.currentState?.fields['duration']?.didChange(
      DurationTime.totalDurationFormat(
        controller!.value.duration,
      ),
    );
  }

  Future<GUpsertExerciseInputDto> getInput() async {
    final formValue = formKey.currentState!.value;
    String? imageUrl;
    String? videoUrl;

    if (image != null) {
      imageUrl = await FileHelper.uploadImage(image!, 'exercise');
    } else {
      imageUrl = widget.exercise?.imgUrl;
    }

    if (video != null) {
      videoUrl = await FileHelper.uploadVideo(video!, 'exercise');
    } else {
      videoUrl = widget.exercise?.videoUrl;
    }
    print(formValue['programId']);
    return GUpsertExerciseInputDto(
      (b) => b
        ..name = formValue['name']
        ..id = widget.exercise?.id
        ..imgUrl = imageUrl
        ..duration = controller!.value.duration.inSeconds.toDouble()
        ..calo = double.parse(formValue['calo'])
        ..videoUrl = videoUrl
        ..programId = formValue['programId'] ?? initialProgram?.id,
    );
  }

  void onPickVideo() async {
    if (controller != null) {
      await controller!.pause();
      await controller!.seekTo(Duration.zero);
    }

    final pickedFile = await FileHelper.pickVideo();

    if (pickedFile != null) {
      if (controller != null) {
        await controller!.dispose();
      }
      setState(() => video = pickedFile);
      formKey.currentState?.fields['videoUrl']?.didChange(video!.name);

      if (kIsWeb) {
        setState(
          () => controller = VideoPlayerController.network(video!.path),
        );
      } else {
        setState(
          () => controller = VideoPlayerController.file(File(video!.path)),
        );
      }

      await controller!.initialize();
      setDuration();
      key = GlobalKey();
    }
  }

  void onPickImage() async {
    final pickedFile = await FileHelper.pickImage();

    if (pickedFile != null) {
      setState(() => image = pickedFile);
      formKey.currentState?.fields['imgUrl']?.didChange(image!.name);
    }
  }

  void handleSubmit() {
    final i18n = I18n.of(context)!;

    if (formKey.currentState!.saveAndValidate()) {
      showAlertDialog(
        context: context,
        builder: (dialogContext, child) {
          return ConfirmationDialog(
            titleText: isCreateNew
                ? i18n.upsertExercise_CreateNewTitle
                : i18n.upsertExercise_UpdateTitle,
            contentText: isCreateNew
                ? i18n.upsertExercise_CreateNewDes
                : i18n.upsertExercise_UpdateDes,
            onTapPositiveButton: () async {
              dialogContext.popRoute(true);
              setState(() => loading = true);
              final upsertData = await getInput();

              final request = GUpsertExerciseReq(
                (b) => b
                  ..vars.input.replace(upsertData)
                  ..updateCacheHandlerKey = UpsertExerciseCacheHandler.key
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
                        ? i18n.toast_Subtitle_CreateExercise
                        : i18n.toast_Subtitle_UpdateExercise,
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
  void dispose() {
    if (controller != null) {
      controller!.dispose();
    }
    super.dispose();
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
                ? i18n.upsertExercise_CreateNewTitle
                : i18n.upsertExercise_ExerciseDetail,
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
                      Label(i18n.upsertExercise_ID),
                      FormBuilderTextField(
                        name: 'id',
                        enabled: false,
                        readOnly: true,
                        initialValue: widget.exercise?.id,
                      ),
                    ],
                    Label(i18n.upsertExercise_Name),
                    FormBuilderTextField(
                      name: 'name',
                      initialValue: widget.exercise?.name,
                      decoration: InputDecoration(
                        hintText: i18n.upsertExercise_NameHint,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.upsertExercise_NameIsRequired,
                      ),
                    ),
                    Label(i18n.upsertExercise_Calo),
                    FormBuilderTextField(
                      name: 'calo',
                      initialValue: widget.exercise?.calo.toString(),
                      decoration: InputDecoration(
                        hintText: i18n.upsertExercise_CaloHint,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.upsertExercise_CaloRequired,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    Label(i18n.upsertExercise_Program),
                    FormBuilderField<String>(
                      name: 'programId',
                      initialValue: isCreateNew
                          ? null
                          : (widget.initialProgramId ?? initialProgram!.id),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.upsertExercise_ProgramRequired,
                      ),
                      builder: (field) {
                        return ProgramSelector(
                          initial:
                              isCreateNew && widget.initialProgramId == null
                                  ? const []
                                  : [initialProgram!],
                          errorText: field.errorText,
                          onChanged: (option) {
                            field.didChange(option.first.key);
                          },
                        );
                      },
                    ),
                    Label(i18n.upsertExercise_Image),
                    FormBuilderField<String>(
                      name: 'imgUrl',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.upsertExercise_ImageIsRequired,
                      ),
                      initialValue: widget.exercise?.imgUrl,
                      builder: (field) {
                        return PickImageField(
                          errorText: field.errorText,
                          onPickImage: onPickImage,
                          fieldValue: !isCreateNew && image == null
                              ? widget.exercise?.imgUrl ?? ''
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
                        imageUrl: widget.exercise!.imgUrl!,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ],
                    Label(i18n.upsertExercise_Video),
                    FormBuilderField<String>(
                      name: 'videoUrl',
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.upsertExercise_VideoIsRequired,
                      ),
                      initialValue: widget.exercise?.videoUrl,
                      builder: (field) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            constraints: const BoxConstraints(minHeight: 48),
                            errorText: field.errorText,
                            contentPadding: const EdgeInsets.all(16),
                          ),
                          child: GestureDetector(
                            onTap: onPickVideo,
                            child: Text(
                              !isCreateNew && video == null
                                  ? widget.exercise!.videoUrl!
                                  : video != null
                                      ? video!.name
                                      : i18n.upsertExercise_VideoHint,
                              style: TextStyle(
                                color: video != null || !isCreateNew
                                    ? AppColors.grey1
                                    : AppColors.grey4,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    if ((video != null || !isCreateNew && video == null) &&
                        controller != null) ...[
                      ExerciseVideo(key: key, controller: controller!)
                    ],
                    Label(i18n.upsertExercise_Duration),
                    FormBuilderTextField(
                      name: 'duration',
                      readOnly: true,
                      initialValue: widget.exercise?.duration != null
                          ? DurationTime.totalDurationFormat(Duration(
                              seconds: widget.exercise!.duration!.toInt()))
                          : null,
                      decoration: InputDecoration(
                        hintText: i18n.upsertExercise_DurationHint,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.upsertExercise_DurationRequired,
                      ),
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
