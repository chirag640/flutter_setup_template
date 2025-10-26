import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_fonts.dart';

int _opacityToAlpha(double opacity) => (opacity.clamp(0.0, 1.0) * 255).round();

/// Universal card widget supporting multiple layouts, gradients, and interactions.
///
/// Example usage:
/// ```dart
/// UniversalCard(
///   title: 'Customer Name',
///   subtitle: 'email@example.com',
///   leading: CircleAvatar(child: Icon(Icons.person)),
///   trailing: Icon(Icons.chevron_right),
///   onTap: () => _viewDetails(),
/// )
///
/// UniversalCard.gradient(
///   gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
///   child: Padding(...),
/// )
///
/// UniversalCard.info(
///   title: 'Total Sales',
///   value: '\$12,450',
///   icon: Icons.attach_money,
/// )
/// ```
class UniversalCard extends StatefulWidget {
  const UniversalCard({
    Key? key,
    this.child,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.showBorder = false,
    this.borderRadius,
    this.gradient,
    this.elevation = 0,
    this.shadowColor,
    this.shadowBlurRadius = 1.6,
    this.shadowOffset = const Offset(0, 2),
    this.showShadow = false,
    this.splashColor,
    this.isExpandable = false,
    this.initiallyExpanded = false,
    this.expandedChild,
    this.badge,
    this.badgeColor,
    this.badgePosition = BadgePosition.topRight,
    this.isSelected = false,
    this.selectedBorderColor,
    this.selectedBorderWidth = 2.0,
    this.clipBehavior = Clip.antiAlias,
    this.semanticLabel,
  }) : super(key: key);

  // Named constructors
  factory UniversalCard.gradient({
    Key? key,
    required Gradient gradient,
    Widget? child,
    String? title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? borderRadius,
    double? width,
    double? height,
  }) {
    return UniversalCard(
      key: key,
      gradient: gradient,
      child: child,
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      onLongPress: onLongPress,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      width: width,
      height: height,
    );
  }

  factory UniversalCard.elevated({
    Key? key,
    Widget? child,
    String? title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    double elevation = 6,
    Color? shadowColor,
    bool showShadow = true,
  }) {
    return UniversalCard(
      key: key,
      child: child,
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      onLongPress: onLongPress,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      elevation: elevation,
      shadowColor: shadowColor,
      showShadow: showShadow,
    );
  }

  factory UniversalCard.outlined({
    Key? key,
    Widget? child,
    String? title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    Color? borderColor,
    double borderWidth = 1.2,
  }) {
    return UniversalCard(
      key: key,
      child: child,
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      onLongPress: onLongPress,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      showBorder: true,
      borderColor: borderColor ?? AppColors.outline,
      borderWidth: borderWidth,
    );
  }

  factory UniversalCard.filled({
    Key? key,
    Widget? child,
    String? title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    Color? backgroundColor,
  }) {
    return UniversalCard(
      key: key,
      child: child,
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      onTap: onTap,
      onLongPress: onLongPress,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      backgroundColor: backgroundColor ?? AppColors.surface,
    );
  }

