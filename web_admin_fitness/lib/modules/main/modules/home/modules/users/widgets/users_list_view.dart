import 'package:flutter/material.dart';
import 'package:web_admin_fitness/global/gen/i18n.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_users.req.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';
import 'package:web_admin_fitness/global/widgets/fitness_empty.dart';
import 'package:web_admin_fitness/global/widgets/fitness_error.dart';
import 'package:web_admin_fitness/global/widgets/infinity_list.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/users/widgets/user_item.dart';

import '../../../../../../../global/graphql/fragment/__generated__/user_fragment.data.gql.dart';

class UsersListView extends StatefulWidget {
  const UsersListView({
    super.key,
    required this.request,
    required this.handleDelete,
  });

  final GGetUsersReq request;
  final Function(GUser user) handleDelete;

  @override
  State<UsersListView> createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> with ClientMixin {
  @override
  Widget build(BuildContext context) {
    var getUsersReq = widget.request;
    final i18n = I18n.of(context)!;

    return InfinityList(
      client: client,
      request: widget.request,
      loadMoreRequest: (response) {
        final data = response?.data?.getUsers;
        if (data != null &&
            data.meta!.currentPage!.toDouble() <
                data.meta!.totalPages!.toDouble()) {
          getUsersReq = widget.request.rebuild(
            (b) => b
              ..vars.queryParams.page = (b.vars.queryParams.page! + 1)
              ..updateResult = (previous, result) =>
                  previous?.rebuild(
                    (b) => b.getUsers
                      ..meta =
                          (result?.getUsers.meta ?? previous.getUsers.meta)!
                              .toBuilder()
                      ..items.addAll(result?.getUsers.items ?? []),
                  ) ??
                  result,
          );
          return getUsersReq;
        }
        return null;
      },
      refreshRequest: () {
        getUsersReq = getUsersReq.rebuild(
          (b) => b
            ..vars.queryParams.page = 1
            ..updateResult = ((previous, result) => result),
        );
        return getUsersReq;
      },
      builder: (context, response, error) {
        if ((response?.hasErrors == true ||
                response?.data?.getUsers.meta?.itemCount == 0) &&
            getUsersReq.vars.queryParams.page != 1) {
          getUsersReq = getUsersReq.rebuild(
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
        final data = response!.data!.getUsers;
        final hasMoreData = data.meta!.currentPage!.toDouble() <
            data.meta!.totalPages!.toDouble();
        final users = data.items;

        if (users?.isEmpty == true) {
          return FitnessEmpty(
            title: i18n.common_NotFound,
          );
        }

        return ListView.separated(
          itemCount: users!.length + (hasMoreData ? 1 : 0),
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          itemBuilder: (context, index) {
            final item = users[index];
            return UserItem(
              user: item,
              handleDelete: () => widget.handleDelete(item),
            );
          },
          separatorBuilder: (_, __) => const SizedBox(height: 10),
        );
      },
    );
  }
}
