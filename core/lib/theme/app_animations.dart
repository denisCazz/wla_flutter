import 'package:flutter/material.dart';

/// Sistema di animazioni consistenti per l'app
class AppAnimations {
  // Durate standard
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  // Curve standard
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve elasticOut = Curves.elasticOut;

  // Animazioni di transizione per pagine
  static PageRouteBuilder<T> slideTransition<T>({
    required Widget child,
    required RouteSettings settings,
    SlideDirection direction = SlideDirection.right,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin;
        switch (direction) {
          case SlideDirection.up:
            begin = const Offset(0.0, 1.0);
            break;
          case SlideDirection.down:
            begin = const Offset(0.0, -1.0);
            break;
          case SlideDirection.left:
            begin = const Offset(-1.0, 0.0);
            break;
          case SlideDirection.right:
            begin = const Offset(1.0, 0.0);
            break;
        }

        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final offsetAnimation = animation.drive(tween.chain(
          CurveTween(curve: easeInOut),
        ));

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: normal,
    );
  }

  static PageRouteBuilder<T> fadeTransition<T>({
    required Widget child,
    required RouteSettings settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: normal,
    );
  }

  static PageRouteBuilder<T> scaleTransition<T>({
    required Widget child,
    required RouteSettings settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: elasticOut,
          )),
          child: child,
        );
      },
      transitionDuration: slow,
    );
  }
}

enum SlideDirection { up, down, left, right }

/// Widget per animazioni di stagger (effetto cascade)
class StaggeredAnimation extends StatefulWidget {
  final List<Widget> children;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final Axis direction;

  const StaggeredAnimation({
    super.key,
    required this.children,
    this.delay = const Duration(milliseconds: 100),
    this.duration = AppAnimations.normal,
    this.curve = AppAnimations.easeOut,
    this.direction = Axis.vertical,
  });

  @override
  State<StaggeredAnimation> createState() => _StaggeredAnimationState();
}

class _StaggeredAnimationState extends State<StaggeredAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _controllers = List.generate(
      widget.children.length,
      (index) => AnimationController(
        duration: widget.duration,
        vsync: this,
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: widget.curve,
      ));
    }).toList();
  }

  void _startAnimations() {
    for (int i = 0; i < _controllers.length; i++) {
      Future.delayed(widget.delay * i, () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.direction == Axis.vertical
        ? Column(
            children: _buildAnimatedChildren(),
          )
        : Row(
            children: _buildAnimatedChildren(),
          );
  }

  List<Widget> _buildAnimatedChildren() {
    return List.generate(widget.children.length, (index) {
      return AnimatedBuilder(
        animation: _animations[index],
        builder: (context, child) {
          return Transform.translate(
            offset: widget.direction == Axis.vertical
                ? Offset(0, 20 * (1 - _animations[index].value))
                : Offset(20 * (1 - _animations[index].value), 0),
            child: Opacity(
              opacity: _animations[index].value,
              child: widget.children[index],
            ),
          );
        },
      );
    });
  }
}

/// Widget per animazioni al scroll
class ScrollAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final double threshold;

  const ScrollAnimation({
    super.key,
    required this.child,
    this.duration = AppAnimations.normal,
    this.curve = AppAnimations.easeOut,
    this.threshold = 0.1,
  });

  @override
  State<ScrollAnimation> createState() => _ScrollAnimationState();
}

class _ScrollAnimationState extends State<ScrollAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkVisibility(double visibleFraction) {
    if (!_hasAnimated && visibleFraction >= widget.threshold) {
      _hasAnimated = true;
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final position = renderBox.localToGlobal(Offset.zero);
          final size = renderBox.size;
          final screenHeight = MediaQuery.of(context).size.height;
          
          final visibleTop = position.dy;
          final visibleBottom = position.dy + size.height;
          
          if (visibleTop < screenHeight && visibleBottom > 0) {
            final visibleHeight = (screenHeight - visibleTop).clamp(0.0, size.height);
            final visibleFraction = visibleHeight / size.height;
            _checkVisibility(visibleFraction);
          }
        }
        return false;
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, 30 * (1 - _animation.value)),
            child: Opacity(
              opacity: _animation.value,
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}

/// Mixin per hover effects
mixin HoverAnimationMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late AnimationController hoverController;
  late Animation<double> hoverAnimation;
  bool isHovered = false;

  @override
  void initState() {
    super.initState();
    hoverController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    hoverAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: hoverController,
      curve: AppAnimations.easeOut,
    ));
  }

  @override
  void dispose() {
    hoverController.dispose();
    super.dispose();
  }

  void onHoverEnter() {
    setState(() => isHovered = true);
    hoverController.forward();
  }

  void onHoverExit() {
    setState(() => isHovered = false);
    hoverController.reverse();
  }

  Widget buildHoverEffect({required Widget child}) {
    return MouseRegion(
      onEnter: (_) => onHoverEnter(),
      onExit: (_) => onHoverExit(),
      child: AnimatedBuilder(
        animation: hoverAnimation,
        builder: (context, _) {
          return Transform.scale(
            scale: hoverAnimation.value,
            child: child,
          );
        },
      ),
    );
  }
}
