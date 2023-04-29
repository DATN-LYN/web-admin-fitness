import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_categories.req.gql.dart';
import 'package:web_admin_fitness/global/models/category_filter_data.dart';
import 'package:web_admin_fitness/global/widgets/search_bar.dart';
import 'package:web_admin_fitness/modules/main/modules/categories/widgets/categories_list_view.dart';
import 'package:web_admin_fitness/modules/main/modules/categories/widgets/categories_table_view.dart';

import '../../../../../../../global/extensions/responsive_wrapper.dart';
import '../../../../global/gen/i18n.dart';
import '../../../../global/utils/constants.dart';
import '../../../../global/widgets/responsive/responsive_page_builder.dart';
import 'widgets/categories_overview.dart';

class CategoriesManagerPage extends StatefulWidget {
  const CategoriesManagerPage({super.key});

  @override
  State<CategoriesManagerPage> createState() => _CategoriesManagerPageState();
}

class _CategoriesManagerPageState extends State<CategoriesManagerPage> {
  final initialFilter = const CategoryFilterData();

  late var getCategoriesReq = GGetCategoriesReq(
    (b) => b
      ..requestId = '@getCategoriesRequestId'
      ..fetchPolicy = FetchPolicy.CacheAndNetwork
      ..vars.queryParams.page = 1
      ..vars.queryParams.limit = Constants.defaultLimit
      ..vars.queryParams.orderBy = 'Category.createdAt:DESC',
  );

  void refreshHandler() {
    setState(() {
      getCategoriesReq = getCategoriesReq.rebuild(
        (b) => b
          ..vars.queryParams.page = 1
          ..updateResult = ((previous, result) => result),
      );
    });
  }

  void handleFilterChange(GGetCategoriesReq newReq) {
    print(newReq.vars.queryParams.filters?.toBuilder());
    setState(
      () => getCategoriesReq = getCategoriesReq.rebuild((b) => b
        ..vars.queryParams.filters =
            newReq.vars.queryParams.filters?.toBuilder()),
    );
  }

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
            SearchBar(
              onChanged: (newReq) =>
                  handleFilterChange(newReq as GGetCategoriesReq),
              request: GGetCategoriesReq(
                (b) => b
                  ..vars.queryParams =
                      getCategoriesReq.vars.queryParams.toBuilder(),
              ),
              initialFilter: initialFilter,
              searchField: 'Category.name',
            ),
          ],
        ),
      ),
      listView: CategoriesListView(
        request: getCategoriesReq,
      ),
      tableView: CategoriesTableView(
        getCategoriesReq: getCategoriesReq,
        onRequestChanged: (request) {
          setState(() {
            getCategoriesReq = request;
          });
        },
      ),
    );
  }
}