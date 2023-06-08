import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';

import '../../../../../global/gen/i18n.dart';
import '../../../../../global/graphql/fragment/__generated__/program_fragment.data.gql.dart';
import '../../../../../global/graphql/query/__generated__/query_get_programs.req.gql.dart';
import '../../../../../global/widgets/program/program_item_large.dart';
import '../../../../../global/widgets/toast/multi_toast.dart';

class TopProgramsWidget extends StatefulWidget {
  const TopProgramsWidget({super.key});

  @override
  State<TopProgramsWidget> createState() => _TopProgramsWidgetState();
}

class _TopProgramsWidgetState extends State<TopProgramsWidget>
    with ClientMixin {
  List<GProgram> mostViewedPrograms = [];
  List<GProgram> newestPrograms = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getMostViewedPrograms();
      getNewestPrograms();
    });
    super.initState();
  }

  void getMostViewedPrograms() async {
    var getProgramsReq = GGetProgramsReq(
      (b) => b
        ..requestId = '@getMostViewedProgramsReq'
        ..fetchPolicy = FetchPolicy.CacheAndNetwork
        ..vars.queryParams.limit = 100
        ..vars.queryParams.orderBy = 'Program.view:DESC',
    );

    final response = await client.request(getProgramsReq).first;

    if (response.hasErrors) {
      if (mounted) {
        showErrorToast(
          context,
          response.graphqlErrors?.first.message,
        );
      }
    } else {
      if (mounted) {
        setState(() {
          mostViewedPrograms =
              response.data!.getPrograms.items!.map((p0) => p0).toList();
        });
      }
    }
  }

  void getNewestPrograms() async {
    var getProgramsReq = GGetProgramsReq(
      (b) => b
        ..requestId = '@getNewestProgramsReq'
        ..fetchPolicy = FetchPolicy.CacheAndNetwork
        ..vars.queryParams.limit = 100
        ..vars.queryParams.orderBy = 'Program.createdAt:DESC',
    );

    final response = await client.request(getProgramsReq).first;

    if (response.hasErrors) {
      if (mounted) {
        showErrorToast(
          context,
          response.graphqlErrors?.first.message,
        );
      }
    } else {
      if (mounted) {
        setState(() {
          newestPrograms =
              response.data!.getPrograms.items!.map((p0) => p0).toList();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.of(context)!;

    final responsive = ResponsiveWrapper.of(context);
    final isDesktopView = responsive.isLargerThan(MOBILE);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          i18n.home_MostViewedPrograms,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktopView ? 5 : 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 16,
            mainAxisExtent: 310,
          ),
          shrinkWrap: true,
          itemCount:
              mostViewedPrograms.length > 10 ? 10 : mostViewedPrograms.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final program = mostViewedPrograms[index];
            return ProgramItemLarge(
              program: program,
            );
          },
        ),
        const SizedBox(height: 20),
        Text(
          i18n.home_NewestPrograms,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktopView ? 5 : 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 16,
            mainAxisExtent: 310,
          ),
          shrinkWrap: true,
          itemCount: newestPrograms.length > 10 ? 10 : newestPrograms.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final program = newestPrograms[index];
            return ProgramItemLarge(
              program: program,
            );
          },
        ),
      ],
    );
  }
}
