import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_wrapper.dart';

class CategoriesListView extends StatelessWidget {
  const CategoriesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return const ShimmerWrapper(
          child: Text('asjdajsdad'),
        );
      },
    );
  }
}
