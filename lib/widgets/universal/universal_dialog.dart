import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';

/// Universal dialog helper with multiple presets and full customization.
///
/// Example usage:
/// ```dart
/// // Confirmation dialog
/// final confirmed = await UniversalDialog.showConfirmation(
///   context,
///   title: 'Delete Item?',
///   message: 'This action cannot be undone.',
///   confirmText: 'Delete',
///   isDanger: true,
/// );
///
/// // Success dialog
/// await UniversalDialog.showSuccess(
///   context,
///   title: 'Success!',
///   message: 'Your changes have been saved.',
/// );
///
/// // Custom dialog
/// await UniversalDialog.show(
///   context,
///   child: MyCustomWidget(),
///   actions: [/* custom buttons */],
/// );
/// ```
enum DialogType { info, success, warning, error, question, custom }

class UniversalDialog {
  /// Show a custom dialog with full control
  static Future<T?> show<T>(
    BuildContext context, {
    String? title,
    Widget? child,
    List<Widget>? actions,
    DialogType type = DialogType.custom,
    bool barrierDismissible = true,
    Color? barrierColor,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsetsGeometry? actionsPadding,
    double? width,
    double? borderRadius,
    Color? backgroundColor,
    MainAxisAlignment actionsAlignment = MainAxisAlignment.end,
    bool showIcon = false,
    IconData? customIcon,
    Color? iconColor,
    double? iconSize,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => _UniversalDialogWidget(
        title: title,
        child: child,
        actions: actions,
        type: type,
        contentPadding: contentPadding,
        actionsPadding: actionsPadding,
        width: width,
        borderRadius: borderRadius,
        backgroundColor: backgroundColor,
        actionsAlignment: actionsAlignment,
        showIcon: showIcon,
        customIcon: customIcon,
        iconColor: iconColor,
        iconSize: iconSize,
      ),
    );
  }

