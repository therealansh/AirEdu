import 'package:airedu/constants/apptheme.dart';
import 'package:airedu/widgets/stepperTouch.dart';
import 'package:flutter/material.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          Positioned(
            top: 0.0,
            right: 0.0,
            child: Image.asset("assets/top1.png"),
          ),
          Positioned(
            top: 0.0,
            right: 0.0,
            child: Image.asset("assets/top2.png"),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            child: Image.asset("assets/bottom1.png"),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            child: Image.asset("assets/img1.png"),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("AirEdu",style: TextStyle(fontSize: 100,fontFamily: "Signatra",color: AppTheme.subTitleTextColor),),
                StepperTouch(withSpring: true,)
              ],
            )
          )
        ],
      )
    );
  }
}
