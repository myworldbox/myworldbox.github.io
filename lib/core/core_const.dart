import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_template/core/core_enum.dart';
import 'package:flutter_template/core/core_record.dart';
import 'package:flutter_template/core/core_var.dart';
import 'package:flutter_template/page/auth/brs_auth_login.dart';
import 'package:flutter_template/page/auth/mwb_auth_login.dart';
import 'package:flutter_template/page/auth/fos_auth_login.dart';
import 'package:flutter_template/page/test/brs_test_param.dart';
import 'package:flutter_template/page/test/fos_test.dart';
import 'package:flutter_template/page/test/fos_test_param.dart';
import 'package:flutter_template/page/user/brs_user_setting.dart';
import 'package:flutter_template/page/user/mwb_user_update_auth.dart';
import 'package:flutter_library/@core/core_enum.dart';

import '../page/ai/brs_ai_book.dart';
import '../page/brs_root.dart';
import '../page/menu/fos_menu_order.dart';
import '../page/suggestion/brs_suggestion_book.dart';
import '../page/transition/brs_transition_scan.dart';
import '../page/user/mwb_user_update_user.dart';
import '../page/auth/mwb_auth_register.dart';
import '../page/menu/fos_menu_food.dart';
import '../page/menu/fos_menu_login.dart';
import '../page/menu/fos_menu_order.dart';
import '../page/mwb_root.dart';
import '../page/order/fos_order_rule.dart';
import '../page/fos_root.dart';
import '../page/auth/mwb_auth_forget_password.dart';
import '../page/auth/fos_auth_logout.dart';
import '../page/auth/mwb_auth_reset_password.dart';
import '../page/payment/fos_payment_cash.dart';
import '../page/screen/screen_load.dart';
import '../page/screen/screen_onboard.dart';
import '../page/screen/screen_splash.dart';
import '../page/table/fos_table_order.dart';
import '../page/user/mwb_user_setting.dart';
import '../../utility/utility_generate.dart';
import 'package:flutter_library/@core/core_enum.dart';
import 'core_generic.dart';
import 'core_static.dart';

class CoreConst {
  Credential get credential => Credential();
  Host get host => Host();
  Header get header => Header();
  Url get url => Url();
  Path get path => Path();
  Asset get asset => Asset();

  Map<CoreEnumRoute, List<CoreEnumInput>> get field =>
      switch (CoreStatic.coreVar.project) {
        CoreEnumProject.brs => {
          CoreEnumRoute.authLogin: [
            CoreEnumInput.nameUser,
            CoreEnumInput.password,
          ],
          CoreEnumRoute.userSetting: [CoreEnumInput.centerCode],
        },
        CoreEnumProject.fos => {},
        CoreEnumProject.mwb => {
          CoreEnumRoute.authRegister: [
            CoreEnumInput.mailSchool,
            CoreEnumInput.password,
          ],
          CoreEnumRoute.authLogin: [
            CoreEnumInput.mailSchool,
            CoreEnumInput.password,
          ],
          CoreEnumRoute.userUpdateAuth: [
            CoreEnumInput.mailSchool,
            CoreEnumInput.password,
          ],
          CoreEnumRoute.userUpdateUser: [
            CoreEnumInput.nameFirst,
            CoreEnumInput.nameLast,
            CoreEnumInput.dateOfBirth,
            CoreEnumInput.countryCode,
            CoreEnumInput.phoneNumberPrimary,
            CoreEnumInput.mailPersonal,
            CoreEnumInput.idTelegram,
            CoreEnumInput.idInstagram,
            CoreEnumInput.membership,
            // CoreEnumInput.emailSubscription,
          ],
        },
      };

  List<CoreEnumInput> fieldAutoAppend = [
    CoreEnumInput.id,
    CoreEnumInput.datetime,
  ];

