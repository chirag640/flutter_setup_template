import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';
import '../../core/theme/theme_helper.dart';

/// Universal button with complete direct customization - no presets.
/// Every visual property is directly controllable via parameters.
/// 
/// Example usage:
/// ```dart
/// UniversalButton(
///   text: 'Submit',
///   onPressed: () => _handleSubmit(),
///   backgroundColor: AppColors.primary,
///   foregroundColor: Colors.white,
///   height: 48,
///   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
/// )
/// ```
enum IconPosition { left, right, top, bottom, only }

class UniversalButton extends StatefulWidget {
  const UniversalButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    // Icon
    this.icon,
    this.iconPosition = IconPosition.left,
    this.iconSize,
    this.iconColor,
    // Dimensions
    this.width,
    this.height,
    this.padding,
    this.margin,
    // Colors
    this.backgroundColor,
    this.foregroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    // Border
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.showBorder = false,
    // Shape & Shadow
    this.gradient,
    this.elevation,
    this.shadowColor,
    this.shadowBlurRadius,
    this.shadowOffset,
    this.showShadow = false,
    this.customShape,
    // Loading
    this.loadingIndicatorColor,
    this.loadingIndicatorSize,
    // Typography
    this.textStyle,
    this.fontSize,
    this.fontWeight,
    // Interaction
    this.splashColor,
    this.animationDuration = const Duration(milliseconds: 200),
    this.hapticFeedback = false,
    // Extras
    this.tooltipMessage,
    this.badgeText,
    this.badgeColor,
    this.badgeBackgroundColor,
  }) : super(key: key);

  // Named constructors for convenience (optional)
  factory UniversalButton.icon({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    required IconData icon,
    IconPosition iconPosition = IconPosition.left,
    bool isLoading = false,
    bool isDisabled = false,
    double? iconSize,
    Color? iconColor,
    Color? backgroundColor,
    Color? foregroundColor,
    double? height,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    Gradient? gradient,
  }) {
    return UniversalButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      iconPosition: iconPosition,
      isLoading: isLoading,
      isDisabled: isDisabled,
      iconSize: iconSize,
      iconColor: iconColor,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      height: height,
      padding: padding,
      borderRadius: borderRadius,
      gradient: gradient,
    );
  }

  factory UniversalButton.iconOnly({
    Key? key,
    required IconData icon,
    required VoidCallback? onPressed,
    bool isLoading = false,
    bool isDisabled = false,
    double? iconSize,
    Color? iconColor,
    Color? backgroundColor,
    double? size,
    bool circular = true,
    String? tooltipMessage,
  }) {
    final effectiveSize = size ?? 48.0;
    return UniversalButton(
      key: key,
      text: '',
      onPressed: onPressed,
      icon: icon,
      iconPosition: IconPosition.only,
      isLoading: isLoading,
      isDisabled: isDisabled,
      iconSize: iconSize,
      iconColor: iconColor,
      backgroundColor: backgroundColor,
      width: effectiveSize,
      height: effectiveSize,
      borderRadius: circular ? 999 : null,
      tooltipMessage: tooltipMessage,
    );
  }

  // Core
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isDisabled;

  // Icon
  final IconData? icon;
  final IconPosition iconPosition;
  final double? iconSize;
  final Color? iconColor;

  // Dimensions
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  // Colors
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;

  // Border
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final bool showBorder;

  // Shape & Shadow
  final Gradient? gradient;
  final double? elevation;
  final Color? shadowColor;
  final double? shadowBlurRadius;
  final Offset? shadowOffset;
  final bool showShadow;
  final ShapeBorder? customShape;

  // Loading
  final Color? loadingIndicatorColor;
  final double? loadingIndicatorSize;

  // Typography
  final TextStyle? textStyle;
  final double? fontSize;
  final FontWeight? fontWeight;

  // Interaction
  final Color? splashColor;
  final Duration animationDuration;
  final bool hapticFeedback;

  // Extras
  final String? tooltipMessage;
  final String? badgeText;
  final Color? badgeColor;
  final Color? badgeBackgroundColor;

  @override
  State<UniversalButton> createState() => _UniversalButtonState();
}

