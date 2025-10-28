import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/theme/app_colors.dart';
import 'universal_button.dart';

int _opacityToAlpha(double opacity) => (opacity.clamp(0.0, 1.0) * 255).round();

enum BottomBarMode { actions, single, custom }

class UniversalBottomBar extends StatelessWidget {
  const UniversalBottomBar({
    super.key,
    this.mode = BottomBarMode.custom,
    this.children,
    this.primaryText,
    this.primaryOnPressed,
    this.primaryIcon,
    this.primaryIsLoading = false,
    this.secondaryText,
    this.secondaryOnPressed,
    this.secondaryIcon,
    this.height,
    this.padding,
    this.backgroundColor,
    this.gradient,
    this.elevation = 0,
    this.showTopBorder = true,
    this.borderColor,
    this.borderWidth = 1.0,
    this.isSticky = true,
    this.safeArea = true,
    this.alignment = MainAxisAlignment.spaceBetween,
    this.buttonSpacing,
    this.buttonHeight,
    this.buttonBorderRadius,
    this.primaryBackgroundColor,
    this.primaryForegroundColor,
    this.primaryDisabledBackgroundColor,
    this.primaryDisabledForegroundColor,
    this.primaryBorderColor,
    this.primaryBorderWidth = 1.5,
    this.primaryShowBorder = false,
    this.primaryGradient,
    this.primaryIconColor,
    this.primaryPadding,
    this.secondaryBackgroundColor,
    this.secondaryForegroundColor,
    this.secondaryDisabledBackgroundColor,
    this.secondaryDisabledForegroundColor,
    this.secondaryBorderColor,
    this.secondaryBorderWidth = 1.5,
    this.secondaryShowBorder = true,
    this.secondaryGradient,
    this.secondaryIconColor,
    this.secondaryPadding,
  });

  factory UniversalBottomBar.actions({
    required String primaryText,
    required VoidCallback? primaryOnPressed,
    Key? key,
    String? secondaryText,
    VoidCallback? secondaryOnPressed,
    IconData? primaryIcon,
    IconData? secondaryIcon,
    bool primaryIsLoading = false,
    double? height,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Gradient? gradient,
    double elevation = 0,
    bool showTopBorder = true,
    bool safeArea = true,
    Color? primaryBackgroundColor,
    Color? primaryForegroundColor,
    Color? secondaryBackgroundColor,
    Color? secondaryForegroundColor,
  }) {
    return UniversalBottomBar(
      key: key,
      mode: BottomBarMode.actions,
      primaryText: primaryText,
      primaryOnPressed: primaryOnPressed,
      primaryIcon: primaryIcon,
      primaryIsLoading: primaryIsLoading,
      secondaryText: secondaryText,
      secondaryOnPressed: secondaryOnPressed,
      secondaryIcon: secondaryIcon,
      height: height,
      padding: padding,
      backgroundColor: backgroundColor,
      gradient: gradient,
      elevation: elevation,
      showTopBorder: showTopBorder,
      safeArea: safeArea,
      primaryBackgroundColor: primaryBackgroundColor,
      primaryForegroundColor: primaryForegroundColor,
      secondaryBackgroundColor: secondaryBackgroundColor,
      secondaryForegroundColor: secondaryForegroundColor,
    );
  }

  factory UniversalBottomBar.single({
    required String text,
    required VoidCallback? onPressed,
    Key? key,
    IconData? icon,
    bool isLoading = false,
    double? height,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Gradient? gradient,
    double elevation = 0,
    bool showTopBorder = true,
    bool safeArea = true,
    Color? backgroundColorOverride,
    Color? foregroundColorOverride,
  }) {
    return UniversalBottomBar(
      key: key,
      mode: BottomBarMode.single,
      primaryText: text,
      primaryOnPressed: onPressed,
      primaryIcon: icon,
      primaryIsLoading: isLoading,
      height: height,
      padding: padding,
      backgroundColor: backgroundColor,
      gradient: gradient,
      elevation: elevation,
      showTopBorder: showTopBorder,
      safeArea: safeArea,
      primaryBackgroundColor: backgroundColorOverride,
      primaryForegroundColor: foregroundColorOverride,
    );
  }

  factory UniversalBottomBar.custom({
    required List<Widget> children,
    Key? key,
    MainAxisAlignment alignment = MainAxisAlignment.spaceBetween,
    double? height,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Gradient? gradient,
    double elevation = 0,
    bool showTopBorder = true,
    bool safeArea = true,
  }) {
    return UniversalBottomBar(
      key: key,
      alignment: alignment,
      height: height,
      padding: padding,
      backgroundColor: backgroundColor,
      gradient: gradient,
      elevation: elevation,
      showTopBorder: showTopBorder,
      safeArea: safeArea,
      children: children,
    );
  }

