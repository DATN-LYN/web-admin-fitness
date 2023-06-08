import 'package:auto_route/auto_route.dart';
import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_programs.req.gql.dart';
import 'package:web_admin_fitness/global/routers/app_router.dart';
import 'package:web_admin_fitness/modules/main/modules/programs/models/program_filter_data.dart';

import '../../../../../../../../../global/extensions/responsive_wrapper.dart';
import '../../../../../../global/gen/i18n.dart';
import '../../../../../../global/utils/constants.dart';
import '../../../../../../global/widgets/responsive/responsive_page_builder.dart';
import 'widgets/program_search_bar.dart';
import 'widgets/programs_list_view.dart';
import 'widgets/programs_table_view.dart';

class ProgramsManagerPage extends StatefulWidget {
  const ProgramsManagerPage({super.key});

  @override
  State<ProgramsManagerPage> createState() => _ProgramsManagerPageState();
}

class _ProgramsManagerPageState extends State<ProgramsManagerPage> {
  final initialFilter = const ProgramFilterData();

  late var getProgramsReq = GGetProgramsReq(
    (b) => b
      ..requestId = '@getProgramsRequestId'
      ..fetchPolicy = FetchPolicy.CacheAndNetwork
      ..vars.queryParams.page = 1
      ..vars.queryParams.limit = Constants.defaultLimit
      ..vars.queryParams.orderBy = 'Program.createdAt:DESC',
  );

  @override
  void initState() {
    final controller = AutoRouter.of(context);
    controller.addListener(() {
      if (controller.current.name == ProgramsManagerRoute.name) {
        if (mounted) {
          getProgramsReq = getProgramsReq.rebuild((b) => b
            ..vars.queryParams.page = 1
            ..updateResult = ((previous, result) => result));
        }
      }
    });
    super.initState();
  }

  void refreshHandler() {
    setState(() {
      getProgramsReq = getProgramsReq.rebuild(
        (b) => b
          ..vars.queryParams.page = 1
          ..vars.queryParams.limit = Constants.defaultLimit
          ..updateResult = ((previous, result) => result),
      );
    });
  }

  void handleFilterChange(GGetProgramsReq newReq) {
    setState(
      () => getProgramsReq = getProgramsReq.rebuild((b) => b
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
        padding: EdgeInsets.all(responsive.adap(16.0, 20.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProgramSearchBar(
              onChanged: (newReq) => handleFilterChange(newReq),
              request: GGetProgramsReq(
                (b) => b
                  ..vars.queryParams =
                      getProgramsReq.vars.queryParams.toBuilder(),
              ),
              initialFilter: initialFilter,
              searchField: 'Program.name',
            ),
          ],
        ),
      ),
      listView: ProgramsListView(
        request: getProgramsReq,
        onRequestChanged: (request) {
          setState(() {
            getProgramsReq = request;
          });
        },
      ),
      tableView: ProgramsTableView(
        getProgramsReq: getProgramsReq,
        onRequestChanged: (request) {
          setState(() {
            getProgramsReq = request;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushRoute(ProgramUpsertRoute()).then(
            (value) {
              if (value != null) {
                refreshHandler();
              }
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
