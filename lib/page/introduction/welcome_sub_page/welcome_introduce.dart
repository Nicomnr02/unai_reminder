import 'package:flutter/material.dart';

class WelcomeIntroduce extends StatelessWidget {
  const WelcomeIntroduce({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 150)),
            Image.asset('assets/images/times.png', width: 250),
            const Text(
              "UNAI REMINDER.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Sp",
                  fontWeight: FontWeight.w600,
                  fontSize: 40,
                  fontStyle: FontStyle.italic),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            const SizedBox(
              width: 250,
              child: Text(
                "Hi! This is Nicolas, thank for using this app, hope you can be more productive afterwards.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Sp",
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    fontStyle: FontStyle.italic),
              ),
            )
          ],
        ),
      ),
    );
  }
}
