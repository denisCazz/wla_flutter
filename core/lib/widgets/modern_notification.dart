import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

import '../theme/app_icons.dart';
import '../theme/app_animations.dart';
import 'glass_container.dart';

/// Widget ultra moderno per le notifiche toast
class ModernNotification extends StatefulWidget {
  final String title;
  final String? message;
  final ModernNotificationType type;
  final Duration duration;
  final VoidCallback? onDismiss;
  final VoidCallback? onTap;
  final bool showCloseButton;
  final bool autoHide;
  final Widget? customIcon;
  final List<ModernNotificationAction> actions;

  const ModernNotification({
    super.key,
    required this.title,
    this.message,
    this.type = ModernNotificationType.info,
    this.duration = const Duration(seconds: 4),
    this.onDismiss,
    this.onTap,
    this.showCloseButton = true,
    this.autoHide = true,
    this.customIcon,
    this.actions = const [],
  });

  @override
  State<ModernNotification> createState() => _ModernNotificationState();
}

class _ModernNotificationState extends State<ModernNotification>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late AnimationController _progressController;
  
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: AppAnimations.normal,
      vsync: this,
    );
    
    _fadeController = AnimationController(
      duration: AppAnimations.fast,
      vsync: this,
    );
    
    _progressController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: AppAnimations.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_fadeController);

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: AppAnimations.easeInOut,
    ));

    _progressAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.linear,
    ));

    // Avvia le animazioni
    _fadeController.forward();
    _slideController.forward();
    
    if (widget.autoHide) {
      _progressController.forward().then((_) {
        if (mounted) _dismiss();
      });
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  void _dismiss() async {
    if (widget.autoHide) {
      _progressController.stop();
    }
    
    await _fadeController.reverse();
    await _slideController.reverse();
    
    if (mounted) {
      widget.onDismiss?.call();
    }
  }

  void _handleHover(bool isHovered) {
    setState(() => _isHovered = isHovered);
    
    if (widget.autoHide) {
      if (isHovered) {
        _progressController.stop();
      } else {
        _progressController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_slideController, _fadeController]),
      builder: (context, child) {
        return SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: _buildNotification(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotification() {
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          margin: EdgeInsets.all(AppSpacing.sm),
          child: GlassContainer(
            padding: EdgeInsets.all(AppSpacing.md),
            backgroundColor: _getBackgroundColor().withOpacity(0.9),
            borderColor: _getBorderColor(),
            borderRadius: AppSpacing.borderRadiusLarge,
            blurIntensity: _isHovered ? 20 : 15,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                if (widget.message != null) ...[
                  SizedBox(height: AppSpacing.xs),
                  _buildMessage(),
                ],
                if (widget.actions.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.sm),
                  _buildActions(),
                ],
                if (widget.autoHide)
                  _buildProgressBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildIcon(),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _getTextColor(),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (widget.showCloseButton) ...[
          SizedBox(width: AppSpacing.sm),
          _buildCloseButton(),
        ],
      ],
    );
  }

  Widget _buildIcon() {
    final icon = widget.customIcon ?? Icon(
      _getIconData(),
      color: _getIconColor(),
      size: 24,
    );

    return AnimatedScale(
      scale: _isHovered ? 1.1 : 1.0,
      duration: AppAnimations.fast,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: _getIconColor().withOpacity(0.2),
          borderRadius: BorderRadius.circular(AppSpacing.borderRadiusSmall),
        ),
        child: icon,
      ),
    );
  }

  Widget _buildMessage() {
    return Text(
      widget.message!,
      style: TextStyle(
        fontSize: 14,
        color: _getTextColor().withOpacity(0.8),
      ),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: widget.actions.map((action) {
        return Padding(
          padding: EdgeInsets.only(left: AppSpacing.sm),
          child: TextButton(
            onPressed: action.onPressed,
            style: TextButton.styleFrom(
              foregroundColor: _getIconColor(),
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
            ),
            child: Text(
              action.label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCloseButton() {
    return GestureDetector(
      onTap: _dismiss,
      child: AnimatedContainer(
      duration: AppAnimations.fast,
        padding: EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: _isHovered 
              ? Colors.white.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.xs),
        ),
        child: Icon(
          AppIcons.close,
          size: 18,
          color: _getTextColor().withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Column(
          children: [
            SizedBox(height: AppSpacing.sm),
            Container(
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _progressAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: _getIconColor(),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _getIconData() {
    switch (widget.type) {
      case ModernNotificationType.success:
        return AppIcons.success;
      case ModernNotificationType.error:
        return AppIcons.error;
      case ModernNotificationType.warning:
        return AppIcons.warning;
      case ModernNotificationType.info:
        return AppIcons.info;
    }
  }

  Color _getBackgroundColor() {
    switch (widget.type) {
      case ModernNotificationType.success:
        return AppColors.success;
      case ModernNotificationType.error:
        return AppColors.error;
      case ModernNotificationType.warning:
        return AppColors.warning;
      case ModernNotificationType.info:
        return AppColors.primary;
    }
  }

  Color _getBorderColor() {
    return _getIconColor().withOpacity(0.3);
  }

  Color _getIconColor() {
    switch (widget.type) {
      case ModernNotificationType.success:
        return AppColors.success;
      case ModernNotificationType.error:
        return AppColors.error;
      case ModernNotificationType.warning:
        return AppColors.warning;
      case ModernNotificationType.info:
        return AppColors.primary;
    }
  }

  Color _getTextColor() {
    return Colors.white;
  }
}

/// Tipi di notifica disponibili
enum ModernNotificationType {
  success,
  error,
  warning,
  info,
}

/// Azione per notifica
class ModernNotificationAction {
  final String label;
  final VoidCallback onPressed;

  const ModernNotificationAction({
    required this.label,
    required this.onPressed,
  });
}

/// Service per gestire le notifiche a livello globale
class ModernNotificationService {
  static final List<OverlayEntry> _activeNotifications = [];
  static OverlayState? _overlay;

  static void init(OverlayState overlay) {
    _overlay = overlay;
  }

  static void show(
    BuildContext context, {
    required String title,
    String? message,
    ModernNotificationType type = ModernNotificationType.info,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onTap,
    List<ModernNotificationAction> actions = const [],
  }) {
    if (_overlay == null) {
      _overlay = Overlay.of(context);
    }

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + AppSpacing.md,
        right: AppSpacing.md,
        child: ModernNotification(
          title: title,
          message: message,
          type: type,
          duration: duration,
          onTap: onTap,
          actions: actions,
          onDismiss: () {
            _removeNotification(overlayEntry);
          },
        ),
      ),
    );

    _activeNotifications.add(overlayEntry);
    _overlay!.insert(overlayEntry);

    // Rimuovi automaticamente dopo la durata
    Future.delayed(duration + const Duration(milliseconds: 500), () {
      _removeNotification(overlayEntry);
    });
  }

  static void _removeNotification(OverlayEntry entry) {
    if (_activeNotifications.contains(entry)) {
      entry.remove();
      _activeNotifications.remove(entry);
    }
  }

  static void clearAll() {
    for (final entry in _activeNotifications) {
      entry.remove();
    }
    _activeNotifications.clear();
  }

  // Metodi di convenienza
  static void success(
    BuildContext context, {
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context,
      title: title,
      message: message,
      type: ModernNotificationType.success,
      duration: duration,
    );
  }

  static void error(
    BuildContext context, {
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 5),
  }) {
    show(
      context,
      title: title,
      message: message,
      type: ModernNotificationType.error,
      duration: duration,
    );
  }

  static void warning(
    BuildContext context, {
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      title: title,
      message: message,
      type: ModernNotificationType.warning,
      duration: duration,
    );
  }

  static void info(
    BuildContext context, {
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      title: title,
      message: message,
      type: ModernNotificationType.info,
      duration: duration,
    );
  }
}
