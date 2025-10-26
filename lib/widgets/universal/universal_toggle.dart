import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';

/// Universal toggle widget supporting switch, checkbox, radio styles.
///
/// Example usage:
/// ```dart
/// UniversalToggle.switch(
///   value: _isEnabled,
///   onChanged: (v) => setState(() => _isEnabled = v),
///   label: 'Enable notifications',
/// )
///
/// UniversalToggle.checkbox(
///   value: _agreed,
///   onChanged: (v) => setState(() => _agreed = v),
///   label: 'I agree to terms',
/// )
///
/// UniversalToggle.radio(
///   value: _selected == 'option1',
///   onChanged: (v) => setState(() => _selected = 'option1'),
///   label: 'Option 1',
/// )
/// ```
enum ToggleStyle { switchStyle, checkbox, radio, custom }
enum LabelPosition { left, right, top, bottom }

class UniversalToggle extends StatelessWidget {
  const UniversalToggle({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.labelPosition = LabelPosition.right,
    this.labelStyle,
    this.style = ToggleStyle.switchStyle,
    this.activeColor,
    this.inactiveColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.thumbColor,
    this.width,
    this.height,
    this.borderRadius,
    this.showBorder = false,
    this.borderColor,
    this.borderWidth = 1.5,
    this.padding,
    this.isDisabled = false,
    this.semanticLabel,
  });

  // Named constructors
  factory UniversalToggle.switchStyle({
    Key? key,
    required bool value,
    required ValueChanged<bool>? onChanged,
    String? label,
    LabelPosition labelPosition = LabelPosition.right,
    TextStyle? labelStyle,
    Color? activeColor,
    Color? inactiveColor,
    double? width,
    double? height,
    bool isDisabled = false,
  }) {
    return UniversalToggle(
      key: key,
      value: value,
      onChanged: onChanged,
      label: label,
      labelPosition: labelPosition,
      labelStyle: labelStyle,
      style: ToggleStyle.switchStyle,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      width: width,
      height: height,
      isDisabled: isDisabled,
    );
  }

  factory UniversalToggle.checkbox({
    Key? key,
    required bool value,
    required ValueChanged<bool>? onChanged,
    String? label,
    LabelPosition labelPosition = LabelPosition.right,
    TextStyle? labelStyle,
    Color? activeColor,
    Color? inactiveColor,
    bool showBorder = true,
    Color? borderColor,
    bool isDisabled = false,
  }) {
    return UniversalToggle(
      key: key,
      value: value,
      onChanged: onChanged,
      label: label,
      labelPosition: labelPosition,
      labelStyle: labelStyle,
      style: ToggleStyle.checkbox,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      showBorder: showBorder,
      borderColor: borderColor,
      isDisabled: isDisabled,
    );
  }

  factory UniversalToggle.radio({
    Key? key,
    required bool value,
    required ValueChanged<bool>? onChanged,
    String? label,
    LabelPosition labelPosition = LabelPosition.right,
    TextStyle? labelStyle,
    Color? activeColor,
    Color? inactiveColor,
    bool isDisabled = false,
  }) {
    return UniversalToggle(
      key: key,
      value: value,
      onChanged: onChanged,
      label: label,
      labelPosition: labelPosition,
      labelStyle: labelStyle,
      style: ToggleStyle.radio,
      activeColor: activeColor,
      inactiveColor: inactiveColor,
      isDisabled: isDisabled,
    );
  }

  // Core properties
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final LabelPosition labelPosition;
  final TextStyle? labelStyle;

  // Style
  final ToggleStyle style;

  // Colors
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? thumbColor;

  // Dimensions
  final double? width;
  final double? height;
  final double? borderRadius;

  // Border
  final bool showBorder;
  final Color? borderColor;
  final double borderWidth;

  // Spacing
  final EdgeInsetsGeometry? padding;

  // Behavior
  final bool isDisabled;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveDisabled = isDisabled || onChanged == null;

    final effectiveActiveColor = activeColor ?? AppColors.primary;
    final effectiveInactiveColor =
        inactiveColor ?? (theme.brightness == Brightness.dark
            ? Colors.grey[700]!
            : Colors.grey[300]!);

    Widget toggleWidget = _buildToggle(
      context,
      effectiveActiveColor,
      effectiveInactiveColor,
      effectiveDisabled,
    );

