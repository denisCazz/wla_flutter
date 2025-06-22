import 'package:flutter/material.dart';

/// Sistema di spaziature consistenti e responsive
class AppSpacing {
  // Spaziature base (multipli di 4 per coerenza)
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Spaziature specializzate
  static const double cardPadding = 16.0;
  static const double screenPadding = 24.0;
  static const double buttonPadding = 16.0;
  static const double iconSize = 24.0;
  static const double borderRadius = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusSmall = 8.0;

  // EdgeInsets predefiniti
  static const EdgeInsets zero = EdgeInsets.zero;
  static const EdgeInsets allXs = EdgeInsets.all(xs);
  static const EdgeInsets allSm = EdgeInsets.all(sm);
  static const EdgeInsets allMd = EdgeInsets.all(md);
  static const EdgeInsets allLg = EdgeInsets.all(lg);
  static const EdgeInsets allXl = EdgeInsets.all(xl);

  // Padding orizzontali
  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: xs);
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);

  // Padding verticali
  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);

  // Padding per schermi
  static const EdgeInsets screenHorizontal = EdgeInsets.symmetric(horizontal: screenPadding);
  static const EdgeInsets screenAll = EdgeInsets.all(screenPadding);

  // SizedBox predefiniti per spaziature verticali
  static const SizedBox verticalSpaceXs = SizedBox(height: xs);
  static const SizedBox verticalSpaceSm = SizedBox(height: sm);
  static const SizedBox verticalSpaceMd = SizedBox(height: md);
  static const SizedBox verticalSpaceLg = SizedBox(height: lg);
  static const SizedBox verticalSpaceXl = SizedBox(height: xl);
  static const SizedBox verticalSpaceXxl = SizedBox(height: xxl);

  // SizedBox predefiniti per spaziature orizzontali
  static const SizedBox horizontalSpaceXs = SizedBox(width: xs);
  static const SizedBox horizontalSpaceSm = SizedBox(width: sm);
  static const SizedBox horizontalSpaceMd = SizedBox(width: md);
  static const SizedBox horizontalSpaceLg = SizedBox(width: lg);
  static const SizedBox horizontalSpaceXl = SizedBox(width: xl);

  // BorderRadius predefiniti
  static const BorderRadius radiusNone = BorderRadius.zero;
  static const BorderRadius radiusXs = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(borderRadiusSmall));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(borderRadius));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(borderRadiusLarge));
  static const BorderRadius radiusXl = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusXxl = BorderRadius.all(Radius.circular(xl));

  // BorderRadius specifici per posizioni
  static const BorderRadius radiusTopMd = BorderRadius.only(
    topLeft: Radius.circular(borderRadius),
    topRight: Radius.circular(borderRadius),
  );

  static const BorderRadius radiusBottomMd = BorderRadius.only(
    bottomLeft: Radius.circular(borderRadius),
    bottomRight: Radius.circular(borderRadius),
  );

  // Metodi helper per spaziature responsive
  static double responsive(BuildContext context, {
    double mobile = md,
    double tablet = lg,
    double desktop = xl,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 1200) return desktop;
    if (screenWidth > 600) return tablet;
    return mobile;
  }

  static EdgeInsets responsivePadding(BuildContext context) {
    final spacing = responsive(context);
    return EdgeInsets.all(spacing);
  }

  static EdgeInsets responsiveHorizontal(BuildContext context) {
    final spacing = responsive(context);
    return EdgeInsets.symmetric(horizontal: spacing);
  }

  // Metodi per creare spaziature custom
  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    );
  }
}
