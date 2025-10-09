# Universal Widgets Library

A comprehensive, production-ready widget library for Flutter applications with extensive customization options and consistent theming.

## 📦 Included Widgets

### 1. **UniversalButton** - Highly Customizable Button Widget
- **5 Variants**: Primary, Secondary, Outlined, Text, Danger
- **4 Size Presets**: Small, Medium, Large, Custom
- **Icon Support**: Left, Right, Top, Bottom, Icon-only
- **States**: Loading, Disabled, with badges
- **Styling**: Gradient support, custom shapes, shadows, elevation
- **Named Constructors**: `.icon()`, `.gradient()`, `.iconOnly()`

#### Quick Examples:
```dart
// Primary button with loading state
UniversalButton(
  text: 'Submit',
  onPressed: () => _handleSubmit(),
  isLoading: _isSubmitting,
)

// Icon button with gradient
UniversalButton.gradient(
  text: 'Premium',
  icon: Icons.stars,
  gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
  onPressed: () {},
)

// Icon-only circular button
UniversalButton.iconOnly(
  icon: Icons.edit,
  onPressed: () {},
  tooltipMessage: 'Edit',
)
```

**Customization Flags** (30+):
- `variant`, `size`, `isLoading`, `isDisabled`
- `icon`, `iconPosition`, `width`, `height`
- `backgroundColor`, `foregroundColor`, `borderColor`, `borderWidth`
- `gradient`, `elevation`, `borderRadius`, `customShape`
- `loadingIndicatorColor`, `showShadow`, `shadowColor`
- `badgeText`, `badgeColor`, `tooltipMessage`
- `animationDuration`, `hapticFeedback`, and more

---

### 2. **UniversalCard** - Flexible Card/Container Widget
- **4 Variants**: Standard, Elevated, Outlined, Filled
- **Layouts**: List-tile style, Info card, Custom content
- **Features**: Expandable, Selectable, With badges
- **Interactions**: Tap, Long-press handlers
- **Styling**: Gradient support, borders, shadows

#### Quick Examples:
```dart
// List-tile style card
UniversalCard(
  title: 'John Doe',
  subtitle: 'john@email.com',
  leading: CircleAvatar(child: Icon(Icons.person)),
  trailing: Icon(Icons.chevron_right),
  onTap: () => _viewDetails(),
)

// Info card with icon
UniversalCard.info(
  title: 'Total Sales',
  value: '\$12,450',
  icon: Icons.attach_money,
  iconColor: Colors.green,
)

// Gradient card
UniversalCard.gradient(
  gradient: LinearGradient(colors: [Colors.blue, Colors.purple]),
  child: MyCustomContent(),
)
```

**Customization Flags** (25+):
- `variant`, `title`, `subtitle`, `leading`, `trailing`
- `child`, `onTap`, `onLongPress`
- `backgroundColor`, `borderColor`, `borderWidth`, `borderRadius`
- `gradient`, `elevation`, `showShadow`
- `isExpandable`, `expandedChild`, `initiallyExpanded`
- `badge`, `badgePosition`, `isSelected`
- `padding`, `margin`, `width`, `height`, `clipBehavior`

---

### 3. **UniversalDialog** - Comprehensive Dialog System
- **5 Types**: Info, Success, Warning, Error, Question
- **Presets**: Confirmation, Success, Error, Warning, Loading
- **Features**: Auto-dismiss, Custom actions, Icons
- **Styling**: Custom width, padding, colors

#### Quick Examples:
```dart
// Confirmation dialog
final confirmed = await UniversalDialog.showConfirmation(
  context,
  title: 'Delete Item?',
  message: 'This action cannot be undone.',
  confirmText: 'Delete',
  isDanger: true,
);

// Success dialog with auto-dismiss
await UniversalDialog.showSuccess(
  context,
  title: 'Success!',
  message: 'Your changes have been saved.',
  autoDismissAfter: Duration(seconds: 3),
);

// Custom dialog
await UniversalDialog.show(
  context,
  title: 'Custom Dialog',
  child: MyCustomWidget(),
  actions: [/* custom buttons */],
);
```

**Customization Flags** (15+):
- `type`, `title`, `child`, `actions`
- `barrierDismissible`, `barrierColor`
- `showIcon`, `customIcon`, `iconColor`, `iconSize`
- `width`, `borderRadius`, `backgroundColor`
- `contentPadding`, `actionsPadding`, `actionsAlignment`

---

