import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_inboxes.req.gql.dart';
import 'package:web_admin_fitness/global/models/inbox_filter_data.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/inboxes/widgets/inboxes_list_view.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/inboxes/widgets/inboxes_search_bar.dart';
import 'package:web_admin_fitness/modules/main/modules/home/modules/inboxes/widgets/inboxes_table_view.dart';

import '../../../../../../../../../global/extensions/responsive_wrapper.dart';
import '../../../../../../global/gen/i18n.dart';
import '../../../../../../global/utils/constants.dart';
import '../../../../../../global/widgets/responsive/responsive_page_builder.dart';

class InboxesManagerPage extends StatefulWidget {
  const InboxesManagerPage({super.key});

  @override
  State<InboxesManagerPage> createState() => _InboxesManagerPageState();
}

class _InboxesManagerPageState extends State<InboxesManagerPage> {
  final initialFilter = const InboxFilterData();

  late var getInboxesReq = GGetInboxesReq(
    (b) => b
      ..requestId = '@getInboxesReq'
      ..fetchPolicy = FetchPolicy.CacheAndNetwork
      ..vars.queryParams.page = 1
      ..vars.queryParams.limit = Constants.defaultLimit
      ..vars.queryParams.orderBy = 'Inbox.createdAt:DESC',
  );

  void refreshHandler() {
    setState(() {
      getInboxesReq = getInboxesReq.rebuild(
        (b) => b
          ..vars.queryParams.page = 1
          ..updateResult = ((previous, result) => result),
      );
    });
  }

  void handleFilterChange(GGetInboxesReq newReq) {
    setState(
      () => getInboxesReq = getInboxesReq.rebuild((b) => b
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
            if (!isDesktopView) ...[
              Text(
                i18n.inboxes_InboxList,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
            ],
            InboxSearchBar(
              onChanged: (newReq) => handleFilterChange(newReq),
              request: GGetInboxesReq(
                (b) => b
                  ..vars.queryParams =
                      getInboxesReq.vars.queryParams.toBuilder(),
              ),
              initialFilter: initialFilter,
              searchField: 'Exercise.name',
            ),
          ],
        ),
      ),
      listView: InboxesListView(
        request: getInboxesReq,
      ),
      tableView: InboxesTableView(
        getInboxesReq: getInboxesReq,
        onRequestChanged: (request) {
          setState(() {
            getInboxesReq = request;
          });
        },
      ),
    );
  }
}
