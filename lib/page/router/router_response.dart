import 'package:flutter/material.dart';
import 'package:unai_reminder/page/authentication/page_authentication.dart';

// ignore: must_be_immutable
class ResponseMessage extends StatelessWidget {
  String msg;
  ResponseMessage(this.msg, {super.key});

  @override
  Widget build(BuildContext context) {
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
                      onPressed: () => {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ))
                          },
                      child: const Text("OK"))
                ],
              ),
            )),
      )),
    );
  }
}
