import 'dart:async';

import 'package:just_audio/just_audio.dart';

import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';

class musicPlayer with ChangeNotifier {
  bool isPlaying = false;
  bool isQueue = false;
  Map downloads = {};
  int position = 0;
  int buffered = 0;
  List queue = [];
  Map queueData = {};
  var player = AudioPlayer();
  Map nowPlaying = {};
  StreamSubscription<Duration?>? positionSubscription;
  StreamSubscription<Duration?>? bufferSubscription;
  List<AudioSource> internalQueue = [];
  LoopMode loopmode = LoopMode.off;
  bool shuffle = false;

  Map TrackInfo = {};
  Map get trackInfo => TrackInfo;
  Future<void> play(Map trackInfo) async {
    // if(queue.length == 0){
      playQueue([trackInfo]);
      queueData["Title"] = "Single Track";
      notifyListeners();
    // }else{
    //   queueData["Title"] = "Your queue";
    //   queueAdd(trackInfo);
    //   print("Current: ${player.currentIndex}");
    //   player.seek(Duration.zero, index: queue.length);
    //   print("New: ${player.currentIndex}");
    //   notifyListeners();
    //   nowPlaying = queue[(player.nextIndex as int)];
    //   resume();
    //   notifyListeners();
    // }
    // final duration = await player.setUrl(
    //     "https://player.monstercat.app/api/release/${trackInfo["Release"]["Id"]}/track-stream/${trackInfo["Id"]}"
    // );
    // isPlaying = true;
    // nowPlaying = trackInfo;
    // queueAdd(trackInfo);
    // resume();
    // notifyListeners(); // Notify listeners to update UI
  }

  Future<void> playQueue(_queue) async {
    player.stop();
    queue = _queue;
    internalQueue.clear();
    for(int s=0; s<_queue.length;s++){
        AudioSource aSource = AudioSource.uri(
            Uri.parse("https://player.monstercat.app/api/release/${_queue[s]["Release"]["Id"]}/track-stream/${_queue[s]["Id"]}"),
            tag: MediaItem(
                id: s.toString(),
                title: _queue[s]["Title"],
                artUri: Uri.parse('https://cdx.monstercat.com/?width=256&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${_queue[s]["Release"]["CatalogId"]}%2Fcover'),
                album: _queue[s]["Release"]["Title"],
                duration: Duration(seconds: _queue[s]["Duration"]),
                artist: _queue[s]["ArtistsTitle"],
                genre: "${_queue[s]["GenrePrimary"]}/${_queue[s]["GenreSecondary"]}",
                displayTitle: _queue[s]["Title"],
                // displayDescription: "Description"

            )
        );
        internalQueue.add(
            aSource
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
      if (playerState.processingState == ProcessingState.completed) {
        await player.seekToNext();
        nowPlaying = queue[(player.currentIndex as int)];
        notifyListeners();
      }
    });
  }

  Future<void> queueAdd(Map trackInfo) async {
    queue.add(trackInfo);
    internalQueue.add(AudioSource.uri(
        Uri.parse("https://player.monstercat.app/api/release/${trackInfo["Release"]["Id"]}/track-stream/${trackInfo["Id"]}"),
        tag: MediaItem(
          id: (queue.length).toString(),
          title: trackInfo["Title"],
          artUri: Uri.parse('https://cdx.monstercat.com/?width=1024&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${trackInfo["Release"]["CatalogId"]}%2Fcover'),
          album: trackInfo["Release"]["Title"],
          duration: Duration(seconds: trackInfo["Duration"]),
          artist: trackInfo["ArtistsTitle"],
          genre: "${trackInfo["GenrePrimary"]}/${trackInfo["GenreSecondary"]}",
          displayTitle: trackInfo["Title"],
          // displayDescription: "Description"
        )
    ));
    await player.setAudioSource(
        ConcatenatingAudioSource(
            children: internalQueue
        )
    );
    notifyListeners();
  }
  void switchShuffleMode() {
    player.setShuffleModeEnabled(!shuffle);
    shuffle = player.shuffleModeEnabled;
    notifyListeners();
  }
  void switchLoopMode(){
    switch (player.loopMode){
      case LoopMode.off:
        player.setLoopMode(LoopMode.all);
        break;
      case LoopMode.all:
        player.setLoopMode(LoopMode.one);
        break;
      case LoopMode.one:
        player.setLoopMode(LoopMode.off);
        break;
    }
    loopmode = player.loopMode;
    notifyListeners();
  }
  void pause() {
    player.pause();
    isPlaying = false;
    positionSubscription?.cancel();
    notifyListeners(); // Notify listeners to update UI
  }
  void playNext() {
    pause();
    player.seekToNext();
    nowPlaying = queue[(player.nextIndex as int)];
    resume();
    notifyListeners();
  }
  void playPrevious() {
    if(player.position > Duration(seconds: 5)){
      player.seek(Duration(seconds: 0));
      resume();
      nowPlaying = queue[(player.currentIndex as int)];
    }else {
      nowPlaying = queue[(player.previousIndex as int)];
      player.seekToPrevious();
      notifyListeners();
      resume();
    }
    notifyListeners();
  }
  void seek(pos){
    player.seek(Duration(seconds: pos.toInt()));
    nowPlaying = queue[(player.currentIndex as int)];
    notifyListeners();
    positionSubscription?.cancel();
    positionSubscription = player.positionStream.listen((_position) {
      if (position != null) {
        position = _position.inSeconds;
        nowPlaying = queue[(player.currentIndex as int)];
        notifyListeners();
      }
    });
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