import 'package:flutter/material.dart';
import 'package:web_admin_fitness/modules/main/modules/categories/widgets/categories_overview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [CategoriesOverview()],
    );
  }
}
