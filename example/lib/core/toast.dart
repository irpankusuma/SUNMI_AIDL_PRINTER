import 'dart:async';

import 'package:flutter/material.dart';

class BlinkingToast {
  bool _isVisible = false;

  /// https://www.didierboelens.com/2018/06/how-to-create-a-toast-or-notifications-notion-of-overlay/
  /// BuildContext context: the context from which we need to retrieve the Overlay
  /// WidgetBuilder externalBuilder: (compulsory) external routine that builds the Widget to be displayed
  /// Duration duration: (optional) duration after which the Widget will be removed
  /// Offset position: (optional) position where you want to show the Widget
  ///
  void show(
      {@required BuildContext context,
      Duration duration = const Duration(seconds: 2),
      Offset position = Offset.zero,
      String message = null,
      String status = 'info'}) async {
    // Prevent from showing multiple Widgets at the same time
    if (_isVisible) {
      return;
    }
    _isVisible = true;
    OverlayState overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = new OverlayEntry(
      builder: (BuildContext context) => new BlinkingToastWidget(
            position: position,
            message: message,
            status: status,
          ),
    );
    overlayState.insert(overlayEntry);
    await new Future.delayed(duration);
    overlayEntry.remove();
    _isVisible = false;
  }

  void alert({
    @required BuildContext context,
    String message,
    bool dismis = true,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: dismis,
      builder: (BuildContext context) {
        return AlertDialog(
            content: new Row(
          children: <Widget>[
            new Flexible(
              child: new Text(
                message.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            )
          ],
        ));
      },
    );
  }
}

class BlinkingToastWidget extends StatefulWidget {
  BlinkingToastWidget(
      {Key key, @required this.position, @required this.message, this.status})
      : super(key: key);

  final Offset position;
  final String message;
  final String status;

  @override
  _BlinkingToastWidgetState createState() => new _BlinkingToastWidgetState();
}

class _BlinkingToastWidgetState extends State<BlinkingToastWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _animation = new Tween(begin: 0.0, end: 1.0).animate(
        new CurvedAnimation(parent: _controller, curve: new Interval(0.0, 0.5)))
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse().orCancel;
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward().orCancel;
        }
      });
    _controller.forward().orCancel;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return new IntrinsicHeight(
      child: Stack(
        children: <Widget>[
          new Positioned(
              top: widget.position.dy,
              right: widget.position.dx,
              child: new IgnorePointer(
                child: new Material(
                  color: Colors.transparent,
                  child: new Opacity(
                      opacity: _animation.value,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        decoration: new BoxDecoration(
                          color: Colors.grey.shade400.withOpacity(0.8),
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(
                              widget.status == 'info'
                                  ? Icons.info
                                  : widget.status == 'warning'
                                      ? Icons.warning
                                      : widget.status == 'error'
                                          ? Icons.error
                                          : Icons.check_circle,
                              color: widget.status == 'info'
                                  ? Colors.blue
                                  : widget.status == 'warning'
                                      ? Colors.yellow
                                      : widget.status == 'error'
                                          ? Colors.red
                                          : Colors.green,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            ),
                            Text(widget.message)
                          ],
                        ),
                      )),
                ),
              ))
        ],
      ),
    );
  }
}
