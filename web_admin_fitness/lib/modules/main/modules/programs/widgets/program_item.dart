import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/enums/workout_body_part.dart';
import 'package:web_admin_fitness/global/enums/workout_level.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/program_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/widgets/label_text_row.dart';
import 'package:web_admin_fitness/global/widgets/shadow_wrapper.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';
import 'package:web_admin_fitness/global/widgets/slidable_wrapper.dart';
import 'package:web_admin_fitness/global/widgets/tag.dart';

class ProgramItem extends StatelessWidget {
  const ProgramItem({
    super.key,
    required this.program,
    this.handleDelete,
    this.handleEdit,
  });

  final GProgram program;
  final VoidCallback? handleDelete;
  final VoidCallback? handleEdit;

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    final level = WorkoutLevel.getLevel(program.level ?? 0);
    final bodyPart = WorkoutBodyPart.getBodyPart(program.bodyPart ?? 0);

    return SlidableWrapper(
      handleDelete: handleDelete,
      handleEdit: handleEdit,
      child: GestureDetector(
        onTap: handleEdit,
        child: ShadowWrapper(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Tag(
                    text: level.label(i18n),
                    color: level.color(),
                  ),
                  Text(
                    bodyPart.label(i18n),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: [
                  ShimmerImage(
                    imageUrl: program.imgUrl ?? '_',
                    width: 100,
                    height: 100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      children: [
                        LabelTextRow(
                          label: i18n.common_Name,
                          value: program.name,
                        ),
                        const SizedBox(height: 6),
                        // LabelTextRow(
                        //   label: i18n.common_Calo,
                        //   value: program.calo.toString(),
                        // ),
                        // const SizedBox(height: 6),
                        // LabelTextRow(
                        //   label: i18n.common_Duration,
                        //   value: program.duration.toString(),
                        // ),
                        const SizedBox(height: 6),
                        LabelTextRow(
                          label: i18n.common_Id,
                          value: program.id,
                        ),
                      ],
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
