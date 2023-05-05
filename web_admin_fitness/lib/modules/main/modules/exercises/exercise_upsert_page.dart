import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/exercise_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/loading_overlay.dart';

import '../../../../global/gen/i18n.dart';
import '../../../../global/themes/app_colors.dart';
import '../../../../global/widgets/label.dart';
import '../../../../global/widgets/right_sheet_appbar.dart';
import '../../../../global/widgets/shimmer_image.dart';

class ExerciseUpsertPage extends StatefulWidget {
  const ExerciseUpsertPage({
    super.key,
    @queryParam this.exercise,
  });

  final GExercise? exercise;

  @override
  State<ExerciseUpsertPage> createState() => _ExerciseUpsertPageState();
}

class _ExerciseUpsertPageState extends State<ExerciseUpsertPage>
    with ClientMixin {
  var formKey = GlobalKey<FormBuilderState>();
  bool loading = false;
  XFile? image;
  XFile? video;

  late final isCreateNew = widget.exercise == null;
  late VideoPlayerController _controller;

  void handleReset() {
    setState(() {
      formKey = GlobalKey<FormBuilderState>();
      image = null;
    });
  }

  void handleCancel() {
    context.popRoute();
  }

  void handleSubmit() {}

  @override
  void dispose() {
    _controller.dispose();
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
                        initialValue: widget.exercise?.id,
                      ),
                      Label(i18n.upsertCategory_CategoryName),
                      FormBuilderTextField(
                        name: 'name',
                        initialValue: widget.exercise?.name,
                        decoration: InputDecoration(
                          hintText: i18n.upsertCategory_NameHint,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.required(
                          errorText: i18n.upsertCategory_NameIsRequired,
                        ),
                      ),
                      Label(i18n.upsertCategory_CategoryName),
                      FormBuilderTextField(
                        name: 'calo',
                        initialValue: widget.exercise?.name,
                        decoration: InputDecoration(
                          hintText: i18n.upsertCategory_NameHint,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.required(
                          errorText: i18n.upsertCategory_NameIsRequired,
                        ),
                      ),
                      Label(i18n.upsertCategory_CategoryName),
                      FormBuilderField<String>(
                        name: 'imgUrl',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.required(
                          errorText: i18n.upsertCategory_ImageIsRequired,
                        ),
                        initialValue: widget.exercise?.imgUrl,
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
                                    ? widget.exercise!.imgUrl!
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
                                final pickedFile =
                                    await ImagePicker().pickImage(
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
                          imageUrl: widget.exercise!.imgUrl!,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ],
                      Label(i18n.upsertCategory_CategoryName),
                      FormBuilderField<String>(
                        name: 'videoUrl',
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: FormBuilderValidators.required(
                          errorText: i18n.upsertCategory_ImageIsRequired,
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
                              child: Text(
                                !isCreateNew && video == null
                                    ? widget.exercise!.videoUrl!
                                    : video != null
                                        ? video!.name
                                        : i18n.upsertCategory_ImageHint,
                                style: TextStyle(
                                  color: video != null || !isCreateNew
                                      ? AppColors.grey1
                                      : AppColors.grey4,
                                ),
                              ),
                              onTap: () async {
                                final pickedFile =
                                    await ImagePicker().pickVideo(
                                  source: ImageSource.gallery,
                                );
                                if (pickedFile != null) {
                                  setState(
                                    () {
                                      video = pickedFile;
                                      field.didChange(video!.name);
                                      _controller = VideoPlayerController.file(
                                        File(video!.path),
                                      )..initialize();
                                      formKey.currentState?.fields['duration']
                                          ?.didChange(
                                        _controller.value.duration.inMinutes
                                            .toString(),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          );
                        },
                      ),
                      if (video != null)
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: VideoPlayer(_controller),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                });
                              },
                              icon: _controller.value.isPlaying
                                  ? const Icon(Icons.pause)
                                  : const Icon(Icons.play_arrow),
                            ),
                          ],
                        ),
                    ],
                    Label(i18n.upsertCategory_CategoryName),
                    FormBuilderTextField(
                      name: 'duration',
                      initialValue: widget.exercise?.duration.toString(),
                      decoration: InputDecoration(
                        hintText: i18n.upsertCategory_NameHint,
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: FormBuilderValidators.required(
                        errorText: i18n.upsertCategory_NameIsRequired,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
