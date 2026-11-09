import 'package:flutter/material.dart';

// Shared motion timing constants
const Duration kRouteForward = Duration(milliseconds: 800);
const Duration kRouteReverse = Duration(milliseconds: 650);
const Duration kTab = Duration(milliseconds: 380);
const Duration kFast = Duration(milliseconds: 220);

// Shared motion curves
const Curve kEmphasized = Curves.easeInOutCubicEmphasized;
const Curve kDecel = Curves.easeOutCubic;

/// Custom route builder for product card -> product details transition.
///
/// Transitions:
/// - 800ms forward duration, 650ms reverse duration.
/// - Background fade in over Interval(0.0, 0.35) so the white page appears
///   quickly behind the flying Hero image.
/// - In reverse, background fades out over Interval(0.65, 1.0) while the Hero image
///   lands back on the product card.
/// - Listens for edge swipe gestures on iOS and responds to Android back gesture.
Route<T> productDetailsRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: kRouteForward,
    reverseTransitionDuration: kRouteReverse,
    pageBuilder: (context, animation, secondaryAnimation) =>
        EdgeSwipeBackWrapper(child: page),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final backgroundFade = CurvedAnimation(
        parent: animation,
        curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
        reverseCurve: const Interval(0.65, 1.0, curve: Curves.easeOut),
      );
      return FadeTransition(
        opacity: backgroundFade,
        child: child,
      );
    },
  );
}

/// Route transition that fades in and scales up the destination page over [duration].
/// Used for Order Confirmed celebration transition.
Route<T> fadeScaleRoute<T>(
  Widget page, {
  Duration duration = const Duration(milliseconds: 500),
}) {
  return PageRouteBuilder<T>(
    transitionDuration: duration,
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.90, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Detects horizontal drag gestures originating from the left screen edge
/// to enable iOS-style edge swipe to pop without competing in Flutter's gesture arena.
class EdgeSwipeBackWrapper extends StatefulWidget {
  final Widget child;
  final double edgeThreshold;
  final double triggerDistance;

  const EdgeSwipeBackWrapper({
    super.key,
    required this.child,
    this.edgeThreshold = 36.0,
    this.triggerDistance = 40.0,
  });

  @override
  State<EdgeSwipeBackWrapper> createState() => _EdgeSwipeBackWrapperState();
}

class _EdgeSwipeBackWrapperState extends State<EdgeSwipeBackWrapper> {
  double? _startX;
  double? _startY;
  bool _didTriggerPop = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) {
        if (event.position.dx <= widget.edgeThreshold) {
          _startX = event.position.dx;
          _startY = event.position.dy;
          _didTriggerPop = false;
        } else {
          _startX = null;
          _startY = null;
        }
      },
      onPointerMove: (event) {
        if (_startX != null && !_didTriggerPop) {
          final dx = event.position.dx - _startX!;
          final dy = (event.position.dy - (_startY ?? event.position.dy)).abs();
          // Predominantly horizontal swipe to the right
          if (dx > widget.triggerDistance && dy < dx * 0.8) {
            _didTriggerPop = true;
            _startX = null;
            Navigator.maybePop(context);
          }
        }
      },
      onPointerUp: (_) {
        _startX = null;
        _startY = null;
      },
      onPointerCancel: (_) {
        _startX = null;
        _startY = null;
      },
      child: widget.child,
    );
  }
}

/// Reusable widget for staggered motion sections inside page transitions.
///
/// On forward route transition:
/// - Fades in and slides up by [slideOffset] over [startInterval, endInterval]
///   curved by [kDecel].
///
/// On reverse route transition:
/// - Fades out quickly over reverse interval [0.0, 0.3] curved by [Curves.easeIn]
///   so content disappears cleanly while the Hero image flies back to the origin card.
class StaggeredMotionSection extends StatefulWidget {
  final Animation<double>? animation;
  final double startInterval;
  final double endInterval;
  final double slideOffset;
  final Widget child;

  const StaggeredMotionSection({
    super.key,
    required this.animation,
    required this.startInterval,
    this.endInterval = 1.0,
    this.slideOffset = 24.0,
    required this.child,
  });

  @override
  State<StaggeredMotionSection> createState() => _StaggeredMotionSectionState();
}

class _StaggeredMotionSectionState extends State<StaggeredMotionSection> {
  CurvedAnimation? _curved;

  @override
  void initState() {
    super.initState();
    _initCurved();
  }

  @override
  void didUpdateWidget(covariant StaggeredMotionSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation != widget.animation ||
        oldWidget.startInterval != widget.startInterval ||
        oldWidget.endInterval != widget.endInterval) {
      _curved?.dispose();
      _initCurved();
    }
  }

  void _initCurved() {
    if (widget.animation != null) {
      _curved = CurvedAnimation(
        parent: widget.animation!,
        curve: Interval(widget.startInterval, widget.endInterval, curve: kDecel),
        reverseCurve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      );
    }
  }

  @override
  void dispose() {
    _curved?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_curved == null) return widget.child;

    return AnimatedBuilder(
      animation: _curved!,
      builder: (context, child) {
        final t = _curved!.value.clamp(0.0, 1.0);
        return Opacity(
          opacity: t,
          child: Transform.translate(
            offset: Offset(0, widget.slideOffset * (1.0 - t)),
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

