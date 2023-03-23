import 'package:flutter/material.dart';
import 'package:unai_reminder/page/authentication/page_authentication.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: null,
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Image.asset('assets/images/times.png', width: 250),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Get Schedule. \n Get Productivity.",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Sp",
                  fontWeight: FontWeight.w600,
                  fontSize: 40,
                  fontStyle: FontStyle.italic),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ));
                },
                child: const Text(
                  "Login Now",
                  style: TextStyle(fontFamily: 'Sp'),
                ))
          ],
        ),
      ),
    );
  }
}
