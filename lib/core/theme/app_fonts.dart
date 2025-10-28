import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../utils/platform_utils.dart';

class AppFonts {
  static String? get _fontFamily {
    if (PlatformUtils.isIOS) {
      return null; // Use system font (SF Pro)
    }
    return 'SF Pro Text';
  }

  // Public accessor for other modules
  static String? get fontFamily => _fontFamily;
  // Internal helper to build a platform-adaptive text style
  static TextStyle _adaptive(double size, FontWeight weight) {
    // Use sizer's .sp to scale font sizes per device. Letter spacing is
    // visual and should scale with the font size as well.
    return TextStyle(
      fontSize: size.sp - 2,
      fontWeight: weight,
      fontFamily: _fontFamily,
    );
  }

  // AppBar Title: 20px, platform adaptive
  static TextStyle get appBarTitle => _adaptive(17, FontWeight.bold);

  // Named tokens per Figma spec

  // 24 px
  static TextStyle get s24bold => _adaptive(18.5, FontWeight.bold);
  static TextStyle get s24semibold => _adaptive(18.5, FontWeight.w600);
  static TextStyle get s24medium => _adaptive(18.5, FontWeight.w500);
  static TextStyle get s24regular => _adaptive(18.5, FontWeight.w400);

  // // 22 px
  // static TextStyle get s22bold => _adaptive(
  //   22.0,
  //   FontWeight.w700,
  //
  // );
  // static TextStyle get s22semibold => _adaptive(
  //   22.0,
  //   FontWeight.w600,
  //
  // );
  // static TextStyle get s22medium => _adaptive(
  //   22.0,
  //   FontWeight.w500,
  //
  // );
  // static TextStyle get s22regular => _adaptive(
  //   22.0,
  //   FontWeight.w400,
  //
  // );

  // 20 px
  static TextStyle get s20bold => _adaptive(17, FontWeight.w700);
  static TextStyle get s20semibold => _adaptive(17, FontWeight.w600);
  static TextStyle get s20medium => _adaptive(17, FontWeight.w500);
  static TextStyle get s20regular => _adaptive(17, FontWeight.w400);

  // 18 px
  static TextStyle get s18bold => _adaptive(15, FontWeight.bold);
  static TextStyle get s18semibold => _adaptive(15, FontWeight.w600);
  static TextStyle get s18medium => _adaptive(15, FontWeight.w500);
  static TextStyle get s18regular => _adaptive(15, FontWeight.w400);

  // 17 px
  static TextStyle get s17bold => _adaptive(14.5, FontWeight.bold);
  static TextStyle get s17semibold => _adaptive(14.5, FontWeight.w600);
  static TextStyle get s17medium => _adaptive(14.5, FontWeight.w500);
  static TextStyle get s17regular => _adaptive(14.5, FontWeight.w400);

  // 16 px
  static TextStyle get s16bold => _adaptive(13.5, FontWeight.bold);
  static TextStyle get s16semibold => _adaptive(13.5, FontWeight.w600);
  static TextStyle get s16medium => _adaptive(13.5, FontWeight.w500);
  static TextStyle get s16regular => _adaptive(13.5, FontWeight.w400);

  // 14 px
  static TextStyle get s14bold => _adaptive(12, FontWeight.bold);
  static TextStyle get s14semibold => _adaptive(12, FontWeight.w600);
  static TextStyle get s14medium => _adaptive(12, FontWeight.w500);
  static TextStyle get s14regular => _adaptive(12, FontWeight.w400);

  // 11 px
  static TextStyle get s13bold => _adaptive(11.5, FontWeight.bold);
  static TextStyle get s13semibold => _adaptive(11.5, FontWeight.w600);
  static TextStyle get s13medium => _adaptive(11.5, FontWeight.w500);
  static TextStyle get s13regular => _adaptive(11.5, FontWeight.w400);

  // 12 px
  static TextStyle get s12bold => _adaptive(11, FontWeight.bold);
  static TextStyle get s12semibold => _adaptive(11, FontWeight.w600);
  static TextStyle get s12medium => _adaptive(11, FontWeight.w500);
  static TextStyle get s12regular => _adaptive(11, FontWeight.w400);

  // 11 px
  static TextStyle get s11bold => _adaptive(10, FontWeight.bold);
  static TextStyle get s11semibold => _adaptive(10, FontWeight.w600);
  static TextStyle get s11medium => _adaptive(10, FontWeight.w500);
  static TextStyle get s11regular => _adaptive(10, FontWeight.w400);

  // 10 px
  static TextStyle get s10bold => _adaptive(9, FontWeight.bold);
  static TextStyle get s10semibold => _adaptive(9, FontWeight.w600);
  static TextStyle get s10medium => _adaptive(9, FontWeight.w500);
  static TextStyle get s10regular => _adaptive(9, FontWeight.w400);

  // // 8 px
  // static TextStyle get s8bold => _adaptive(
  //   8.0,
  //   FontWeight.bold,
  // );
  // static TextStyle get s8semibold => _adaptive(
  //   8.0,
  //   FontWeight.w600,
  // );
  // static TextStyle get s8medium => _adaptive(
  //   8.0,
  //   FontWeight.w500,
  // );
  // static TextStyle get s8regular => _adaptive(
  //   8.0,
  //   FontWeight.w400,
  // );
}