  Map<CoreEnumRoute, CoreRecordRoute> get allRoute =>
      switch (CoreStatic.coreVar.project) {
        CoreEnumProject.brs => {
          CoreEnumRoute.root: (
            icon: Icons.home,
            builder: (context) => const Pager(state: BrsRoot.new),
            enable: true,
          ),
          CoreEnumRoute.authLogin: (
            icon: Icons.supervised_user_circle,
            builder: (context) => const Pager(state: BrsAuthLogin.new),
            enable: true,
          ),
          CoreEnumRoute.aiBook: (
            icon: Icons.agriculture_sharp,
            builder: (context) => const Pager(state: BrsAiBook.new),
            enable: false,
          ),
          CoreEnumRoute.suggestionBook: (
            icon: Icons.info,
            builder: (context) => const Pager(state: BrsSuggestionBook.new),
            enable: false,
          ),
          CoreEnumRoute.userSetting: (
            icon: Icons.settings,
            builder: (context) => const Pager(state: BrsUserSetting.new),
            enable: false,
          ),
          CoreEnumRoute.screenSplash: (
            icon: Icons.schedule_rounded,
            builder: (context) => const Pager(state: ScreenSplash.new),
            enable: false,
          ),
          CoreEnumRoute.testParam: (
            icon: Icons.abc,
            builder: (context) => const Pager(state: BrsTestParam.new),
            enable: true,
          ),
          CoreEnumRoute.transitionScan: (
            icon: Icons.scanner,
            builder: (context) => const Pager(state: BrsTransitionScan.new),
            enable: false,
          ),
        },
        CoreEnumProject.fos => {
          CoreEnumRoute.root: (
            icon: Icons.home,
            builder: (context) => const Pager(state: FosRoot.new),
            enable: true,
          ),
          CoreEnumRoute.test: (
            icon: Icons.abc,
            builder: (context) => const Pager(state: FosTest.new),
            enable: false,
          ),
          CoreEnumRoute.authLogin: (
            icon: Icons.login,
            builder: (context) => const Pager(state: FosAuthLogin.new),
            enable: true,
          ),
          CoreEnumRoute.authLogout: (
            icon: Icons.logout,
            builder: (context) => const Pager(state: FosAuthLogout.new),
            enable: false,
          ),
          CoreEnumRoute.menuLogin: (
            icon: Icons.menu,
            builder: (context) => const Pager(state: FosMenuLogin.new),
            enable: true,
          ),
          CoreEnumRoute.menuOrder: (
            icon: Icons.shopping_cart,
            builder: (context) => const Pager(state: FosMenuOrder.new),
            enable: true,
          ),
          CoreEnumRoute.menuFood: (
            icon: Icons.fastfood,
            builder: (context) => const Pager(state: FosMenuFood.new),
            enable: true,
          ),
          CoreEnumRoute.paymentCash: (
            icon: Icons.money,
            builder: (context) => const Pager(state: FosPaymentCash.new),
            enable: true,
          ),
          CoreEnumRoute.orderRule: (
            icon: Icons.rule,
            builder: (context) => const Pager(state: FosOrderRule.new),
            enable: true,
          ),
          CoreEnumRoute.tableOrder: (
            icon: Icons.table_chart,
            builder: (context) => const Pager(state: FosTableOrder.new),
            enable: true,
          ),
          CoreEnumRoute.testParam: (
            icon: Icons.abc,
            builder: (context) => const Pager(state: FosTestParam.new),
            enable: true,
          ),
        },
        CoreEnumProject.mwb => {
          CoreEnumRoute.root: (
            icon: Icons.home,
            builder: (context) => const Pager(state: MwbRoot.new),
            enable: true,
          ),
          CoreEnumRoute.authLogin: (
            icon: Icons.login,
            builder: (context) => const Pager(state: MwbAuthLogin.new),
            enable: true,
          ),
          CoreEnumRoute.authRegister: (
            icon: Icons.app_registration,
            builder: (context) => const Pager(state: MwbAuthRegister.new),
            enable: true,
          ),
          CoreEnumRoute.authResetPassword: (
            icon: Icons.lock_reset,
            builder: (context) => const Pager(state: MwbAuthResetPassword.new),
            enable: false,
          ),
          CoreEnumRoute.authForgetPassword: (
            icon: Icons.lock_open,
            builder: (context) => const Pager(state: MwbAuthForgetPassword.new),
            enable: false,
          ),
          CoreEnumRoute.userUpdateAuth: (
            icon: Icons.info,
            builder: (context) => const Pager(state: MwbUserUpdateAuth.new),
            enable: true,
          ),
          CoreEnumRoute.userUpdateUser: (
            icon: Icons.info,
            builder: (context) => const Pager(state: MwbUserUpdateUser.new),
            enable: true,
          ),
          CoreEnumRoute.userSetting: (
            icon: Icons.settings,
            builder: (context) => const Pager(state: MwbUserSetting.new),
            enable: true,
          ),
          CoreEnumRoute.testParam: (
            icon: Icons.abc,
            builder: (context) => const Pager(state: FosTestParam.new),
            enable: true,
          ),
        },
      };

