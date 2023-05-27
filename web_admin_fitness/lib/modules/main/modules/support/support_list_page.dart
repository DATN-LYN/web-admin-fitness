import 'package:auto_route/auto_route.dart';
import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_supports.req.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/utils/constants.dart';
import 'package:web_admin_fitness/global/widgets/infinity_list.dart';
import 'package:web_admin_fitness/modules/main/modules/support/widgets/support_tile.dart';

import '../../../../global/widgets/fitness_empty.dart';
import '../../../../global/widgets/fitness_error.dart';

class SupportListPage extends StatefulWidget {
  const SupportListPage({super.key});

  @override
  State<SupportListPage> createState() => _SupportListPageState();
}

class _SupportListPageState extends State<SupportListPage> with ClientMixin {
  var getSupportsReq = GGetSupportsReq(
    (b) => b
      ..requestId = '@getSupportsRequestId'
      ..fetchPolicy = FetchPolicy.CacheAndNetwork
      ..vars.queryParams.page = 1
      ..vars.queryParams.limit = Constants.defaultLimit
      ..vars.queryParams.orderBy = 'Support.createdAt:DESC',
  );
  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
        leading: IconButton(
          onPressed: context.popRoute,
          icon: const Icon(
            Icons.arrow_back_ios_outlined,
          ),
        ),
      ),
      body: InfinityList(
        client: client,
        request: getSupportsReq,
        loadMoreRequest: (response) {
          final data = response?.data?.getSupports;
          if (data != null &&
              data.meta!.currentPage!.toDouble() <
                  data.meta!.totalPages!.toDouble()) {
            getSupportsReq = getSupportsReq.rebuild(
              (b) => b
                ..vars.queryParams.page = (b.vars.queryParams.page! + 1)
                ..updateResult = (previous, result) =>
                    previous?.rebuild(
                      (b) => b.getSupports
                        ..meta = (result?.getSupports.meta ??
                                previous.getSupports.meta)!
                            .toBuilder()
                        ..items.addAll(result?.getSupports.items ?? []),
                    ) ??
                    result,
            );
            return getSupportsReq;
          }
          return null;
        },
        refreshRequest: () {
          getSupportsReq = getSupportsReq.rebuild(
            (b) => b
              ..vars.queryParams.page = 1
              ..updateResult = ((previous, result) => result),
          );
          return getSupportsReq;
        },
        builder: (context, response, error) {
          if ((response?.hasErrors == true ||
                  response?.data?.getSupports.meta?.itemCount == 0) &&
              getSupportsReq.vars.queryParams.page != 1) {
            getSupportsReq = getSupportsReq.rebuild(
              (b) => b..vars.queryParams.page = b.vars.queryParams.page! - 1,
            );
          }

          if (response?.hasErrors == true) {
            return FitnessError(response: response);
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

          final data = response!.data!.getSupports;
          final hasMoreData = data.meta!.currentPage!.toDouble() <
              data.meta!.totalPages!.toDouble();
          final supports = data.items;

          if (supports?.isEmpty == true) {
            return FitnessEmpty(
              title: i18n.common_NotFound,
            );
          }

          return ListView.separated(
            itemCount: supports!.length + (hasMoreData ? 1 : 0),
            itemBuilder: (context, index) {
              final item = supports[index];
              return SupportTile(support: item);
            },
            separatorBuilder: (_, __) => const Divider(height: 1),
          );
        },
      ),
    );
  }
}
