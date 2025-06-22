import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_shadows.dart';

/// Container con effetto glass ultra moderno e accessibile
class GlassContainer extends StatefulWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final double blurIntensity;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;
  final bool isInteractive;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final bool enableHoverEffect;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = AppSpacing.borderRadius,
    this.blurIntensity = 10.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.boxShadow,
    this.isInteractive = false,
    this.onTap,
    this.semanticLabel,
    this.enableHoverEffect = true,
  });

  @override
  State<GlassContainer> createState() => _GlassContainerState();
}

class _GlassContainerState extends State<GlassContainer>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(_) {
    if (widget.isInteractive) {
      _animationController.forward();
    }
  }

  void _handleTapUp(_) {
    if (widget.isInteractive) {
      _animationController.reverse();
      widget.onTap?.call();
    }
  }

  void _handleTapCancel() {
    if (widget.isInteractive) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final shadows = widget.boxShadow ?? AppShadows.of(context).glass;
    
    return Semantics(
      label: widget.semanticLabel,
      button: widget.isInteractive,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.isInteractive ? _scaleAnimation.value : 1.0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: widget.width,
                  height: widget.height,
                  margin: widget.margin,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    boxShadow: _isHovered && widget.enableHoverEffect
                        ? AppShadows.of(context).large
                        : shadows,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: widget.blurIntensity,
                        sigmaY: widget.blurIntensity,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.backgroundColor ?? AppColors.glassBackground,
                          borderRadius: BorderRadius.circular(widget.borderRadius),
                          border: Border.all(
                            color: widget.borderColor ?? AppColors.glassBorder,
                            width: widget.borderWidth,
                          ),
                        ),
                        padding: widget.padding,
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Bottone con effetto glass ultra moderno
class GlassButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? borderColor;
  final String? semanticLabel;

  const GlassButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.borderRadius = AppSpacing.borderRadius,
    this.isLoading = false,
    this.backgroundColor,
    this.borderColor,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: width,
      height: height,
      padding: padding ?? AppSpacing.allMd,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor ?? AppColors.primary.withOpacity(0.2),
      borderColor: borderColor ?? AppColors.primary.withOpacity(0.3),
      isInteractive: true,
      onTap: isLoading ? null : onPressed,
      semanticLabel: semanticLabel,
      child: isLoading
          ? const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.textPrimary,
                ),
              ),
            )
          : child,
    );
  }
}
