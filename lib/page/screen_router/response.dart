import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ResponseMessage {
  Future successRsp(BuildContext context, String successMsg) {
    return Future.delayed(Duration.zero, () {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.success,
        text: successMsg,
      );
    });
  }

  Future erorrResp(BuildContext context, String errMsg) {
    return Future.delayed(Duration.zero, () {
      //your code goes here
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: "Oops..",
        text: errMsg,
      );
    });
  }
}