  factory UniversalCard.info({
    Key? key,
    required String title,
    required String value,
    IconData? icon,
    Color? iconColor,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    Color? backgroundColor,
    Color? valueColor,
    Color? subtitleColor,
  }) {
    return UniversalCard(
      key: key,
      backgroundColor: backgroundColor ?? AppColors.surface,
      padding: padding ?? EdgeInsets.all(4.w),
      margin: margin,
      width: width,
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primary)
            .withAlpha(_opacityToAlpha(0.1)),
                borderRadius: BorderRadius.circular(3.w),
              ),
              child: Icon(icon, color: iconColor ?? AppColors.primary, size: 3.5.w),
            ),
            SizedBox(width: 4.w),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppFonts.s12medium.copyWith(
                    color: subtitleColor ?? AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppFonts.s20bold.copyWith(
                    color: valueColor ?? AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Core properties
  final Widget? child;
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;

  // Interaction
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  // Variant
  // Dimensions
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  // Styling
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final bool showBorder;
  final double? borderRadius;
  final Gradient? gradient;
  final double elevation;
  final Color? shadowColor;
  final double shadowBlurRadius;
  final Offset shadowOffset;
  final bool showShadow;
  final Color? splashColor;
  final Clip clipBehavior;

  // Expandable
  final bool isExpandable;
  final bool initiallyExpanded;
  final Widget? expandedChild;

  // Badge
  final String? badge;
  final Color? badgeColor;
  final BadgePosition badgePosition;

  // Selection
  final bool isSelected;
  final Color? selectedBorderColor;
  final double selectedBorderWidth;

  // Accessibility
  final String? semanticLabel;

  @override
  State<UniversalCard> createState() => _UniversalCardState();
}

enum BadgePosition { topLeft, topRight, bottomLeft, bottomRight }

class _UniversalCardState extends State<UniversalCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _expandController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    );
    if (_isExpanded) _expandController.value = 1.0;
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Resolve colors based on variant
    final effectiveBgColor = widget.backgroundColor ??
        (isDark ? const Color(0xFF1B1B1B) : Colors.white);
    final effectiveBorderColor = widget.borderColor ??
        (widget.showBorder ? AppColors.outline : null);

    // Border radius
    final effectiveBorderRadius = widget.borderRadius ?? 4.w;

    // Padding
    final effectivePadding = widget.padding ?? EdgeInsets.all(4.w);

    // Build card content
    Widget content = _buildContent();

    // Wrap in padding
    content = Padding(padding: effectivePadding, child: content);

    // Build decoration
    BoxDecoration decoration;
    if (widget.gradient != null) {
      decoration = BoxDecoration(
        gradient: widget.gradient,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: widget.isSelected
            ? Border.all(
                color: widget.selectedBorderColor ?? AppColors.primary,
                width: widget.selectedBorderWidth,
              )
            : (widget.showBorder || effectiveBorderColor != null)
                ? Border.all(
                    color: effectiveBorderColor ?? AppColors.outline,
                    width: widget.borderWidth,
                  )
                : null,
        boxShadow: widget.showShadow || widget.elevation > 0
            ? [
                BoxShadow(
                  color: widget.shadowColor ??
                      (isDark ? Colors.black45 : Colors.black12),
                  blurRadius: widget.shadowBlurRadius * 1.h,
                  offset: widget.shadowOffset,
                ),
              ]
            : null,
      );
    } else {
      decoration = BoxDecoration(
        color: effectiveBgColor,
        borderRadius: BorderRadius.circular(effectiveBorderRadius),
        border: widget.isSelected
            ? Border.all(
                color: widget.selectedBorderColor ?? AppColors.primary,
                width: widget.selectedBorderWidth,
              )
            : (widget.showBorder || effectiveBorderColor != null)
                ? Border.all(
                    color: effectiveBorderColor ?? AppColors.outline,
                    width: widget.borderWidth,
                  )
                : null,
        boxShadow: widget.showShadow || widget.elevation > 0
            ? [
                BoxShadow(
                  color: widget.shadowColor ??
                      (isDark ? Colors.black45 : Colors.black12),
                  blurRadius: widget.shadowBlurRadius * 1.h,
                  offset: widget.shadowOffset,
                ),
              ]
            : null,
      );
    }

    // Build card widget
    Widget card = Container(
      width: widget.width,
      height: widget.height,
      decoration: decoration,
      clipBehavior: widget.clipBehavior,
      child: widget.onTap != null || widget.onLongPress != null
          ? Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.isExpandable ? _toggleExpand : widget.onTap,
                onLongPress: widget.onLongPress,
                borderRadius: BorderRadius.circular(effectiveBorderRadius),
                splashColor: widget.splashColor,
                child: content,
              ),
            )
          : content,
    );

    // Add badge if present
    if (widget.badge != null) {
      card = Stack(
        clipBehavior: Clip.none,
        children: [
          card,
          _buildBadge(),
        ],
      );
    }

    // Add margin
    if (widget.margin != null) {
      card = Padding(padding: widget.margin!, child: card);
    }

    // Add semantic label
    if (widget.semanticLabel != null) {
      card = Semantics(
        label: widget.semanticLabel,
        button: widget.onTap != null,
        child: card,
      );
    }

    return card;
  }

  Widget _buildContent() {
    // If custom child is provided, use it
    if (widget.child != null && widget.title == null) {
      if (widget.isExpandable && widget.expandedChild != null) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.child!,
            SizeTransition(
              sizeFactor: _expandAnimation,
              child: widget.expandedChild!,
            ),
          ],
        );
      }
      return widget.child!;
    }

    // Build standard list-tile-like layout
    final children = <Widget>[];

    if (widget.leading != null) {
      children.add(widget.leading!);
      children.add(SizedBox(width: 3.w));
    }

    // Title and subtitle
    if (widget.title != null || widget.subtitle != null) {
      children.add(
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.title != null)
                Text(
                  widget.title!,
                  style: AppFonts.s16semibold,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              if (widget.subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  widget.subtitle!,
                  style: AppFonts.s14regular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (widget.trailing != null) {
      children.add(SizedBox(width: 3.w));
      children.add(widget.trailing!);
    } else if (widget.isExpandable) {
      children.add(SizedBox(width: 3.w));
      children.add(
        AnimatedRotation(
          turns: _isExpanded ? 0.5 : 0,
          duration: const Duration(milliseconds: 300),
          child: Icon(Icons.expand_more, size: 3.5.w),
        ),
      );
    }

    Widget row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: children,
    );

    // Add custom child below if both title and child are provided
    if (widget.child != null && widget.title != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          row,
          SizedBox(height: 3.w),
          widget.child!,
        ],
      );
    }

    // Add expandable content if applicable
    if (widget.isExpandable && widget.expandedChild != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          row,
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: widget.expandedChild!,
            ),
          ),
        ],
      );
    }

    return row;
  }

  Widget _buildBadge() {
    double top = -2.w;
    double? right;
    double? left;
    double bottom = -8;

    switch (widget.badgePosition) {
      case BadgePosition.topRight:
        right = -2.w;
        break;
      case BadgePosition.topLeft:
        left = -2.w;
        break;
      case BadgePosition.bottomRight:
        right = -2.w;
        top = double.nan;
        break;
      case BadgePosition.bottomLeft:
        left = -2.w;
        top = double.nan;
        break;
    }

    return Positioned(
      top: top.isNaN ? null : top,
      right: right,
      left: left,
      bottom: widget.badgePosition == BadgePosition.bottomLeft ||
              widget.badgePosition == BadgePosition.bottomRight
          ? bottom
          : null,
      child: Container(
  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: widget.badgeColor ?? AppColors.error,
          borderRadius: BorderRadius.circular(12),
        ),
    constraints: BoxConstraints(minWidth: 6.w, minHeight: 6.w),
        child: Text(
          widget.badge!,
          style: AppFonts.s12medium.copyWith(color: Colors.white, fontSize: 10.sp),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
    widget.onTap?.call();
  }
}
