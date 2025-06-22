import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';

/// Card ultra moderna con effetti avanzati e accessibilità
class ModernCard extends StatefulWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final ModernCardVariant variant;
  final bool enableHoverEffect;
  final bool enablePressEffect;
  final String? semanticLabel;
  final Color? customColor;

  const ModernCard({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.padding,
    this.margin,
    this.variant = ModernCardVariant.elevated,
    this.enableHoverEffect = true,
    this.enablePressEffect = true,
    this.semanticLabel,
    this.customColor,
  });

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isPressed = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
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
    if (widget.onTap != null && widget.enablePressEffect) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _handleTapUp(_) {
    if (widget.onTap != null) {
      setState(() => _isPressed = false);
      _animationController.reverse();
      widget.onTap!();
    }
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardConfig = _getCardConfig(colorScheme);

    return Semantics(
      label: widget.semanticLabel ?? widget.title,
      button: widget.onTap != null,
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
                scale: widget.enablePressEffect && widget.onTap != null
                    ? _scaleAnimation.value
                    : 1.0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: widget.margin ?? AppSpacing.allSm,
                  decoration: BoxDecoration(
                    color: cardConfig.backgroundColor,
                    gradient: cardConfig.gradient,
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLarge),
                    border: cardConfig.border,
                    boxShadow: _isHovered && widget.enableHoverEffect
                        ? cardConfig.hoverShadows
                        : cardConfig.shadows,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.borderRadiusLarge),
                    child: Material(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.title != null || widget.leading != null || widget.trailing != null)
                            _buildHeader(cardConfig),
                          Padding(
                            padding: widget.padding ?? AppSpacing.allMd,
                            child: widget.child,
                          ),
                        ],
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

  Widget _buildHeader(_CardConfig config) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          if (widget.leading != null) ...[
            widget.leading!,
            AppSpacing.horizontalSpaceMd,
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.title != null)
                  Text(
                    widget.title!,
                    style: AppTypography.titleMedium.copyWith(
                      color: config.titleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (widget.subtitle != null) ...[
                  AppSpacing.verticalSpaceXs,
                  Text(
                    widget.subtitle!,
                    style: AppTypography.bodySmall.copyWith(
                      color: config.subtitleColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (widget.trailing != null) ...[
            AppSpacing.horizontalSpaceMd,
            widget.trailing!,
          ],
        ],
      ),
    );
  }

  _CardConfig _getCardConfig(ColorScheme colorScheme) {
    switch (widget.variant) {
      case ModernCardVariant.elevated:
        return _CardConfig(
          backgroundColor: colorScheme.surface,
          titleColor: colorScheme.onSurface,
          subtitleColor: colorScheme.onSurface.withOpacity(0.7),
          shadows: AppShadows.of(context).medium,
          hoverShadows: AppShadows.of(context).large,
        );

      case ModernCardVariant.filled:
        return _CardConfig(
          backgroundColor: colorScheme.surfaceVariant,
          titleColor: colorScheme.onSurfaceVariant,
          subtitleColor: colorScheme.onSurfaceVariant.withOpacity(0.7),
          shadows: [],
          hoverShadows: AppShadows.of(context).small,
        );

      case ModernCardVariant.outlined:
        return _CardConfig(
          backgroundColor: colorScheme.surface,
          titleColor: colorScheme.onSurface,
          subtitleColor: colorScheme.onSurface.withOpacity(0.7),
          border: Border.all(color: colorScheme.outline),
          shadows: [],
          hoverShadows: AppShadows.of(context).small,
        );

      case ModernCardVariant.glass:
        return _CardConfig(
          backgroundColor: AppColors.glassBackground,
          titleColor: AppColors.textPrimary,
          subtitleColor: AppColors.textSecondary,
          border: Border.all(color: AppColors.glassBorder),
          shadows: AppShadows.of(context).glass,
          hoverShadows: AppShadows.of(context).large,
        );

      case ModernCardVariant.gradient:
        final primaryColor = widget.customColor ?? AppColors.primary;
        return _CardConfig(
          gradient: LinearGradient(
            colors: [
              primaryColor.withOpacity(0.1),
              primaryColor.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          titleColor: colorScheme.onSurface,
          subtitleColor: colorScheme.onSurface.withOpacity(0.7),
          border: Border.all(color: primaryColor.withOpacity(0.2)),
          shadows: AppShadows.coloredShadow(primaryColor, intensity: 0.3),
          hoverShadows: AppShadows.coloredShadow(primaryColor, intensity: 0.6),
        );
    }
  }
}

enum ModernCardVariant {
  elevated,
  filled,
  outlined,
  glass,
  gradient,
}

class _CardConfig {
  final Color? backgroundColor;
  final LinearGradient? gradient;
  final Color titleColor;
  final Color subtitleColor;
  final Border? border;
  final List<BoxShadow> shadows;
  final List<BoxShadow> hoverShadows;

  _CardConfig({
    this.backgroundColor,
    this.gradient,
    required this.titleColor,
    required this.subtitleColor,
    this.border,
    required this.shadows,
    required this.hoverShadows,
  });
}
