import 'package:lottie/lottie.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';

//models
import '../models/onboarding.dart';
class OnboardingPage extends StatelessWidget {
  OnboardingPage({Key? key}) : super(key: key);

  final data = [
    onboardingData(
      title: "Participate",
      subtitle:
          "Aceess to lots of event at one place so that you can easily participate",
      image: LottieBuilder.asset('Assets/128833-footballer.json'),
      backgroundColor: Color(0xFF3B2A22),

      titleColor: Colors.yellow,
      subtitleColor: Colors.white,
      background: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(71, 59, 117, 1),
              Color.fromRGBO(71, 59, 117, 1),
            ],
          ),
        ),
      ),
    ),
    onboardingData(
      title: "Booking",
      subtitle:
          "Booking easily for the events you want to participate in and get notified",
      image: LottieBuilder.asset('Assets/112454-form-registration.json'),
      backgroundColor: Colors.white,
      titleColor: Colors.pink,
      subtitleColor: Colors.black,
      background: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(0, 10, 56, 1),
              Color.fromRGBO(0, 10, 56, 1),
            ],
          ),
        ),
      ),
    ),
    onboardingData(
      title: "Plan Your Day!",
      subtitle: "By carefully scheduling your events and tasks for the day, you can maximize productivity and ensure that you don't miss out on any important opportunities.",
      image: Lottie.asset('Assets/121529-businessman-balancing-on-time-unicycle.json'),
      backgroundColor: Colors.blueAccent,
      titleColor: Colors.white,
      subtitleColor: const Color.fromRGBO(0, 10, 56, 1),
      background: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(255, 255, 255, 1),
              Color.fromRGBO(255, 255, 255, 1),
            ],
          ),
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ConcentricPageView(
        colors: data.map((e) => e.backgroundColor).toList(),
        itemCount: data.length,
        itemBuilder: (int index) {
          return onboarding(data: data[index]);
        },
        onFinish: () {
          Navigator.of(context).pushReplacementNamed("/auth");
        },
      ),
    );
  }
}
