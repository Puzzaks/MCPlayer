
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:monstercatplayer/player.dart';
import 'package:monstercatplayer/view.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'network.dart';



class mcAlbumTrackLine extends StatelessWidget {
  final Map data;
  final double width;
  const mcAlbumTrackLine({required this.data, required this.width});
  String formatDuration(int seconds) {
    String hoursString = (seconds ~/ 3600).toString().padLeft(2, '0');
    String minutesString = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    String secondsString = (seconds % 60).toString().padLeft(2, '0');
    return '${hoursString == "00" ?"":"$hoursString:"}$minutesString:$secondsString';
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Color(0xFF202020)
                : Colors.teal.withAlpha(64),
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: const BorderSide(color: Colors.transparent, width: 1),
            ),
          ),
          onPressed: () {
            Provider.of<musicPlayer>(context, listen: false).play(data);
          },
          onLongPress: (){
            showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              isScrollControlled: true,
              constraints: BoxConstraints(
                  maxHeight: 390,
                  maxWidth: 500
              ),
              enableDrag: true,
              showDragHandle: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
              ),
              useSafeArea: true,
              backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? Color(0xFF202020)
                  : ThemeData.light().scaffoldBackgroundColor,
              builder: (BuildContext context) {
                return mcTrackOptions(
                    data: data
                );
              },
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            shadowColor: Colors.transparent,
            color: Colors.transparent,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      data["TrackNumber"].toString(),
                      style: const TextStyle(fontFamily: 'Comfortaa', fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width - 82,
                        child: Text(
                          "${data["Explicit"]?"[E] ":""}${data["Title"]}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: 'Comfortaa', fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      data["ArtistsTitle"] == data["Release"]["ArtistsTitle"]
                          ? Container()
                          : SizedBox(
                        width: width - 90,
                        child: Text(
                          data["ArtistsTitle"],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(height:1.25,fontFamily: 'Comfortaa', color:Colors.grey, fontSize: 18),
                        ),
                      ),
                      SizedBox(
                        width: width - 90,
                        child: Text(
                          "${formatDuration(data["Duration"])} · ${data["BPM"]}BPM",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(height:1.25,fontFamily: 'Comfortaa', color:Colors.grey, fontSize: 18),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

}

class mcPlaylistTrackLine extends StatelessWidget {
  final Map data;
  final double width;
  const mcPlaylistTrackLine({required this.data, required this.width});
  String formatDuration(int seconds) {
    String hoursString = (seconds ~/ 3600).toString().padLeft(2, '0');
    String minutesString = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    String secondsString = (seconds % 60).toString().padLeft(2, '0');
    return '${hoursString == "00" ?"":"$hoursString:"}$minutesString:$secondsString';
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Color(0xFF202020)
                : Colors.teal.withAlpha(64),
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: const BorderSide(color: Colors.transparent, width: 1),
            ),
          ),
          onPressed: () {
            Provider.of<musicPlayer>(context, listen: false).play(data);
          },
          onLongPress: (){
            showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              isScrollControlled: true,
              constraints: BoxConstraints(
                  maxHeight: 390,
                  maxWidth: 500
              ),
              enableDrag: true,
              showDragHandle: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
              ),
              useSafeArea: true,
              backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? Color(0xFF202020)
                  : ThemeData.light().scaffoldBackgroundColor,
              builder: (BuildContext context) {
                return mcTrackOptions(
                    data: data
                );
              },
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            shadowColor: Colors.transparent,
            color: Colors.transparent,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: 'https://cdx.monstercat.com/?width=256&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${data["Release"]["CatalogId"]}%2Fcover',
                      width: 70, // Set the desired width
                      height: 70, // Set the desired height
                      placeholder: (context, url) => const CircularProgressIndicator(
                        color: Colors.teal,
                        backgroundColor: Colors.transparent,
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width - 120,
                        child: Text(
                          data["Title"],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: 'Comfortaa', fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width - 120,
                            child: Text(
                              data["ArtistsTitle"],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontFamily: 'Comfortaa',
                                  fontSize: 16,
                                  height: 1.125,
                                  color: Colors.grey
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width - 130,
                            child: Text(
                              "${data["BPM"]} BPM • ${formatDuration(data["Duration"])}",
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontFamily: 'Comfortaa',
                                  fontSize: 16,
                                  height: 1.125,
                                  color: Colors.grey
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

}

class mcTrackOptions extends StatelessWidget {
  final Map data;
  const mcTrackOptions({required this.data});
  String formatDuration(int seconds) {
    String hoursString = (seconds ~/ 3600).toString().padLeft(2, '0');
    String minutesString = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    String secondsString = (seconds % 60).toString().padLeft(2, '0');
    return '${hoursString == "00" ?"":"$hoursString:"}$minutesString:$secondsString';
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: 'https://cdx.monstercat.com/?width=256&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${data["Release"]["CatalogId"]}%2Fcover',
                      width: 70, // Set the desired width
                      height: 70, // Set the desired height
                      placeholder: (context, url) => const CircularProgressIndicator(
                        color: Colors.teal,
                        backgroundColor: Colors.transparent,
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data["Title"],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(fontFamily: 'Comfortaa', fontWeight: FontWeight.bold, fontSize: 22, height: 1.25),
                      ),
                      Row(
                        children: [
                          Text(
                            data["ArtistsTitle"],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: const TextStyle(
                              fontFamily: 'Comfortaa',
                              fontSize: 18,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
              ElevatedButton(
                onPressed: (){
                  Provider.of<musicPlayer>(context, listen: false).play(data);
                },
                onLongPress: (){
                  Fluttertoast.showToast(
                    msg: 'Tap to play',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                  );
                },
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 32,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shadowColor: Colors.transparent,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10),
                ),
              )
            ],
          ),

        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: (){
                Fluttertoast.showToast(
                  msg: 'Not implemented yet',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              onLongPress: (){
                Fluttertoast.showToast(
                  msg: 'Tap to play next',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.playlist_play_rounded,
                    color: MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? null
                        : Colors.black,
                    size: 28,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    "Play next",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: MediaQuery.of(context).platformBrightness == Brightness.dark
                          ? null
                          : Colors.black,
                      fontFamily: 'Comfortaa',
                      fontSize: 22,
                      height: 1.25,
                    ),
                  )
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(),
                padding: EdgeInsets.all(10),
              ),
            ),
            ElevatedButton(
              onPressed: (){
                Fluttertoast.showToast(
                  msg: 'Not implemented yet',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              onLongPress: (){
                Fluttertoast.showToast(
                  msg: 'Tap to add to queue',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.playlist_add_rounded,
                    color: MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? null
                        : Colors.black,
                    size: 28,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    "Add to queue",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Comfortaa',
                      color: MediaQuery.of(context).platformBrightness == Brightness.dark
                          ? null
                          : Colors.black,
                      fontSize: 22,
                      height: 1.25,
                    ),
                  )
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(),
                padding: EdgeInsets.all(10),
              ),
            ),
            ElevatedButton(
              onPressed: (){
                Fluttertoast.showToast(
                  msg: 'Not implemented yet',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              onLongPress: (){
                Fluttertoast.showToast(
                  msg: 'Tap to add to downloads',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.download_rounded,
                    color: MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? null
                        : Colors.black,
                    size: 28,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    "Download",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Comfortaa',
                      color: MediaQuery.of(context).platformBrightness == Brightness.dark
                          ? null
                          : Colors.black,
                      fontSize: 22,
                      height: 1.25,
                    ),
                  )
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(),
                padding: EdgeInsets.all(10),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Share.share('https://player.monstercat.app/release/${data["Release"]["CatalogId"]}');
              },
              onLongPress: (){
                Fluttertoast.showToast(
                  msg: 'Tap to share release link',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.share_rounded,
                    color: MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? null
                        : Colors.black,
                    size: 28,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    "Share",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Comfortaa',
                      color: MediaQuery.of(context).platformBrightness == Brightness.dark
                          ? null
                          : Colors.black,
                      fontSize: 22,
                      height: 1.25,
                    ),
                  )
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(),
                padding: EdgeInsets.all(10),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      fullscreenDialog: true,
                      allowSnapshotting: true,
                      maintainState: true,
                      builder: (context) => albumView(
                        release: data["Release"]["CatalogId"],
                      )),
                );
              },
              onLongPress: (){
                Fluttertoast.showToast(
                  msg: 'Tap to open album',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.album_rounded,
                    color: MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? null
                        : Colors.black,
                    size: 28,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    "Open release",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Comfortaa',
                      color: MediaQuery.of(context).platformBrightness == Brightness.dark
                          ? null
                          : Colors.black,
                      fontSize: 22,
                      height: 1.25,
                    ),
                  )
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(),
                padding: EdgeInsets.all(10),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  useRootNavigator: true,
                  isScrollControlled: true,
                  constraints: BoxConstraints(
                      maxHeight: 400,
                      maxWidth: 500
                  ),
                  enableDrag: true,
                  showDragHandle: false,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                  ),
                  useSafeArea: true,
                  backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark
                      ? Color(0xFF202020)
                      : ThemeData.light().scaffoldBackgroundColor,
                  builder: (BuildContext context) {
                    return mcSongToPlaylistSelector(
                        data: data
                    );
                  },
                );
              },
              onLongPress: (){
                Fluttertoast.showToast(
                  msg: 'Tap to add to playlist',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              },
              child: Row(
                children: [
                  Icon(
                    Icons.add_rounded,
                    color: MediaQuery.of(context).platformBrightness == Brightness.dark
                        ? null
                        : Colors.black,
                    size: 28,
                  ),
                  SizedBox(width: 10,),
                  Text(
                    "Add to playlist",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: 'Comfortaa',
                      color: MediaQuery.of(context).platformBrightness == Brightness.dark
                          ? null
                          : Colors.black,
                      fontSize: 22,
                      height: 1.25,
                    ),
                  )
                ],
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(),
                padding: EdgeInsets.all(10),
              ),
            ),
          ],
        ),
      ],
    );
  }

}

