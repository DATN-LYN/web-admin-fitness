import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:ferry/ferry.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class DialogUtils {
  DialogUtils._();

  static void showError({
    required BuildContext context,
    required OperationResponse response,
  }) async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == false) {
      return;
    } else {
      Future.delayed(Duration.zero, () {
        if (response.graphqlErrors?.isNotEmpty ?? false) {
          showOkAlertDialog(
            context: context,
            title: 'Error',
            message: response.graphqlErrors?.first.message,
          );
        } else {
          if (response.linkException != null) {
            showOkAlertDialog(
              context: context,
              title: 'Error',
              message: response.linkException.toString(),
            );
          }
        }
      });
    }
  }

  // static Future showSuccess({
  //   required BuildContext context,
  //   required String title,
  //   required String subTitle,
  // }) {
  //   return showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) => SuccessDialog(
  //       title: title,
  //       subtitle: subTitle,
  //     ),
  //   );
  // }
}
