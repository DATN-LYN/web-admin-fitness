import 'package:auto_route/auto_route.dart';
import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:web_admin_fitness/global/models/exercise_filter_data.dart';
import 'package:web_admin_fitness/global/routers/app_router.dart';

import '../../../../../../../../../global/extensions/responsive_wrapper.dart';
import '../../../../../../global/gen/i18n.dart';
import '../../../../../../global/graphql/query/__generated__/query_get_exercises.req.gql.dart';
import '../../../../../../global/utils/constants.dart';
import '../../../../../../global/widgets/responsive/responsive_page_builder.dart';
import 'widgets/exercise_search_bar.dart';
import 'widgets/exercises_list_view.dart';
import 'widgets/exercises_table_view.dart';

class ExercisesManagerPage extends StatefulWidget {
  const ExercisesManagerPage({super.key});

  @override
  State<ExercisesManagerPage> createState() => _ExercisesManagerPageState();
}

class _ExercisesManagerPageState extends State<ExercisesManagerPage> {
  final initialFilter = const ExerciseFilterData();

  late var getExercisesReq = GGetExercisesReq(
    (b) => b
      ..requestId = '@getExercisesReq'
      ..fetchPolicy = FetchPolicy.CacheAndNetwork
      ..vars.queryParams.page = 1
      ..vars.queryParams.limit = Constants.defaultLimit
      ..vars.queryParams.orderBy = 'Exercise.createdAt:DESC',
  );

  @override
  void initState() {
    final controller = AutoRouter.of(context);
    controller.addListener(() {
      if (controller.current.name == ProgramsManagerRoute.name) {
        if (mounted) {
          getExercisesReq = getExercisesReq.rebuild((b) => b
            ..vars.queryParams.page = 1
            ..updateResult = ((previous, result) => result));
        }
      }
    });
    super.initState();
  }

  void refreshHandler() {
    setState(() {
      getExercisesReq = getExercisesReq.rebuild(
        (b) => b
          ..vars.queryParams.page = 1
          ..updateResult = ((previous, result) => result),
      );
    });
  }

  void handleFilterChange(GGetExercisesReq newReq) {
    setState(
      () => getExercisesReq = getExercisesReq.rebuild((b) => b
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
            ExerciseSearchBar(
              onChanged: (newReq) => handleFilterChange(newReq),
              request: GGetExercisesReq(
                (b) => b
                  ..vars.queryParams =
                      getExercisesReq.vars.queryParams.toBuilder(),
              ),
              initialFilter: initialFilter,
              searchField: 'Exercise.name',
            ),
          ],
        ),
      ),
      listView: ExercisesListView(
        request: getExercisesReq,
        onRequestChanged: (request) {
          setState(() {
            getExercisesReq = request;
          });
        },
      ),
      tableView: ExercisesTableView(
        getExercisesReq: getExercisesReq,
        onRequestChanged: (request) {
          setState(() {
            getExercisesReq = request;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context
              .pushRoute(ExerciseUpsertRoute())
              .then((value) => refreshHandler());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
