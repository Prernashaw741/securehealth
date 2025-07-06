import 'package:flutter/material.dart';
import 'package:securehealth/constants/colors.dart';

class UIHelpers {
  static BoxDecoration cardDecoration({
    Color? color,
    double borderRadius = 16,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      color: color ?? Colors.white,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: boxShadow ?? elevationShadow(2),
    );
  }

  static List<BoxShadow> elevationShadow(int elevation) {
    if (elevation == 0) return [];
    
    final baseColor = Colors.black.withOpacity(0.08);
    final lightColor = Colors.black.withOpacity(0.04);
    
    switch (elevation) {
      case 1:
        return [
          BoxShadow(
            color: baseColor,
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ];
      case 2:
        return [
          BoxShadow(
            color: baseColor,
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
          BoxShadow(
            color: lightColor,
            offset: const Offset(0, 1),
            blurRadius: 3,
          ),
        ];
      case 3:
        return [
          BoxShadow(
            color: baseColor,
            offset: const Offset(0, 8),
            blurRadius: 16,
          ),
          BoxShadow(
            color: lightColor,
            offset: const Offset(0, 2),
            blurRadius: 6,
          ),
        ];
      default:
        return [
          BoxShadow(
            color: baseColor,
            offset: const Offset(0, 12),
            blurRadius: 24,
          ),
          BoxShadow(
            color: lightColor,
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ];
    }
  }

  static LinearGradient primaryGradient({
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [
        SecureHealthColors.coolOrange,
        SecureHealthColors.coolOrange.withOpacity(0.8),
      ],
    );
  }

  static LinearGradient darkGradient({
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [
        SecureHealthColors.darkPurple,
        SecureHealthColors.darkPurple.withOpacity(0.85),
      ],
    );
  }

  static Widget glassmorphism({
    required Widget child,
    double borderRadius = 16,
    Color? backgroundColor,
    double blur = 10,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ColorFilter.mode(
            Colors.white.withOpacity(0.1),
            BlendMode.srcOver,
          ),
          child: child,
        ),
      ),
    );
  }

  static Widget shimmerEffect({
    double? width,
    double? height,
    double borderRadius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: SecureHealthColors.neutralGrey4,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }

  static EdgeInsets screenPadding = const EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 16,
  );

  static EdgeInsets cardPadding = const EdgeInsets.all(16);

  static EdgeInsets listItemPadding = const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 12,
  );

  static const double buttonHeight = 48;
  static const double inputHeight = 56;
  static const double appBarHeight = 64;
}