  Map<CoreEnumInput, CoreRecordInput> get inputAll => {
    CoreEnumInput.address: (
      iconData: Icons.location_on,
      pattern: r'^[a-zA-Z0-9\s,.-]+$',
      name: 'Address',
      hint: 'e.g. 123 Main St, Springfield',
      enable: true,
      readOnly: false,
      select: null,
      defaultValue: null,
    ),
    CoreEnumInput.city: (
      iconData: Icons.location_city,
      pattern: r'^[a-zA-Z\s]+$',
      name: 'City',
      hint: 'e.g. New York',
      enable: true,
      readOnly: false,
      select: null,
      defaultValue: null,
    ),
    CoreEnumInput.dateOfBirth: (
      iconData: Icons.cake,
      pattern: r'^\d{4}-\d{2}-\d{2}$',
      name: 'Date of Birth',
      hint: 'e.g. 1990-01-01',
      enable: true,
      readOnly: false,
      select: null,
      defaultValue: null,
    ),
    CoreEnumInput.nameFirst: (
      iconData: Icons.person,
      pattern: r'^[a-zA-Z]+$',
      name: 'First Name',
      hint: 'e.g. John',
      enable: true,
      readOnly: false,
      select: null,
      defaultValue: null,
    ),
    CoreEnumInput.gender: (
      iconData: Icons.wc,
      pattern: r'^(male|female|other)$',
      name: 'Gender',
      hint: 'e.g. male',
      enable: true,
      readOnly: false,
      select: null,
      defaultValue: null,
    ),
    CoreEnumInput.numberIdCard: (
      iconData: Icons.credit_card,
      pattern: r'^[a-zA-Z0-9]+$',
      name: 'ID Card Number',
      hint: 'e.g. A1234567',
      enable: true,
      readOnly: false,
      select: null,
      defaultValue: null,
    ),
    CoreEnumInput.nameLast: (
      iconData: Icons.person_outline,
      pattern: r'^[a-zA-Z]+$',
      name: 'Last Name',
      hint: 'e.g. Doe',
      enable: true,
      readOnly: false,
      select: null,
      defaultValue: null,
    ),
    CoreEnumInput.nationality: (
      iconData: Icons.flag,
      pattern: r'^[a-zA-Z\s]+$',
      name: 'Nationality',
      hint: 'e.g. American',
      enable: true,
      readOnly: false,
      select: null,
      defaultValue: null,
    ),
    CoreEnumInput.password: (
      iconData: Icons.lock,
      pattern: r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$',
      name: 'Password',
      hint: 'At least 8 characters, letters, numbers, and optional symbols',
      enable: true,
      readOnly: false,
      select: null,
      defaultValue: null,
    ),
    CoreEnumInput.mailPersonal: (
      iconData: Icons.email,
      pattern: r'^[a-zA-Z0-9.%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      name: 'Personal Email',
      hint: 'e.g. john.doe@example.com',
      enable: true,
      readOnly: false,
      select: null,
      defaultValue: null,
    ),
    CoreEnumInput.phoneNumberPrimary: (
      iconData: Icons.phone_android,
      pattern: r'^\d{10,15}$',
      name: 'Phone Number',
      hint: 'e.g. 1234567890',
      enable: true,
      readOnly: false,
      select: null,
      defaultValue: null,
    ),
    CoreEnumInput.postalCode: (
      iconData: Icons.local_post_office,
      pattern: r'^\d{5,6}$',
      name: 'Postal Code',
      hint: 'e.g. 10001',
      enable: true,
      readOnly: false,
      select: null,
      defaultValue: null,
    ),
    CoreEnumInput.profilePicture: (
      iconData: Icons.image,
      pattern: r'^(http|https)://[^\s]+$',
      name: 'Profile Picture',
      hint: 'e.g. https://example.com/image.jpg',
      enable: true,
      readOnly: false,
      select: null,
      defaultValue: null,
    ),
    CoreEnumInput.state: (
      iconData: Icons.map,
      pattern: r'^[a-zA-Z\s]+$',
      name: 'State',
      hint: 'e.g. California',
      enable: true,
      readOnly: false,
      select: null,
      defaultValue: null,
    ),
    CoreEnumInput.nameUser: (
      iconData: Icons.account_circle,
      pattern: r'^[a-zA-Z0-9._-]{3,}$',
      name: 'Username',
      hint: 'e.g. john_doe123',
      enable: true,
      readOnly: false,
      select: null,
      defaultValue: null,
    ),
    CoreEnumInput.idTelegram: (
      name: 'Telegram ID',
      hint: 'e.g. @YourTelegramHandle',
      pattern: r'^@[\w]{5,32}$',
      iconData: Icons.send,
      enable: true,
      readOnly: false,
      select: null,
      defaultValue: null,
    ),
    CoreEnumInput.idInstagram: (
      name: 'Instagram ID',
      hint: 'e.g. @your.instagram.handle',
      pattern: r'^@[\w.]{1,30}$',
      iconData: Icons.camera_alt,
      enable: true,
      readOnly: false,
      select: null,
      defaultValue: null,
    ),
    CoreEnumInput.membership: (
      name: 'Membership',
      hint: 'e.g. ${CoreEnumMembership.values.map((x) => x.name).join(", ")}',
      pattern:
          '(${CoreEnumMembership.values.map((x) => x.name).toList().map(RegExp.escape).join('|')})\$',
      iconData: Icons.camera_alt,
      enable: true,
      readOnly: true,
      select: CoreEnumMembership.values
          .map((x) => (displayText: x.name, value: x.name))
          .toList(),
      defaultValue: CoreEnumMembership.bronze.name,
    ),
  };

