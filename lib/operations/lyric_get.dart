import 'dart:convert';

import 'package:get/get.dart';
import 'package:netplayer_web/variables/player_var.dart';
import 'package:http/http.dart' as http;

class LyricGet{

  final PlayerVar p=Get.find();


  // 时间戳转换成毫秒
  int timeToMilliseconds(String timeString) {
    List<String> parts = timeString.split(':');
    int minutes = int.parse(parts[0]);
    List<String> secondsParts = parts[1].split('.');
    int seconds = int.parse(secondsParts[0]);
    int milliseconds = int.parse(secondsParts.length>1 ? secondsParts[1] : "0");

    // 将分钟、秒和毫秒转换为总毫秒数
    return (minutes * 60 * 1000) + (seconds * 1000) + milliseconds;
  }

  Future<void> getLyric() async {
    if(!(await lrclib())){
      p.lyricSource.value=null;
      p.lyric.value=[
        LyricItem('noLyric'.tr, "", 0)
      ];
    }
  }

  Future<bool> lrclib() async {
    final title=p.nowPlay['title'];
    final album=p.nowPlay['album'];
    final artist=p.nowPlay['artist'];
    final duration=p.nowPlay['duration'];

    final uri = Uri.parse('https://lrclib.net/api/get').replace(queryParameters: {
      'artist_name': artist,
      'track_name': title,
      'album_name': album,
      'duration': duration.toString(),
    });

    final res = await http.get(
      uri,
      headers: {
        'User-Agent': 'netPlayer / (https://github.com/Zhoucheng133/netPlayer-Mobile)',
        'X-Lrclib-Client': 'netPlayer',
      },
    );

    if (res.statusCode != 200) {
      return false;
    }

    String responseBody = utf8.decode(res.bodyBytes);
    final rlt = jsonDecode(responseBody);
    var response=rlt['syncedLyrics']??"";
    if(response==''){
      return false;
    }
    List<LyricItem> lyricCovert=[];
    List<String> lines = LineSplitter.split(response).toList();
    for(String line in lines){
      int pos1=line.indexOf("[");
      int pos2=line.indexOf("]");
      if(pos1==-1 || pos2==-1){
        return false;
      }
      lyricCovert.add(LyricItem(line.substring(pos2 + 1).trim(), "", timeToMilliseconds(line.substring(pos1+1, pos2))));
    }
    p.lyric.value=lyricCovert;
    p.lyricSource.value=LyricSource.lrclib;
    return true;
  }
}