class _UniversalButtonState extends State<UniversalButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Determine effective disabled state
    final effectiveDisabled =
        widget.isDisabled || widget.onPressed == null || widget.isLoading;

    // Apply defaults with theme awareness
  final effectiveHeight = widget.height ?? 6.h;
  final effectivePadding = widget.padding ??
    EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h);
  final effectiveBorderRadius = widget.borderRadius ?? 2.8.w;
    
    final effectiveBgColor = widget.backgroundColor ??
        (isDark ? AppColors.primary : AppColors.primary);
    final effectiveFgColor = widget.foregroundColor ?? Colors.white;
  final effectiveDisabledBg = widget.disabledBackgroundColor ??
    colorWithOpacity(effectiveBgColor, 0.4);
    final effectiveDisabledFg =
        widget.disabledForegroundColor ?? Colors.white70;
    
  final effectiveIconSize = widget.iconSize ?? 2.4.w;
    final effectiveIconColor = widget.iconColor ?? effectiveFgColor;
    
    final effectiveTextStyle = widget.textStyle ??
        AppFonts.s14semibold.copyWith(
          fontSize: widget.fontSize != null ? widget.fontSize!.sp : null,
          fontWeight: widget.fontWeight,
        );

    // Build button content
    Widget content = _buildContent(
      effectiveDisabled ? effectiveDisabledFg : effectiveFgColor,
      effectiveDisabled ? effectiveDisabledFg : effectiveIconColor,
      effectiveTextStyle,
      effectiveIconSize,
    );

    // Wrap in container for gradient or custom decoration
    Widget buttonChild;
    if (widget.gradient != null && !effectiveDisabled) {
      final decoration = BoxDecoration(
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: widget.showBorder && widget.borderColor != null
            ? Border.all(
                color: widget.borderColor!,
                width: widget.borderWidth ?? 1.5,
              )
            : null,
        boxShadow: widget.showShadow
            ? [
                BoxShadow(
                  color: widget.shadowColor ??
                      (isDark ? Colors.black45 : Colors.black26),
                  blurRadius: widget.shadowBlurRadius ?? 1.6.h,
                  offset: widget.shadowOffset ?? Offset(0, 0.5.h),
                ),
              ]
            : null,
      );
      
      buttonChild = Container(
        height: effectiveHeight,
        width: widget.width,
        decoration: decoration,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: effectiveDisabled ? null : _handleTap,
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            splashColor: widget.splashColor,
            child: Padding(
              padding: effectivePadding,
              child: content,
            ),
          ),
        ),
      );
    } else {
      // Standard Material button
      final shape = (widget.customShape is OutlinedBorder)
          ? widget.customShape as OutlinedBorder
          : RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(effectiveBorderRadius),
              side: widget.showBorder && widget.borderColor != null
                  ? BorderSide(
                      color: effectiveDisabled
                          ? colorWithOpacity(effectiveDisabledFg, 0.3)
                          : widget.borderColor!,
                      width: widget.borderWidth ?? 1.5,
                    )
                  : BorderSide.none,
            );

      buttonChild = SizedBox(
        height: effectiveHeight,
        width: widget.width,
        child: ElevatedButton(
          onPressed: effectiveDisabled ? null : _handleTap,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                effectiveDisabled ? effectiveDisabledBg : effectiveBgColor,
            foregroundColor:
                effectiveDisabled ? effectiveDisabledFg : effectiveFgColor,
            elevation: widget.elevation ?? 0,
            shadowColor: widget.shadowColor,
            padding: effectivePadding,
            shape: shape,
            splashFactory: widget.splashColor != null
                ? InkRipple.splashFactory
                : null,
          ),
          child: content,
        ),
      );

      // Add shadow if requested
      if (widget.showShadow && !effectiveDisabled) {
        buttonChild = Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(effectiveBorderRadius),
            boxShadow: [
              BoxShadow(
                color: widget.shadowColor ??
                    (isDark ? Colors.black45 : Colors.black26),
                blurRadius: widget.shadowBlurRadius ?? 1.6.h,
                offset: widget.shadowOffset ?? Offset(0, 0.5.h),
              ),
            ],
          ),
          child: buttonChild,
        );
      }
    }

    // Wrap in scale animation
    buttonChild = ScaleTransition(
      scale: _scaleAnimation,
      child: buttonChild,
    );

    // Add badge if present
    if (widget.badgeText != null && widget.badgeText!.isNotEmpty) {
      buttonChild = Stack(
        clipBehavior: Clip.none,
        children: [
          buttonChild,
          Positioned(
            top: -8,
            right: -8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: widget.badgeBackgroundColor ?? Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              child: Text(
                widget.badgeText!,
                style: TextStyle(
                  color: widget.badgeColor ?? Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    // Add margin
    if (widget.margin != null) {
      buttonChild = Padding(padding: widget.margin!, child: buttonChild);
    }

    // Add tooltip if present
    if (widget.tooltipMessage != null) {
      buttonChild = Tooltip(
        message: widget.tooltipMessage!,
        child: buttonChild,
      );
    }

    return buttonChild;
  }

  Widget _buildContent(
    Color textColor,
    Color iconColor,
    TextStyle textStyle,
    double iconSize,
  ) {
    // Loading state
    if (widget.isLoading) {
      return SizedBox(
  width: widget.loadingIndicatorSize ?? 2.4.w,
  height: widget.loadingIndicatorSize ?? 2.4.w,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            widget.loadingIndicatorColor ?? textColor,
          ),
        ),
      );
    }

    // Icon-only
    if (widget.iconPosition == IconPosition.only && widget.icon != null) {
      return Icon(widget.icon, size: iconSize, color: iconColor);
    }

    // Text-only
    if (widget.icon == null) {
      return Text(
        widget.text,
        style: textStyle.copyWith(color: textColor),
        textAlign: TextAlign.center,
      );
    }

    // Icon + Text combinations
    final iconWidget = Icon(widget.icon, size: iconSize, color: iconColor);
    final textWidget = Text(
      widget.text,
      style: textStyle.copyWith(color: textColor),
      textAlign: TextAlign.center,
    );

    switch (widget.iconPosition) {
      case IconPosition.left:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
            iconWidget,
            SizedBox(width: 2.w),
            Flexible(child: textWidget),
          ],
        );
      case IconPosition.right:
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Flexible(child: textWidget),
            SizedBox(width: 2.w),
            iconWidget,
          ],
        );
      case IconPosition.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
            iconWidget,
            SizedBox(height: 0.8.h),
            textWidget,
          ],
        );
      case IconPosition.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
            textWidget,
            SizedBox(height: 0.8.h),
            iconWidget,
          ],
        );
      default:
        return textWidget;
    }
  }

  void _handleTap() {
    if (widget.hapticFeedback) {
      // HapticFeedback.lightImpact(); // Uncomment if you add services package
    }
    _controller.forward().then((_) => _controller.reverse());
    widget.onPressed?.call();
  }
}
