import 'package:flutter/material.dart';
import 'package:unai_reminder/page/introduction/welcome_sub_page/welcome_autostart_permission.dart';
import 'package:unai_reminder/page/introduction/welcome_sub_page/welcome_introduce.dart';
import 'package:unai_reminder/page/introduction/welcome_sub_page/welcome_noti_permission.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage({super.key});

  @override
  State<IntroductionPage> createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {

  // declare and initizlize the page controller
  final PageController _pageController = PageController(initialPage: 0);

  // the index of the current page
  int _activePage = 0;

  // this list holds all the pages
  final List<Widget> _pages = [
    const WelcomeIntroduce(),
    const WelcomeAutostartPermission(),
    const WelcomeNotificationPermission()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // the page view
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _activePage = page;
              });
            },
            itemCount: _pages.length,
            itemBuilder: (BuildContext context, int index) {
              return _pages[index % _pages.length];
            },
          ),
          // Display the dots indicator
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                  _pages.length,
                  (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: InkWell(
                          onTap: () {
                            _pageController.animateToPage(index,
                                duration: const Duration(milliseconds: 50),
                                curve: Curves.easeIn);
                          },
                          child: CircleAvatar(
                            radius: 8,
                            // check if a dot is connected to the current page
                            // if true, give it a different color
                            backgroundColor: _activePage == index
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                      )),
            ),
          ),
        ],
      ),
    );
  }
}
