import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:netplayer_web/lang/en_us.dart';
import 'package:netplayer_web/lang/zh_cn.dart';
import 'package:netplayer_web/lang/zh_tw.dart';
import 'package:netplayer_web/lang/ja_jp.dart';
import 'package:netplayer_web/lang/ko_kr.dart';
import 'package:netplayer_web/lang/de_de.dart';
import 'package:netplayer_web/lang/ru_ru.dart';
import 'package:netplayer_web/lang/es_es.dart';
import 'package:netplayer_web/lang/pt_pt.dart';
import 'package:netplayer_web/lang/fr_fr.dart';
import 'package:netplayer_web/main_view.dart';
import 'package:netplayer_web/variables/dialog_var.dart';

import 'package:netplayer_web/variables/ls_var.dart';
import 'package:netplayer_web/variables/page_var.dart';
import 'package:netplayer_web/variables/player_var.dart';
import 'package:netplayer_web/variables/settings_var.dart';
import 'package:netplayer_web/variables/user_var.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final darkMode=prefs.getBool("darkMode");
  final autoDark=prefs.getBool("autoDark");
  final p=Get.put(PlayerVar());
  final SettingsVar s=Get.put(SettingsVar());
  Get.put(DialogVar());
  Get.put(LsVar());
  Get.put(PageVar());
  Get.put(UserVar());
  await p.initPlayer();
  s.initDark(autoDark, darkMode);
  await s.initLang();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class MainTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': enUS,
    'zh_CN': zhCN,
    'zh_TW': zhTW,
    'ja_JP': jaJP,
    'ko_KR': koKR,
    'de_DE': deDE,
    'ru_RU': ruRU,
    'es_ES': esES,
    'pt_PT': ptPT,
    'fr_FR': frFR,
  };
}

class _MainAppState extends State<MainApp> {

  final SettingsVar s=Get.find();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ));

    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    s.autoDarkMode(brightness == Brightness.dark);

    return Obx(()=>
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate
        ],
        translations: MainTranslations(),
        locale: s.lang.value.locale,
        supportedLocales: supportedLocales.map((item)=>item.locale).toList(),
        fallbackLocale: supportedLocales[0].locale,
        builder: (context, child)=>FTheme(
          data: FThemeData(
            colors: s.darkMode.value ? FThemes.zinc.dark.colors : FThemes.zinc.light.colors,
          ),
          child: DefaultTextHeightBehavior(
            textHeightBehavior: const TextHeightBehavior(
              applyHeightToFirstAscent: false,
              applyHeightToLastDescent: false,
            ),
            child: FToaster(child: child!)
          ),
        ),
        theme: ThemeData(
          brightness: s.darkMode.value ? Brightness.dark : Brightness.light,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: s.darkMode.value ? Brightness.dark : Brightness.light,
          ),
          textTheme: s.darkMode.value ? ThemeData.dark().textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ) : ThemeData.light().textTheme.apply(),
          dialogTheme: DialogThemeData(
            backgroundColor: s.darkMode.value ? null : Colors.grey[50],
          ),
          bottomSheetTheme: BottomSheetThemeData(
            backgroundColor: s.darkMode.value ? null : Colors.grey[50],
          ),
          highlightColor: s.darkMode.value ? null : Colors.transparent,
        ),
        home: const MainView()
      )
    );
  }
}