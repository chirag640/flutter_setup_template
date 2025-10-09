import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';

/// Universal bottom bar for forms, actions, and navigation.
///
/// Example usage:
/// ```dart
/// UniversalBottomBar.actions(
///   primaryText: 'Save',
///   primaryOnPressed: () => _save(),
///   secondaryText: 'Cancel',
///   secondaryOnPressed: () => Navigator.pop(context),
///   isLoading: _isSaving,
/// )
///
/// UniversalBottomBar.single(
///   text: 'Continue',
///   onPressed: () => _continue(),
/// )
///
/// UniversalBottomBar.custom(
///   children: [/* custom widgets */],
/// )
/// ```
enum BottomBarMode { actions, single, custom }

class UniversalBottomBar extends StatelessWidget {
  const UniversalBottomBar({
    Key? key,
    this.mode = BottomBarMode.custom,
    this.children,
    this.primaryText,
    this.primaryOnPressed,
    this.primaryIcon,
    this.primaryIsLoading = false,
    this.primaryVariant = ButtonVariant.primary,
    this.secondaryText,
    this.secondaryOnPressed,
    this.secondaryIcon,
    this.secondaryVariant = ButtonVariant.secondary,
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
  }) : super(key: key);

  // Named constructors
  factory UniversalBottomBar.actions({
    Key? key,
    required String primaryText,
    required VoidCallback? primaryOnPressed,
    String? secondaryText,
    VoidCallback? secondaryOnPressed,
    IconData? primaryIcon,
    IconData? secondaryIcon,
    bool primaryIsLoading = false,
    ButtonVariant primaryVariant = ButtonVariant.primary,
    ButtonVariant secondaryVariant = ButtonVariant.secondary,
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
      mode: BottomBarMode.actions,
      primaryText: primaryText,
      primaryOnPressed: primaryOnPressed,
      primaryIcon: primaryIcon,
      primaryIsLoading: primaryIsLoading,
      primaryVariant: primaryVariant,
      secondaryText: secondaryText,
      secondaryOnPressed: secondaryOnPressed,
      secondaryIcon: secondaryIcon,
      secondaryVariant: secondaryVariant,
      height: height,
      padding: padding,
      backgroundColor: backgroundColor,
      gradient: gradient,
      elevation: elevation,
      showTopBorder: showTopBorder,
      safeArea: safeArea,
    );
  }

  factory UniversalBottomBar.single({
    Key? key,
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
    bool isLoading = false,
    ButtonVariant variant = ButtonVariant.primary,
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
      mode: BottomBarMode.single,
      primaryText: text,
      primaryOnPressed: onPressed,
      primaryIcon: icon,
      primaryIsLoading: isLoading,
      primaryVariant: variant,
      height: height,
      padding: padding,
      backgroundColor: backgroundColor,
      gradient: gradient,
      elevation: elevation,
      showTopBorder: showTopBorder,
      safeArea: safeArea,
    );
  }

  factory UniversalBottomBar.custom({
    Key? key,
    required List<Widget> children,
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
      mode: BottomBarMode.custom,
      children: children,
      alignment: alignment,
      height: height,
      padding: padding,
      backgroundColor: backgroundColor,
      gradient: gradient,
      elevation: elevation,
      showTopBorder: showTopBorder,
      safeArea: safeArea,
    );
  }

  // Mode
  final BottomBarMode mode;

  // Custom children
  final List<Widget>? children;

  // Action buttons
  final String? primaryText;
  final VoidCallback? primaryOnPressed;
  final IconData? primaryIcon;
  final bool primaryIsLoading;
  final ButtonVariant primaryVariant;

  final String? secondaryText;
  final VoidCallback? secondaryOnPressed;
  final IconData? secondaryIcon;
  final ButtonVariant secondaryVariant;

  // Styling
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Gradient? gradient;
  final double elevation;
  final bool showTopBorder;
  final Color? borderColor;
  final double borderWidth;