### 4. **UniversalBottomBar** - Bottom Action Bar
- **3 Modes**: Single button, Actions (Save/Cancel), Custom
- **Features**: Loading states, Icon buttons, Gradient support
- **Layout**: Full-width or split button layouts
- **Styling**: Custom height, padding, borders

#### Quick Examples:
```dart
// Save/Cancel actions
UniversalBottomBar.actions(
  primaryText: 'Save',
  primaryOnPressed: () => _save(),
  primaryIsLoading: _isSaving,
  secondaryText: 'Cancel',
  secondaryOnPressed: () => Navigator.pop(context),
)

// Single button
UniversalBottomBar.single(
  text: 'Continue',
  onPressed: () => _continue(),
  icon: Icons.arrow_forward,
)

// Custom layout
UniversalBottomBar.custom(
  children: [/* custom widgets */],
  alignment: MainAxisAlignment.spaceBetween,
)
```

**Customization Flags** (20+):
- `mode`, `primaryText`, `secondaryText`
- `primaryOnPressed`, `secondaryOnPressed`
- `primaryIcon`, `secondaryIcon`
- `primaryIsLoading`, `primaryVariant`, `secondaryVariant`
- `height`, `padding`, `backgroundColor`, `gradient`
- `elevation`, `showTopBorder`, `borderColor`, `borderWidth`
- `isSticky`, `safeArea`, `alignment`

---

### 5. **UniversalToggle** - Multi-Style Toggle Widget
- **3 Styles**: Switch, Checkbox, Radio
- **Label Positions**: Left, Right, Top, Bottom
- **States**: Active, Inactive, Disabled
- **Styling**: Custom colors, sizes, borders

#### Quick Examples:
```dart
// Switch with label
UniversalToggle.switchStyle(
  value: _isEnabled,
  onChanged: (v) => setState(() => _isEnabled = v),
  label: 'Enable notifications',
)

// Checkbox
UniversalToggle.checkbox(
  value: _agreed,
  onChanged: (v) => setState(() => _agreed = v),
  label: 'I agree to terms',
)

// Radio button
UniversalToggle.radio(
  value: _selected == 'option1',
  onChanged: (v) => setState(() => _selected = 'option1'),
  label: 'Option 1',
)
```

**Customization Flags** (15+):
- `style`, `value`, `onChanged`, `label`
- `labelPosition`, `labelStyle`
- `activeColor`, `inactiveColor`
- `width`, `height`, `borderRadius`
- `showBorder`, `borderColor`, `borderWidth`
- `isDisabled`, `semanticLabel`

---

### 6. **UniversalAppBar** - Customizable App Bar
- **Features**: Back button with confirmation, Actions, Search mode
- **Styling**: Gradient support, Custom height, Bottom border
- **Variants**: Standard, Gradient, Search
- **Behavior**: Configurable back navigation

#### Quick Examples:
```dart
// Standard app bar
UniversalAppBar(
  title: 'Customer Details',
  showBackButton: true,
  actions: [
    IconButton(icon: Icon(Icons.edit), onPressed: () {}),
  ],
)

// Gradient app bar
UniversalAppBar.gradient(
  title: 'Premium',
  gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
)

// Search app bar
UniversalAppBar.search(
  onSearch: (query) => _handleSearch(query),
  hintText: 'Search customers...',
)
```

**Customization Flags** (15+):
- `title`, `titleWidget`, `titleStyle`
- `showBackButton`, `onBackPressed`
- `confirmOnBack`, `backConfirmMessage`
- `leading`, `actions`, `centerTitle`
- `backgroundColor`, `foregroundColor`
- `elevation`, `shadowColor`, `height`
- `gradient`, `showBottomBorder`, `borderColor`

---

## 🎨 Design Principles

### 1. **Consistency**
- All widgets follow the same API pattern
- Unified naming conventions
- Consistent flag naming across widgets

### 2. **Customization**
- 20-30+ customization flags per widget
- Named constructors for common patterns
- Preset variants for quick use

### 3. **Theme Awareness**
- Automatically adapts to light/dark theme
- Uses app's color scheme by default
- Respects Material Design guidelines

### 4. **Developer Experience**
- Inline documentation with examples
- Sensible defaults (minimal required props)
- Type-safe enums for variants

### 5. **Production Ready**
- Handles edge cases (disabled, loading, errors)
- Accessibility support (semantic labels)
- Null-safe and well-tested

---

## 🚀 Usage

