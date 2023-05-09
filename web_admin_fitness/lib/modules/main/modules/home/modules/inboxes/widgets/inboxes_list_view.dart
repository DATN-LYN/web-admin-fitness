import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/inbox_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_inboxes.req.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/fitness_empty.dart';
import 'package:web_admin_fitness/global/widgets/fitness_error.dart';
import 'package:web_admin_fitness/global/widgets/infinity_list.dart';
import 'package:web_admin_fitness/global/widgets/loading_overlay.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/inboxes/helper/inbox_helper.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/inboxes/widgets/inbox_item.dart';

class InboxesListView extends StatefulWidget {
  const InboxesListView({
    super.key,
    required this.request,
  });

  final GGetInboxesReq request;

  @override
  State<InboxesListView> createState() => _InboxesListViewState();
}

class _InboxesListViewState extends State<InboxesListView> with ClientMixin {
  bool loading = false;
  void handleDelete(GInbox inbox) async {
    setState(() => loading = true);
    await InboxHelper().handleDelete(context, inbox);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    var getProgramsReq = widget.request;
    final i18n = I18n.of(context)!;

    return LoadingOverlay(
      isDark: false,
      loading: loading,
      child: InfinityList(
        client: client,
        request: widget.request,
        loadMoreRequest: (response) {
          final data = response?.data?.getInboxes;
          if (data != null &&
              data.meta!.currentPage!.toDouble() <
                  data.meta!.totalPages!.toDouble()) {
            getProgramsReq = widget.request.rebuild(
              (b) => b
                ..vars.queryParams.page = (b.vars.queryParams.page! + 1)
                ..updateResult = (previous, result) =>
                    previous?.rebuild(
                      (b) => b.getInboxes
                        ..meta = (result?.getInboxes.meta ??
                                previous.getInboxes.meta)!
                            .toBuilder()
                        ..items.addAll(result?.getInboxes.items ?? []),
                    ) ??
                    result,
            );
            return getProgramsReq;
          }
          return null;
        },
        refreshRequest: () {
          getProgramsReq = getProgramsReq.rebuild(
            (b) => b
              ..vars.queryParams.page = 1
              ..updateResult = ((previous, result) => result),
          );
          return getProgramsReq;
        },
        builder: (context, response, error) {
          if ((response?.hasErrors == true ||
                  response?.data?.getInboxes.meta?.itemCount == 0) &&
              getProgramsReq.vars.queryParams.page != 1) {
            getProgramsReq = getProgramsReq.rebuild(
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
          final data = response!.data!.getInboxes;
          final hasMoreData = data.meta!.currentPage!.toDouble() <
              data.meta!.totalPages!.toDouble();
          final inboxes = data.items;

          if (inboxes?.isEmpty == true) {
            return FitnessEmpty(
              title: i18n.common_NotFound,
            );
          }

          return ListView.separated(
            itemCount: inboxes!.length + (hasMoreData ? 1 : 0),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            itemBuilder: (context, index) {
              final item = inboxes[index];
              return InboxItem(
                inbox: item,
                handleDelete: () => handleDelete(item),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 16),
          );
        },
      ),
    );
  }
}
