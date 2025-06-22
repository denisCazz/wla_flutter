import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../theme/app_shadows.dart';

/// Bottone ultra moderno con animazioni e accessibilità
class ModernButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final String? text;
  final IconData? icon;
  final ModernButtonVariant variant;
  final ModernButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final String? semanticLabel;
  final Color? customColor;

  const ModernButton({
    super.key,
    required this.onPressed,
    this.child,
    this.text,
    this.icon,
    this.variant = ModernButtonVariant.primary,
    this.size = ModernButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.semanticLabel,
    this.customColor,
  }) : assert(child != null || text != null, 'Either child or text must be provided');

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
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
    if (widget.onPressed != null && !widget.isLoading) {
      _animationController.forward();
    }
  }

  void _handleTapUp(_) {
    if (widget.onPressed != null && !widget.isLoading) {
      _animationController.reverse();
      widget.onPressed!();
    }
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final buttonConfig = _getButtonConfig(colorScheme);
    
    return Semantics(
      label: widget.semanticLabel ?? widget.text,
      button: true,
      enabled: widget.onPressed != null && !widget.isLoading,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  width: widget.isFullWidth ? double.infinity : null,
                  padding: buttonConfig.padding,
                  decoration: BoxDecoration(
                    gradient: buttonConfig.gradient,
                    borderRadius: BorderRadius.circular(buttonConfig.borderRadius),
                    border: buttonConfig.border,
                    boxShadow: _isHovered && widget.onPressed != null
                        ? buttonConfig.hoverShadows
                        : buttonConfig.shadows,
                  ),
                  child: Row(
                    mainAxisSize: widget.isFullWidth ? MainAxisSize.max : MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.isLoading)
                        SizedBox(
                          width: buttonConfig.iconSize,
                          height: buttonConfig.iconSize,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: buttonConfig.contentColor,
                          ),
                        )
                      else if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          size: buttonConfig.iconSize,
                          color: buttonConfig.contentColor,
                        ),
                        if (widget.text != null || widget.child != null)
                          SizedBox(width: AppSpacing.sm),
                      ],
                      if (!widget.isLoading && (widget.text != null || widget.child != null))
                        widget.child ?? Text(
                          widget.text!,
                          style: buttonConfig.textStyle.copyWith(
                            color: buttonConfig.contentColor,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _ButtonConfig _getButtonConfig(ColorScheme colorScheme) {
    final baseColor = widget.customColor ?? AppColors.primary;
    
    switch (widget.variant) {
      case ModernButtonVariant.primary:
        return _ButtonConfig(
          gradient: LinearGradient(
            colors: [baseColor, baseColor.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          contentColor: Colors.white,
          shadows: AppShadows.coloredShadow(baseColor, intensity: 0.5),
          hoverShadows: AppShadows.coloredShadow(baseColor, intensity: 1.0),
          size: widget.size,
        );
        
      case ModernButtonVariant.secondary:
        return _ButtonConfig(
          gradient: LinearGradient(
            colors: [
              colorScheme.surface,
              colorScheme.surface.withOpacity(0.8),
            ],
          ),
          contentColor: colorScheme.onSurface,
          border: Border.all(color: colorScheme.outline),
          shadows: AppShadows.of(context).medium,
          hoverShadows: AppShadows.of(context).large,
          size: widget.size,
        );
        
      case ModernButtonVariant.ghost:
        return _ButtonConfig(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.transparent],
          ),
          contentColor: baseColor,
          shadows: [],
          hoverShadows: [
            BoxShadow(
              color: baseColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          size: widget.size,
        );
        
      case ModernButtonVariant.danger:
        return _ButtonConfig(
          gradient: LinearGradient(
            colors: [AppColors.error, AppColors.error.withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          contentColor: Colors.white,
          shadows: AppShadows.coloredShadow(AppColors.error, intensity: 0.5),
          hoverShadows: AppShadows.coloredShadow(AppColors.error, intensity: 1.0),
          size: widget.size,
        );
    }
  }
}

enum ModernButtonVariant { primary, secondary, ghost, danger }

enum ModernButtonSize { small, medium, large }

class _ButtonConfig {
  final LinearGradient gradient;
  final Color contentColor;
  final Border? border;
  final List<BoxShadow> shadows;
  final List<BoxShadow> hoverShadows;
  final ModernButtonSize size;

  _ButtonConfig({
    required this.gradient,
    required this.contentColor,
    required this.shadows,
    required this.hoverShadows,
    required this.size,
    this.border,
  });

  EdgeInsets get padding {
    switch (size) {
      case ModernButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 8);
      case ModernButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20, vertical: 12);
      case ModernButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 28, vertical: 16);
    }
  }

  double get borderRadius {
    switch (size) {
      case ModernButtonSize.small:
        return 8;
      case ModernButtonSize.medium:
        return 12;
      case ModernButtonSize.large:
        return 16;
    }
  }

  double get iconSize {
    switch (size) {
      case ModernButtonSize.small:
        return 16;
      case ModernButtonSize.medium:
        return 20;
      case ModernButtonSize.large:
        return 24;
    }
  }

  TextStyle get textStyle {
    switch (size) {
      case ModernButtonSize.small:
        return AppTypography.labelSmall;
      case ModernButtonSize.medium:
        return AppTypography.labelMedium;
      case ModernButtonSize.large:
        return AppTypography.labelLarge;
    }
  }
}