  // Behavior
  final bool isSticky;
  final bool safeArea;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveBgColor = backgroundColor ??
        (isDark ? const Color(0xFF1E1E1E) : Colors.white);
  final effectiveHeight = height ?? 9.h;
  final effectivePadding =
    padding ?? EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h);
    final effectiveBorderColor =
        borderColor ?? (isDark ? Colors.grey[800]! : AppColors.outline);

    Widget content = _buildContent(context);

    // Wrap in padding
    content = Padding(padding: effectivePadding, child: content);

    // Build container
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

    // Wrap in SafeArea if requested
    if (safeArea) {
      bar = SafeArea(
        top: false,
        child: bar,
      );
    }

    return bar;
  }

  Widget _buildContent(BuildContext context) {
    switch (mode) {
      case BottomBarMode.single:
        return _buildSingleButton(context);
      case BottomBarMode.actions:
        return _buildActionButtons(context);
      case BottomBarMode.custom:
        return Row(
          mainAxisAlignment: alignment,
          children: children ?? [],
        );
    }
  }

  Widget _buildSingleButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: _UniversalBottomBarButton(
        text: primaryText!,
        onPressed: primaryOnPressed,
        icon: primaryIcon,
        isLoading: primaryIsLoading,
        variant: primaryVariant,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final buttons = <Widget>[];

    if (secondaryText != null) {
      buttons.add(
        Expanded(
          child: _UniversalBottomBarButton(
            text: secondaryText!,
            onPressed: secondaryOnPressed,
            icon: secondaryIcon,
            variant: secondaryVariant,
          ),
        ),
      );
      buttons.add(const SizedBox(width: 12));
    }

    buttons.add(
      Expanded(
        flex: secondaryText != null ? 1 : 2,
        child: _UniversalBottomBarButton(
          text: primaryText!,
          onPressed: primaryOnPressed,
          icon: primaryIcon,
          isLoading: primaryIsLoading,
          variant: primaryVariant,
        ),
      ),
    );

    return Row(children: buttons);
  }
}

enum ButtonVariant { primary, secondary, text, outlined, danger }

class _UniversalBottomBarButton extends StatelessWidget {
  const _UniversalBottomBarButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.variant = ButtonVariant.primary,
  }) : super(key: key);

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final ButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _getVariantColors(theme);

    final isDisabled = onPressed == null || isLoading;

    Widget content;
    if (isLoading) {
      content = const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else if (icon != null) {
      content = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(text, style: AppFonts.s16semibold),
        ],
      );
    } else {
      content = Text(text, style: AppFonts.s16semibold);
    }

    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? colors['disabledBackground']
              : colors['background'],
          foregroundColor: isDisabled
              ? colors['disabledForeground']
              : colors['foreground'],
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: (variant == ButtonVariant.outlined ||
                    variant == ButtonVariant.secondary)
                ? BorderSide(
                    color: isDisabled
                        ? (colors['disabledForeground'] as Color)
                            .withOpacity(0.3)
                        : colors['border'] as Color,
                    width: 1.5,
                  )
                : BorderSide.none,
          ),
        ),
        child: content,
      ),
    );
  }

  Map<String, Color?> _getVariantColors(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    switch (variant) {
      case ButtonVariant.primary:
        return {
          'background': AppColors.primary,
          'foreground': Colors.white,
          'border': AppColors.primary,
          'disabledBackground': AppColors.primary.withOpacity(0.4),
          'disabledForeground': Colors.white70,
        };
      case ButtonVariant.secondary:
        return {
          'background': Colors.transparent,
          'foreground': AppColors.primary,
          'border': AppColors.primary,
          'disabledBackground': Colors.transparent,
          'disabledForeground': AppColors.primary.withOpacity(0.4),
        };
      case ButtonVariant.outlined:
        return {
          'background': isDark ? Colors.grey[850] : Colors.white,
          'foreground': isDark ? Colors.white : AppColors.textPrimary,
          'border': AppColors.outline,
          'disabledBackground': isDark ? Colors.grey[900] : Colors.grey[100],
          'disabledForeground': AppColors.textSecondary,
        };
      case ButtonVariant.text:
        return {
          'background': Colors.transparent,
          'foreground': AppColors.primary,
          'border': Colors.transparent,
          'disabledBackground': Colors.transparent,
          'disabledForeground': AppColors.textSecondary,
        };
      case ButtonVariant.danger:
        return {
          'background': AppColors.error,
          'foreground': Colors.white,
          'border': AppColors.error,
          'disabledBackground': AppColors.error.withOpacity(0.4),
          'disabledForeground': Colors.white70,
        };
    }
  }
}
