import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/theme/app_colors.dart';
import '../universal/universal_app_bar.dart';
import '../universal/universal_bottom_bar.dart';
import '../universal/universal_button.dart' show UniversalButton, IconPosition;
import '../universal/universal_card.dart';
import '../universal/universal_dialog.dart';
import '../universal/universal_toggle.dart';

/// Comprehensive showcase page demonstrating all universal widgets.
///
/// This page serves as:
/// 1. Live documentation for developers
/// 2. Visual testing ground for all widget variants
/// 3. Example implementation reference
class WidgetsShowcasePage extends StatefulWidget {
  const WidgetsShowcasePage({super.key});

  @override
  State<WidgetsShowcasePage> createState() => _WidgetsShowcasePageState();
}

class _WidgetsShowcasePageState extends State<WidgetsShowcasePage> {
  bool _switchValue = false;
  bool _checkboxValue = false;
  bool _radioValue = false;
  bool _isLoading = false;
  bool _cardSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniversalAppBar(
        title: 'Universal Widgets Showcase',
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(4.w),
        children: [
          _buildSectionHeader('Buttons'),
          _buildButtonsSection(),
          SizedBox(height: 3.h),

          _buildSectionHeader('Cards'),
          _buildCardsSection(),
          SizedBox(height: 3.h),

          _buildSectionHeader('Toggles'),
          _buildTogglesSection(),
          SizedBox(height: 3.h),

          _buildSectionHeader('Dialogs'),
          _buildDialogsSection(),
          SizedBox(height: 3.h),

          _buildSectionHeader('App Bars'),
          _buildAppBarsSection(),
          SizedBox(height: 3.h),

          _buildSectionHeader('Bottom Bars'),
          _buildBottomBarsInfo(),
          SizedBox(height: 14.h), // Space for bottom bar
        ],
      ),
      bottomNavigationBar: UniversalBottomBar.actions(
        primaryText: 'Save Changes',
        primaryOnPressed: _isLoading ? null : _handleSave,
        primaryIsLoading: _isLoading,
        secondaryText: 'Cancel',
        secondaryOnPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
  }

  // BUTTONS SECTION
  Widget _buildButtonsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Primary Buttons',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 1.2.h),
        UniversalButton(
          text: 'Primary Button',
          onPressed: () => _showSnackBar('Primary tapped'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        SizedBox(height: 1.2.h),
        UniversalButton(
          text: 'Loading Button',
          onPressed: () {},
          isLoading: true,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        SizedBox(height: 1.2.h),
        const UniversalButton(
          text: 'Disabled Button',
          onPressed: null,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),

        SizedBox(height: 2.5.h),
        const Text(
          'Color Variants',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 1.2.h),
        UniversalButton(
          text: 'Secondary',
          onPressed: () => _showSnackBar('Secondary tapped'),
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
        ),
        SizedBox(height: 1.2.h),
        UniversalButton(
          text: 'Outlined',
          onPressed: () => _showSnackBar('Outlined tapped'),
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primary,
          borderColor: AppColors.primary,
          showBorder: true,
        ),
        SizedBox(height: 1.2.h),
        UniversalButton(
          text: 'Text Button',
          onPressed: () => _showSnackBar('Text tapped'),
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primary,
          elevation: 0,
        ),
        const SizedBox(height: 8),
        UniversalButton(
          text: 'Danger Button',
          onPressed: () => _showSnackBar('Danger tapped'),
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),

        SizedBox(height: 2.5.h),
        const Text(
          'Icon Buttons',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 1.2.h),
        UniversalButton.icon(
          text: 'Add Item',
          icon: Icons.add,
          onPressed: () => _showSnackBar('Add tapped'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        SizedBox(height: 1.2.h),
        UniversalButton.icon(
          text: 'Next',
          icon: Icons.arrow_forward,
          onPressed: () => _showSnackBar('Next tapped'),
          iconPosition: IconPosition.right,
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
        ),
        SizedBox(height: 1.2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            UniversalButton.iconOnly(
              icon: Icons.edit,
              onPressed: () => _showSnackBar('Edit tapped'),
              tooltipMessage: 'Edit',
              backgroundColor: AppColors.primary,
              iconColor: Colors.white,
            ),
            UniversalButton.iconOnly(
              icon: Icons.delete,
              onPressed: () => _showSnackBar('Delete tapped'),
              backgroundColor: Colors.red,
              iconColor: Colors.white,
              tooltipMessage: 'Delete',
            ),
            UniversalButton.iconOnly(
              icon: Icons.share,
              onPressed: () => _showSnackBar('Share tapped'),
              backgroundColor: AppColors.secondary,
              iconColor: Colors.white,
              tooltipMessage: 'Share',
            ),
          ],
        ),

        SizedBox(height: 2.5.h),
        const Text(
          'Gradient Button',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 1.2.h),
        UniversalButton(
          text: 'Premium Feature',
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          onPressed: () => _showSnackBar('Premium tapped'),
          icon: Icons.stars,
          foregroundColor: Colors.white,
        ),

        const SizedBox(height: 16),
        const Text(
          'Button Sizes',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 1.2.h),
        UniversalButton(
          text: 'Small',
          onPressed: () {},
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          fontSize: 12,
        ),
        const SizedBox(height: 8),
        UniversalButton(
          text: 'Medium (Default)',
          onPressed: () {},
          // Uses default height: 48, padding: 20/12
        ),
        const SizedBox(height: 8),
        UniversalButton(
          text: 'Large',
          onPressed: () {},
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          fontSize: 16,
        ),
      ],
    );
  }

  // CARDS SECTION
  Widget _buildCardsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Standard Cards',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        UniversalCard(
          title: 'John Doe',
          subtitle: 'john.doe@email.com',
          leading: const CircleAvatar(child: Icon(Icons.person)),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showSnackBar('Card tapped'),
        ),
        const SizedBox(height: 8),
        UniversalCard(
          title: 'Card with Badge',
          subtitle: 'This card has a notification badge',
          badge: '5',
          badgeColor: Colors.red,
          onTap: () => _showSnackBar('Badge card tapped'),
        ),
        const SizedBox(height: 8),
        UniversalCard(
          title: 'Selectable Card',
          subtitle: 'Tap to select/deselect',
          isSelected: _cardSelected,
          onTap: () => setState(() => _cardSelected = !_cardSelected),
        ),

