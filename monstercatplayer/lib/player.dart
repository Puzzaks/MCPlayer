import 'dart:async';

import 'package:just_audio/just_audio.dart';

import 'package:flutter/material.dart';

class musicPlayer with ChangeNotifier {
  bool isPlaying = false;
  bool isQueue = false;

  int position = 0;
  int buffered = 0;
  List queue = [];
  Map queueData = {};
  final player = AudioPlayer();
  Map nowPlaying = {};
  StreamSubscription<Duration?>? positionSubscription;
  StreamSubscription<Duration?>? bufferSubscription;

  Map TrackInfo = {};
  Map get trackInfo => TrackInfo;

  Future<void> play(Map trackInfo) async {
    queueData["Title"] = "Your queue";
    final duration = await player.setUrl("https://player.monstercat.app/api/release/${trackInfo["Release"]["Id"]}/track-stream/${trackInfo["Id"]}");
    isPlaying = true;
    nowPlaying = trackInfo;
    resume();
    notifyListeners(); // Notify listeners to update UI
  }

  Future<void> playQueue(_queue) async {
    player.stop();
    queue = _queue;
    List<AudioSource> internalQueue = [];
    for(int s=0; s<_queue.length;s++){
      internalQueue.add(
          AudioSource.uri(
              Uri.parse("https://player.monstercat.app/api/release/${_queue[s]["Release"]["Id"]}/track-stream/${_queue[s]["Id"]}")
          )
      );
    }
    await player.setAudioSource(
        ConcatenatingAudioSource(
            children: internalQueue
        )
    );
    resume();
    nowPlaying = queue[(player.currentIndex as int)];
    notifyListeners();
    player.playerStateStream.listen((playerState) async {
      print(playerState.processingState);
      if (playerState.processingState == ProcessingState.completed) {
        await player.seekToNext();
        print("Index: ${player.currentIndex}");
        nowPlaying = queue[(player.currentIndex as int)];
        notifyListeners();
      }
    });
  }

  Future<void> queueAdd(Map trackInfo) async {
    queue.add(trackInfo);
    notifyListeners();
  }

  void pause() {
    player.pause();
    isPlaying = false;
    positionSubscription?.cancel();
    notifyListeners(); // Notify listeners to update UI
  }
  void playNext() {
    player.seekToNext();
    notifyListeners();
  }

  void resume() {
    positionSubscription?.cancel();
    bufferSubscription?.cancel();
    notifyListeners();
    player.play();
    isPlaying = true;
    positionSubscription = player.positionStream.listen((_position) {
      if (position != null) {
        position = _position.inSeconds;
        notifyListeners();
      }
    });
    bufferSubscription = player.bufferedPositionStream.listen((_buffered) {
      if (position != null) {
        buffered = _buffered.inSeconds;
        notifyListeners();
      }
    });
    notifyListeners(); // Notify listeners to update UI
  }
}