import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:web_admin_fitness/global/graphql/fragment/__generated__/exercise_fragment.data.gql.dart';
import 'package:web_admin_fitness/global/utils/client_mixin.dart';

import '../../../../../../../global/gen/i18n.dart';
import '../../../../../../../global/graphql/mutation/__generated__/mutation_delete_exercise.req.gql.dart';
import '../../../../../../../global/widgets/dialogs/confirmation_dialog.dart';
import '../../../../../../../global/widgets/toast/multi_toast.dart';

class ExerciseHelper with ClientMixin {
  ExerciseHelper();

  Future handleDelete(BuildContext context, GExercise? exercise) async {
    final i18n = I18n.of(context)!;

    return showAlertDialog(
      context: context,
      builder: (dialogContext, child) {
        return ConfirmationDialog(
          titleText: i18n.deleteExercise_Title,
          contentText: i18n.deleteExercise_Des,
          onTapPositiveButton: () async {
            dialogContext.popRoute();

            final request = GDeleteExerciseReq(
              (b) => b..vars.exerciseId = exercise?.id,
            );

            final response = await client.request(request).first;
            if (response.hasErrors) {
              if (context.mounted) {
                showErrorToast(
                  context,
                  response.graphqlErrors?.first.message,
                );
                // DialogUtils.showError(context: context, response: response);
              }
            } else {
              if (context.mounted) {
                showSuccessToast(context, i18n.toast_Subtitle_DeleteExercise);
                // context.popRoute(response);
              }
            }
          },
        );
      },
    );
  }
}
