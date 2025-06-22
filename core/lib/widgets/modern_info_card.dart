import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_icons.dart';
import '../theme/app_animations.dart';
import 'glass_container.dart';

/// Widget moderno per mostrare informazioni di una card
class ModernInfoCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String? value;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isLoading;
  final ModernInfoCardVariant variant;
  final ModernInfoCardSize size;

  const ModernInfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.value,
    this.iconColor,
    this.onTap,
    this.trailing,
    this.isLoading = false,
    this.variant = ModernInfoCardVariant.elevated,
    this.size = ModernInfoCardSize.medium,
  });

  @override
  State<ModernInfoCard> createState() => _ModernInfoCardState();
}

class _ModernInfoCardState extends State<ModernInfoCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;
  bool _isPressed = false;

  // Default shadows for different states
  static const List<BoxShadow> _defaultShadowLow = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];

  static const List<BoxShadow> _defaultShadowMedium = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -1,
    ),
    BoxShadow(
      color: Color(0x19000000),
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: -1,
    ),
  ];

  static const List<BoxShadow> _defaultShadowHigh = [
    BoxShadow(
      color: Color(0x0F000000),
      offset: Offset(0, 10),
      blurRadius: 15,
      spreadRadius: -3,
    ),
    BoxShadow(
      color: Color(0x19000000),
      offset: Offset(0, 4),
      blurRadius: 6,
      spreadRadius: -2,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: AppAnimations.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (widget.onTap != null) {
      setState(() => _isPressed = false);
      _animationController.reverse();
      widget.onTap?.call();
    }
  }

  void _handleTapCancel() {
    if (widget.onTap != null) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  void _handleHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: MouseRegion(
              onEnter: (_) => _handleHover(true),
              onExit: (_) => _handleHover(false),
              child: AnimatedContainer(
                duration: AppAnimations.normal,
                curve: AppAnimations.easeInOut,
                child: _buildCardContent(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardContent() {
    switch (widget.variant) {
      case ModernInfoCardVariant.elevated:
        return _buildElevatedCard();
      case ModernInfoCardVariant.filled:
        return _buildFilledCard();
      case ModernInfoCardVariant.outlined:
        return _buildOutlinedCard();
      case ModernInfoCardVariant.glass:
        return _buildGlassCard();
      case ModernInfoCardVariant.gradient:
        return _buildGradientCard();
    }
  }

  Widget _buildElevatedCard() {
    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: AppColors.glassBackground,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        boxShadow: [
          if (_isHovered)
            ..._defaultShadowHigh
          else if (_isPressed)
            ..._defaultShadowLow
          else
            ..._defaultShadowMedium,
        ],
      ),
      child: _buildContent(),
    );
  }

  Widget _buildFilledCard() {
    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: _isHovered 
            ? AppColors.glassBackground.withOpacity(0.8)
            : AppColors.glassBackground,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        border: Border.all(
          color: _isPressed 
              ? AppColors.primary
              : AppColors.glassBorder,
        ),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildOutlinedCard() {
    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: _isHovered 
            ? AppColors.primary.withOpacity(0.05)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        border: Border.all(
          color: _isPressed 
              ? AppColors.primary
              : AppColors.glassBorder,
          width: _isHovered ? 2 : 1,
        ),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildGlassCard() {
    return GlassContainer(
      padding: _getPadding(),
      borderRadius: AppSpacing.borderRadius,
      child: _buildContent(),
    );
  }

  Widget _buildGradientCard() {
    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _isHovered
              ? [
                  AppColors.primary.withOpacity(0.2),
                  AppColors.secondary.withOpacity(0.1),
                ]
              : [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.secondary.withOpacity(0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadius),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
        ),
      ),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Row(
      children: [
        _buildIcon(),
        SizedBox(width: _getIconSpacing()),
        Expanded(child: _buildTextContent()),
        if (widget.trailing != null) ...[
          SizedBox(width: AppSpacing.sm),
          widget.trailing!,
        ],
        if (widget.onTap != null && widget.trailing == null) ...[
          SizedBox(width: AppSpacing.sm),
          Icon(
            AppIcons.forward,
            size: _getIconSize() * 0.8,
            color: AppColors.textSecondary,
          ),
        ],
      ],
    );
  }

  Widget _buildIcon() {
    final iconSize = _getIconSize();
    
    if (widget.isLoading) {
      return SizedBox(
        width: iconSize,
        height: iconSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.iconColor ?? AppColors.primary,
          ),
        ),
      );
    }

    return AnimatedScale(
      scale: _isHovered ? 1.1 : 1.0,
      duration: AppAnimations.fast,
      child: Container(
        width: iconSize,
        height: iconSize,
        decoration: BoxDecoration(
          color: (widget.iconColor ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSmall),
        ),
        child: Icon(
          widget.icon,
          size: iconSize * 0.6,
          color: widget.iconColor ?? AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.title,
          style: _getTitleStyle(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          widget.subtitle,
          style: _getSubtitleStyle(),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        if (widget.value != null) ...[
          SizedBox(height: AppSpacing.xs),
          Text(
            widget.value!,
            style: _getValueStyle(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  EdgeInsets _getPadding() {
    switch (widget.size) {
      case ModernInfoCardSize.small:
        return EdgeInsets.all(AppSpacing.sm);
      case ModernInfoCardSize.medium:
        return EdgeInsets.all(AppSpacing.md);
      case ModernInfoCardSize.large:
        return EdgeInsets.all(AppSpacing.lg);
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case ModernInfoCardSize.small:
        return 32;
      case ModernInfoCardSize.medium:
        return 40;
      case ModernInfoCardSize.large:
        return 48;
    }
  }

  double _getIconSpacing() {
    switch (widget.size) {
      case ModernInfoCardSize.small:
        return AppSpacing.sm;
      case ModernInfoCardSize.medium:
        return AppSpacing.md;
      case ModernInfoCardSize.large:
        return AppSpacing.lg;
    }
  }

  TextStyle _getTitleStyle() {
    switch (widget.size) {
      case ModernInfoCardSize.small:
        return const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        );
      case ModernInfoCardSize.medium:
        return const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        );
      case ModernInfoCardSize.large:
        return const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        );
    }
  }

  TextStyle _getSubtitleStyle() {
    switch (widget.size) {
      case ModernInfoCardSize.small:
        return const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        );
      case ModernInfoCardSize.medium:
        return const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        );
      case ModernInfoCardSize.large:
        return const TextStyle(
          fontSize: 16,
          color: AppColors.textSecondary,
        );
    }
  }

  TextStyle _getValueStyle() {
    switch (widget.size) {
      case ModernInfoCardSize.small:
        return const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        );
      case ModernInfoCardSize.medium:
        return const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        );
      case ModernInfoCardSize.large:
        return const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        );
    }
  }
}

/// Varianti di stile per ModernInfoCard
enum ModernInfoCardVariant {
  elevated,
  filled,
  outlined,
  glass,
  gradient,
}

/// Dimensioni per ModernInfoCard
enum ModernInfoCardSize {
  small,
  medium,
  large,
}
