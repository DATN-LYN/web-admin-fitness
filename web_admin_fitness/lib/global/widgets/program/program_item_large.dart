import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:web_admin_fitness/global/extensions/body_part_extension.dart';
import 'package:web_admin_fitness/global/extensions/workout_level_extension.dart';
import 'package:web_admin_fitness/global/routers/app_router.dart';

import '../../gen/i18n.dart';
import '../../graphql/fragment/__generated__/program_fragment.data.gql.dart';
import '../shadow_wrapper.dart';
import '../shimmer_image.dart';
import '../tag.dart';

class ProgramItemLarge extends StatelessWidget {
  const ProgramItemLarge({
    super.key,
    required this.program,
  });

  final GProgram program;

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    return ShadowWrapper(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => context.pushRoute(
          ProgramUpsertRoute(program: program),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ShimmerImage(
              imageUrl: program.imgUrl ?? '',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(12),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    program.name ?? '_',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Tag(
                  text: program.level!.label(i18n),
                  color: program.level!.color(),
                )
              ],
            ),
            const SizedBox(height: 6),
            _infoTile(
              icon: Ionicons.body,
              label: '${i18n.programs_BodyPart}: ',
              value: program.bodyPart!.label(i18n),
            ),
            _infoTile(
              icon: Ionicons.document_text,
              label: '${i18n.programs_Description}: ',
              value: program.description ?? '_',
            ),
            _infoTile(
              icon: Ionicons.eye,
              label: 'View: ',
              value: '${program.view?.toInt() ?? 0}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