    // Add label if present
    if (label != null) {
      final effectiveLabelStyle = labelStyle ?? AppFonts.s14regular;
      final labelWidget = Text(
        label!,
        style: effectiveLabelStyle.copyWith(
          color: effectiveDisabled
              ? AppColors.textSecondary
              : AppColors.textPrimary,
        ),
      );

      Widget combined;
      switch (labelPosition) {
        case LabelPosition.left:
          combined = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              labelWidget,
              const SizedBox(width: 12),
              toggleWidget,
            ],
          );
          break;
        case LabelPosition.right:
          combined = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              toggleWidget,
              const SizedBox(width: 12),
              Flexible(child: labelWidget),
            ],
          );
          break;
        case LabelPosition.top:
          combined = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              labelWidget,
              const SizedBox(height: 8),
              toggleWidget,
            ],
          );
          break;
        case LabelPosition.bottom:
          combined = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              toggleWidget,
              const SizedBox(height: 8),
              labelWidget,
            ],
          );
          break;
      }

      toggleWidget = GestureDetector(
        onTap: effectiveDisabled
            ? null
            : () => onChanged?.call(!value),
        child: combined,
      );
    }

    // Add padding if present
    if (padding != null) {
      toggleWidget = Padding(padding: padding!, child: toggleWidget);
    }

    // Add semantic label
    if (semanticLabel != null) {
      toggleWidget = Semantics(
        label: semanticLabel,
        toggled: value,
        child: toggleWidget,
      );
    }

    return toggleWidget;
  }

  Widget _buildToggle(
    BuildContext context,
    Color activeColor,
    Color inactiveColor,
    bool isDisabled,
  ) {
    switch (style) {
      case ToggleStyle.switchStyle:
        return _buildSwitch(context, activeColor, inactiveColor, isDisabled);
      case ToggleStyle.checkbox:
        return _buildCheckbox(context, activeColor, inactiveColor, isDisabled);
      case ToggleStyle.radio:
        return _buildRadio(context, activeColor, inactiveColor, isDisabled);
      case ToggleStyle.custom:
        return _buildCustomToggle(
            context, activeColor, inactiveColor, isDisabled);
    }
  }

  Widget _buildSwitch(
    BuildContext context,
    Color activeColor,
    Color inactiveColor,
    bool isDisabled,
  ) {
    final effectiveWidth = width ?? 12.w;
    final effectiveHeight = height ?? 4.h;
    final effectiveBorderRadius = borderRadius ?? effectiveHeight / 2;
    final trackColor = value
        ? (activeTrackColor ?? activeColor)
        : (inactiveTrackColor ?? inactiveColor);
    final knobColor = thumbColor ?? Colors.white;
    final borderSide = showBorder
        ? Border.all(
            color: borderColor ?? (value ? activeColor : inactiveColor),
            width: borderWidth,
          )
        : null;

    return GestureDetector(
      onTap: isDisabled ? null : () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: effectiveWidth,
        height: effectiveHeight,
        decoration: BoxDecoration(
          color: trackColor,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          border: borderSide,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.all(0.4.w),
            width: effectiveHeight - 4,
            height: effectiveHeight - 4,
            decoration: BoxDecoration(
              color: knobColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox(
    BuildContext context,
    Color activeColor,
    Color inactiveColor,
    bool isDisabled,
  ) {
  final effectiveSize = width ?? 6.w;
  final effectiveBorderRadius = borderRadius ?? 1.5.w;

    return GestureDetector(
      onTap: isDisabled ? null : () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: effectiveSize,
        height: effectiveSize,
        decoration: BoxDecoration(
          color: value ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          border: Border.all(
            color: value
                ? activeColor
                : (borderColor ?? AppColors.outline),
            width: showBorder ? borderWidth : 2.0,
          ),
        ),
        child: value
            ? Icon(
                Icons.check,
                size: (effectiveSize * 0.7).sp,
                color: Colors.white,
              )
            : null,
      ),
    );
  }

  Widget _buildRadio(
    BuildContext context,
    Color activeColor,
    Color inactiveColor,
    bool isDisabled,
  ) {
  final effectiveSize = width ?? 6.w;

    return GestureDetector(
      onTap: isDisabled ? null : () => onChanged?.call(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: effectiveSize,
        height: effectiveSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: value ? activeColor : (borderColor ?? AppColors.outline),
            width: 2.0,
          ),
        ),
        child: value
            ? Center(
                child: Container(
                  width: effectiveSize * 0.5,
                  height: effectiveSize * 0.5,
                  decoration: BoxDecoration(
                    color: activeColor,
                    shape: BoxShape.circle,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildCustomToggle(
    BuildContext context,
    Color activeColor,
    Color inactiveColor,
    bool isDisabled,
  ) {
    // Custom toggle implementation (placeholder for future expansion)
    return _buildSwitch(context, activeColor, inactiveColor, isDisabled);
  }
}
