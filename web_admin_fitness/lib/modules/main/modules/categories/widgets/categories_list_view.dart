import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_categories.req.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/fitness_empty.dart';
import 'package:web_admin_fitness/global/widgets/fitness_error.dart';
import 'package:web_admin_fitness/global/widgets/infinity_list.dart';
import 'package:web_admin_fitness/global/widgets/loading_overlay.dart';

import '../../../../../../../global/graphql/fragment/__generated__/category_fragment.data.gql.dart';
import '../../../../../../../global/routers/app_router.dart';
import '../helper/category_helper.dart';
import 'category_item.dart';

class CategoriesListView extends StatefulWidget {
  const CategoriesListView({
    super.key,
    required this.request,
    required this.onRequestChanged,
  });

  final GGetCategoriesReq request;
  final Function(GGetCategoriesReq) onRequestChanged;

  @override
  State<CategoriesListView> createState() => _CategoriesListViewState();
}

class _CategoriesListViewState extends State<CategoriesListView>
    with ClientMixin {
  bool loading = false;

  void refreshHandler() {
    widget.onRequestChanged(widget.request.rebuild(
      (b) => b
        ..vars.queryParams.page = 1
        ..updateResult = ((previous, result) => result),
    ));
  }

  void handleDelete(GCategory category) async {
    setState(() => loading = true);
    await CategoryHelper().handleDelete(context, category);
    refreshHandler();
    setState(() => loading = false);
  }

  void goToUpsertPage(GCategory category) {
    context.pushRoute(CategoryUpsertRoute(category: category)).then(
      (value) {
        if (value != null) {
          refreshHandler();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var getCategoriesReq = widget.request;

    return LoadingOverlay(
      loading: loading,
      isDark: false,
      child: InfinityList(
        client: client,
        request: widget.request,
        loadMoreRequest: (response) {
          final data = response?.data?.getCategories;
          if (data != null &&
              data.meta!.currentPage!.toDouble() <
                  data.meta!.totalPages!.toDouble()) {
            getCategoriesReq = widget.request.rebuild(
              (b) => b
                ..vars.queryParams.page = (b.vars.queryParams.page! + 1)
                ..updateResult = (previous, result) =>
                    previous?.rebuild(
                      (b) => b.getCategories
                        ..meta = (result?.getCategories.meta ??
                                previous.getCategories.meta)!
                            .toBuilder()
                        ..items.addAll(result?.getCategories.items ?? []),
                    ) ??
                    result,
            );
            return getCategoriesReq;
          }
          return null;
        },
        refreshRequest: () {
          getCategoriesReq = getCategoriesReq.rebuild(
            (b) => b
              ..vars.queryParams.page = 1
              ..updateResult = ((previous, result) => result),
          );
          return getCategoriesReq;
        },
        builder: (context, response, error) {
          if ((response?.hasErrors == true ||
                  response?.data?.getCategories.meta?.itemCount == 0) &&
              getCategoriesReq.vars.queryParams.page != 1) {
            getCategoriesReq = getCategoriesReq.rebuild(
              (b) => b..vars.queryParams.page = b.vars.queryParams.page! - 1,
            );
          }

          if (response?.hasErrors == true) {
            return FitnessError(response: response);
          }

          if (response?.loading ?? false) {
            return ListView.separated(
              itemCount: 3,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemBuilder: (context, index) {
                // return const ShimmerRemoteTile();
                return const SizedBox();
              },
              separatorBuilder: (_, __) => const SizedBox(height: 16),
            );
          }
          final data = response!.data!.getCategories;
          // final hasMoreData = data.meta!.currentPage!.toDouble() <
          // data.meta!.totalPages!.toDouble();
          final categories = data.items;

          if (categories?.isEmpty == true) {
            return const FitnessEmpty(
              title: 'Not Found',
            );
          }

          return ListView.builder(
            itemCount: categories!.length,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemBuilder: (context, index) {
              final item = categories[index];
              return CategoryItem(
                category: item,
                handleDelete: () => handleDelete(item),
                handleEdit: () => goToUpsertPage(item),
              );
            },
          );
        },
      ),
    );
  }
}
