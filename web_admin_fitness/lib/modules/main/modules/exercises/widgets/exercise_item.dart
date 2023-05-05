import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/exercise_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/routers/app_router.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';
import 'package:web_admin_fitness/global/widgets/label_text_row.dart';
import 'package:web_admin_fitness/global/widgets/shadow_wrapper.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';

class ExerciseItem extends StatelessWidget {
  const ExerciseItem({super.key, required this.exercise});

  final GExercise exercise;

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    return GestureDetector(
      onTap: () {
        context.pushRoute(ExerciseUpsertRoute(exercise: exercise));
      },
      child: ShadowWrapper(
        margin: EdgeInsets.zero,
        child: Row(
          children: [
            ShimmerImage(
              imageUrl: exercise.imgUrl ?? '_',
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
                    value: exercise.duration.toString(),
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
    );
  }
}
