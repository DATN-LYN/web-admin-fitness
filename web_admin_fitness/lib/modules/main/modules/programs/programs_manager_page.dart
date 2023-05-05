import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:web_admin_fitness/global/graphql/query/__generated__/query_get_programs.req.gql.dart';
import 'package:web_admin_fitness/global/models/program_filter_data.dart';
import 'package:web_admin_fitness/modules/main/modules/programs/widgets/program_search_bar.dart';
import 'package:web_admin_fitness/modules/main/modules/programs/widgets/programs_list_view.dart';
import 'package:web_admin_fitness/modules/main/modules/programs/widgets/programs_overview.dart';
import 'package:web_admin_fitness/modules/main/modules/programs/widgets/programs_table_view.dart';

import '../../../../../../../global/extensions/responsive_wrapper.dart';
import '../../../../global/gen/i18n.dart';
import '../../../../global/utils/constants.dart';
import '../../../../global/widgets/responsive/responsive_page_builder.dart';

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

  void refreshHandler() {
    setState(() {
      getProgramsReq = getProgramsReq.rebuild(
        (b) => b
          ..vars.queryParams.page = 1
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
            const ProgramsOverview(),
            SizedBox(height: responsive.adap(20.0, 26.0)),
            if (!isDesktopView) ...[
              Text(
                i18n.programs_ProgramList,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
            ],
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
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
