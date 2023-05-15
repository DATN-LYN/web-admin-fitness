import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:web_admin_fitness/global/extensions/responsive_wrapper.dart';
import 'package:web_admin_fitness/global/gen/assets.gen.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_users.req.gql.dart';
import 'package:web_admin_fitness/global/themes/app_colors.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/shimmer_image.dart';
import 'package:web_admin_fitness/global/widgets/table/data_table_builder.dart';
import 'package:web_admin_fitness/global/widgets/table/table_column.dart';
import 'package:web_admin_fitness/global/widgets/table/table_data_source.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/users/helper/user_helper.dart';

import '../../../../../../../global/gen/i18n.dart';
import '../../../../../../../global/graphql/fragment/__generated__/user_fragment.data.gql.dart';
import '../../../../../../../global/routers/app_router.dart';

class UsersTableView extends StatefulWidget {
  const UsersTableView({
    super.key,
    required this.getUsersReq,
    required this.onRequestChanged,
  });

  final GGetUsersReq getUsersReq;
  final Function(GGetUsersReq) onRequestChanged;

  @override
  State<UsersTableView> createState() => _UsersTableViewState();
}

class _UsersTableViewState extends State<UsersTableView> with ClientMixin {
  String? orderBy;

  bool loading = false;
  void handleOrderBy(String fieldName) {
    if (orderBy == 'User.$fieldName:DESC') {
      setState(() => orderBy = 'User.$fieldName:ASC');
    } else {
      setState(() => orderBy = 'User.$fieldName:DESC');
    }

    widget.onRequestChanged(
      widget.getUsersReq.rebuild(
        (b) => b
          ..vars.queryParams.orderBy = b.vars.queryParams.orderBy = orderBy
          ..updateResult = ((previous, result) => result),
      ),
    );
  }

  Widget sortButton(String fieldName) {
    return InkWell(
      onTap: () => handleOrderBy(fieldName),
      child: orderBy == 'User.$fieldName:DESC'
          ? Assets.icons.icSortDown.svg(width: 10, height: 10)
          : orderBy == 'User.$fieldName:ASC'
              ? Assets.icons.icSortUpper.svg(width: 10, height: 10)
              : Assets.icons.icSort.svg(width: 12, height: 12),
    );
  }

  void refreshHandler() {
    widget.onRequestChanged(
      widget.getUsersReq.rebuild(
        (b) => b
          ..vars.queryParams.page = 1
          ..updateResult = ((previous, result) => result),
      ),
    );
  }

  void handleDelete(GUser user) async {
    setState(() => loading = true);
    await UserHelper().handleDelete(context, user);
    refreshHandler();
    setState(() => loading = false);
  }

  void goToUpsertPage(GUser user) {
    context
        .pushRoute(UserUpsertRoute(user: user))
        .then((value) => refreshHandler());
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveWrapper.of(context).adap(16.0, 24.0);
    final i18n = I18n.of(context)!;
    var request = widget.getUsersReq;

    return Padding(
      padding: EdgeInsets.fromLTRB(spacing, 0, spacing, spacing),
      child: DataTableBuilder(
        loading: loading,
        client: client,
        request: request,
        meta: (response) {
          return response?.data?.getUsers.meta;
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
          final data = response?.data?.getUsers;
          final users = data?.items?.toList() ?? <GUser>[];

          final dataSource = TableDataSource<GUser>(
            tableData: users,
            columnItems: [
              // TableColumn(
              //   label: i18n.common_Id,
              //   minimumWidth: 220,
              //   columnWidthMode: ColumnWidthMode.fill,
              //   itemValue: (e) => e.id,
              // ),
              // TableColumn(
              //   label: i18n.common_Name,
              //   itemValue: (e) => e.fullName,
              //   minimumWidth: 200,
              //   columnWidthMode: ColumnWidthMode.fill,
              //   action: sortButton('fullName'),
              // ),
              TableColumn(
                label: i18n.users_Avatar,
                minimumWidth: 50,
                columnWidthMode: ColumnWidthMode.fill,
                action: sortButton('avatar'),
                cellBuilder: (e) {
                  return Row(
                    children: [
                      ShimmerImage(
                        imageUrl: e.avatar ?? '',
                        height: 70,
                        width: 70,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      // Expanded(
                      //   child: Text(
                      //     e.avatar ?? '-',
                      //     overflow: TextOverflow.ellipsis,
                      //     maxLines: 3,
                      //     softWrap: true,
                      //   ),
                      // ),
                    ],
                  );
                },
              ),
              TableColumn(
                label: i18n.login_Email,
                minimumWidth: 200,
                columnWidthMode: ColumnWidthMode.fill,
                action: sortButton('email'),
                itemValue: (e) => e.email.toString(),
              ),
              TableColumn(
                label: i18n.upsertUser_FullName,
                minimumWidth: 200,
                columnWidthMode: ColumnWidthMode.fill,
                action: sortButton('fullName'),
                itemValue: (e) => e.fullName ?? '-',
              ),
              TableColumn(
                label: i18n.upsertUser_Age,
                minimumWidth: 150,
                columnWidthMode: ColumnWidthMode.fill,
                action: sortButton('age'),
                itemValue: (e) => e.age.toString(),
              ),
              TableColumn(
                label: i18n.common_Actions,
                align: Alignment.center,
                width: 125,
                cellBuilder: (e) {
                  return Row(
                    children: [
                      IconButton(
                        onPressed: () => goToUpsertPage(e),
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
            rowHeight: 100,
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
