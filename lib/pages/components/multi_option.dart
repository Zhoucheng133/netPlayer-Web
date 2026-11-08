import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:netplayer_web/operations/operations.dart';
import 'package:netplayer_web/variables/dialog_var.dart';
import 'package:netplayer_web/variables/ls_var.dart';
import 'package:netplayer_web/variables/settings_var.dart';

class MultiOption extends StatefulWidget {

  final bool fromPlaylist;
  final String listId;
  final List target;

  const MultiOption({super.key, required this.fromPlaylist, required this.listId, this.target=const []});

  @override
  State<MultiOption> createState() => _MultiOptionState();
}

class _MultiOptionState extends State<MultiOption> {

  DialogVar d=Get.find();
  LsVar l=Get.find();
  final SettingsVar s=Get.find();

  Future<void> showOption(BuildContext context) async {
    var req=await d.showActionSheet(
      context: context,
      list: [
        ActionItem(name: 'addToPlaylist'.tr, key: "add", icon: Icons.playlist_add_rounded),
      ]
    );

    if(req=="add"){ 
      if(l.playList.isEmpty && context.mounted){
        d.showOkDialog(context: context, title: "cantAddToPlaylist".tr, content: "noPlaylist".tr);
      }else if(s.selectList.isNotEmpty && context.mounted){
        String selectedId = l.playList[0]['id'];
        await d.showOkCancelDialogRaw(
          context: context,
          title: "addToPlaylist".tr,
          okText: "add".tr,
          child: StatefulBuilder(
            builder: (context, setState) {
              return FSelect<String>.rich(
                control: .managed(initial: selectedId, onChange: (val) {
                  if(val!=null){
                    setState(() {
                      selectedId = val;
                    });
                  }
                }), autoHide: true,
                format: (String id) {
                  final item = l.playList.firstWhere(
                    (e) => e['id'] == id,
                  );
                  return item['name'];
                },
                children: List.generate(l.playList.length, (index) {
                  return FSelectItem<String>(
                    title: Text(l.playList[index]['name']),
                    value: l.playList[index]['id'],
                  );
                }),
              );
            },
          ),
          okHandler: () async {
            await Operations().multiAddToList(s.selectList, selectedId, context);
          },
        );
      }
      s.selectMode.value = false;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: ()=>showOption(context), 
      icon: Icon(Icons.more_vert_rounded)
    );
  }
}
