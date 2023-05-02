import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/category_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/widgets/shadow_wrapper.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';

import '../../../../../global/widgets/label_text_row.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.category,
  });

  final GCategory category;

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    return ShadowWrapper(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 6),
      borderRadius: BorderRadius.circular(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ShimmerImage(
              imageUrl: category.imgUrl ?? '',
              width: double.infinity,
              height: 120,
              fit: BoxFit.fill,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 12),
          LabelTextRow(
            label: i18n.common_Id,
            value: category.id,
          ),
          const SizedBox(height: 8),
          LabelTextRow(
            label: i18n.common_Name,
            value: category.name,
          ),
        ],
      ),
    );
  }
}
