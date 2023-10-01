import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<int> getFileSize(String filePath) async {
  File file = File(filePath);
  if (file.existsSync()) {
    int fileSize = await file.length();
    return fileSize;
  }
  return 0;
}

Future cacheInfo() async {
  Directory cacheDirectory = await getTemporaryDirectory();
  int filesCount = 0;
  int filesSize = 0;
  int imagesCount = 0;
  int imagesSize = 0;
  int musicCount = 0;
  int musicSize = 0;
  int otherCount = 0;
  int otherSize = 0;
  if (cacheDirectory.existsSync()) {
    List<FileSystemEntity> cacheFiles = cacheDirectory.listSync(recursive: true);
    for (FileSystemEntity file in cacheFiles) {
      await getFileSize(file.path).then((value){
        filesSize = filesSize + value;
      });
      filesCount++;
      if(file.path.endsWith('.jpg') || file.path.endsWith('.png') || file.path.endsWith('.webp')){
        await getFileSize(file.path).then((value){
          imagesSize = imagesSize + value;
        });
        imagesCount++;
      }else if(file.path.endsWith('.mp3') || file.path.endsWith('.flac') || file.path.endsWith('.wav')){
        await getFileSize(file.path).then((value){
          musicSize = musicSize + value;
        });
        musicCount++;
      }else{
        await getFileSize(file.path).then((value){
          musicSize = musicSize + value;
        });
        musicCount++;
      }
    }
  }
  return {
    "count": filesCount,
    "size": filesSize,
    "images": {
      "count": imagesCount,
      "size": imagesSize,
    },
    "other": {
      "count": otherCount,
      "size": otherSize,
    },
    "music": {
      "count": musicCount,
      "size": musicSize,
    }
  };
}


Future imageCacheInfo() async {
  Directory cacheDirectory = await getTemporaryDirectory();
  int imageCount = 0;
  int sumSize = 0;
  if (cacheDirectory.existsSync()) {
    List<FileSystemEntity> cacheFiles = cacheDirectory.listSync(recursive: true);
    for (FileSystemEntity file in cacheFiles) {
      await getFileSize(file.path).then((value){
        sumSize = sumSize + value;
      });
      imageCount++;
    }
  }
  return {
    "count": imageCount,
    "size": sumSize
  };
}


Future getString(name) async {
  final prefs = await SharedPreferences.getInstance();
  final response = await prefs.getString(name);
  return response;
}

Future getBool(name) async {
  final prefs = await SharedPreferences.getInstance();
  final response = await prefs.getBool(name);
  return response;
}

Future<bool> setString(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
  return true;
}

Future<bool> setBool(String key, bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
  return true;
}

Future<bool> checkKey(key) async {
  final prefs = await SharedPreferences.getInstance();
  final response = await prefs.containsKey(key);
  return response;
}

Future clearKey(key) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}

Future<bool> checkLogin() async {
  final prefs = await SharedPreferences.getInstance();
  final response = await prefs.containsKey('signed in');
  return response;
}