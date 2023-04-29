import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/category_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';
import 'package:web_admin_fitness/global/widgets/shadow_wrapper.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';

class CategoryItem extends StatefulWidget {
  const CategoryItem({
    super.key,
    required this.category,
  });

  final GCategory category;

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  @override
  Widget build(BuildContext context) {
    var category = widget.category;
    return ShadowWrapper(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerImage(
            imageUrl: category.imgUrl ?? '',
            width: double.infinity,
            height: 150,
            fit: BoxFit.fill,
            borderRadius: BorderRadius.circular(12),
          ),
          const SizedBox(height: 16),
          Text.rich(
            WidgetSpan(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.label,
                    size: 12,
                    color: AppColors.primaryBold,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'ID: ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Expanded(
                    child: Text(
                      category.id ?? '_',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text.rich(
            WidgetSpan(
              child: Row(
                children: [
                  const Icon(
                    Icons.text_snippet_rounded,
                    size: 12,
                    color: AppColors.primaryBold,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Name: ',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(category.name ?? '_'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
