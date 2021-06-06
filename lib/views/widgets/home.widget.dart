import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myapp/views/widgets/event.widget.dart';

class Home extends StatefulWidget {
  const Home({
    required this.contentSize,
    required this.builder,
    this.swipePositionThreshold = 0.20,
    this.swipeVelocityThreshold = 2000,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  final int contentSize;
  final IndexedWidgetBuilder builder;
  final double swipePositionThreshold;
  final double swipeVelocityThreshold;
  final Duration animationDuration;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late Size _containerSize;
  late double _cardOffset;
  late double _dragStartPosition;
  late AnimationController _animationController;
  late Animation<double> _animation;
  late int _cardIndex;
  late DragState _dragState;

  @override
  void initState() {
    _cardOffset = 0;
    _dragStartPosition = 0;
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _cardIndex = 0;
    _dragState = DragState.idle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      /// Takes the size of the container, not the whole screen size
      _containerSize = constraints.biggest;

      return Stack(
        children: <Widget>[
          if (_cardIndex > 0)
            Positioned(
              bottom: _containerSize.height - _cardOffset,
              child: SizedBox.fromSize(
                size: _containerSize,
                child: Event(),
              ),
            ),
          Positioned(
            top: _cardOffset,
            child: GestureDetector(
              child: SizedBox.fromSize(
                  size: _containerSize,
                  child: Event()
              ),
              onVerticalDragStart: (DragStartDetails details) {
                setState(() {
                  _dragState = DragState.dragging;
                  _dragStartPosition = details.localPosition.dy;
                });
              },
              onVerticalDragUpdate: (DragUpdateDetails details) {
                setState(() {
                  _cardOffset = details.localPosition.dy - _dragStartPosition;
                });
              },
              onVerticalDragEnd: (DragEndDetails details) {
                setState(() {
                  _dragState = detemineDragState(details);
                });
                _createAnimation();
              },
            ),
          ),
          if (_cardIndex < widget.contentSize - 1)
            Positioned(
              top: _containerSize.height + _cardOffset,
              child: SizedBox.fromSize(
                size: _containerSize,
                child: Event(),
              ),
            ),
        ],
      );
    });
  }

  void _createAnimation() {
    double _end;
    switch (_dragState) {
      case DragState.animatingForward:
        _end = -_containerSize.height;
        break;
      case DragState.animatingBackward:
        _end = _containerSize.height;
        break;
      case DragState.animatingToCancel:
      default:
        _end = 0;
    }
    _animation = Tween<double>(begin: _cardOffset, end: _end)
        .animate(_animationController)
          ..addListener(_animationListener)
          ..addStatusListener((AnimationStatus _status) {
            switch (_status) {
              case AnimationStatus.completed:
                // change the card index if required,
                // change the offset back to zero,
                // change the drag state back to idle
                int _newCardIndex = _cardIndex;
                switch (_dragState) {
                  case DragState.animatingForward:
                    _newCardIndex++;
                    break;
                  case DragState.animatingBackward:
                    _newCardIndex--;
                    break;
                  case DragState.animatingToCancel:
                    //no change to card index
                    break;
                  default:
                }

                if (_status != AnimationStatus.dismissed &&
                    _status != AnimationStatus.forward) {
                  setState(() {
                    _cardIndex = _newCardIndex;
                    _dragState = DragState.idle;
                    _cardOffset = 0;
                  });
                  _animation.removeListener(_animationListener);
                  _animationController.reset();
                }
                break;
              default:
            }
          });
    _animationController.forward();
  }

  void _animationListener() {
    setState(() {
      _cardOffset = _animation.value;
    });
  }

  DragState detemineDragState(DragEndDetails details) {
    if (shouldAnimateForward(details)) {
      return DragState.animatingForward;
    } else if (shouldAnimateBackward(details)) {
      return DragState.animatingBackward;
    } else {
      return DragState.animatingToCancel;
    }
  }

  bool shouldAnimateForward(DragEndDetails details) {
    var isPastPositionThreshold = _cardOffset < -_containerSize.height * widget.swipePositionThreshold;
    var isPastVelocityThreshold = details.primaryVelocity! < -widget.swipeVelocityThreshold;
    var hasMoreCards = _cardIndex < widget.contentSize - 1;
    return ( isPastPositionThreshold || isPastVelocityThreshold) && hasMoreCards;
  }

  bool shouldAnimateBackward(DragEndDetails details) {
    var isPastPositionThreshold = _cardOffset > _containerSize.height / widget.swipePositionThreshold;
    var isPastVelocityThreshold = details.primaryVelocity! > widget.swipeVelocityThreshold;
    var hasMoreCards = _cardIndex > 0;
    return ( isPastPositionThreshold || isPastVelocityThreshold) && hasMoreCards;
  }
}

enum DragState {
  idle,
  dragging,
  animatingForward,
  animatingBackward,
  animatingToCancel,
}