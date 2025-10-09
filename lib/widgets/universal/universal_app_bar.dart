import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';

/// Universal app bar with back button, actions, search, and full customization.
///
/// Example usage:
/// ```dart
/// UniversalAppBar(
///   title: 'Customer Details',
///   showBackButton: true,
///   actions: [
///     IconButton(icon: Icon(Icons.edit), onPressed: () {}),
///   ],
/// )
///
/// UniversalAppBar.search(
///   onSearch: (query) => _handleSearch(query),
/// )
///
/// UniversalAppBar.gradient(
///   title: 'Premium',
///   gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
/// )
/// ```
class UniversalAppBar extends StatelessWidget implements PreferredSizeWidget {
  const UniversalAppBar({
    Key? key,
    this.title,
    this.titleWidget,
    this.titleStyle,
    this.showBackButton = true,
    this.onBackPressed,
    this.confirmOnBack = false,
    this.backConfirmMessage = 'Are you sure you want to go back?',
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 0,
    this.shadowColor,
    this.height,
    this.gradient,
    this.showBottomBorder = false,
    this.borderColor,
    this.borderWidth = 1.0,
    this.flexibleSpace,
    this.bottom,
  }) : super(key: key);

  // Named constructors
  factory UniversalAppBar.gradient({
    Key? key,
    String? title,
    Widget? titleWidget,
    required Gradient gradient,
    bool showBackButton = true,
    VoidCallback? onBackPressed,
    List<Widget>? actions,
    bool centerTitle = true,
    Color? foregroundColor,
    double? height,
    PreferredSizeWidget? bottom,
  }) {
    return UniversalAppBar(
      key: key,
      title: title,
      titleWidget: titleWidget,
      gradient: gradient,
      showBackButton: showBackButton,
      onBackPressed: onBackPressed,
      actions: actions,
      centerTitle: centerTitle,
      foregroundColor: foregroundColor ?? Colors.white,
      height: height,
      bottom: bottom,
    );
  }

  factory UniversalAppBar.search({
    Key? key,
    required ValueChanged<String> onSearch,
    String hintText = 'Search...',
    Color? backgroundColor,
    double? height,
  }) {
    return UniversalAppBar(
      key: key,
      backgroundColor: backgroundColor,
      height: height,
      titleWidget: _SearchBar(
        onSearch: onSearch,
        hintText: hintText,
      ),
      showBackButton: false,
      centerTitle: false,
    );
  }

  // Content
  final String? title;
  final Widget? titleWidget;
  final TextStyle? titleStyle;

  // Back button
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool confirmOnBack;
  final String backConfirmMessage;

  // Navigation
  final Widget? leading;
  final List<Widget>? actions;

  // Layout
  final bool centerTitle;

  // Styling
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final Color? shadowColor;
  final double? height;
  final Gradient? gradient;
  final bool showBottomBorder;
  final Color? borderColor;
  final double borderWidth;

  // Additional
  final Widget? flexibleSpace;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
        (height ?? kToolbarHeight) + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final effectiveBgColor = backgroundColor ??
        (isDark ? const Color(0xFF1E1E1E) : Colors.white);
    final effectiveFgColor =
        foregroundColor ?? (isDark ? Colors.white : AppColors.textPrimary);

    // Build title widget
    Widget? titleContent;
    if (titleWidget != null) {
      titleContent = titleWidget;
    } else if (title != null) {
      titleContent = Text(
        title!,
        style: titleStyle ?? AppFonts.s18bold.copyWith(color: effectiveFgColor),
      );
    }

    // Build leading widget
    Widget? leadingWidget;
    if (leading != null) {
      leadingWidget = leading;
    } else if (showBackButton) {
      leadingWidget = IconButton(
        icon: Icon(Icons.arrow_back, color: effectiveFgColor),
        onPressed: () => _handleBack(context),
      );
    }

    // Build app bar
    AppBar appBar = AppBar(
      title: titleContent,
      centerTitle: centerTitle,
      leading: leadingWidget,
      actions: actions,
      backgroundColor: gradient == null ? effectiveBgColor : Colors.transparent,
      foregroundColor: effectiveFgColor,
      elevation: elevation,
      shadowColor: shadowColor,
      toolbarHeight: height ?? kToolbarHeight,
      flexibleSpace: gradient != null
          ? Container(
              decoration: BoxDecoration(gradient: gradient),
              child: flexibleSpace,
            )
          : flexibleSpace,
      bottom: bottom,
      shape: showBottomBorder
          ? Border(
              bottom: BorderSide(
                color: borderColor ??
                    (isDark ? Colors.grey[800]! : AppColors.outline),
                width: borderWidth,
              ),
            )
          : null,
    );

    return appBar;
  }

  void _handleBack(BuildContext context) async {
    if (confirmOnBack) {
      final shouldPop = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dctx) => AlertDialog(
          title: const Text('Confirm'),
          content: Text(backConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dctx).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dctx).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      );
      if (shouldPop == true) {
        if (onBackPressed != null) {
          onBackPressed!();
        } else if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      }
    } else {
      if (onBackPressed != null) {
        onBackPressed!();
      } else if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    }
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({
    Key? key,
    required this.onSearch,
    this.hintText = 'Search...',
  }) : super(key: key);

  final ValueChanged<String> onSearch;
  final String hintText;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onSearch,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _controller.clear();
                  widget.onSearch('');
                },
              )
            : null,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
      onTap: () => setState(() {}),
      onEditingComplete: () => setState(() {}),
    );
  }
}