### 1. View the Showcase
Navigate to the showcase page to see all widgets in action:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => WidgetsShowcasePage(),
  ),
);
```

Or from the home screen, tap **"View Universal Widgets"**.

### 2. Import What You Need
```dart
import 'package:setup/widgets/universal/universal_button.dart';
import 'package:setup/widgets/universal/universal_card.dart';
import 'package:setup/widgets/universal/universal_dialog.dart';
// ... etc
```

### 3. Use in Your Code
All widgets are designed to work seamlessly with your existing theme and can be dropped into any Flutter project.

---

## 📖 Example: Building a Form Page

```dart
import 'package:flutter/material.dart';
import 'widgets/universal/universal_app_bar.dart';
import 'widgets/universal/universal_button.dart';
import 'widgets/universal/universal_card.dart';
import 'widgets/universal/universal_bottom_bar.dart';
import 'widgets/universal/universal_toggle.dart';

class CustomerFormPage extends StatefulWidget {
  @override
  State<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends State<CustomerFormPage> {
  bool _isEnabled = true;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: UniversalAppBar(
        title: 'Add Customer',
        showBackButton: true,
        confirmOnBack: true,
        actions: [
          UniversalToggle.switchStyle(
            value: _isEnabled,
            onChanged: (v) => setState(() => _isEnabled = v),
            label: 'Enabled',
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          UniversalCard(
            title: 'Customer Information',
            child: Column(
              children: [
                // Your form fields here
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: UniversalBottomBar.actions(
        primaryText: 'Save',
        primaryOnPressed: _isSaving ? null : () => _handleSave(),
        primaryIsLoading: _isSaving,
        secondaryText: 'Cancel',
        secondaryOnPressed: () => Navigator.pop(context),
      ),
    );
  }

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);
    // Save logic...
    await Future.delayed(Duration(seconds: 2));
    if (mounted) {
      await UniversalDialog.showSuccess(
        context,
        message: 'Customer saved successfully!',
      );
      Navigator.pop(context);
    }
  }
}
```

---

## 🎯 Best Practices

### 1. **Use Named Constructors**
```dart
// ✅ Good - expressive and concise
UniversalButton.icon(text: 'Add', icon: Icons.add, onPressed: () {})

// ❌ Avoid - verbose for common patterns
UniversalButton(text: 'Add', icon: Icons.add, iconPosition: IconPosition.left, onPressed: () {})
```

### 2. **Leverage Presets**
```dart
// ✅ Good - use built-in dialog presets
UniversalDialog.showSuccess(context, message: 'Done!')

// ❌ Avoid - unnecessary manual setup
UniversalDialog.show(
  context,
  type: DialogType.success,
  showIcon: true,
  child: Text('Done!'),
  actions: [ElevatedButton(...)],
)
```

### 3. **Keep Customizations Minimal**
Only override what you need. The widgets have sensible defaults.

```dart
// ✅ Good - minimal props
UniversalButton(text: 'Save', onPressed: () {})

// ❌ Unnecessary - explicit defaults
UniversalButton(
  text: 'Save',
  onPressed: () {},
  variant: ButtonVariant.primary, // default
  size: ButtonSize.medium, // default
  isLoading: false, // default
  isDisabled: false, // default
)
```

### 4. **Consistent Variant Usage**
Stick to semantic variants across your app:
- **Primary**: Main actions (Save, Submit, Confirm)
- **Secondary**: Alternative actions (Cancel, Back)
- **Danger**: Destructive actions (Delete, Remove)
- **Outlined/Text**: Tertiary actions

---

## 🔧 Extending the Library

All widgets are designed to be extended. Example:

```dart
// Create app-specific button presets
class AppButton extends UniversalButton {
  AppButton.save({VoidCallback? onPressed, bool isLoading = false})
      : super(
          text: 'Save Changes',
          icon: Icons.save,
          onPressed: onPressed,
          isLoading: isLoading,
          showShadow: true,
        );
}
```

---

## 📝 Notes

- All widgets are **null-safe** and follow Flutter best practices
- **Theme-aware**: Automatically adapts to your app's theme
- **Accessible**: Includes semantic labels and proper ARIA support
- **Tested**: Built following your existing `ReusableTextField` pattern
- **No iOS**: As requested, iOS-specific code is excluded

---

## 🐛 Troubleshooting

### Import Conflicts
If you see `ButtonVariant` conflicts, use selective imports:

```dart
import 'widgets/universal/universal_button.dart' show UniversalButton, ButtonVariant;
import 'widgets/universal/universal_bottom_bar.dart' hide ButtonVariant;
```

### Deprecated Warnings
The analyzer shows `.withOpacity()` deprecation warnings. These are informational and don't affect functionality. To fix, replace with `.withValues()` (Material 3).

---

## 📄 License

Part of the `setup` Flutter template project.
