import 'package:flutter/material.dart';
import 'dart:async';

class LibCarousel extends StatefulWidget {
  
  final List<Widget> children;
  int get childrenCount => children.length;
  final Curve animationCurve;
  final Duration animationDuration;
  final Duration displayDuration;

  LibCarousel({
    this.children,
    this.animationCurve = Curves.ease,
    this.animationDuration = const Duration(milliseconds: 250),
    this.displayDuration = const Duration(seconds: 2)
  }) :
    assert(children != null),
    assert(animationCurve != null),
    assert(animationDuration != null),
    assert(displayDuration != null);

  @override
  State createState() => new _CarouselState();
}

class _CarouselState extends State<LibCarousel> with SingleTickerProviderStateMixin {
  TabController _controller;
  Timer _timer;

  int get actualIndex => _controller.index;
  int get nextIndex {
    var nextIndexValue = actualIndex;

    if(nextIndexValue < _controller.length - 1){
      nextIndexValue++;
    } else {
      nextIndexValue = 0;
    }

    return nextIndexValue;
  }

  @override
  void initState(){
    super.initState();
    _controller = new TabController(length:widget.childrenCount,vsync:this);
    startAnimating();
  }

  @override
  void dispose(){
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context){
    return new TabBarView(
      children: widget.children.map((widget) { 
        // new Center(child: widget,)
        return new Center(
          child: new Container(
            child: new Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)
              ),
              child: new ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: widget,
              ),
            ),
          ),
        );
      }).toList(),
      controller: _controller,
    );
  }

  void startAnimating(){
    _timer?.cancel();
    _timer = new Timer.periodic(widget.displayDuration,(_) => this._controller.animateTo(
      this.nextIndex,
      curve: widget.animationCurve,
      duration: widget.animationDuration
    ));
  }






}
