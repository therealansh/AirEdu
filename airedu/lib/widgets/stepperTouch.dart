import 'package:airedu/constants/apptheme.dart';
import 'package:airedu/screens/airBoard.dart';
import 'package:airedu/screens/airScript.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
class StepperTouch extends StatefulWidget {
  final bool withSpring;
  StepperTouch({
    this.withSpring
});
  @override
  _StepperTouchState createState() => _StepperTouchState();
}

class _StepperTouchState extends State<StepperTouch> with SingleTickerProviderStateMixin{

  AnimationController _animationController;
  Animation _animation;
  double startXpos;
  double startYpos;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this,lowerBound: -0.5,upperBound: 0.5);
    _animationController.value= 0.0;
    _animationController.addListener(() {});
    _animation = Tween<Offset>(begin: Offset(0,0),end: Offset(1.5,0.0)).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant StepperTouch oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animation = Tween<Offset>(begin: Offset(0,0),end: Offset(1.5,0.0)).animate(_animationController);
  }


  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return FittedBox(
      child: Container(
        width: kIsWeb ?  500 : _size.width*0.85,
        height: kIsWeb ? 120:_size.height*0.1,
        child: Material(
          type: MaterialType.canvas,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(60),
          color: AppTheme.primaryColor,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 50,

                child: Image.asset("assets/teach.png",color: Colors.white,height: 55,),
              ),
              Positioned(
                right: 50,

                child: Icon(Icons.assignment,color: Colors.white,size: 55,),
              ),
              GestureDetector(
                onHorizontalDragStart: _onPanStart,
                onHorizontalDragUpdate: _onPanUpdate,
                onHorizontalDragEnd: _onPanEnd,
                child: SlideTransition(
                  position: _animation,
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 5,
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: Duration(milliseconds: 500),
                        transitionBuilder: (child,animation){
                          return ScaleTransition(scale: animation,child: child,);
                        },
                        child: Icon(Icons.circle,color: AppTheme.secondaryColor,),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  offsetFromGlobalPos(Offset globalPos){
    RenderBox box = context.findRenderObject() as RenderBox;
    Offset local = box.globalToLocal(globalPos);
    startXpos = ((local.dx * 0.75)/box.size.width)-0.4;
    startYpos = ((local.dy * 0.75)/box.size.height)-0.4;
    return ((local.dx * 0.75) / box.size.width) - 0.4;
  }

  _onPanStart(DragStartDetails details){
    _animationController.stop();
    _animationController.value = offsetFromGlobalPos(details.globalPosition);
  }

  _onPanUpdate(DragUpdateDetails details){
    _animationController.value = offsetFromGlobalPos(details.globalPosition);
  }

  _onPanEnd(DragEndDetails details){
    _animationController.stop();
    bool changed = false;
    if (_animationController.value <= -0.20) {
      setState((){});
      changed = true;
      Navigator.push(context, CupertinoPageRoute(builder: (_)=>AirBoardPage()));
    } else if (_animationController.value >= 0.20) {
      setState((){});
      changed = true;
      Navigator.push(context, CupertinoPageRoute(builder: (_)=>AirScriptPage()));
    }
    if (widget.withSpring) {
      final SpringDescription _kDefaultSpring =
      new SpringDescription.withDampingRatio(
        mass: 0.9,
        stiffness: 250.0,
        ratio: 0.6,
      );

        _animationController.animateWith(
            SpringSimulation(_kDefaultSpring, startXpos, 0.0, 0.0));

    } else {
        _animationController.animateTo(0.0,
          curve: Curves.bounceOut, duration: Duration(milliseconds: 500));
    }

  }
}