  Map<CoreEnumSize, double> size = Map.fromEntries(
    CoreEnumSize.values.asMap().entries.map((e) {
      double baseSize = 5;
      double offset = 10.0;
      return MapEntry(e.value, baseSize + offset * e.key);
    }),
  );

  Map<(CoreEnumTheme, CoreEnumColorRole), Color> color = {
    // Light theme colors
    (CoreEnumTheme.light, CoreEnumColorRole.primary): Colors.blue,
    (CoreEnumTheme.light, CoreEnumColorRole.onPrimary): Colors.white,
    (CoreEnumTheme.light, CoreEnumColorRole.primaryContainer): Color(
      0xFFBBDEFB,
    ), // Blue 100
    (CoreEnumTheme.light, CoreEnumColorRole.onPrimaryContainer): Colors.black,
    (CoreEnumTheme.light, CoreEnumColorRole.secondary): Colors.blueAccent,
    (CoreEnumTheme.light, CoreEnumColorRole.onSecondary): Colors.white,
    (CoreEnumTheme.light, CoreEnumColorRole.secondaryContainer): Color(
      0xFF82B1FF,
    ), // BlueAccent 100
    (CoreEnumTheme.light, CoreEnumColorRole.onSecondaryContainer): Colors.black,
    (CoreEnumTheme.light, CoreEnumColorRole.tertiary): Colors.teal,
    (CoreEnumTheme.light, CoreEnumColorRole.onTertiary): Colors.white,
    (CoreEnumTheme.light, CoreEnumColorRole.tertiaryContainer): Color(
      0xFFB2DFDB,
    ), // Teal 100
    (CoreEnumTheme.light, CoreEnumColorRole.onTertiaryContainer): Colors.black,
    (CoreEnumTheme.light, CoreEnumColorRole.error): Colors.red,
    (CoreEnumTheme.light, CoreEnumColorRole.onError): Colors.white,
    (CoreEnumTheme.light, CoreEnumColorRole.errorContainer): Color(
      0xFFFDEDED,
    ), // Red 50
    (CoreEnumTheme.light, CoreEnumColorRole.onErrorContainer): Colors.red,
    (CoreEnumTheme.light, CoreEnumColorRole.background): Colors.white,
    (CoreEnumTheme.light, CoreEnumColorRole.onBackground): Colors.black,
    (CoreEnumTheme.light, CoreEnumColorRole.surface): Color(
      0xFFF5F5F5,
    ), // Grey 100
    (CoreEnumTheme.light, CoreEnumColorRole.onSurface): Colors.black,
    (CoreEnumTheme.light, CoreEnumColorRole.surfaceContainerLowest):
        Colors.white,
    (CoreEnumTheme.light, CoreEnumColorRole.surfaceContainerLow): Color(
      0xFFEEEEEE,
    ), // Grey 200
    (CoreEnumTheme.light, CoreEnumColorRole.surfaceContainer): Color(
      0xFFE0E0E0,
    ), // Grey 300
    (CoreEnumTheme.light, CoreEnumColorRole.surfaceContainerHigh): Color(
      0xFFD6D6D6,
    ), // Grey 400
    (CoreEnumTheme.light, CoreEnumColorRole.surfaceContainerHighest): Color(
      0xFFCCCCCC,
    ), // Grey 500
    (CoreEnumTheme.light, CoreEnumColorRole.onSurfaceVariant): Colors.black54,
    (CoreEnumTheme.light, CoreEnumColorRole.outline): Color(
      0xFFB0BEC5,
    ), // Grey 400
    (CoreEnumTheme.light, CoreEnumColorRole.outlineVariant): Color(
      0xFFCFD8DC,
    ), // Grey 300
    (CoreEnumTheme.light, CoreEnumColorRole.inverseSurface): Color(
      0xFF424242,
    ), // Grey 800
    (CoreEnumTheme.light, CoreEnumColorRole.onInverseSurface): Colors.white,
    (CoreEnumTheme.light, CoreEnumColorRole.inversePrimary): Colors.blue,
    (CoreEnumTheme.light, CoreEnumColorRole.surfaceTint): Colors.blue,
    (CoreEnumTheme.light, CoreEnumColorRole.scrim): Color(
      0x99000000,
    ), // Black with 60% opacity
    // Dark theme colors
    (CoreEnumTheme.dark, CoreEnumColorRole.primary): Colors.blue,
    (CoreEnumTheme.dark, CoreEnumColorRole.onPrimary): Colors.white,
    (CoreEnumTheme.dark, CoreEnumColorRole.primaryContainer): Color(
      0xFF1976D2,
    ), // Blue 700
    (CoreEnumTheme.dark, CoreEnumColorRole.onPrimaryContainer): Colors.white,
    (CoreEnumTheme.dark, CoreEnumColorRole.secondary): Colors.blueAccent,
    (CoreEnumTheme.dark, CoreEnumColorRole.onSecondary): Colors.white,
    (CoreEnumTheme.dark, CoreEnumColorRole.secondaryContainer): Color(
      0xFF448AFF,
    ), // BlueAccent 400
    (CoreEnumTheme.dark, CoreEnumColorRole.onSecondaryContainer): Colors.white,
    (CoreEnumTheme.dark, CoreEnumColorRole.tertiary): Colors.teal,
    (CoreEnumTheme.dark, CoreEnumColorRole.onTertiary): Colors.white,
    (CoreEnumTheme.dark, CoreEnumColorRole.tertiaryContainer): Color(
      0xFF00695C,
    ), // Teal 800
    (CoreEnumTheme.dark, CoreEnumColorRole.onTertiaryContainer): Colors.white,
    (CoreEnumTheme.dark, CoreEnumColorRole.error): Colors.redAccent,
    (CoreEnumTheme.dark, CoreEnumColorRole.onError): Colors.white,
    (CoreEnumTheme.dark, CoreEnumColorRole.errorContainer): Color(
      0xFFB71C1C,
    ), // Red 900
    (CoreEnumTheme.dark, CoreEnumColorRole.onErrorContainer): Colors.white,
    (CoreEnumTheme.dark, CoreEnumColorRole.background): Color(
      0xFF212121,
    ), // Grey 900
    (CoreEnumTheme.dark, CoreEnumColorRole.onBackground): Colors.white,
    (CoreEnumTheme.dark, CoreEnumColorRole.surface): Color(
      0xFF424242,
    ), // Grey 800
    (CoreEnumTheme.dark, CoreEnumColorRole.onSurface): Colors.white,
    (CoreEnumTheme.dark, CoreEnumColorRole.surfaceContainerLowest): Color(
      0xFF1A1A1A,
    ), // Grey 950
    (CoreEnumTheme.dark, CoreEnumColorRole.surfaceContainerLow): Color(
      0xFF303030,
    ), // Grey 850
    (CoreEnumTheme.dark, CoreEnumColorRole.surfaceContainer): Color(
      0xFF424242,
    ), // Grey 800
    (CoreEnumTheme.dark, CoreEnumColorRole.surfaceContainerHigh): Color(
      0xFF555555,
    ), // Grey 700
    (CoreEnumTheme.dark, CoreEnumColorRole.surfaceContainerHighest): Color(
      0xFF616161,
    ), // Grey 600
    (CoreEnumTheme.dark, CoreEnumColorRole.onSurfaceVariant): Colors.white70,
    (CoreEnumTheme.dark, CoreEnumColorRole.outline): Color(
      0xFF78909C,
    ), // Grey 600
    (CoreEnumTheme.dark, CoreEnumColorRole.outlineVariant): Color(
      0xFF546E7A,
    ), // Grey 700
    (CoreEnumTheme.dark, CoreEnumColorRole.inverseSurface): Color(
      0xFFE0E0E0,
    ), // Grey 300
    (CoreEnumTheme.dark, CoreEnumColorRole.onInverseSurface): Colors.black,
    (CoreEnumTheme.dark, CoreEnumColorRole.inversePrimary): Colors.blue,
    (CoreEnumTheme.dark, CoreEnumColorRole.surfaceTint): Colors.blue,
    (CoreEnumTheme.dark, CoreEnumColorRole.scrim): Color(
      0x99000000,
    ), // Black with 60% opacity
    // High contrast theme colors
    (CoreEnumTheme.highContrast, CoreEnumColorRole.primary): Colors.black,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.onPrimary): Colors.yellow,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.primaryContainer):
        Colors.black,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.onPrimaryContainer):
        Colors.yellow,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.secondary): Colors.yellow,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.onSecondary): Colors.black,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.secondaryContainer):
        Colors.yellow,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.onSecondaryContainer):
        Colors.black,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.tertiary): Colors.cyan,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.onTertiary): Colors.black,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.tertiaryContainer):
        Colors.cyan,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.onTertiaryContainer):
        Colors.black,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.error): Colors.red,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.onError): Colors.white,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.errorContainer): Colors.red,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.onErrorContainer):
        Colors.white,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.background): Colors.white,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.onBackground): Colors.black,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.surface): Colors.white,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.onSurface): Colors.black,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.surfaceContainerLowest):
        Colors.white,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.surfaceContainerLow):
        Colors.white,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.surfaceContainer):
        Colors.white,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.surfaceContainerHigh):
        Colors.white,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.surfaceContainerHighest):
        Colors.white,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.onSurfaceVariant):
        Colors.black,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.outline): Colors.yellow,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.outlineVariant):
        Colors.yellow,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.inverseSurface):
        Colors.black,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.onInverseSurface):
        Colors.yellow,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.inversePrimary):
        Colors.black,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.surfaceTint): Colors.black,
    (CoreEnumTheme.highContrast, CoreEnumColorRole.scrim): Color(
      0xFF000000,
    ), // Black for high contrast
  };
}