        const SizedBox(height: 16),
        const Text(
          'Card Variants',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        UniversalCard.elevated(
          title: 'Elevated Card',
          subtitle: 'With shadow',
          elevation: 8,
        ),
        const SizedBox(height: 8),
        UniversalCard.outlined(
          title: 'Outlined Card',
          subtitle: 'With border',
          borderColor: AppColors.primary,
        ),
        const SizedBox(height: 8),
        UniversalCard.filled(
          title: 'Filled Card',
          subtitle: 'With background color',
          backgroundColor: AppColors.primary.withAlpha((0.08 * 255).round()),
        ),

        const SizedBox(height: 16),
        const Text('Info Cards', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: UniversalCard.info(
                title: 'Total Sales',
                value: r'$12,450',
                icon: Icons.attach_money,
                iconColor: Colors.green,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: UniversalCard.info(
                title: 'Customers',
                value: '1,234',
                icon: Icons.people,
                iconColor: Colors.blue,
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        const Text(
          'Gradient Card',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        UniversalCard.gradient(
          gradient: const LinearGradient(
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
          padding: const EdgeInsets.all(20),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Premium Feature',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Upgrade to unlock this feature',
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        const Text(
          'Expandable Card',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        UniversalCard(
          title: 'Click to expand',
          subtitle: 'More content below',
          isExpandable: true,
          expandedChild: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'This is the expanded content that appears when you tap the card. You can put any widget here!',
            ),
          ),
        ),
      ],
    );
  }

  // TOGGLES SECTION
  Widget _buildTogglesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Switch', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        UniversalToggle.switchStyle(
          value: _switchValue,
          onChanged: (v) => setState(() => _switchValue = v),
          label: 'Enable notifications',
        ),
        const SizedBox(height: 8),
        UniversalToggle.switchStyle(
          value: true,
          onChanged: null,
          label: 'Disabled switch',
          isDisabled: true,
        ),

        const SizedBox(height: 16),
        const Text('Checkbox', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        UniversalToggle.checkbox(
          value: _checkboxValue,
          onChanged: (v) => setState(() => _checkboxValue = v),
          label: 'I agree to terms and conditions',
        ),
        const SizedBox(height: 8),
        UniversalToggle.checkbox(
          value: true,
          onChanged: null,
          label: 'Disabled checkbox',
          isDisabled: true,
        ),

        const SizedBox(height: 16),
        const Text('Radio', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        UniversalToggle.radio(
          value: _radioValue,
          onChanged: (v) => setState(() => _radioValue = v),
          label: 'Option 1',
        ),
        const SizedBox(height: 8),
        UniversalToggle.radio(
          value: !_radioValue,
          onChanged: (v) => setState(() => _radioValue = !v),
          label: 'Option 2',
        ),
      ],
    );
  }

  // DIALOGS SECTION
  Widget _buildDialogsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        UniversalButton(
          text: 'Show Confirmation Dialog',
          onPressed: _showConfirmationDialog,
          icon: Icons.check_circle_outline,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        const SizedBox(height: 8),
        UniversalButton(
          text: 'Show Success Dialog',
          onPressed: _showSuccessDialog,
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          icon: Icons.check,
        ),
        const SizedBox(height: 8),
        UniversalButton(
          text: 'Show Error Dialog',
          onPressed: _showErrorDialog,
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.error_outline,
        ),
        const SizedBox(height: 8),
        UniversalButton(
          text: 'Show Warning Dialog',
          onPressed: _showWarningDialog,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.orange,
          borderColor: Colors.orange,
          showBorder: true,
          icon: Icons.warning_amber_outlined,
        ),
        const SizedBox(height: 8),
        UniversalButton(
          text: 'Show Loading Dialog',
          onPressed: _showLoadingDialog,
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primary,
          icon: Icons.hourglass_empty,
        ),
      ],
    );
  }

  // APP BARS SECTION
  Widget _buildAppBarsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'App bars are shown at the top of this page. Tap the buttons below to navigate to pages with different app bar styles:',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        const UniversalButton(
          text: 'Standard App Bar (Current)',
          onPressed: null,
          icon: Icons.done,
        ),
        const SizedBox(height: 8),
        UniversalButton(
          text: 'Gradient App Bar Example',
          onPressed: _navigateToGradientAppBar,
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          icon: Icons.gradient,
        ),
        const SizedBox(height: 8),
        UniversalButton(
          text: 'Search App Bar Example',
          onPressed: _navigateToSearchAppBar,
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primary,
          borderColor: AppColors.primary,
          showBorder: true,
          icon: Icons.search,
        ),
      ],
    );
  }

  // BOTTOM BARS INFO
  Widget _buildBottomBarsInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Bottom bars are shown at the bottom of this page. This page uses the "actions" variant with Save/Cancel buttons. Other variants:',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        UniversalCard.filled(
          backgroundColor: AppColors.surface,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• Single button: Full-width primary action',
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 4),
              Text(
                '• Actions: Split Save/Cancel layout (current)',
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 4),
              Text(
                '• Custom: Any widget combination',
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // HELPER METHODS
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _showConfirmationDialog() async {
    final confirmed = await UniversalDialog.showConfirmation(
      context,
      title: 'Confirm Action',
      message: 'Are you sure you want to proceed with this action?',
      confirmText: 'Yes, Continue',
    );
    if (confirmed) {
      _showSnackBar('Action confirmed!');
    }
  }

  Future<void> _showSuccessDialog() async {
    await UniversalDialog.showSuccess(
      context,
      title: 'Success!',
      message: 'Your changes have been saved successfully.',
      autoDismissAfter: const Duration(seconds: 3),
    );
  }

  Future<void> _showErrorDialog() async {
    await UniversalDialog.showError(
      context,
      message: 'Something went wrong. Please try again.',
    );
  }

  Future<void> _showWarningDialog() async {
    await UniversalDialog.showWarning(
      context,
      message: 'This action may have unintended consequences.',
    );
  }

  Future<void> _showLoadingDialog() async {
    UniversalDialog.showLoading(context, message: 'Processing...');
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) Navigator.pop(context);
    _showSnackBar('Loading complete!');
  }

  void _showInfoDialog() {
    UniversalDialog.showInfo(
      context,
      title: 'About This Showcase',
      message:
          'This page demonstrates all universal widgets available in the app. Each widget is fully customizable with 20-30 flags and supports theming.',
    );
  }

  void _handleSave() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isLoading = false);
        _showSuccessDialog();
      }
    });
  }

  void _navigateToGradientAppBar() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _GradientAppBarExample()),
    );
  }

  void _navigateToSearchAppBar() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _SearchAppBarExample()),
    );
  }
}

// EXAMPLE PAGES FOR APP BAR VARIANTS
class _GradientAppBarExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniversalAppBar.gradient(
        title: 'Gradient App Bar',
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.gradient, size: 64, color: AppColors.primary),
            SizedBox(height: 16),
            Text(
              'This page has a gradient app bar!',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchAppBarExample extends StatefulWidget {
  @override
  State<_SearchAppBarExample> createState() => _SearchAppBarExampleState();
}

class _SearchAppBarExampleState extends State<_SearchAppBarExample> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniversalAppBar.search(
        onSearch: (query) => setState(() => _searchQuery = query),
        hintText: 'Search customers...',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search, size: 64, color: AppColors.primary),
              const SizedBox(height: 16),
              const Text(
                'Search App Bar Example',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _searchQuery.isEmpty
                    ? 'Start typing to search...'
                    : 'Searching for: "$_searchQuery"',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
