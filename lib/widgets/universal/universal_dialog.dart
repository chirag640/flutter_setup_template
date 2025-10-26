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

int _opacityToAlpha(double opacity) => (opacity.clamp(0.0, 1.0) * 255).round();

class _DialogVisualDefaults {
  const _DialogVisualDefaults({
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.titleColor,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final Color titleColor;

  static _DialogVisualDefaults forType(DialogType type) {
    switch (type) {
      case DialogType.success:
        return _DialogVisualDefaults(
          icon: Icons.check_circle_outline,
          iconColor: AppColors.success,
          iconBackgroundColor:
              AppColors.success.withAlpha(_opacityToAlpha(0.12)),
          titleColor: AppColors.textPrimary,
        );
      case DialogType.error:
        return _DialogVisualDefaults(
          icon: Icons.error_outline,
          iconColor: AppColors.error,
          iconBackgroundColor:
              AppColors.error.withAlpha(_opacityToAlpha(0.12)),
          titleColor: AppColors.textPrimary,
        );
      case DialogType.warning:
        return _DialogVisualDefaults(
          icon: Icons.warning_amber_outlined,
          iconColor: AppColors.warning,
          iconBackgroundColor:
              AppColors.warning.withAlpha(_opacityToAlpha(0.12)),
          titleColor: AppColors.textPrimary,
        );
      case DialogType.info:
        return _DialogVisualDefaults(
          icon: Icons.info_outline,
          iconColor: AppColors.primary,
          iconBackgroundColor:
              AppColors.primary.withAlpha(_opacityToAlpha(0.12)),
          titleColor: AppColors.textPrimary,
        );
      case DialogType.question:
        return _DialogVisualDefaults(
          icon: Icons.help_outline,
          iconColor: AppColors.primary,
          iconBackgroundColor:
              AppColors.primary.withAlpha(_opacityToAlpha(0.12)),
          titleColor: AppColors.textPrimary,
        );
      case DialogType.custom:
        return _DialogVisualDefaults(
          icon: Icons.info_outline,
          iconColor: AppColors.primary,
          iconBackgroundColor:
              AppColors.primary.withAlpha(_opacityToAlpha(0.12)),
          titleColor: AppColors.textPrimary,
        );
    }
  }
}

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
    Color? titleColor,
    Color? iconBackgroundColor,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: (context) => _UniversalDialogWidget(
        title: title,
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
        titleColor: titleColor,
        iconBackgroundColor: iconBackgroundColor,
        child: child,
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
    this.titleColor,
    this.iconBackgroundColor,
  });

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
  final Color? titleColor;
  final Color? iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final defaults = _DialogVisualDefaults.forType(type);

    final effectiveBackgroundColor =
        backgroundColor ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white);
    final effectiveBorderRadius = borderRadius ?? 4.w;
    final effectiveContentPadding =
        contentPadding ?? EdgeInsets.fromLTRB(6.w, 2.5.h, 6.w, 2.h);
    final effectiveActionsPadding =
        actionsPadding ?? EdgeInsets.fromLTRB(4.w, 0, 4.w, 2.h);
    final resolvedIconColor = iconColor ?? defaults.iconColor;
    final resolvedIconBackgroundColor =
        iconBackgroundColor ?? defaults.iconBackgroundColor;
    final resolvedIcon = customIcon ?? defaults.icon;
    final resolvedTitleColor = titleColor ?? defaults.titleColor;
    final resolvedIconSize = iconSize ?? 50.0;

    return Dialog(
      backgroundColor: effectiveBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
      ),
      child: SizedBox(
        width: width ?? 80.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showIcon)
              _buildIcon(
                icon: resolvedIcon,
                iconColor: resolvedIconColor,
                backgroundColor: resolvedIconBackgroundColor,
                size: resolvedIconSize,
              ),
            if (title != null)
              Padding(
                padding: EdgeInsets.fromLTRB(6.w, 2.5.h, 6.w, 1.h),
                child: Text(
                  title!,
                  style: AppFonts.s18bold
                      .copyWith(fontSize: 16.sp, color: resolvedTitleColor),
                  textAlign: TextAlign.center,
                ),
              ),
            if (child != null)
              Padding(
                padding: effectiveContentPadding,
                child: child,
              ),
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

  Widget _buildIcon({
    required IconData icon,
    required Color iconColor,
    required Color backgroundColor,
    required double size,
  }) {
    return Padding(
      padding: EdgeInsets.only(top: 3.h),
      child: Center(
        child: Container(
          width: size + 5.w,
          height: size + 5.w,
          decoration: BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: size.sp,
            color: iconColor,
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
}