class Asset {
  late final String background = switch (CoreStatic.coreVar.project) {
    CoreEnumProject.brs => 'assets/jpg/kindergarten.jpg',
    _ => 'assets/jpeg/background_${8}.jpeg',
  };
  late final String ghostRunGif = 'assets/gif/ghost_run.gif';
  late final String faceScanGif = 'assets/gif/face_scan_${0}.gif';
  late final String bookFoldGif = 'assets/gif/book_fold_${2}.gif';
}

class Header {
  Map<String, String> json = {'Content-Type': 'application/json'};
}

class Host {
  String https = CoreEnumScheme.https.name;
  String http = CoreEnumScheme.http.name;

  get mail => "mailto";
  get github => "github.com";
  get facebook => "facebook.com";
  get linkedin => "linkedin.com";
  get myworldbox => "myworldbox.github.io";
  get myapibox => "myapibox.vercel.app";
  get backend => switch (CoreStatic.coreVar.env) {
    CoreEnumEnv.uat => "devapppub2.skhwc.org.hk",
    CoreEnumEnv.sit => null,
    CoreEnumEnv.prod => "hecan.msg-box.com",
    CoreEnumEnv.staging => null,
    CoreEnumEnv.dev => "localhost:7069",
  };
}

class Url {
  Host host = Host();

  get background => '${host.myworldbox}/resource/image/background/hill.jpeg';
  get image => '${host.myworldbox}/resource/image/background/dark_forest.png';
}

class Path {
  get addition => CoreStatic.coreVar.env == CoreEnumEnv.uat ? 'BRSAPI/' : '';

  get login => '${addition}api/Book/Login';
  get bookList => '${addition}api/Book/DownloadBooks';
  get bookPreference => '${addition}api/Book/UploadBookPreferences';
  get heCanForgetPassword => 'SecurityServiceWeb/Account/RequestResetPwd';
}

class Credential {
  Google get google => Google();
  Aws get aws => Aws();
}

class Google {}

class Aws {}