  /// Show confirmation dialog (Yes/No pattern)
  static Future<bool> showConfirmation(
    BuildContext context, {
    String? title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDanger = false,
    bool barrierDismissible = true,
    IconData? icon,
  }) async {
    final result = await show<bool>(
      context,
      title: title,
      type: DialogType.question,
      showIcon: icon != null || title != null,
      customIcon: icon,
      barrierDismissible: barrierDismissible,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          message,
          style: AppFonts.s14regular,
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelText),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: isDanger ? AppColors.error : AppColors.primary,
            foregroundColor: Colors.white,
          ),
          child: Text(confirmText),
        ),
      ],
    );
    return result ?? false;
  }

  /// Show success dialog
  static Future<void> showSuccess(
    BuildContext context, {
    String title = 'Success',
    required String message,
    String buttonText = 'OK',
    bool barrierDismissible = true,
    Duration? autoDismissAfter,
  }) async {
    final future = show<void>(
      context,
      title: title,
      type: DialogType.success,
      showIcon: true,
      barrierDismissible: barrierDismissible,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          message,
          style: AppFonts.s14regular,
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.success,
            foregroundColor: Colors.white,
          ),
          child: Text(buttonText),
        ),
      ],
    );

    if (autoDismissAfter != null) {
      Future.delayed(autoDismissAfter, () {
        if (context.mounted) Navigator.of(context).pop();
      });
    }

    return future;
  }

  /// Show error dialog
  static Future<void> showError(
    BuildContext context, {
    String title = 'Error',
    required String message,
    String buttonText = 'OK',
    bool barrierDismissible = true,
  }) {
    return show<void>(
      context,
      title: title,
      type: DialogType.error,
      showIcon: true,
      barrierDismissible: barrierDismissible,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          message,
          style: AppFonts.s14regular,
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
          ),
          child: Text(buttonText),
        ),
      ],
    );
  }

  /// Show warning dialog
  static Future<void> showWarning(
    BuildContext context, {
    String title = 'Warning',
    required String message,
    String buttonText = 'OK',
    bool barrierDismissible = true,
  }) {
    return show<void>(
      context,
      title: title,
      type: DialogType.warning,
      showIcon: true,
      barrierDismissible: barrierDismissible,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          message,
          style: AppFonts.s14regular,
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.warning,
            foregroundColor: Colors.white,
          ),
          child: Text(buttonText),
        ),
      ],
    );
  }

  /// Show info dialog
  static Future<void> showInfo(
    BuildContext context, {
    String title = 'Info',
    required String message,
    String buttonText = 'OK',
    bool barrierDismissible = true,
  }) {
    return show<void>(
      context,
      title: title,
      type: DialogType.info,
      showIcon: true,
      barrierDismissible: barrierDismissible,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          message,
          style: AppFonts.s14regular,
          textAlign: TextAlign.center,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonText),
        ),
      ],
    );
  }

  /// Show loading dialog (non-dismissible by default)
  static Future<void> showLoading(
    BuildContext context, {
    String message = 'Loading...',
    bool barrierDismissible = false,
  }) {
    return show<void>(
      context,
      barrierDismissible: barrierDismissible,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppFonts.s14regular,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _UniversalDialogWidget extends StatelessWidget {
  const _UniversalDialogWidget({
    Key? key,
    this.title,
    this.child,
    this.actions,
    this.type = DialogType.custom,
    this.contentPadding,
    this.actionsPadding,
    this.width,
    this.borderRadius,
    this.backgroundColor,
    this.actionsAlignment = MainAxisAlignment.end,
    this.showIcon = false,
    this.customIcon,
    this.iconColor,
    this.iconSize,
  }) : super(key: key);

  final String? title;
  final Widget? child;
  final List<Widget>? actions;
  final DialogType type;
  final EdgeInsetsGeometry? contentPadding;
  final EdgeInsetsGeometry? actionsPadding;
  final double? width;
  final double? borderRadius;
  final Color? backgroundColor;
  final MainAxisAlignment actionsAlignment;
  final bool showIcon;
  final IconData? customIcon;
  final Color? iconColor;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveBgColor = backgroundColor ??
        (isDark ? const Color(0xFF1E1E1E) : Colors.white);
  final effectiveBorderRadius = borderRadius ?? 4.w;
  final effectiveContentPadding =
    contentPadding ?? EdgeInsets.fromLTRB(6.w, 2.5.h, 6.w, 2.h);
  final effectiveActionsPadding =
    actionsPadding ?? EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h);

    return Dialog(
      backgroundColor: effectiveBgColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
      ),
      child: Container(
        width: width ?? 80.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon (if enabled)
            if (showIcon) _buildIcon(),

            // Title
            if (title != null)
              Padding(
                padding: EdgeInsets.fromLTRB(6.w, 2.5.h, 6.w, 1.h),
                child: Text(
                  title!,
                  style: AppFonts.s18bold.copyWith(fontSize: 16.sp),
                  textAlign: TextAlign.center,
                ),
              ),

            // Content
            if (child != null)
              Padding(
                padding: effectiveContentPadding,
                child: child,
              ),

            // Actions
            if (actions != null && actions!.isNotEmpty)
              Padding(
                padding: effectiveActionsPadding,
                child: Row(
                  mainAxisAlignment: actionsAlignment,
                  children: _buildActionButtons(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    final config = _getTypeConfig();
    final effectiveIcon = customIcon ?? config['icon'] as IconData;
    final effectiveColor = iconColor ?? config['color'] as Color;
    final effectiveSize = iconSize ?? 50.0;

    return Padding(
        padding: EdgeInsets.only(top: 3.h),
      child: Center(
        child: Container(
          width: effectiveSize + 5.w,
          height: effectiveSize + 5.w,
          decoration: BoxDecoration(
            color: effectiveColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            effectiveIcon,
            size: effectiveSize.sp,
            color: effectiveColor,
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons() {
    final buttons = <Widget>[];
    for (int i = 0; i < actions!.length; i++) {
      if (i > 0) buttons.add(const SizedBox(width: 8));
      buttons.add(Flexible(child: actions![i]));
    }
    return buttons;
  }

  Map<String, dynamic> _getTypeConfig() {
    switch (type) {
      case DialogType.success:
        return {
          'icon': Icons.check_circle_outline,
          'color': AppColors.success,
        };
      case DialogType.error:
        return {
          'icon': Icons.error_outline,
          'color': AppColors.error,
        };
      case DialogType.warning:
        return {
          'icon': Icons.warning_amber_outlined,
          'color': AppColors.warning,
        };
      case DialogType.info:
        return {
          'icon': Icons.info_outline,
          'color': AppColors.primary,
        };
      case DialogType.question:
        return {
          'icon': Icons.help_outline,
          'color': AppColors.primary,
        };
      case DialogType.custom:
        return {
          'icon': Icons.info_outline,
          'color': AppColors.primary,
        };
    }
  }
}
