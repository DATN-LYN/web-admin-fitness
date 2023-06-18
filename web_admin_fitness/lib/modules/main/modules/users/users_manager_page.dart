import 'package:auto_route/auto_route.dart';
import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_users.req.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/modules/main/modules/users/models/user_filter_data.dart';

import '../../../../../../../../../global/extensions/responsive_wrapper.dart';
import '../../../../../../global/gen/i18n.dart';
import '../../../../../../global/routers/app_router.dart';
import '../../../../../../global/utils/constants.dart';
import '../../../../../../global/widgets/responsive/responsive_page_builder.dart';
import 'widgets/user_search_bar.dart';
import 'widgets/users_list_view.dart';
import 'widgets/users_table_view.dart';

class UsersManagerPage extends StatefulWidget {
  const UsersManagerPage({super.key});

  @override
  State<UsersManagerPage> createState() => _UsersManagerPageState();
}

class _UsersManagerPageState extends State<UsersManagerPage> with ClientMixin {
  final initialFilter = const UserFilterData();

  late var getUsersReq = GGetUsersReq(
    (b) => b
      ..requestId = '@getUsersReq'
      ..fetchPolicy = FetchPolicy.CacheAndNetwork
      ..vars.queryParams.page = 1
      ..vars.queryParams.limit = Constants.defaultLimit
      ..vars.queryParams.orderBy = 'User.createdAt:DESC',
  );

  void refreshHandler() {
    setState(() {
      getUsersReq = getUsersReq.rebuild(
        (b) => b
          ..vars.queryParams.page = 1
          ..updateResult = ((previous, result) => result),
      );
    });
  }

  void handleFilterChange(GGetUsersReq newReq) {
    setState(
      () => getUsersReq = getUsersReq.rebuild((b) => b
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isDesktopView) const SizedBox(height: 16),
            UserSearchBar(
              onChanged: (newReq) => handleFilterChange(newReq),
              request: GGetUsersReq(
                (b) => b
                  ..vars.queryParams = getUsersReq.vars.queryParams.toBuilder(),
              ),
              initialFilter: initialFilter,
              searchField: 'User.fullName',
            ),
          ],
        ),
      ),
      listView: UsersListView(
        request: getUsersReq,
        onRequestChanged: (request) {
          setState(() {
            getUsersReq = request;
          });
        },
      ),
      tableView: UsersTableView(
        getUsersReq: getUsersReq,
        onRequestChanged: (request) {
          setState(() {
            getUsersReq = request;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          context.pushRoute(UserUpsertRoute()).then((value) {
            if (value != null) {
              refreshHandler();
            }
          });
        },
      ),
    );
  }
}
