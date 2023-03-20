import 'package:flutter/material.dart';

class ResponseMessage {
  Widget errorPageBuilder(BuildContext context, String msg) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.black87,
      body: Center(
          child: SizedBox(
        height: 200,
        width: 350,
        child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      msg,
                      style: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'Sp',
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () => {Navigator.of(context).pop()},
                      child: const Text("OK"))
                ],
              ),
            )),
      )),
    );
  }
}




// class ResponseMessage {
//   Future successRsp(BuildContext context, String successMsg) {
//     return 
//     });
//   }

//   Future<Widget> erorrResp(BuildContext context, String errMsg) {
//     return Future.delayed(Duration.zero, () async {
//       return Container(
//           child: await QuickAlert.show(
//         context: context,
//         type: QuickAlertType.error,
//         title: "Oops..",
//         text: errMsg,
//       ));
//     });
//   }

//   Future noInternetRsp(BuildContext context, String errMsg) {
//     return Future.delayed(Duration.zero, () {
//       //your code goes here
//       QuickAlert.show(
//         context: context,
//         type: QuickAlertType.warning,
//         title: "No Internet Connection",
//         text: errMsg,
//       );
//     });
//   }
// }
