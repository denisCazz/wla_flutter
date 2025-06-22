import 'package:flutter/material.dart';

/// Sistema di icone consistenti per l'app
class AppIcons {
  // Navigation Icons
  static const IconData home = Icons.home_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData profile = Icons.person_rounded;
  static const IconData menu = Icons.menu_rounded;
  static const IconData back = Icons.arrow_back_ios_rounded;
  static const IconData forward = Icons.arrow_forward_ios_rounded;
  static const IconData close = Icons.close_rounded;
  
  // Action Icons
  static const IconData add = Icons.add_rounded;
  static const IconData remove = Icons.remove_rounded;
  static const IconData edit = Icons.edit_rounded;
  static const IconData delete = Icons.delete_rounded;
  static const IconData save = Icons.save_rounded;
  static const IconData download = Icons.download_rounded;
  static const IconData upload = Icons.upload_rounded;
  static const IconData share = Icons.share_rounded;
  static const IconData copy = Icons.copy_rounded;
  
  // UI State Icons
  static const IconData visible = Icons.visibility_rounded;
  static const IconData hidden = Icons.visibility_off_rounded;
  static const IconData expand = Icons.expand_more_rounded;
  static const IconData collapse = Icons.expand_less_rounded;
  static const IconData refresh = Icons.refresh_rounded;
  static const IconData loading = Icons.hourglass_empty_rounded;
  
  // Communication Icons
  static const IconData email = Icons.email_rounded;
  static const IconData phone = Icons.phone_rounded;
  static const IconData message = Icons.message_rounded;
  static const IconData notification = Icons.notifications_rounded;
  static const IconData notificationOff = Icons.notifications_off_rounded;
  
  // Content Icons
  static const IconData image = Icons.image_rounded;
  static const IconData video = Icons.video_library_rounded;
  static const IconData audio = Icons.audiotrack_rounded;
  static const IconData document = Icons.description_rounded;
  static const IconData folder = Icons.folder_rounded;
  static const IconData file = Icons.insert_drive_file_rounded;
  
  // Commerce Icons
  static const IconData cart = Icons.shopping_cart_rounded;
  static const IconData favorite = Icons.favorite_rounded;
  static const IconData favoriteBorder = Icons.favorite_border_rounded;
  static const IconData payment = Icons.payment_rounded;
  static const IconData receipt = Icons.receipt_rounded;
  static const IconData discount = Icons.local_offer_rounded;
  
  // Status Icons
  static const IconData success = Icons.check_circle_rounded;
  static const IconData error = Icons.error_rounded;
  static const IconData warning = Icons.warning_rounded;
  static const IconData info = Icons.info_rounded;
  static const IconData help = Icons.help_rounded;
  
  // Settings Icons
  static const IconData settings = Icons.settings_rounded;
  static const IconData security = Icons.security_rounded;
  static const IconData privacy = Icons.privacy_tip_rounded;
  static const IconData theme = Icons.palette_rounded;
  static const IconData language = Icons.language_rounded;
  
  // Social Icons
  static const IconData like = Icons.thumb_up_rounded;
  static const IconData dislike = Icons.thumb_down_rounded;
  static const IconData comment = Icons.comment_rounded;
  static const IconData star = Icons.star_rounded;
  static const IconData starBorder = Icons.star_border_rounded;
  
  // Food & Pizza Icons (per Speedy Pizza)
  static const IconData pizza = Icons.local_pizza_rounded;
  static const IconData restaurant = Icons.restaurant_rounded;
  static const IconData delivery = Icons.delivery_dining_rounded;
  static const IconData timer = Icons.timer_rounded;
  static const IconData fastfood = Icons.fastfood_rounded;
  
  // Location Icons
  static const IconData location = Icons.location_on_rounded;
  static const IconData locationOff = Icons.location_off_rounded;
  static const IconData directions = Icons.directions_rounded;
  static const IconData map = Icons.map_rounded;
  
  // Time Icons
  static const IconData schedule = Icons.schedule_rounded;
  static const IconData today = Icons.today_rounded;
  static const IconData calendar = Icons.calendar_month_rounded;
  static const IconData history = Icons.history_rounded;
  
  // Security Icons
  static const IconData lock = Icons.lock_rounded;
  static const IconData unlock = Icons.lock_open_rounded;
  static const IconData fingerprint = Icons.fingerprint_rounded;
  static const IconData shield = Icons.shield_rounded;
}

/// Widget helper per icone con stili consistenti
class AppIcon extends StatelessWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;

  const AppIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Icon(
        icon,
        size: size ?? 24,
        color: color ?? Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

/// Widget per icone animate
class AnimatedAppIcon extends StatefulWidget {
  final IconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;
  final Duration duration;
  final bool animate;

  const AnimatedAppIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
    this.duration = const Duration(milliseconds: 300),
    this.animate = true,
  });

  @override
  State<AnimatedAppIcon> createState() => _AnimatedAppIconState();
}

class _AnimatedAppIconState extends State<AnimatedAppIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Icon(
                widget.icon,
                size: widget.size ?? 24,
                color: widget.color ?? Theme.of(context).colorScheme.onSurface,
              ),
            ),
          );
        },
      ),
    );
  }
}
