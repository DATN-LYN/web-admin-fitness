import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_users.req.gql.dart';
import 'package:web_admin_fitness/global/models/user_filter_data.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/users/widgets/user_search_bar.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/users/widgets/users_list_view.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/users/widgets/users_table_view.dart';

import '../../../../../../../../../global/extensions/responsive_wrapper.dart';
import '../../../../../../global/gen/i18n.dart';
import '../../../../../../global/graphql/fragment/__generated__/user_fragment.data.gql.dart';
import '../../../../../../global/graphql/mutation/__generated__/mutation_delete_user.req.gql.dart';
import '../../../../../../global/routers/app_router.dart';
import '../../../../../../global/utils/constants.dart';
import '../../../../../../global/widgets/dialogs/confirmation_dialog.dart';
import '../../../../../../global/widgets/responsive/responsive_page_builder.dart';
import '../../../../../../global/widgets/toast/multi_toast.dart';

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
      ..vars.queryParams.limit = Constants.defaultLimit,
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

  void handleDelete(GUser user) {
    final i18n = I18n.of(context)!;

    showAlertDialog(
      context: context,
      builder: (dialogContext, child) {
        return ConfirmationDialog(
          titleText: i18n.deleteUser_Title,
          contentText: i18n.deleteUser_Des,
          onTapPositiveButton: () async {
            dialogContext.popRoute();

            final request = GDeleteUserReq(
              (b) => b..vars.userId = user.id,
            );

            final response = await client.request(request).first;
            if (response.hasErrors) {
              if (mounted) {
                showErrorToast(
                  context,
                  response.graphqlErrors?.first.message,
                );
                // DialogUtils.showError(context: context, response: response);
              }
            } else {
              if (mounted) {
                showSuccessToast(context, 'Delete Successfully');
                refreshHandler();
              }
            }
          },
        );
      },
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
            if (!isDesktopView) ...[
              Text(
                i18n.exercises_ExerciseList,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
            ],
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
        handleDelete: handleDelete,
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
