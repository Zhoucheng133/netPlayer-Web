import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:netplayer_web/operations/account.dart';
import 'package:netplayer_web/operations/operations.dart';
import 'package:netplayer_web/operations/play_check.dart';
import 'package:netplayer_web/pages/components/progress_dialog.dart';
import 'package:netplayer_web/pages/components/title_area.dart';
import 'package:netplayer_web/variables/dialog_var.dart';
import 'package:netplayer_web/variables/player_var.dart';
import 'package:netplayer_web/variables/settings_var.dart';
import 'package:netplayer_web/variables/user_var.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final Operations operations=Operations();
  late SharedPreferences prefs;

  SettingsVar s=Get.find();
  int cacheSize=0;
  bool loading=false;
  UserVar u = Get.find();
  PlayerVar p=Get.find();
  DialogVar d=Get.find();
  Account account=Account();

  Future<void> init() async {
    prefs=await SharedPreferences.getInstance();
  }

  @override
  void initState(){
    super.initState();
    init();
  }

  String sizeConvert(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1048576) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else if (bytes < 1073741824) {
      return '${(bytes / 1048576).toStringAsFixed(2)} MB';
    } else {
      return '${(bytes / 1073741824).toStringAsFixed(2)} GB';
    }
  }

  Future<int> getDirectorySize(Directory path) async {
    int size = 0;
    for (var entity in path.listSync(recursive: true)) {
      if (entity is File) {
        size += entity.lengthSync();
      }
    }
    return size;
  }

  String progresStyle(){
    if(s.progressStyle.value==ProgressStyle.off){
      return 'close'.tr;
    }else if(s.progressStyle.value==ProgressStyle.ring){
      return 'ring'.tr;
    }
    return 'background'.tr;
  }

  void showPaddingBottomDialog(BuildContext context){
    int tmpPadding=s.paddingBottom.value;

    d.showOkCancelDialogRaw(
      context: context, 
      title: "paddingBottom".tr, 
      okText: 'ok'.tr,
      child: Obx(()=>
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              s.paddingBottom.value==0 ? "none".tr : s.paddingBottom.value.toString(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Material(
              color: Theme.of(context).brightness==Brightness.light ? Colors.white : Colors.black,
              child: Slider(
                value: s.paddingBottom.value.toDouble(),
                min: 0,
                max: 50,
                divisions: 50,
                onChanged: (val) {
                  s.paddingBottom.value = val.toInt();
                },
              ),
            ),
          ],
        ),
      ), 
      okHandler: () async {
        prefs.setInt("paddingBottom", s.paddingBottom.value);
      },
      cancelHandler: () async {
        s.paddingBottom.value=tmpPadding;
      }
    );
  }

  Future<void> showDarkModeDialog(BuildContext context) async {

    bool tmpDarkMode=s.darkMode.value;
    bool tmpAutoDark=s.autoDark.value;

    await d.showOkCancelDialogRaw(
      context: context, 
      title: 'darkMode'.tr, 
      child: Obx(()=>
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  'followSystem'.tr,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Expanded(child: Container()),
                FSwitch(
                  value: s.autoDark.value, 
                  onChange: (val){
                    s.autoDark.value=val;
                    final Brightness brightness = MediaQuery.of(context).platformBrightness;
                    s.autoDarkMode(brightness==Brightness.dark);
                  }
                )
              ],
            ),
            const SizedBox(height: 5,),
            Row(
              children: [
                Text(
                  'darkMode'.tr,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Expanded(child: Container()),
                FSwitch(
                  value: s.darkMode.value, 
                  onChange: s.autoDark.value ? null : (val){
                    s.darkMode.value=val;
                  }
                )
              ],
            )
          ],
        )
      ), 
      okHandler: () async {
        prefs.setBool('autoDark', s.autoDark.value);
        prefs.setBool('darkMode', s.darkMode.value);
      },
      cancelHandler: (){
        s.darkMode.value=tmpDarkMode;
        s.autoDark.value=tmpAutoDark;
      },
      okText: 'ok'.tr,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Obx(()=>
      Scaffold(
        backgroundColor: s.darkMode.value ? s.bgColor2 : Colors.white,
        appBar: AppBar(
          backgroundColor: s.darkMode.value ? s.bgColor1 : Colors.grey[100],
          scrolledUnderElevation:0.0,
          toolbarHeight: 70,
        ),
        body: Column(
          children: [
            TitleArea(title: 'settings'.tr, subtitle: ' '),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FTileGroup(
                          label: Text('appSettings'.tr),
                          children: [
                            FTile(
                              title: Text(
                                'autoLogin'.tr, 
                              ),
                              details: Obx(()=>
                                FSwitch(
                                  value: s.autoLogin.value,
                                  onChange: (val) async {
                                    s.autoLogin.value=val;
                                    prefs.setBool('autoLogin', val);
                                  }
                                ),
                              ),
                            ),
                            FTile(
                              title: Text(
                                'savePlay'.tr, 
                              ),
                              details: Obx(()=>
                                FSwitch(
                                  value: s.savePlay.value, 
                                  onChange: (val) async {
                                    s.savePlay.value=val;
                                    prefs.setBool('savePlay', val);
                                  }
                                )
                              ),
                            ),
                            FTile(
                              title: Text(
                                'enableNavidromeAPI'.tr, 
                                style: TextStyle(
                                )
                              ),
                              details: Obx(()=>
                                FSwitch(
                                  value: p.useNavidrome.value, 
                                  onChange: (val) async {
                                    if(val){
                                      final ok=await d.showOkCancelDialog(
                                        context: context, 
                                        title: "enableNavidromeAPI".tr, 
                                        content: "useNavidromeApiFirst".tr,
                                        okText: u.password.value.isEmpty ? "enableAndRestart".tr : "continue".tr,
                                        cancelText: "cancel".tr
                                      );
                                      if(ok && u.password.value.isEmpty){
                                        account.logout();
                                        if(context.mounted) Navigator.pop(context);
                                      }else if(!ok){
                                        return;
                                      }
                                    }
                                    p.useNavidrome.value=val;
                                    prefs.setBool("useNavidrome", val);
                                  }
                                )
                              ),
                              subtitle: Text('showAllSongsAndAlbums'.tr, style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                              )),
                            ),
                            FTile(
                              title: Text('ignoreMissing'.tr),
                              details: Obx(()=>
                                FSwitch(
                                  value: p.removeMissing.value, 
                                  onChange: p.useNavidrome.value ? (val) async {
                                    p.removeMissing.value=val;
                                    prefs.setBool("removeMissing", val);
                                    if(p.nowPlay['playFrom']=="all" && context.mounted){
                                      PlayCheck().check(context);
                                    }
                                  } : null,
                                )
                              ),
                              subtitle: Text('avaliableForNavidromeApi'.tr, style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[400],
                              )),
                            ),
                            FTile( 
                              title: Text('showPlaylistCover'.tr),
                              subtitle: Text(
                                "showPlaylistCoverContent".tr, 
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                              details: Obx(()=>
                                FSwitch(
                                  value: s.showPlaylistCover.value, 
                                  onChange: (val) async {
                                    s.showPlaylistCover.value=val;
                                    prefs.setBool("showPlaylistCover", val);
                                  }
                                )
                              ),
                            ),
                            FTile(
                              title: Text("resizeCoverImg".tr),
                              subtitle: Text(
                                "resizeCoverImgContent".tr, 
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                              details: Obx(()=>
                                FSwitch(
                                  value: s.resizeCoverImg.value, 
                                  onChange: (val) async {
                                    s.resizeCoverImg.value=val;
                                    prefs.setBool("resizeCoverImg", val);
                                  }
                                )
                              ),
                            ),
                            FTile(
                              title: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('language'.tr),
                                  const SizedBox(width: 5,),
                                  const FaIcon(
                                    FontAwesomeIcons.globe,
                                    size: 14,
                                  )
                                ],
                              ),
                              subtitle: Text(
                                s.lang.value.name, 
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400],
                                ),
                              ),
                              onPress: () => s.showLanguageDialog(context),
                            ),
                          ]
                        ),
                        FTileGroup(
                          label: Text('apperanceSettings'.tr),
                          children: [
                            FTile(
                              onPress: ()=>showPaddingBottomDialog(context),
                              title: Text('paddingBottom'.tr),
                              subtitle: Obx(()=>
                                Text(
                                  s.paddingBottom.value==0 ? "none".tr : s.paddingBottom.value.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[400]
                                  ),
                                )
                              ),
                            ),
                            FTile(
                              onPress: ()=>showDarkModeDialog(context),
                              title: Text('darkMode'.tr),
                              subtitle: Obx(()=>
                                Text(
                                  s.autoDark.value ? 'auto'.tr : s.darkMode.value ? 'enable'.tr : 'disable'.tr,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[400]
                                  ),
                                )
                              ),
                            ),
                            FTile(
                              onPress: ()=>showProgressDialog(context),
                              title: Text(
                                'progressbarStyle'.tr,
                              ),
                              subtitle: Obx(()=>
                                Text(
                                  progresStyle(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[400]
                                  ),
                                ),
                              ),
                            ),
                          ]
                        ),
                        FTileGroup(
                          label: Text('others'.tr),
                          children: [

                            FTile(
                              onPress: () async {
                                setState(() {
                                  loading=true;
                                });
                                await Operations().refreshLibrary(context);
                                setState(() {
                                  loading=false;
                                });
                              },
                              title: Text('rescanLibrary'.tr),
                              subtitle: Text(
                                "rescanLibraryContent".tr, 
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[400]
                                ),
                              ),
                              details: loading ? Transform.scale(
                                scale: 0.6,
                                child: const CircularProgressIndicator()
                              ) : null,
                            ),
                          ]
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: s.paddingBottom.value.toDouble(),
            )
          ],
        ),
      ),
    );
  }
}