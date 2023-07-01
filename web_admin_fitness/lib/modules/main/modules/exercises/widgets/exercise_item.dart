import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/exercise_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';
import 'package:web_admin_fitness/global/widgets/label_text_row.dart';
import 'package:web_admin_fitness/global/widgets/shadow_wrapper.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';
import 'package:web_admin_fitness/global/widgets/slidable_wrapper.dart';

import '../../../../../../../global/utils/duration_time.dart';

class ExerciseItem extends StatelessWidget {
  const ExerciseItem({
    super.key,
    required this.exercise,
    this.handleDelete,
    this.handleEdit,
  });

  final GExercise exercise;
  final VoidCallback? handleDelete;
  final VoidCallback? handleEdit;

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    return SlidableWrapper(
      handleDelete: handleDelete,
      handleEdit: handleEdit,
      child: GestureDetector(
        onTap: handleEdit,
        child: ShadowWrapper(
          margin: EdgeInsets.zero,
          child: Row(
            children: [
              ShimmerImage(
                imageUrl: exercise.imgUrl ?? '',
                height: 100,
                width: 100,
                borderRadius: BorderRadius.circular(8),
              ),
              Expanded(
                child: Column(
                  children: [
                    LabelTextRow(
                      label: i18n.common_Name,
                      value: exercise.name,
                    ),
                    const SizedBox(height: 6),
                    LabelTextRow(
                      label: i18n.common_Calo,
                      value: exercise.calo.toString(),
                    ),
                    const SizedBox(height: 6),
                    LabelTextRow(
                      label: i18n.common_Duration,
                      value: DurationTime.totalDurationFormat(
                        Duration(
                          seconds: exercise.duration!.toInt(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    LabelTextRow(
                      label: i18n.exercises_Program,
                      value: exercise.program?.name,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: AppColors.primarySoft,
                ),
                child: const Icon(Icons.play_arrow_rounded),
              )
            ],
          ),
        ),
      ),
    );
  }
}
