import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_admin_fitness/global/extensions/responsive_wrapper.dart';
import 'package:web_admin_fitness/global/gen/assets.gen.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/inbox_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_inboxes.req.gql.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';
import 'package:web_admin_fitness/global/widgets/table/data_table_builder.dart';
import 'package:web_admin_fitness/global/widgets/table/table_column.dart';
import 'package:web_admin_fitness/global/widgets/table/table_data_source.dart';
import 'package:web_admin_fitness/global/widgets/tag.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/inboxes/helper/inbox_helper.dart';

import '../../../../../../../global/gen/i18n.dart';
import '../../../../../../../global/routers/app_router.dart';

class InboxesTableView extends StatefulWidget {
  const InboxesTableView({
    super.key,
    required this.getInboxesReq,
    required this.onRequestChanged,
  });

  final GGetInboxesReq getInboxesReq;
  final Function(GGetInboxesReq) onRequestChanged;

  @override
  State<InboxesTableView> createState() => _InboxesTableViewState();
}

class _InboxesTableViewState extends State<InboxesTableView> with ClientMixin {
  String? orderBy;
  bool loading = false;

  void handleOrderBy(String fieldName) {
    if (orderBy == 'Inbox.$fieldName:DESC') {
      setState(() => orderBy = 'Inbox.$fieldName:ASC');
    } else {
      setState(() => orderBy = 'Inbox.$fieldName:DESC');
    }

    widget.onRequestChanged(
      widget.getInboxesReq.rebuild(
        (b) => b
          ..vars.queryParams.orderBy = b.vars.queryParams.orderBy = orderBy
          ..updateResult = ((previous, result) => result),
      ),
    );
  }

  void handleDelete(GInbox inbox) async {
    setState(() => loading = true);
    await InboxHelper().handleDelete(context, inbox);
    refreshHandler();
    setState(() => loading = false);
  }

  void refreshHandler() {
    widget.onRequestChanged(
      widget.getInboxesReq.rebuild(
        (b) => b
          ..vars.queryParams.page = 1
          ..updateResult = ((previous, result) => result),
      ),
    );
  }

  Widget sortButton(String fieldName) {
    return InkWell(
      onTap: () => handleOrderBy(fieldName),
      child: orderBy == 'Inbox.$fieldName:DESC'
          ? Assets.icons.icSortDown.svg(width: 10, height: 10)
          : orderBy == 'Inbox.$fieldName:ASC'
              ? Assets.icons.icSortUpper.svg(width: 10, height: 10)
              : Assets.icons.icSort.svg(width: 12, height: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveWrapper.of(context).adap(16.0, 24.0);
    final i18n = I18n.of(context)!;
    var request = widget.getInboxesReq;

    return Padding(
      padding: EdgeInsets.fromLTRB(spacing, 0, spacing, spacing),
      child: DataTableBuilder(
        loading: loading,
        client: client,
        request: request,
        meta: (response) {
          return response?.data?.getInboxes.meta;
        },
        changeLimitRequest: (response, limit) {
          request = request.rebuild(
            (b) => b..vars.queryParams.limit = limit.toDouble(),
          );
          return request;
        },
        changePageRequest: (response, page) {
          request = request.rebuild(
            (b) => b..vars.queryParams.page = page.toDouble(),
          );
          return request;
        },
        builder: (context, response, error) {
          final data = response?.data?.getInboxes;
          final inboxes = data?.items?.toList() ?? <GInbox>[];

          final dataSource = TableDataSource<GInbox>(
            tableData: inboxes,
            columnItems: [
              // TableColumn(
              //   label: i18n.common_Id,
              //   minimumWidth: 220,
              //   columnWidthMode: ColumnWidthMode.fill,
              //   itemValue: (e) => e.id,
              // ),
              TableColumn(
                label: i18n.inboxes_User,
                minimumWidth: 350,
                columnWidthMode: ColumnWidthMode.fill,
                cellBuilder: (e) {
                  return Row(
                    children: [
                      ShimmerImage(
                        imageUrl: e.user?.avatar ?? '_',
                        width: 50,
                        height: 50,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              e.user?.email ?? '_',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 12),
                            Text(e.userId),
                          ],
                        ),
                      )
                    ],
                  );
                },
                action: sortButton('userId'),
              ),
              TableColumn(
                label: i18n.inboxes_Message,
                minimumWidth: 450,
                columnWidthMode: ColumnWidthMode.fill,
                action: sortButton('message'),
                itemValue: (e) => e.message,
              ),
              TableColumn(
                label: i18n.inboxes_From,
                minimumWidth: 150,
                columnWidthMode: ColumnWidthMode.fill,
                action: sortButton('isSender'),
                cellBuilder: (e) {
                  return Tag(
                    text: e.isSender ? i18n.inboxes_User : i18n.inboxes_Bot,
                    color: e.isSender ? AppColors.success : AppColors.alert,
                  );
                },
              ),
              TableColumn(
                label: 'Created At',
                minimumWidth: 220,
                columnWidthMode: ColumnWidthMode.fill,
                action: sortButton('createdAt'),
                itemValue: (e) => e.createdAt?.toIso8601String(),
              ),
              TableColumn(
                label: i18n.common_Actions,
                align: Alignment.center,
                width: 125,
                cellBuilder: (e) {
                  return Row(
                    children: [
                      IconButton(
                        onPressed: () => context.pushRoute(
                          InboxDetailRoute(inbox: e),
                        ),
                        icon: const Icon(Icons.remove_red_eye),
                        color: AppColors.grey4,
                        tooltip: i18n.common_ViewDetail,
                      ),
                      IconButton(
                        onPressed: () => handleDelete(e),
                        icon: const Icon(Icons.delete_outline),
                        color: AppColors.error,
                        tooltip: i18n.button_Delete,
                      ),
                    ],
                  );
                },
              ),
            ],
          );

          return SfDataGrid(
            source: dataSource,
            shrinkWrapRows: true,
            rowHeight: 120,
            headerRowHeight: 42,
            footerFrozenColumnsCount: 1,
            headerGridLinesVisibility: GridLinesVisibility.none,
            horizontalScrollPhysics: const ClampingScrollPhysics(),
            columns: dataSource.buildColumns(),
            columnWidthMode: ColumnWidthMode.fill,
          );
        },
      ),
    );
  }
}