class mcSongToPlaylistSelector extends StatelessWidget {
  final Map data;
  const mcSongToPlaylistSelector({required this.data});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserPlaylists(),
        builder: (BuildContext context, AsyncSnapshot playlists) {
          int amount = 0;
          if (playlists.hasData) {
            if(playlists.data != "False"){
              if(playlists.data["Playlists"]["Count"] > 5){
                amount = 5;
              }else{
                amount = playlists.data["Playlists"]["Count"];
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Padding(
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                      child: Text(
                        "Select playlist:",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Comfortaa',
                        ),
                      ),
                    ),
                    ],
                  ),
                  playlists.data["Playlists"]["Count"] < 1
                      ? Text(
                    "You haven't added any playlists yet.",
                    style: TextStyle(
                      fontFamily: 'Comfortaa',
                    ),
                  )
                      : Container(
                    height: 333,
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: playlists.data["Playlists"]["Data"].map((option) {
                            bool trackPresent = false;
                            if(option["MyLibrary"] == true) {
                              for (int i = 0; i < option["Items"].length; i++) {
                                if (option["Items"][i]["TrackId"] == data["Id"]) {
                                  trackPresent = true;
                                }
                              }
                            }
                            if(!trackPresent){
                              return GestureDetector(
                                onTap: () async {
                                  await sendAddToPlaylist(option["Id"], data).then((value){
                                    if(value){
                                      Fluttertoast.showToast(
                                        msg: 'Added!',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                      Navigator.pop(context);
                                    }else{
                                      Fluttertoast.showToast(
                                        msg: 'Unable to add song!',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        option["Title"],
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Comfortaa',
                                        ),
                                      ),
                                      Text(
                                        "${option["NumRecords"].toString()} tracks",
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Comfortaa',
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                            return GestureDetector(
                              onTap: () async {
                                Fluttertoast.showToast(
                                  msg: 'This track is already added!',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option["Title"],
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                        fontFamily: 'Comfortaa',
                                      ),
                                    ),
                                    Text(
                                    "${option["NumRecords"].toString()} tracks",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                      fontFamily: 'Comfortaa',
                                    ),
                                  )
                                  ],
                                ),
                              ),
                            );
                          }).toList().cast<Widget>()
                      ),
                    ),
                  ),
                ],
              );
            }
            return Container();
          } else {
            return Center(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: const [
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
                  child: Text(
                    "Loading playlists",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Comfortaa',
                    ),
                  ),
                ),
                LinearProgressIndicator(
                  color: Colors.teal,
                  backgroundColor: Colors.transparent,
                ),
              ]),
            );
          }
        });
  }

}

