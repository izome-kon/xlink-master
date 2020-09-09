
import 'package:beda3a/utils/images.dart';
import 'package:beda3a/utils/theme.dart';

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class Introduction extends StatelessWidget {
  final List<PageViewModel> listPagesViewModel = [
    PageViewModel(
      title: "مكان واحد لكل شيء",
      body: "كل ما يحتاجه مطعمك ستجده في مكان واحد",
      image: Center(
        child: welcomePage1,
      ),
    ),
    PageViewModel(
      title: "توصيل سريع",
      body: "تسليم بضاعتك إلى باب المطعم في أسرع وقت ممكن!",
      image: Center(
        child: welcomePage2,
      ),
    ),
    PageViewModel(
      title: "أفضل سعر",
      body: "يوفر لك التطبيق أفضل الأسعار في السوق",
      image: Center(
        child: welcomePage3,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: listPagesViewModel,
      onDone: () {
        Navigator.pushReplacementNamed(context, 'Login');
      },
      showSkipButton: true,
      skip: Text('تخطي'),
      next: const Icon(Icons.arrow_forward_ios),
      done: const Text("البدأ", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: accentColor,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0))),
    );
  }
}