  final BottomBarMode mode;
  final List<Widget>? children;
  final String? primaryText;
  final VoidCallback? primaryOnPressed;
  final IconData? primaryIcon;
  final bool primaryIsLoading;
  final String? secondaryText;
  final VoidCallback? secondaryOnPressed;
  final IconData? secondaryIcon;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double elevation;
  final bool showTopBorder;
  final Color? borderColor;
  final double borderWidth;
  final bool isSticky;
  final bool safeArea;
  final MainAxisAlignment alignment;
  final double? buttonSpacing;
  final double? buttonHeight;
  final double? buttonBorderRadius;
  final Color? primaryBackgroundColor;
  final Color? primaryForegroundColor;
  final Color? primaryDisabledBackgroundColor;
  final Color? primaryDisabledForegroundColor;
  final Color? primaryBorderColor;
  final double primaryBorderWidth;
  final bool primaryShowBorder;
  final Gradient? primaryGradient;
  final Color? primaryIconColor;
  final EdgeInsetsGeometry? primaryPadding;
  final Color? secondaryBackgroundColor;
  final Color? secondaryForegroundColor;
  final Color? secondaryDisabledBackgroundColor;
  final Color? secondaryDisabledForegroundColor;
  final Color? secondaryBorderColor;
  final double secondaryBorderWidth;
  final bool secondaryShowBorder;
  final Gradient? secondaryGradient;
  final Color? secondaryIconColor;
  final EdgeInsetsGeometry? secondaryPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectiveBgColor =
        backgroundColor ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white);
    final effectiveHeight = height ?? 9.h;
    final effectivePadding =
        padding ?? EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h);
    final effectiveBorderColor =
        borderColor ?? (isDark ? Colors.grey[800]! : AppColors.outline);

    Widget content = _buildContent();
    content = Padding(padding: effectivePadding, child: content);

    Widget bar = Container(
      height: effectiveHeight,
      decoration: BoxDecoration(
        color: gradient == null ? effectiveBgColor : null,
        gradient: gradient,
        border: showTopBorder
            ? Border(
                top: BorderSide(
                  color: effectiveBorderColor,
                  width: borderWidth,
                ),
              )
            : null,
        boxShadow: elevation > 0
            ? [
                BoxShadow(
                  color: isDark ? Colors.black45 : Colors.black12,
                  blurRadius: elevation * 2,
                  offset: Offset(0, -elevation),
                ),
              ]
            : null,
      ),
      child: content,
    );

    if (safeArea) {
      bar = SafeArea(top: false, child: bar);
    }

    return bar;
  }

  Widget _buildContent() {
    switch (mode) {
      case BottomBarMode.single:
        return _buildSingleButton();
      case BottomBarMode.actions:
        return _buildActionButtons();
      case BottomBarMode.custom:
        return Row(
          mainAxisAlignment: alignment,
          children: children ?? const [],
        );
    }
  }

  Widget _buildSingleButton() {
    return SizedBox(
      width: double.infinity,
      child: _buildPrimaryButton(expanded: true),
    );
  }

  Widget _buildActionButtons() {
    final spacing = buttonSpacing ?? 3.w;
    final buttonChildren = <Widget>[];
    if (secondaryText != null) {
      buttonChildren.add(
        Expanded(child: _buildSecondaryButton(expanded: true)),
      );
      buttonChildren.add(SizedBox(width: spacing));
    }
    buttonChildren.add(
      Expanded(
        flex: secondaryText != null ? 1 : 2,
        child: _buildPrimaryButton(expanded: true),
      ),
    );
    return Row(children: buttonChildren);
  }

  Widget _buildPrimaryButton({required bool expanded}) {
    final baseBackground = primaryBackgroundColor ?? AppColors.primary;
    return UniversalButton(
      text: primaryText ?? '',
      onPressed: primaryOnPressed,
      icon: primaryIcon,
      isLoading: primaryIsLoading,
      iconColor: primaryIconColor,
      backgroundColor: primaryGradient == null ? baseBackground : null,
      gradient: primaryGradient,
      foregroundColor: primaryForegroundColor ?? Colors.white,
      disabledBackgroundColor:
          primaryDisabledBackgroundColor ??
          baseBackground.withAlpha(_opacityToAlpha(0.4)),
      disabledForegroundColor: primaryDisabledForegroundColor ?? Colors.white70,
      borderColor: primaryShowBorder || primaryBorderColor != null
          ? (primaryBorderColor ?? baseBackground)
          : null,
      borderWidth: primaryBorderWidth,
      showBorder: primaryShowBorder || primaryBorderColor != null,
      height: buttonHeight ?? 5.6.h,
      width: expanded ? double.infinity : null,
      borderRadius: buttonBorderRadius ?? 3.w,
      padding:
          primaryPadding ??
          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.4.h),
    );
  }

  Widget _buildSecondaryButton({required bool expanded}) {
    final baseBackground = secondaryBackgroundColor ?? Colors.transparent;
    final baseForeground = secondaryForegroundColor ?? AppColors.primary;
    final borderColor = secondaryBorderColor ?? AppColors.primary;
    return UniversalButton(
      text: secondaryText ?? '',
      onPressed: secondaryOnPressed,
      icon: secondaryIcon,
      iconColor: secondaryIconColor ?? baseForeground,
      backgroundColor: secondaryGradient == null ? baseBackground : null,
      gradient: secondaryGradient,
      foregroundColor: baseForeground,
      disabledBackgroundColor:
          secondaryDisabledBackgroundColor ?? baseBackground,
      disabledForegroundColor:
          secondaryDisabledForegroundColor ??
          baseForeground.withAlpha(_opacityToAlpha(0.4)),
      borderColor: secondaryShowBorder || secondaryBorderColor != null
          ? borderColor
          : null,
      borderWidth: secondaryBorderWidth,
      showBorder: secondaryShowBorder || secondaryBorderColor != null,
      height: buttonHeight ?? 5.6.h,
      width: expanded ? double.infinity : null,
      borderRadius: buttonBorderRadius ?? 3.w,
      padding:
          secondaryPadding ??
          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.4.h),
    );
  }
}