class mcSearchTrackLine extends StatelessWidget {
  final Map data;
  final double width;
  const mcSearchTrackLine({required this.data, required this.width});
  String formatDuration(int seconds) {
    String hoursString = (seconds ~/ 3600).toString().padLeft(2, '0');
    String minutesString = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    String secondsString = (seconds % 60).toString().padLeft(2, '0');
    return '${hoursString == "00" ?"":"$hoursString:"}$minutesString:$secondsString';
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Color(0xFF202020)
                : Colors.teal.withAlpha(64),
            shadowColor: Colors.transparent,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: const BorderSide(color: Colors.transparent, width: 1),
            ),
          ),
          onPressed: () {
            Provider.of<musicPlayer>(context, listen: false).play(data);
          },
          onLongPress: (){
            showModalBottomSheet(
              context: context,
              useRootNavigator: true,
              isScrollControlled: true,
              constraints: BoxConstraints(
                  maxHeight: 390,
                  maxWidth: 500
              ),
              enableDrag: true,
              showDragHandle: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
              ),
              useSafeArea: true,
              backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? Color(0xFF202020)
                  : ThemeData.light().scaffoldBackgroundColor,
              builder: (BuildContext context) {
                return mcTrackOptions(
                  data: data
                );
              },
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: 'https://cdx.monstercat.com/?width=256&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${data["Release"]["CatalogId"]}%2Fcover',
                      width: 52, // Set the desired width
                      height: 52, // Set the desired height
                      placeholder: (context, url) => const CircularProgressIndicator(
                        color: Colors.teal,
                        backgroundColor: Colors.transparent,
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width - 120,
                        child: Text(
                          data["Title"],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: 'Comfortaa', fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width - 120,
                            child: Text(
                              data["ArtistsTitle"],
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontFamily: 'Comfortaa',
                                  fontSize: 16,
                                  height: 1.125,
                                  color: Colors.grey
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Row(
                      //   children: [
                      //     SizedBox(
                      //       width: width - 130,
                      //       child: Text(
                      //         "${data["BPM"]} BPM • ${formatDuration(data["Duration"])}",
                      //         overflow: TextOverflow.ellipsis,
                      //         style: const TextStyle(
                      //             fontFamily: 'Comfortaa',
                      //             fontSize: 16,
                      //             height: 1.125,
                      //             color: Colors.grey
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

}

class mcJumpSettingsButton extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  const mcJumpSettingsButton({required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right:15),
          child: Icon(
              icon,
              size: 35,
              color: MediaQuery.of(context).platformBrightness == Brightness.dark
                  ? Colors.white
                  : Colors.black
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: MediaQuery.of(context).platformBrightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
                fontSize: 20,
                fontFamily: "Comfortaa",
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              subtitle,
              style: TextStyle(
                height: 1,
                fontSize: 14,
                fontFamily: "Comfortaa",
                color: Colors.grey,
              ),
            )
          ],
        )
      ],
    );
  }
}

class mcNotificationCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  const mcNotificationCard({required this.icon, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 20, fontFamily: "Comfortaa", fontWeight: FontWeight.bold),
                  ),
                  Icon(icon)
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Comfortaa",
                ),
              ),
            ],
          ),
        ));
  }
}

class mcRecentAlbum extends StatelessWidget {
  final data;
  final width;
  final appSettings;
  const mcRecentAlbum({this.data, this.width, this.appSettings});
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right:10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: CachedNetworkImage(
                imageUrl: 'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${data["Release"]["CatalogId"]}%2Fcover',
                width: 64, // Set the desired width
                height: 64, // Set the desired height
                placeholder: (context, url) => Container(color: Colors.transparent),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Container(
            width: width - 120,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data["Release"]["Title"],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Comfortaa',
                    ),
                  ),
                  Text(
                    data["Release"]["ArtistsTitle"],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Comfortaa',
                        height: 1.25,
                        color: Colors.teal),
                  ),
                ]),
          ),
        ],
      ),
    );
  }
}

