import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:web_admin_fitness/modules/main/modules/categories/widgets/categories_list_view.dart';

import '../../../../../../../global/extensions/responsive_wrapper.dart';
import '../../../../global/gen/i18n.dart';
import '../../../../global/widgets/responsive/responsive_page_builder.dart';
import 'widgets/categories_overview.dart';

class CategoriesManagerPage extends StatefulWidget {
  const CategoriesManagerPage({super.key});

  @override
  State<CategoriesManagerPage> createState() => _CategoriesManagerPageState();
}

class _CategoriesManagerPageState extends State<CategoriesManagerPage> {
  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveWrapper.of(context);
    final isDesktopView = responsive.isLargerThan(MOBILE);
    final i18n = I18n.of(context)!;
    return ResponsivePageBuilder(
      header: Padding(
        padding: EdgeInsets.all(responsive.adap(16.0, 24.0)),
        child: Column(
          children: [
            const CategoriesOverview(),
            SizedBox(height: responsive.adap(32.0, 24.0)),
          ],
        ),
      ),
      listView: const CategoriesListView(),
      tableView: null,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Categories'),
        ),
        body: ListView(
          children: const [CategoriesOverview()],
        ),
      ),
    );
  }
}
