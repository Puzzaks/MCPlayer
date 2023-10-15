import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:monstercatplayer/library.dart';
import 'package:monstercatplayer/network.dart';
import 'package:monstercatplayer/player.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import 'elements.dart';
import 'memory.dart';

class playistView extends StatefulWidget {
  final String playlist;
  const playistView({super.key, required this.playlist});
  @override
  playistViewState createState() => playistViewState();
}

class playistViewState extends State<playistView> {
  bool isDarkTheme = false;
  bool expandedDescription = false;
  String userID = "";
  String playlist = "";

  int totalLength = 0;

  Map<String, String> appSettings = {};

  void setMusLength(int length) {
    setState(() {
      totalLength = length;
    });
  }

  @override
  void initState() {
    // getString("albumArtPreviewRes").then((value) {
    //   appSettings["albumArtPreviewRes"] = value;
    // });
    playlist = widget.playlist;
    getString("UID").then((value){
      userID = value;
    });
    super.initState();
  }


  @override
  Widget build(BuildContext topContext) {
    return MaterialApp(
      theme: ThemeData(iconTheme: const IconThemeData(color: Colors.teal)),
      darkTheme: ThemeData.dark().copyWith(cardColor: Color(0xFF202020), scaffoldBackgroundColor: const Color(0xFF040707)), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          double scaffoldHeight = constraints.maxHeight;
          double scaffoldWidth = constraints.maxWidth;
          if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
            isDarkTheme = true;
          } else {
            isDarkTheme = false;
          }
          final backgroundColor = MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Color(0xFF040707)
              : ThemeData.light().scaffoldBackgroundColor;
          final iconColor = MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark;
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: iconColor,
              systemNavigationBarColor: backgroundColor,
            ),
          );
          return OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                if (orientation == Orientation.landscape) {
                  // return SafeArea(
                  //     child: Padding(
                  //       padding: EdgeInsets.symmetric(horizontal: 0),
                  //       child: Row(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Expanded(
                  //             child: FutureBuilder(
                  //                 future: getPlaylistInfo(playlist),
                  //                 builder: (BuildContext context, AsyncSnapshot playlistInfo) {
                  //                   if (playlistInfo.hasData) {
                  //                     if (playlistInfo.data != "False") {
                  //                       double ratio = scaffoldWidth / scaffoldHeight;
                  //                       double picSize = 0;
                  //                       if(ratio < 2){
                  //                         picSize = ((scaffoldWidth / 2) - 30);
                  //                       }else if(ratio < 4){
                  //                         picSize = ((scaffoldHeight / 1.5) - 30);
                  //                       }else{
                  //                         picSize = (scaffoldHeight / 2);
                  //                       }
                  //                       return Stack(
                  //                         children: [
                  //                           Padding(
                  //                             padding: EdgeInsets.all(15),
                  //                             child: playlistInfo.data["Playlist"]["TileFileId"] == null
                  //                                 ? playlistInfo.data["Playlist"]["NumRecords"] > 0
                  //                                 ? FutureBuilder(
                  //                                 future: getPlaylistAlbumArt(playlistInfo.data["Playlist"]["Id"]),
                  //                                 builder: (BuildContext context, AsyncSnapshot plist) {
                  //                                   if (plist.hasData) {
                  //                                     if (plist.data != "False") {
                  //                                       if (plist.data["Data"].length == 1) {
                  //                                         return Padding(
                  //                                           padding: EdgeInsets.only(right: 10),
                  //                                           child: ClipRRect(
                  //                                             borderRadius: BorderRadius.circular(15.0),
                  //                                             child: CachedNetworkImage(
                  //                                               imageUrl:
                  //                                               'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                  //                                               width: picSize, // Set the desired width
                  //                                               height: picSize, // Set the desired height
                  //                                               placeholder: (context, url) => Container(color: Colors.transparent),
                  //                                               errorWidget: (context, url, error) => const Icon(Icons.error),
                  //                                             ),
                  //                                           ),
                  //                                         );
                  //                                       }
                  //                                       if (plist.data["Data"].length == 2) {
                  //                                         return Padding(
                  //                                           padding: EdgeInsets.only(right: 10),
                  //                                           child: ClipRRect(
                  //                                             borderRadius: BorderRadius.circular(15.0),
                  //                                             child: Row(
                  //                                               children: [
                  //                                                 Column(
                  //                                                   children: [
                  //                                                     CachedNetworkImage(
                  //                                                       imageUrl:
                  //                                                       'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "1024"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                  //                                                       width: picSize / 2, // Set the desired width
                  //                                                       height: picSize / 2, // Set the desired height
                  //                                                       placeholder: (context, url) => Container(color: Colors.transparent),
                  //                                                       errorWidget: (context, url, error) => const Icon(Icons.error),
                  //                                                     ),
                  //                                                     CachedNetworkImage(
                  //                                                       imageUrl:
                  //                                                       'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "1024"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][1]["Release"]["CatalogId"]}%2Fcover',
                  //                                                       width: picSize / 2, // Set the desired width
                  //                                                       height: picSize / 2, // Set the desired height
                  //                                                       placeholder: (context, url) => Container(color: Colors.transparent),
                  //                                                       errorWidget: (context, url, error) => const Icon(Icons.error),
                  //                                                     )
                  //                                                   ],
                  //                                                 ),
                  //                                                 Column(
                  //                                                   children: [
                  //                                                     CachedNetworkImage(
                  //                                                       imageUrl:
                  //                                                       'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "1024"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][1]["Release"]["CatalogId"]}%2Fcover',
                  //                                                       width: picSize / 2, // Set the desired width
                  //                                                       height: picSize / 2, // Set the desired height
                  //                                                       placeholder: (context, url) => Container(color: Colors.transparent),
                  //                                                       errorWidget: (context, url, error) => const Icon(Icons.error),
                  //                                                     ),
                  //                                                     CachedNetworkImage(
                  //                                                       imageUrl:
                  //                                                       'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "1024"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                  //                                                       width: picSize / 2, // Set the desired width
                  //                                                       height: picSize / 2, // Set the desired height
                  //                                                       placeholder: (context, url) => Container(color: Colors.transparent),
                  //                                                       errorWidget: (context, url, error) => const Icon(Icons.error),
                  //                                                     )
                  //                                                   ],
                  //                                                 )
                  //                                               ],
                  //                                             ),
                  //                                           ),
                  //                                         );
                  //                                       }
                  //                                       if (plist.data["Data"].length == 3) {
                  //                                         return Padding(
                  //                                           padding: EdgeInsets.only(right: 10),
                  //                                           child: ClipRRect(
                  //                                             borderRadius: BorderRadius.circular(15.0),
                  //                                             child: Row(
                  //                                               children: [
                  //                                                 Column(
                  //                                                   children: [
                  //                                                     CachedNetworkImage(
                  //                                                       imageUrl:
                  //                                                       'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "1024"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                  //                                                       width: picSize / 2, // Set the desired width
                  //                                                       height: picSize / 2, // Set the desired height
                  //                                                       placeholder: (context, url) => Container(color: Colors.transparent),
                  //                                                       errorWidget: (context, url, error) => const Icon(Icons.error),
                  //                                                     ),
                  //                                                     CachedNetworkImage(
                  //                                                       imageUrl:
                  //                                                       'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "1024"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][1]["Release"]["CatalogId"]}%2Fcover',
                  //                                                       width: picSize / 2, // Set the desired width
                  //                                                       height: picSize / 2, // Set the desired height
                  //                                                       placeholder: (context, url) => Container(color: Colors.transparent),
                  //                                                       errorWidget: (context, url, error) => const Icon(Icons.error),
                  //                                                     )
                  //                                                   ],
                  //                                                 ),
                  //                                                 Column(
                  //                                                   children: [
                  //                                                     CachedNetworkImage(
                  //                                                       imageUrl:
                  //                                                       'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "1024"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][2]["Release"]["CatalogId"]}%2Fcover',
                  //                                                       width: picSize / 2, // Set the desired width
                  //                                                       height: picSize / 2, // Set the desired height
                  //                                                       placeholder: (context, url) => Container(color: Colors.transparent),
                  //                                                       errorWidget: (context, url, error) => const Icon(Icons.error),
                  //                                                     ),
                  //                                                     CachedNetworkImage(
                  //                                                       imageUrl:
                  //                                                       'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "1024"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                  //                                                       width: picSize / 2, // Set the desired width
                  //                                                       height: picSize / 2, // Set the desired height
                  //                                                       placeholder: (context, url) => Container(color: Colors.transparent),
                  //                                                       errorWidget: (context, url, error) => const Icon(Icons.error),
                  //                                                     )
                  //                                                   ],
                  //                                                 )
                  //                                               ],
                  //                                             ),
                  //                                           ),
                  //                                         );
                  //                                       }
                  //                                       if (plist.data["Data"].length >= 4) {
                  //                                         return Padding(
                  //                                           padding: EdgeInsets.only(right: 10),
                  //                                           child: ClipRRect(
                  //                                             borderRadius: BorderRadius.circular(15.0),
                  //                                             child: Row(
                  //                                               children: [
                  //                                                 Column(
                  //                                                   children: [
                  //                                                     CachedNetworkImage(
                  //                                                       imageUrl:
                  //                                                       'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                  //                                                       width: picSize / 2, // Set the desired width
                  //                                                       height: picSize / 2, // Set the desired height
                  //                                                       placeholder: (context, url) => Container(color: Colors.transparent),
                  //                                                       errorWidget: (context, url, error) => const Icon(Icons.error),
                  //                                                     ),
                  //                                                     CachedNetworkImage(
                  //                                                       imageUrl:
                  //                                                       'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][1]["Release"]["CatalogId"]}%2Fcover',
                  //                                                       width: picSize / 2, // Set the desired width
                  //                                                       height: picSize / 2, // Set the desired height
                  //                                                       placeholder: (context, url) => Container(color: Colors.transparent),
                  //                                                       errorWidget: (context, url, error) => const Icon(Icons.error),
                  //                                                     )
                  //                                                   ],
                  //                                                 ),
                  //                                                 Column(
                  //                                                   children: [
                  //                                                     CachedNetworkImage(
                  //                                                       imageUrl:
                  //                                                       'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][2]["Release"]["CatalogId"]}%2Fcover',
                  //                                                       width: picSize / 2, // Set the desired width
                  //                                                       height: picSize / 2, // Set the desired height
                  //                                                       placeholder: (context, url) => Container(color: Colors.transparent),
                  //                                                       errorWidget: (context, url, error) => const Icon(Icons.error),
                  //                                                     ),
                  //                                                     CachedNetworkImage(
                  //                                                       imageUrl:
                  //                                                       'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][3]["Release"]["CatalogId"]}%2Fcover',
                  //                                                       width: picSize / 2, // Set the desired width
                  //                                                       height: picSize / 2, // Set the desired height
                  //                                                       placeholder: (context, url) => Container(color: Colors.transparent),
                  //                                                       errorWidget: (context, url, error) => const Icon(Icons.error),
                  //                                                     )
                  //                                                   ],
                  //                                                 )
                  //                                               ],
                  //                                             ),
                  //                                           ),
                  //                                         );
                  //                                       }
                  //                                       return Padding(
                  //                                         padding: EdgeInsets.only(right: 10),
                  //                                         child: ClipRRect(
                  //                                           borderRadius: BorderRadius.circular(15.0),
                  //                                           child: CachedNetworkImage(
                  //                                             imageUrl:
                  //                                             'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                  //                                             width: picSize, // Set the desired width
                  //                                             height: picSize, // Set the desired height
                  //                                             placeholder: (context, url) => Container(color: Colors.transparent),
                  //                                             errorWidget: (context, url, error) => const Icon(Icons.error),
                  //                                           ),
                  //                                         ),
                  //                                       );
                  //                                     }
                  //                                   }
                  //                                   return Padding(
                  //                                     padding: EdgeInsets.only(right: 10),
                  //                                     child: Container(
                  //                                       width: picSize,
                  //                                       height: picSize,
                  //                                     ),
                  //                                   );
                  //                                 })
                  //                                 : Padding(
                  //                               padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 18),
                  //                               child: ClipRRect(
                  //                                 borderRadius: BorderRadius.circular(15.0),
                  //                                 child: !isDarkTheme
                  //                                     ? ColorFiltered(
                  //                                   colorFilter: ColorFilter.matrix([
                  //                                     -1, 0, 0, 0, 255, // Red channel
                  //                                     0, -1, 0, 0, 255, // Green channel
                  //                                     0, 0, -1, 0, 255, // Blue channel
                  //                                     0, 0, 0, 1, 0, // Alpha channel
                  //                                   ]),
                  //                                   child: Image.asset(
                  //                                     "assets/app_logo.png",
                  //                                     height: picSize,
                  //                                     width: picSize,
                  //                                   ),
                  //                                 )
                  //                                     : Image.asset(
                  //                                   "assets/app_logo.png",
                  //                                   height: picSize / 2,
                  //                                   width: picSize / 2,
                  //                                 ),
                  //                               ),
                  //                             )
                  //                                 : ClipRRect(
                  //                               borderRadius: BorderRadius.circular(15.0),
                  //                               child: CachedNetworkImage(
                  //                                 imageUrl: 'https://monstercat.com/api/playlist/${playlistInfo.data["Playlist"]["Id"]}/tile',
                  //                                 width: picSize, // Set the desired width
                  //                                 height: picSize, // Set the desired height
                  //                                 placeholder: (context, url) => Container(color: Colors.transparent),
                  //                                 errorWidget: (context, url, error) => const Icon(Icons.error),
                  //                               ),
                  //                             ),
                  //                           ),
                  //                           Container(
                  //                             height: scaffoldHeight,
                  //                             child: Column(
                  //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                               children: [
                  //                                 Container(),
                  //                                 Column(
                  //                                   crossAxisAlignment: CrossAxisAlignment.start,
                  //                                   children: [
                  //                                     Padding(
                  //                                       padding: EdgeInsets.only(left: 15),
                  //                                       child: Row(
                  //                                         crossAxisAlignment: CrossAxisAlignment.center,
                  //                                         children: [
                  //                                           Container(
                  //                                             width: scaffoldWidth / 2 - 30,
                  //                                             child: Column(
                  //                                               crossAxisAlignment: CrossAxisAlignment.start,
                  //                                               children: [
                  //                                                 Text(
                  //                                                   playlistInfo.data["Playlist"]["Title"],
                  //                                                   style: TextStyle(
                  //                                                     backgroundColor: backgroundColor,
                  //                                                     fontSize: 24,
                  //                                                     fontFamily: "Comfortaa",
                  //                                                     fontWeight: FontWeight.bold,
                  //                                                   ),
                  //                                                 ),
                  //                                                 FutureBuilder(
                  //                                                     future: getPlaylist(playlist),
                  //                                                     builder: (BuildContext context, AsyncSnapshot playlist) {
                  //                                                       if (playlist.hasData) {
                  //                                                         int musLength = 0;
                  //                                                         for (int s = 0; s < playlist.data["Data"].length; s++) {
                  //                                                           musLength = musLength + playlist.data["Data"][s]["Duration"] as int;
                  //                                                         }
                  //                                                         String formatDuration(int seconds) {
                  //                                                           String hoursString = (seconds ~/ 3600).toString().padLeft(2, '0');
                  //                                                           String minutesString = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
                  //                                                           String secondsString = (seconds % 60).toString().padLeft(2, '0');
                  //                                                           return '$hoursString:$minutesString:$secondsString';
                  //                                                         }
                  //
                  //                                                         return Row(
                  //                                                           crossAxisAlignment: CrossAxisAlignment.center,
                  //                                                           children: [
                  //                                                             Text(
                  //                                                               playlistInfo.data["Playlist"]["NumRecords"].toString()[playlistInfo.data["Playlist"]["NumRecords"].toString().length - 1] == "1"
                  //                                                                   ? "${playlistInfo.data["Playlist"]["NumRecords"]} song | ${formatDuration(musLength)}"
                  //                                                                   : "${playlistInfo.data["Playlist"]["NumRecords"]} songs | ${formatDuration(musLength)}",
                  //                                                               overflow: TextOverflow.ellipsis,
                  //                                                               maxLines: 1,
                  //                                                               style: TextStyle(
                  //                                                                   backgroundColor: backgroundColor,
                  //                                                                   fontSize: 20,
                  //                                                                   fontFamily: 'Comfortaa',
                  //                                                                   height: 1.25,
                  //                                                                   color: Colors.grey),
                  //                                                             ),
                  //                                                           ],
                  //                                                         );
                  //                                                       }
                  //                                                       return Padding(
                  //                                                         padding: EdgeInsets.symmetric(vertical: 8),
                  //                                                         child: LinearProgressIndicator(
                  //                                                           backgroundColor: Colors.transparent,
                  //                                                           color: Colors.teal,
                  //                                                         ),
                  //                                                       );
                  //                                                     }),
                  //                                                 Text(
                  //                                                   playlistInfo.data["Playlist"]["IsPublic"]
                  //                                                       ? playlistInfo.data["Playlist"]["UserId"] == userID
                  //                                                       ? "Your public playlist"
                  //                                                       : "Public playlist"
                  //                                                       : playlistInfo.data["Playlist"]["UserId"] == userID
                  //                                                       ? "Your private playlist"
                  //                                                       : "Private playlist",
                  //                                                   overflow: TextOverflow.ellipsis,
                  //                                                   maxLines: 1,
                  //                                                   style: TextStyle(
                  //                                                       backgroundColor: backgroundColor,
                  //                                                       fontSize: 20,
                  //                                                       fontFamily: 'Comfortaa',
                  //                                                       height: 1.25,
                  //                                                       color: Colors.grey),
                  //                                                 ),
                  //                                               ],
                  //                                             ),
                  //                                           )
                  //                                         ],
                  //                                       ),
                  //                                     ),
                  //                                     playlistInfo.data["Playlist"]["Description"] == ""
                  //                                         ? Container()
                  //                                         : Padding(
                  //                                       padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                  //                                       child: GestureDetector(
                  //                                         onTap: () {
                  //                                           setState(() {
                  //                                             expandedDescription = !expandedDescription;
                  //                                           });
                  //                                         },
                  //                                         child: Column(
                  //                                           children: [
                  //                                             Text(
                  //                                               playlistInfo.data["Playlist"]["Description"],
                  //                                               overflow: TextOverflow.ellipsis,
                  //                                               maxLines: expandedDescription ? 10 : 1,
                  //                                               style: TextStyle(
                  //                                                 backgroundColor: backgroundColor,
                  //                                                 fontSize: 18,
                  //                                                 fontFamily: 'Comfortaa',
                  //                                                 height: 1.125,
                  //                                               ),
                  //                                             ),
                  //                                           ],
                  //                                         ),
                  //                                       ),
                  //                                     ),
                  //                                     Padding(
                  //                                       padding: EdgeInsets.symmetric(
                  //                                           vertical: 10, horizontal: 15
                  //                                       ),
                  //                                       child: Row(
                  //                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //                                         children: [
                  //                                           Row(
                  //                                             mainAxisAlignment: MainAxisAlignment.start,
                  //                                             children: [
                  //                                               Padding(
                  //                                                 padding: EdgeInsets.only(left:0),
                  //                                                 child: Container(
                  //                                                   width:38,
                  //                                                   height:38,
                  //                                                   child: ElevatedButton(
                  //                                                     onPressed: () {},
                  //                                                     child: Icon(
                  //                                                       Icons.download_rounded,
                  //                                                       color: isDarkTheme
                  //                                                           ? null
                  //                                                           : Colors.black,
                  //                                                       size: 28,
                  //                                                     ),
                  //                                                     style: ElevatedButton.styleFrom(
                  //                                                       backgroundColor: Colors.transparent,
                  //                                                       shadowColor: Colors.transparent,
                  //                                                       shape: CircleBorder(),
                  //                                                       padding: EdgeInsets.zero,
                  //                                                     ),
                  //                                                   ),
                  //                                                 ),
                  //                                               ),
                  //                                               playlistInfo.data["Playlist"]["IsPublic"]
                  //                                                   ? Padding(
                  //                                                 padding: EdgeInsets.only(left: 5),
                  //                                                 child: Container(
                  //                                                   width:38,
                  //                                                   height:38,
                  //                                                   child: ElevatedButton(
                  //                                                     onPressed: () {
                  //                                                       Share.share('https://player.monstercat.app/playlist/${playlistInfo.data["Playlist"]["Id"]}');
                  //                                                     },
                  //                                                     child: Icon(
                  //                                                       Icons.share_rounded,
                  //                                                       color: isDarkTheme
                  //                                                           ? null
                  //                                                           : Colors.black,
                  //                                                       size: 28,
                  //                                                     ),
                  //                                                     style: ElevatedButton.styleFrom(
                  //                                                       backgroundColor: Colors.transparent,
                  //                                                       shadowColor: Colors.transparent,
                  //                                                       shape: CircleBorder(),
                  //                                                       padding: EdgeInsets.zero,
                  //                                                     ),
                  //                                                   ),
                  //                                                 ),
                  //                                               ) : Container(),
                  //                                               playlistInfo.data["Playlist"]["UserId"] == userID && !playlistInfo.data["Playlist"]["MyLibrary"]
                  //                                                   ? Padding(
                  //                                                 padding: EdgeInsets.only(left: 5),
                  //                                                 child: Container(
                  //                                                   width:38,
                  //                                                   height:38,
                  //                                                   child: ElevatedButton(
                  //                                                     onPressed: () {
                  //                                                       Navigator.push(
                  //                                                         topContext,
                  //                                                         MaterialPageRoute(
                  //                                                             fullscreenDialog: false,
                  //                                                             allowSnapshotting: false,
                  //                                                             maintainState: false,
                  //                                                             builder: (context) => editPlaylist(
                  //                                                               preContext: context,
                  //                                                               playlistID: playlistInfo.data["Playlist"]["Id"],
                  //                                                             )
                  //                                                         ),
                  //                                                       );
                  //
                  //                                                     },
                  //                                                     child: Icon(
                  //                                                       Icons.edit_rounded,
                  //                                                       color: isDarkTheme
                  //                                                           ? null
                  //                                                           : Colors.black,
                  //                                                       size: 28,
                  //                                                     ),
                  //                                                     style: ElevatedButton.styleFrom(
                  //                                                       backgroundColor: Colors.transparent,
                  //                                                       shadowColor: Colors.transparent,
                  //                                                       shape: CircleBorder(),
                  //                                                       padding: EdgeInsets.zero,
                  //                                                     ),
                  //                                                   ),
                  //                                                 ),
                  //                                               ) : Container(),
                  //                                             ],
                  //                                           ),
                  //                                           Row(
                  //                                             children: [
                  //                                               ElevatedButton(
                  //                                                 onPressed: () {},
                  //                                                 child: Icon(
                  //                                                   Icons.shuffle_rounded,
                  //                                                   color: isDarkTheme
                  //                                                       ? null
                  //                                                       : Colors.black,
                  //                                                   size: 28,
                  //                                                 ),
                  //                                                 style: ElevatedButton.styleFrom(
                  //                                                   backgroundColor: Colors.transparent,
                  //                                                   shadowColor: Colors.transparent,
                  //                                                   shape: CircleBorder(),
                  //                                                   padding: EdgeInsets.all(0),
                  //                                                 ),
                  //                                               ),
                  //                                               ElevatedButton(
                  //                                                 onPressed: () {},
                  //                                                 child: Icon(
                  //                                                   Icons.play_arrow_rounded,
                  //                                                   size: 32,
                  //                                                 ),
                  //                                                 style: ElevatedButton.styleFrom(
                  //                                                   backgroundColor: Colors.teal,
                  //                                                   shadowColor: Colors.transparent,
                  //                                                   shape: CircleBorder(),
                  //                                                   padding: EdgeInsets.all(10),
                  //                                                 ),
                  //                                               )
                  //                                             ],
                  //                                           )
                  //                                         ],
                  //                                       ),
                  //                                     )
                  //                                   ],
                  //                                 )
                  //                               ],
                  //                             ),
                  //                           ),
                  //                           Padding(
                  //                             padding: EdgeInsets.only(left: 30, top: 15),
                  //                             child: Row(
                  //                               children: [
                  //                                 GestureDetector(
                  //                                   onTap: () {
                  //                                     Navigator.pop(topContext);
                  //                                   },
                  //                                   child: Padding(
                  //                                     padding: EdgeInsets.only(right: 10, top: 15),
                  //                                     child: Icon(
                  //                                       Icons.arrow_back_rounded,
                  //                                       color: isDarkTheme
                  //                                           ? null
                  //                                           : Colors.black,
                  //                                       size: 32,
                  //                                     ),
                  //                                   ),
                  //                                 ),
                  //                               ],
                  //                             ),
                  //                           ),
                  //                         ],
                  //                       );
                  //                     } else {
                  //                       return Padding(
                  //                         padding: EdgeInsets.only(
                  //                           left: 15,
                  //                         ),
                  //                         child: Row(
                  //                           children: [
                  //                             GestureDetector(
                  //                               onTap: () {
                  //                                 Navigator.pop(topContext);
                  //                               },
                  //                               child: const Padding(
                  //                                 padding: EdgeInsets.only(right: 10, top: 15),
                  //                                 child: Icon(
                  //                                   Icons.arrow_back_rounded,
                  //                                   size: 32,
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             Container(
                  //                               width: scaffoldWidth - 80,
                  //                               child: const Padding(
                  //                                 padding: EdgeInsets.only(left: 10, top: 15),
                  //                                 child: Text(
                  //                                   "Couldn't load",
                  //                                   style: TextStyle(
                  //                                     fontSize: 32,
                  //                                     height: 1,
                  //                                     fontFamily: "Comfortaa",
                  //                                     fontWeight: FontWeight.bold,
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                             )
                  //                           ],
                  //                         ),
                  //                       );
                  //                     }
                  //                   }
                  //                   return Column(
                  //                     crossAxisAlignment: CrossAxisAlignment.start,
                  //                     children: [
                  //                       Padding(
                  //                         padding: EdgeInsets.only(left: 15, bottom: 15),
                  //                         child: Row(
                  //                           children: [
                  //                             GestureDetector(
                  //                               onTap: () {
                  //                                 Navigator.pop(topContext);
                  //                               },
                  //                               child: Padding(
                  //                                 padding: EdgeInsets.only(right: 10, top: 15),
                  //                                 child: Icon(
                  //                                   Icons.arrow_back_rounded,
                  //                                   color: isDarkTheme
                  //                                       ? null
                  //                                       : Colors.black,
                  //                                   size: 32,
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                       Padding(
                  //                         padding: EdgeInsets.only(left: 15),
                  //                         child: Row(
                  //                           crossAxisAlignment: CrossAxisAlignment.center,
                  //                           children: [
                  //                             Padding(
                  //                               padding: EdgeInsets.only(right: 10),
                  //                               child: Container(
                  //                                 width: 96,
                  //                                 height: 96,
                  //                               ),
                  //                             ),
                  //                             SizedBox(
                  //                               width: 15,
                  //                             ),
                  //                             Container(
                  //                               width: scaffoldWidth - 142,
                  //                               child: Column(
                  //                                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                                 children: [
                  //                                   Text(
                  //                                     "Title",
                  //                                     style: TextStyle(
                  //                                       fontSize: 24,
                  //                                       fontFamily: "Flow",
                  //                                       fontWeight: FontWeight.bold,
                  //                                     ),
                  //                                   ),
                  //                                   SizedBox(
                  //                                     height: 5,
                  //                                   ),
                  //                                   Padding(
                  //                                     padding: EdgeInsets.symmetric(vertical: 8),
                  //                                     child: LinearProgressIndicator(
                  //                                       backgroundColor: Colors.transparent,
                  //                                       color: Colors.teal,
                  //                                     ),
                  //                                   ),
                  //                                   SizedBox(
                  //                                     height: 5,
                  //                                   ),
                  //                                   Text(
                  //                                     "Playlist",
                  //                                     overflow: TextOverflow.ellipsis,
                  //                                     maxLines: 1,
                  //                                     style: const TextStyle(fontSize: 20, fontFamily: 'Flow', height: 1, color: Colors.grey),
                  //                                   ),
                  //                                 ],
                  //                               ),
                  //                             )
                  //                           ],
                  //                         ),
                  //                       ),
                  //                       Padding(
                  //                         padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                  //                         child: Column(
                  //                           children: [
                  //                             Text(
                  //                               "Description",
                  //                               overflow: TextOverflow.ellipsis,
                  //                               maxLines: 1,
                  //                               style: const TextStyle(
                  //                                 fontSize: 18,
                  //                                 fontFamily: 'Flow',
                  //                                 height: 1.125,
                  //                               ),
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   );
                  //                 }),
                  //           ),
                  //           Expanded(
                  //             child: FutureBuilder(
                  //                 future: getPlaylist(playlist),
                  //                 builder: (BuildContext context, AsyncSnapshot playlist) {
                  //                   if (playlist.hasData) {
                  //                     return Expanded(
                  //                       child: ClipRRect(
                  //                         borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  //                         child: ListView.builder(
                  //                           itemCount: playlist.data["Data"].length,
                  //                           itemBuilder: (context, index) {
                  //                             return mcPlaylistTrackLine(
                  //                                 data: playlist.data["Data"][index],
                  //                                 width: scaffoldWidth / 2);
                  //                           },
                  //                         ),
                  //                       ),
                  //                     );
                  //                   }
                  //                   return LinearProgressIndicator(
                  //                     backgroundColor: Colors.transparent,
                  //                     color: Colors.teal,
                  //                   );
                  //                 }),
                  //           ),
                  //         ],
                  //       ),
                  //     ));
                }
                return SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder(
                              future: getPlaylistInfo(playlist),
                              builder: (BuildContext context, AsyncSnapshot playlistInfo) {
                                if (playlistInfo.hasData) {
                                  if (playlistInfo.data != "False") {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Padding(
                                        //   padding: EdgeInsets.only(left: 15, bottom: 15),
                                        //   child: Row(
                                        //     children: [
                                        //       GestureDetector(
                                        //         onTap: () {
                                        //           Navigator.pop(topContext);
                                        //         },
                                        //         child: Padding(
                                        //           padding: EdgeInsets.only(right: 10, top: 15),
                                        //           child: Icon(
                                        //             Icons.arrow_back_rounded,
                                        //             color: isDarkTheme
                                        //                 ? null
                                        //                 : Colors.black,
                                        //             size: 32,
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              playlistInfo.data["Playlist"]["TileFileId"] == null
                                                  ? playlistInfo.data["Playlist"]["NumRecords"] > 0
                                                  ? FutureBuilder(
                                                  future: getPlaylistAlbumArt(playlistInfo.data["Playlist"]["Id"]),
                                                  builder: (BuildContext context, AsyncSnapshot plist) {
                                                    if (plist.hasData) {
                                                      if (plist.data != "False") {
                                                        if (plist.data["Data"].length == 1) {
                                                          return Padding(
                                                            padding: EdgeInsets.only(right: 10),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(15.0),
                                                              child: CachedNetworkImage(
                                                                imageUrl:
                                                                'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                                                                width: 96, // Set the desired width
                                                                height: 96, // Set the desired height
                                                                placeholder: (context, url) => Container(color: Colors.transparent),
                                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        if (plist.data["Data"].length == 2) {
                                                          return Padding(
                                                            padding: EdgeInsets.only(right: 10),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(15.0),
                                                              child: Row(
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      CachedNetworkImage(
                                                                        imageUrl:
                                                                        'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                                                                        width: 48, // Set the desired width
                                                                        height: 48, // Set the desired height
                                                                        placeholder: (context, url) => Container(color: Colors.transparent),
                                                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                      ),
                                                                      CachedNetworkImage(
                                                                        imageUrl:
                                                                        'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][1]["Release"]["CatalogId"]}%2Fcover',
                                                                        width: 48, // Set the desired width
                                                                        height: 48, // Set the desired height
                                                                        placeholder: (context, url) => Container(color: Colors.transparent),
                                                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      CachedNetworkImage(
                                                                        imageUrl:
                                                                        'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][1]["Release"]["CatalogId"]}%2Fcover',
                                                                        width: 48, // Set the desired width
                                                                        height: 48, // Set the desired height
                                                                        placeholder: (context, url) => Container(color: Colors.transparent),
                                                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                      ),
                                                                      CachedNetworkImage(
                                                                        imageUrl:
                                                                        'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                                                                        width: 48, // Set the desired width
                                                                        height: 48, // Set the desired height
                                                                        placeholder: (context, url) => Container(color: Colors.transparent),
                                                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        if (plist.data["Data"].length == 3) {
                                                          return Padding(
                                                            padding: EdgeInsets.only(right: 10),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(15.0),
                                                              child: Row(
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      CachedNetworkImage(
                                                                        imageUrl:
                                                                        'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                                                                        width: 48, // Set the desired width
                                                                        height: 48, // Set the desired height
                                                                        placeholder: (context, url) => Container(color: Colors.transparent),
                                                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                      ),
                                                                      CachedNetworkImage(
                                                                        imageUrl:
                                                                        'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][1]["Release"]["CatalogId"]}%2Fcover',
                                                                        width: 48, // Set the desired width
                                                                        height: 48, // Set the desired height
                                                                        placeholder: (context, url) => Container(color: Colors.transparent),
                                                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      CachedNetworkImage(
                                                                        imageUrl:
                                                                        'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][2]["Release"]["CatalogId"]}%2Fcover',
                                                                        width: 48, // Set the desired width
                                                                        height: 48, // Set the desired height
                                                                        placeholder: (context, url) => Container(color: Colors.transparent),
                                                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                      ),
                                                                      CachedNetworkImage(
                                                                        imageUrl:
                                                                        'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                                                                        width: 48, // Set the desired width
                                                                        height: 48, // Set the desired height
                                                                        placeholder: (context, url) => Container(color: Colors.transparent),
                                                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        if (plist.data["Data"].length >= 4) {
                                                          return Padding(
                                                            padding: EdgeInsets.only(right: 10),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(15.0),
                                                              child: Row(
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      CachedNetworkImage(
                                                                        imageUrl:
                                                                        'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                                                                        width: 48, // Set the desired width
                                                                        height: 48, // Set the desired height
                                                                        placeholder: (context, url) => Container(color: Colors.transparent),
                                                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                      ),
                                                                      CachedNetworkImage(
                                                                        imageUrl:
                                                                        'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][1]["Release"]["CatalogId"]}%2Fcover',
                                                                        width: 48, // Set the desired width
                                                                        height: 48, // Set the desired height
                                                                        placeholder: (context, url) => Container(color: Colors.transparent),
                                                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      CachedNetworkImage(
                                                                        imageUrl:
                                                                        'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][2]["Release"]["CatalogId"]}%2Fcover',
                                                                        width: 48, // Set the desired width
                                                                        height: 48, // Set the desired height
                                                                        placeholder: (context, url) => Container(color: Colors.transparent),
                                                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                      ),
                                                                      CachedNetworkImage(
                                                                        imageUrl:
                                                                        'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][3]["Release"]["CatalogId"]}%2Fcover',
                                                                        width: 48, // Set the desired width
                                                                        height: 48, // Set the desired height
                                                                        placeholder: (context, url) => Container(color: Colors.transparent),
                                                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        }
                                                        return Padding(
                                                          padding: EdgeInsets.only(right: 10),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(15.0),
                                                            child: CachedNetworkImage(
                                                              imageUrl:
                                                              'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                                                              width: 96, // Set the desired width
                                                              height: 96, // Set the desired height
                                                              placeholder: (context, url) => Container(color: Colors.transparent),
                                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    }
                                                    return Padding(
                                                      padding: EdgeInsets.only(right: 10),
                                                      child: Container(
                                                        width: 96,
                                                        height: 96,
                                                      ),
                                                    );
                                                  })
                                                  : Padding(
                                                padding: EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 18),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                  child: !isDarkTheme
                                                      ? ColorFiltered(
                                                    colorFilter: ColorFilter.matrix([
                                                      -1, 0, 0, 0, 255, // Red channel
                                                      0, -1, 0, 0, 255, // Green channel
                                                      0, 0, -1, 0, 255, // Blue channel
                                                      0, 0, 0, 1, 0, // Alpha channel
                                                    ]),
                                                    child: Image.asset(
                                                      "assets/app_logo.png",
                                                      height: 48,
                                                      width: 48,
                                                    ),
                                                  )
                                                      : Image.asset(
                                                    "assets/app_logo.png",
                                                    height: 48,
                                                    width: 48,
                                                  ),
                                                ),
                                              )
                                                  : ClipRRect(
                                                borderRadius: BorderRadius.circular(15.0),
                                                child: CachedNetworkImage(
                                                  imageUrl: 'https://monstercat.com/api/playlist/${playlistInfo.data["Playlist"]["Id"]}/tile',
                                                  width: 96, // Set the desired width
                                                  height: 96, // Set the desired height
                                                  placeholder: (context, url) => Container(color: Colors.transparent),
                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Container(
                                                width: scaffoldWidth - 142,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      playlistInfo.data["Playlist"]["Title"],
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        fontFamily: "Comfortaa",
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    FutureBuilder(
                                                        future: getPlaylist(playlist),
                                                        builder: (BuildContext context, AsyncSnapshot playlist) {
                                                          if (playlist.hasData) {
                                                            int musLength = 0;
                                                            for (int s = 0; s < playlist.data["Data"].length; s++) {
                                                              musLength = musLength + playlist.data["Data"][s]["Duration"] as int;
                                                            }
                                                            String formatDuration(int seconds) {
                                                              String hoursString = (seconds ~/ 3600).toString().padLeft(2, '0');
                                                              String minutesString = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
                                                              String secondsString = (seconds % 60).toString().padLeft(2, '0');
                                                              return '$hoursString:$minutesString:$secondsString';
                                                            }

                                                            return Row(
                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                              children: [
                                                                Text(
                                                                  playlistInfo.data["Playlist"]["NumRecords"].toString()[playlistInfo.data["Playlist"]["NumRecords"].toString().length - 1] == "1"
                                                                      ? "${playlistInfo.data["Playlist"]["NumRecords"]} song | ${formatDuration(musLength)}"
                                                                      : "${playlistInfo.data["Playlist"]["NumRecords"]} songs | ${formatDuration(musLength)}",
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 1,
                                                                  style: const TextStyle(fontSize: 20, fontFamily: 'Comfortaa', height: 1, color: Colors.grey),
                                                                ),
                                                              ],
                                                            );
                                                          }
                                                          return Padding(
                                                            padding: EdgeInsets.symmetric(vertical: 8),
                                                            child: LinearProgressIndicator(
                                                              backgroundColor: Colors.transparent,
                                                              color: Colors.teal,
                                                            ),
                                                          );
                                                        }),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      playlistInfo.data["Playlist"]["IsPublic"]
                                                          ? playlistInfo.data["Playlist"]["UserId"] == userID
                                                          ? "Your public playlist"
                                                          : "Public playlist"
                                                          : playlistInfo.data["Playlist"]["UserId"] == userID
                                                          ? "Your private playlist"
                                                          : "Private playlist",
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: const TextStyle(fontSize: 20, fontFamily: 'Comfortaa', height: 1, color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        playlistInfo.data["Playlist"]["Description"] == ""
                                            ? Container()
                                            : Padding(
                                          padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                expandedDescription = !expandedDescription;
                                              });
                                            },
                                            child: Column(
                                              children: [
                                                Text(
                                                  playlistInfo.data["Playlist"]["Description"],
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: expandedDescription ? 10 : 1,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Comfortaa',
                                                    height: 1.125,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10, horizontal: 15
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(left:0),
                                                    child: Container(
                                                      width:38,
                                                      height:38,
                                                      child: ElevatedButton(
                                                        onPressed: () {},
                                                        child: Icon(
                                                          Icons.download_rounded,
                                                          color: isDarkTheme
                                                              ? null
                                                              : Colors.black,
                                                          size: 28,
                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.transparent,
                                                          shadowColor: Colors.transparent,
                                                          shape: CircleBorder(),
                                                          padding: EdgeInsets.zero,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  playlistInfo.data["Playlist"]["IsPublic"]
                                                      ? Padding(
                                                    padding: EdgeInsets.only(left: 5),
                                                    child: Container(
                                                      width:38,
                                                      height:38,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Share.share('https://player.monstercat.app/playlist/${playlistInfo.data["Playlist"]["Id"]}');
                                                        },
                                                        child: Icon(
                                                          Icons.share_rounded,
                                                          color: isDarkTheme
                                                              ? null
                                                              : Colors.black,
                                                          size: 28,
                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.transparent,
                                                          shadowColor: Colors.transparent,
                                                          shape: CircleBorder(),
                                                          padding: EdgeInsets.zero,
                                                        ),
                                                      ),
                                                    ),
                                                  ) : Container(),
                                                  playlistInfo.data["Playlist"]["UserId"] == userID && !playlistInfo.data["Playlist"]["MyLibrary"]
                                                      ? Padding(
                                                    padding: EdgeInsets.only(left: 5),
                                                    child: Container(
                                                      width:38,
                                                      height:38,
                                                      child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.push(
                                                            topContext,
                                                            MaterialPageRoute(
                                                                fullscreenDialog: false,
                                                                allowSnapshotting: false,
                                                                maintainState: false,
                                                                builder: (context) => editPlaylist(
                                                                  preContext: context,
                                                                  playlistID: playlistInfo.data["Playlist"]["Id"],
                                                                )
                                                            ),
                                                          );

                                                        },
                                                        child: Icon(
                                                          Icons.edit_rounded,
                                                          color: isDarkTheme
                                                              ? null
                                                              : Colors.black,
                                                          size: 28,
                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: Colors.transparent,
                                                          shadowColor: Colors.transparent,
                                                          shape: CircleBorder(),
                                                          padding: EdgeInsets.zero,
                                                        ),
                                                      ),
                                                    ),
                                                  ) : Container(),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () {},
                                                    child: Icon(
                                                      Icons.shuffle_rounded,
                                                      color: isDarkTheme
                                                          ? null
                                                          : Colors.black,
                                                      size: 28,
                                                    ),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.transparent,
                                                      shadowColor: Colors.transparent,
                                                      shape: CircleBorder(),
                                                      padding: EdgeInsets.all(0),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {},
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
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    );
                                  } else {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        left: 15,
                                      ),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.pop(topContext);
                                            },
                                            child: const Padding(
                                              padding: EdgeInsets.only(right: 10, top: 15),
                                              child: Icon(
                                                Icons.arrow_back_rounded,
                                                size: 32,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            width: scaffoldWidth - 80,
                                            child: const Padding(
                                              padding: EdgeInsets.only(left: 10, top: 15),
                                              child: Text(
                                                "Couldn't load",
                                                style: TextStyle(
                                                  fontSize: 32,
                                                  height: 1,
                                                  fontFamily: "Comfortaa",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Padding(
                                    //   padding: EdgeInsets.only(left: 15, bottom: 15),
                                    //   child: Row(
                                    //     children: [
                                    //       GestureDetector(
                                    //         onTap: () {
                                    //           Navigator.pop(topContext);
                                    //         },
                                    //         child: Padding(
                                    //           padding: EdgeInsets.only(right: 10, top: 15),
                                    //           child: Icon(
                                    //             Icons.arrow_back_rounded,
                                    //             color: isDarkTheme
                                    //                 ? null
                                    //                 : Colors.black,
                                    //             size: 32,
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 15),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Container(
                                              width: 96,
                                              height: 96,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Container(
                                            width: scaffoldWidth - 142,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Title",
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontFamily: "Flow",
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(vertical: 8),
                                                  child: LinearProgressIndicator(
                                                    backgroundColor: Colors.transparent,
                                                    color: Colors.teal,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Playlist",
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: const TextStyle(fontSize: 20, fontFamily: 'Flow', height: 1, color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                                      child: Column(
                                        children: [
                                          Text(
                                            "Description",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontFamily: 'Flow',
                                              height: 1.125,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }),
                          FutureBuilder(
                              future: getPlaylist(playlist),
                              builder: (BuildContext context, AsyncSnapshot playlist) {
                                if (playlist.hasData) {
                                  return Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                      child: ListView.builder(
                                        itemCount: playlist.data["Data"].length,
                                        itemBuilder: (context, index) {
                                          return mcPlaylistTrackLine(
                                              data: playlist.data["Data"][index],
                                              width: scaffoldWidth);
                                        },
                                      ),
                                    ),
                                  );
                                }
                                return LinearProgressIndicator(
                                  backgroundColor: Colors.transparent,
                                  color: Colors.teal,
                                );
                              }),
                        ],
                      ),
                    ));
              }
          );
        }),
      ),
    );
  }
}

class moodView extends StatefulWidget {
  final String mood;
  const moodView({super.key, required this.mood});
  @override
  moodViewState createState() => moodViewState();
}

class moodViewState extends State<moodView> {
  bool isDarkTheme = false;
  bool expandedDescription = false;
  String userID = "";
  String moodString = "";

  int totalLength = 0;

  Map<String, String> appSettings = {};

  void setMusLength(int length) {
    setState(() {
      totalLength = length;
    });
  }

  @override
  void initState() {
    getString("albumArtPreviewRes").then((value) {
      appSettings["albumArtPreviewRes"] = value;
    });
    moodString = widget.mood;
    getString("UID").then((value){
      userID = value;
    });
    super.initState();
  }


  @override
  Widget build(BuildContext topContext) {
    return MaterialApp(
      theme: ThemeData(iconTheme: const IconThemeData(color: Colors.teal)),
      darkTheme: ThemeData.dark().copyWith(cardColor: Color(0xFF202020), scaffoldBackgroundColor: const Color(0xFF040707)), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          double scaffoldHeight = constraints.maxHeight;
          double scaffoldWidth = constraints.maxWidth;
          if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
            isDarkTheme = true;
          } else {
            isDarkTheme = false;
          }
          final backgroundColor = MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Color(0xFF040707)
              : ThemeData.light().scaffoldBackgroundColor;
          final iconColor = MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark;
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: iconColor,
              systemNavigationBarColor: backgroundColor,
            ),
          );
          return OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              if (orientation == Orientation.landscape) {
                return SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: FutureBuilder(
                                future: getMoodInfo(moodString),
                                builder: (BuildContext context, AsyncSnapshot moodInfo) {
                                  if (moodInfo.hasData) {
                                    if (moodInfo.data != "False") {
                                      print(moodInfo.data);
                                      return Stack(
                                        alignment: Alignment.topCenter,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(15),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(15.0),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                'https://player.monstercat.app/api/mood/${moodInfo.data["Mood"]["Id"]}/tile',
                                                width: scaffoldHeight, // Set the desired width
                                                height: scaffoldHeight, // Set the desired height
                                                placeholder: (context, url) => Container(color: Colors.transparent),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Container(),
                                                Container(
                                                    height: scaffoldHeight,
                                                    width: scaffoldWidth / 2,
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: 15, horizontal: 15
                                                      ),
                                                      child: Row(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Container(),
                                                          Row(
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed: () {},
                                                                child: Icon(
                                                                  Icons.shuffle_rounded,
                                                                  color: isDarkTheme
                                                                      ? null
                                                                      : Colors.black,
                                                                  size: 28,
                                                                ),
                                                                style: ElevatedButton.styleFrom(
                                                                  backgroundColor: Colors.transparent,
                                                                  shadowColor: Colors.transparent,
                                                                  shape: CircleBorder(),
                                                                  padding: EdgeInsets.all(0),
                                                                ),
                                                              ),
                                                              ElevatedButton(
                                                                onPressed: () {},
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
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 30, top: 15),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.pop(topContext);
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(right: 10, top: 15),
                                                    child: Icon(
                                                      Icons.arrow_back_rounded,
                                                      color: isDarkTheme
                                                          ? null
                                                          : Colors.black,
                                                      size: 32,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(right: 30, top: 15),
                                                  child: Text(
                                                    moodInfo.data["Mood"]["Name"].toString(),
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontFamily: "Comfortaa",
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Container()
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                          left: 15,
                                        ),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(topContext);
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.only(right: 10, top: 15),
                                                child: Icon(
                                                  Icons.arrow_back_rounded,
                                                  size: 32,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: scaffoldWidth - 80,
                                              child: const Padding(
                                                padding: EdgeInsets.only(left: 10, top: 15),
                                                child: Text(
                                                  "Couldn't load",
                                                  style: TextStyle(
                                                    fontSize: 32,
                                                    height: 1,
                                                    fontFamily: "Comfortaa",
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 15, bottom: 15),
                                        child: Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(topContext);
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(right: 10, top: 15),
                                                child: Icon(
                                                  Icons.arrow_back_rounded,
                                                  color: isDarkTheme
                                                      ? null
                                                      : Colors.black,
                                                  size: 32,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(right: 10),
                                              child: Container(
                                                width: 96,
                                                height: 96,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Container(
                                              width: scaffoldWidth - 142,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Title",
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontFamily: "Flow",
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 8),
                                                    child: LinearProgressIndicator(
                                                      backgroundColor: Colors.transparent,
                                                      color: Colors.teal,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    "Playlist",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: const TextStyle(fontSize: 20, fontFamily: 'Flow', height: 1, color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                                        child: Column(
                                          children: [
                                            Text(
                                              "Description",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontFamily: 'Flow',
                                                height: 1.125,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                          Expanded(
                            child: FutureBuilder(
                                future: getMood(moodString),
                                builder: (BuildContext context, AsyncSnapshot mood) {
                                  if (mood.hasData) {
                                    print(mood.data);
                                    return Expanded(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                        child: ListView.builder(
                                          itemCount: mood.data["Data"].length,
                                          itemBuilder: (context, index) {
                                            return mcPlaylistTrackLine(
                                                data: mood.data["Data"][index],
                                                width: scaffoldWidth / 2
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  }
                                  return LinearProgressIndicator(
                                    backgroundColor: Colors.transparent,
                                    color: Colors.teal,
                                  );
                                }),
                          ),
                        ],
                      ),
                    ));
              }
              return SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                            future: getMoodInfo(moodString),
                            builder: (BuildContext context, AsyncSnapshot moodInfo) {
                              if (moodInfo.hasData) {
                                if (moodInfo.data != "False") {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Padding(
                                      //   padding: EdgeInsets.only(left: 15, bottom: 15),
                                      //   child: Row(
                                      //     crossAxisAlignment: CrossAxisAlignment.center,
                                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //     children: [
                                      //       GestureDetector(
                                      //         onTap: () {
                                      //           Navigator.pop(topContext);
                                      //         },
                                      //         child: Padding(
                                      //           padding: EdgeInsets.only(right: 10, top: 15),
                                      //           child: Icon(
                                      //             Icons.arrow_back_rounded,
                                      //             color: isDarkTheme
                                      //                 ? null
                                      //                 : Colors.black,
                                      //             size: 32,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //
                                      //       Container()
                                      //     ],
                                      //   ),
                                      // ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(right: 0),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(15.0),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                  'https://player.monstercat.app/api/mood/${moodInfo.data["Mood"]["Id"]}/tile',
                                                  width: 96, // Set the desired width
                                                  height: 96, // Set the desired height
                                                  placeholder: (context, url) => Container(color: Colors.transparent),
                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15,
                                            ),
                                            Container(
                                              width: scaffoldWidth - 142,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(right: 0, top: 0),
                                                    child: Text(
                                                      moodInfo.data["Mood"]["Name"],
                                                      style: TextStyle(
                                                        fontSize: 24,
                                                        fontFamily: "Comfortaa",
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 0, horizontal: 15
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [

                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            ElevatedButton(
                                                              onPressed: () {},
                                                              child: Icon(
                                                                Icons.shuffle_rounded,
                                                                color: isDarkTheme
                                                                    ? null
                                                                    : Colors.black,
                                                                size: 28,
                                                              ),
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor: Colors.transparent,
                                                                shadowColor: Colors.transparent,
                                                                shape: CircleBorder(),
                                                                padding: EdgeInsets.all(0),
                                                              ),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () {},
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
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: 15,
                                    ),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(topContext);
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.only(right: 10, top: 15),
                                            child: Icon(
                                              Icons.arrow_back_rounded,
                                              size: 32,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: scaffoldWidth - 80,
                                          child: const Padding(
                                            padding: EdgeInsets.only(left: 10, top: 15),
                                            child: Text(
                                              "Couldn't load",
                                              style: TextStyle(
                                                fontSize: 32,
                                                height: 1,
                                                fontFamily: "Comfortaa",
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Padding(
                                  //   padding: EdgeInsets.only(left: 15, bottom: 15),
                                  //   child: Row(
                                  //     children: [
                                  //       GestureDetector(
                                  //         onTap: () {
                                  //           Navigator.pop(topContext);
                                  //         },
                                  //         child: Padding(
                                  //           padding: EdgeInsets.only(right: 10, top: 15),
                                  //           child: Icon(
                                  //             Icons.arrow_back_rounded,
                                  //             color: isDarkTheme
                                  //                 ? null
                                  //                 : Colors.black,
                                  //             size: 32,
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Container(
                                            width: 96,
                                            height: 96,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Container(
                                          width: scaffoldWidth - 142,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Title",
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontFamily: "Flow",
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(vertical: 8),
                                                child: LinearProgressIndicator(
                                                  backgroundColor: Colors.transparent,
                                                  color: Colors.teal,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Playlist",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(fontSize: 20, fontFamily: 'Flow', height: 1, color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Description",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Flow',
                                            height: 1.125,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                        FutureBuilder(
                            future: getMood(moodString),
                            builder: (BuildContext context, AsyncSnapshot mood) {
                              if (mood.hasData) {
                                return Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                    child: ListView.builder(
                                      itemCount: mood.data["Data"].length,
                                      itemBuilder: (context, index) {
                                        return mcPlaylistTrackLine(
                                            data: mood.data["Data"][index],
                                            width: scaffoldWidth
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }
                              return LinearProgressIndicator(
                                backgroundColor: Colors.transparent,
                                color: Colors.teal,
                              );
                            }),
                      ],
                    ),
                  ));
            }
          );
        }),
      ),
    );
  }
}

class albumView extends StatefulWidget {
  final String release;
  const albumView({super.key, required this.release});
  @override
  albumViewState createState() => albumViewState();
}

class albumViewState extends State<albumView> {
  bool isDarkTheme = false;
  bool infoExpanded = false;

  String userID = "";
  String release = "";

  int totalLength = 0;

  Map<String, String> appSettings = {};

  void setMusLength(int length) {
    setState(() {
      totalLength = length;
    });
  }

  @override
  void initState() {
    // getString("albumArtPreviewRes").then((value) {
    //   appSettings["albumArtPreviewRes"] = value;
    // });
    release = widget.release;
    getString("UID").then((value){
      userID = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext topContext) {
    return MaterialApp(
      theme: ThemeData(iconTheme: const IconThemeData(color: Colors.teal)),
      darkTheme: ThemeData.dark().copyWith(cardColor: Color(0xFF202020), scaffoldBackgroundColor: const Color(0xFF040707)), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          double scaffoldHeight = constraints.maxHeight;
          double scaffoldWidth = constraints.maxWidth;
          if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
            isDarkTheme = true;
          } else {
            isDarkTheme = false;
          }
          final backgroundColor = MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Color(0xFF040707)
              : ThemeData.light().scaffoldBackgroundColor;
          final iconColor = MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark;
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: iconColor,
              systemNavigationBarColor: backgroundColor,
            ),
          );
          return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: FutureBuilder(
                    future: getRelease(release),
                    builder: (BuildContext context, AsyncSnapshot release) {
                      if (release.hasData) {
                        if (release.data != "False") {
                          Map musList = {};
                          for (int s = 0; s < release.data["Tracks"].length; s++) {
                            final int tnum = release.data["Tracks"][s]["TrackNumber"] - 1;
                            musList[tnum] = release.data["Tracks"][s];
                          }
                          int musLength = 0;
                          for (int s = 0; s < release.data["Tracks"].length; s++) {
                            musLength = musLength + release.data["Tracks"][s]["Duration"] as int;
                          }
                          String formatDuration(int seconds) {
                            String hoursString = (seconds ~/ 3600).toString().padLeft(2, '0');
                            String minutesString = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
                            String secondsString = (seconds % 60).toString().padLeft(2, '0');
                            return '$hoursString:$minutesString:$secondsString';
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Padding(
                              //   padding: EdgeInsets.only(left: 15, bottom: 15),
                              //   child: Row(
                              //     crossAxisAlignment: CrossAxisAlignment.center,
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       GestureDetector(
                              //         onTap: () {
                              //           Navigator.pop(topContext);
                              //         },
                              //         child: Padding(
                              //           padding: EdgeInsets.only(right: 10, top: 15),
                              //           child: Icon(
                              //             Icons.arrow_left,
                              //             color: isDarkTheme
                              //                 ? null
                              //                 : Colors.black,
                              //             size: 32,
                              //           ),
                              //         ),
                              //       ),
                              //       Container()
                              //     ],
                              //   ),
                              // ),
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(right: 10),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15.0),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                          'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https://www.monstercat.com/release/${release.data["Release"]["CatalogId"]}/cover',
                                          width: 96, // Set the desired width
                                          height: 96, // Set the desired height
                                          placeholder: (context, url) => Container(color: Colors.transparent),
                                          errorWidget: (context, url, error) => const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: scaffoldWidth - 130,
                                          child: Text(
                                            release.data["Release"]["Title"],
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontFamily: "Comfortaa",
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: scaffoldWidth - 130,
                                          child: Text(
                                            "${release.data["Release"]["Type"]} by ${release.data["Release"]["ArtistsTitle"]}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: const TextStyle(fontSize: 20, fontFamily: 'Comfortaa', height: 1.25, color: Colors.grey),
                                          ),
                                        ),
                                        Text(
                                          release.data["Tracks"].length == 1
                                              ? "${release.data["Tracks"].length} song | ${formatDuration(musLength)}"
                                              : "${release.data["Tracks"].length} songs | ${formatDuration(musLength)}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(fontSize: 20, fontFamily: 'Comfortaa', height: 1.25, color: Colors.grey),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15
                                ),
                                child: GestureDetector(
                                  onTap:(){
                                    setState(() {
                                      infoExpanded = !infoExpanded;
                                    });
                                  },
                                  child: infoExpanded
                                      ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Released: ${DateFormat('MMMM d, y').format(DateTime.parse(release.data["Release"]["ReleaseDate"]))}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(fontSize: 20, fontFamily: 'Comfortaa', height: 1.25, color: Colors.grey),
                                      ),
                                      Text(
                                        "Genre: ${release.data["Release"]["GenrePrimary"]}/${release.data["Release"]["GenreSecondary"]}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(fontSize: 20, fontFamily: 'Comfortaa', height: 1.25, color: Colors.grey),
                                      ),
                                      Text(
                                        "Brand: ${release.data["Release"]["BrandTitle"]}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(fontSize: 20, fontFamily: 'Comfortaa', height: 1.25, color: Colors.grey),
                                      ),
                                    ],
                                  )
                                      : Text(
                                    "Show more info",
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 20, fontFamily: 'Comfortaa', height: 1.25, color: Colors.grey),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left:0),
                                          child: Container(
                                            width:38,
                                            height:38,
                                            child: ElevatedButton(
                                              onPressed: () {},
                                              child: Icon(
                                                Icons.download_rounded,
                                                color: isDarkTheme
                                                    ? null
                                                    : Colors.black,
                                                size: 28,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.transparent,
                                                shadowColor: Colors.transparent,
                                                shape: CircleBorder(),
                                                padding: EdgeInsets.zero,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Container(
                                            width:38,
                                            height:38,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Share.share('https://player.monstercat.app/release/${release.data["Release"]["CatalogId"]}');
                                              },
                                              child: Icon(
                                                Icons.share_rounded,
                                                color: isDarkTheme
                                                    ? null
                                                    : Colors.black,
                                                size: 28,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.transparent,
                                                shadowColor: Colors.transparent,
                                                shape: CircleBorder(),
                                                padding: EdgeInsets.zero,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Provider.of<musicPlayer>(context, listen: false).playQueue(release.data["Tracks"]);
                                          },
                                          child: Icon(
                                            Icons.shuffle_rounded,
                                            color: isDarkTheme
                                                ? null
                                                : Colors.black,
                                            size: 28,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            shape: CircleBorder(),
                                            padding: EdgeInsets.all(0),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Map musList = {};
                                            List musListPass = [];
                                            for (int s = 0; s < release.data["Tracks"].length; s++) {
                                              final int tnum = release.data["Tracks"][s]["TrackNumber"] - 1;
                                              musList[tnum] = release.data["Tracks"][s];
                                            }
                                            for(int g = 0; g < musList.length; g++){
                                              musListPass.add(musList[g]);
                                            }
                                            Provider.of<musicPlayer>(context, listen: false).queueData = release.data["Release"];
                                            Provider.of<musicPlayer>(context, listen: false).playQueue(musListPass);
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
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                  child: ListView.builder(
                                    itemCount: musList.length,
                                    itemBuilder: (context, index) {
                                      return mcAlbumTrackLine(
                                          data: musList[index],
                                          width: scaffoldWidth
                                      );
                                    },
                                  ),
                                ),
                              )


                            ],
                          );
                        } else {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: 15,
                            ),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(topContext);
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 10, top: 15),
                                    child: Icon(
                                      Icons.arrow_back_rounded,
                                      size: 32,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: scaffoldWidth - 80,
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 10, top: 15),
                                    child: Text(
                                      "Couldn't load",
                                      style: TextStyle(
                                        fontSize: 32,
                                        height: 1,
                                        fontFamily: "Comfortaa",
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Padding(
                          //   padding: EdgeInsets.only(left: 15, bottom: 15),
                          //   child: Row(
                          //     children: [
                          //       GestureDetector(
                          //         onTap: () {
                          //           Navigator.pop(topContext);
                          //         },
                          //         child: Padding(
                          //           padding: EdgeInsets.only(right: 10, top: 15),
                          //           child: Icon(
                          //             Icons.arrow_back_rounded,
                          //             color: isDarkTheme
                          //                 ? null
                          //                 : Colors.black,
                          //             size: 32,
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Container(
                                    width: 96,
                                    height: 96,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Container(
                                  width: scaffoldWidth - 142,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Title",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontFamily: "Flow",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(vertical: 8),
                                        child: LinearProgressIndicator(
                                          backgroundColor: Colors.transparent,
                                          color: Colors.teal,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Playlist",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(fontSize: 20, fontFamily: 'Flow', height: 1, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                            child: Column(
                              children: [
                                Text(
                                  "Description",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontFamily: 'Flow',
                                    height: 1.125,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }),
              ));
          // return OrientationBuilder(
          //   builder: (BuildContext context, Orientation orientation) {
          //     if (orientation == Orientation.portrait) {
          //       return SafeArea(
          //           child: Padding(
          //             padding: EdgeInsets.symmetric(horizontal: 0),
          //             child: FutureBuilder(
          //                 future: getRelease(release),
          //                 builder: (BuildContext context, AsyncSnapshot release) {
          //                   if (release.hasData) {
          //                     if (release.data != "False") {
          //                       Map musList = {};
          //                       for (int s = 0; s < release.data["Tracks"].length; s++) {
          //                         final int tnum = release.data["Tracks"][s]["TrackNumber"] - 1;
          //                         musList[tnum] = release.data["Tracks"][s];
          //                       }
          //                       int musLength = 0;
          //                       for (int s = 0; s < release.data["Tracks"].length; s++) {
          //                         musLength = musLength + release.data["Tracks"][s]["Duration"] as int;
          //                       }
          //                       String formatDuration(int seconds) {
          //                         String hoursString = (seconds ~/ 3600).toString().padLeft(2, '0');
          //                         String minutesString = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
          //                         String secondsString = (seconds % 60).toString().padLeft(2, '0');
          //                         return '$hoursString:$minutesString:$secondsString';
          //                       }
          //                       return Column(
          //                         crossAxisAlignment: CrossAxisAlignment.start,
          //                         children: [
          //                           Padding(
          //                             padding: EdgeInsets.only(left: 15, bottom: 15),
          //                             child: Row(
          //                               crossAxisAlignment: CrossAxisAlignment.center,
          //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                               children: [
          //                                 GestureDetector(
          //                                   onTap: () {
          //                                     Navigator.pop(topContext);
          //                                   },
          //                                   child: Padding(
          //                                     padding: EdgeInsets.only(right: 10, top: 15),
          //                                     child: Icon(
          //                                       Icons.arrow_back_rounded,
          //                                       color: isDarkTheme
          //                                           ? null
          //                                           : Colors.black,
          //                                       size: 32,
          //                                     ),
          //                                   ),
          //                                 ),
          //                                 Container()
          //                               ],
          //                             ),
          //                           ),
          //                           Padding(
          //                             padding: EdgeInsets.only(left: 15),
          //                             child: Row(
          //                               crossAxisAlignment: CrossAxisAlignment.center,
          //                               children: [
          //                                 Padding(
          //                                   padding: EdgeInsets.only(right: 10),
          //                                   child: ClipRRect(
          //                                     borderRadius: BorderRadius.circular(15.0),
          //                                     child: CachedNetworkImage(
          //                                       imageUrl:
          //                                       'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https://www.monstercat.com/release/${release.data["Release"]["CatalogId"]}/cover',
          //                                       width: 96, // Set the desired width
          //                                       height: 96, // Set the desired height
          //                                       placeholder: (context, url) => Container(color: Colors.transparent),
          //                                       errorWidget: (context, url, error) => const Icon(Icons.error),
          //                                     ),
          //                                   ),
          //                                 ),
          //                                 SizedBox(
          //                                   width: 5,
          //                                 ),
          //                                 Column(
          //                                   crossAxisAlignment: CrossAxisAlignment.start,
          //                                   children: [
          //                                     Container(
          //                                       width: scaffoldWidth - 130,
          //                                       child: Text(
          //                                         release.data["Release"]["Title"],
          //                                         style: TextStyle(
          //                                           fontSize: 22,
          //                                           fontFamily: "Comfortaa",
          //                                           fontWeight: FontWeight.bold,
          //                                         ),
          //                                       ),
          //                                     ),
          //                                     Container(
          //                                       width: scaffoldWidth - 130,
          //                                       child: Text(
          //                                         "${release.data["Release"]["Type"]} by ${release.data["Release"]["ArtistsTitle"]}",
          //                                         overflow: TextOverflow.ellipsis,
          //                                         maxLines: 2,
          //                                         style: const TextStyle(fontSize: 20, fontFamily: 'Comfortaa', height: 1.25, color: Colors.grey),
          //                                       ),
          //                                     ),
          //                                     Text(
          //                                       release.data["Tracks"].length == 1
          //                                           ? "${release.data["Tracks"].length} song | ${formatDuration(musLength)}"
          //                                           : "${release.data["Tracks"].length} songs | ${formatDuration(musLength)}",
          //                                       overflow: TextOverflow.ellipsis,
          //                                       maxLines: 1,
          //                                       style: const TextStyle(fontSize: 20, fontFamily: 'Comfortaa', height: 1.25, color: Colors.grey),
          //                                     ),
          //                                   ],
          //                                 )
          //                               ],
          //                             ),
          //                           ),
          //                           Padding(
          //                             padding: EdgeInsets.symmetric(
          //                                 vertical: 10, horizontal: 15
          //                             ),
          //                             child: GestureDetector(
          //                               onTap:(){
          //                                 setState(() {
          //                                   infoExpanded = !infoExpanded;
          //                                 });
          //                               },
          //                               child: infoExpanded
          //                                   ? Column(
          //                                 crossAxisAlignment: CrossAxisAlignment.start,
          //                                 children: [
          //                                   Text(
          //                                     "Released: ${DateFormat('MMMM d, y').format(DateTime.parse(release.data["Release"]["ReleaseDate"]))}",
          //                                     overflow: TextOverflow.ellipsis,
          //                                     maxLines: 1,
          //                                     style: const TextStyle(fontSize: 20, fontFamily: 'Comfortaa', height: 1.25, color: Colors.grey),
          //                                   ),
          //                                   Text(
          //                                     "Genre: ${release.data["Release"]["GenrePrimary"]}/${release.data["Release"]["GenreSecondary"]}",
          //                                     overflow: TextOverflow.ellipsis,
          //                                     maxLines: 1,
          //                                     style: const TextStyle(fontSize: 20, fontFamily: 'Comfortaa', height: 1.25, color: Colors.grey),
          //                                   ),
          //                                   Text(
          //                                     "Brand: ${release.data["Release"]["BrandTitle"]}",
          //                                     overflow: TextOverflow.ellipsis,
          //                                     maxLines: 1,
          //                                     style: const TextStyle(fontSize: 20, fontFamily: 'Comfortaa', height: 1.25, color: Colors.grey),
          //                                   ),
          //                                 ],
          //                               )
          //                                   : Text(
          //                                 "Show more info",
          //                                 maxLines: 1,
          //                                 style: const TextStyle(fontSize: 20, fontFamily: 'Comfortaa', height: 1.25, color: Colors.grey),
          //                               ),
          //                             ),
          //                           ),
          //                           Padding(
          //                             padding: EdgeInsets.symmetric(
          //                                 vertical: 0, horizontal: 15
          //                             ),
          //                             child: Row(
          //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                               children: [
          //                                 Row(
          //                                   mainAxisAlignment: MainAxisAlignment.start,
          //                                   children: [
          //                                     Padding(
          //                                       padding: EdgeInsets.only(left:0),
          //                                       child: Container(
          //                                         width:38,
          //                                         height:38,
          //                                         child: ElevatedButton(
          //                                           onPressed: () {},
          //                                           child: Icon(
          //                                             Icons.download_rounded,
          //                                             color: isDarkTheme
          //                                                 ? null
          //                                                 : Colors.black,
          //                                             size: 28,
          //                                           ),
          //                                           style: ElevatedButton.styleFrom(
          //                                             backgroundColor: Colors.transparent,
          //                                             shadowColor: Colors.transparent,
          //                                             shape: CircleBorder(),
          //                                             padding: EdgeInsets.zero,
          //                                           ),
          //                                         ),
          //                                       ),
          //                                     ),
          //                                     Padding(
          //                                       padding: EdgeInsets.only(left: 5),
          //                                       child: Container(
          //                                         width:38,
          //                                         height:38,
          //                                         child: ElevatedButton(
          //                                           onPressed: () {
          //                                             Share.share('https://player.monstercat.app/release/${release.data["Release"]["CatalogId"]}');
          //                                           },
          //                                           child: Icon(
          //                                             Icons.share_rounded,
          //                                             color: isDarkTheme
          //                                                 ? null
          //                                                 : Colors.black,
          //                                             size: 28,
          //                                           ),
          //                                           style: ElevatedButton.styleFrom(
          //                                             backgroundColor: Colors.transparent,
          //                                             shadowColor: Colors.transparent,
          //                                             shape: CircleBorder(),
          //                                             padding: EdgeInsets.zero,
          //                                           ),
          //                                         ),
          //                                       ),
          //                                     ),
          //                                   ],
          //                                 ),
          //                                 Row(
          //                                   children: [
          //                                     ElevatedButton(
          //                                       onPressed: () {
          //                                         Provider.of<musicPlayer>(context, listen: false).playQueue(release.data["Tracks"]);
          //                                       },
          //                                       child: Icon(
          //                                         Icons.shuffle_rounded,
          //                                         color: isDarkTheme
          //                                             ? null
          //                                             : Colors.black,
          //                                         size: 28,
          //                                       ),
          //                                       style: ElevatedButton.styleFrom(
          //                                         backgroundColor: Colors.transparent,
          //                                         shadowColor: Colors.transparent,
          //                                         shape: CircleBorder(),
          //                                         padding: EdgeInsets.all(0),
          //                                       ),
          //                                     ),
          //                                     ElevatedButton(
          //                                       onPressed: () {
          //                                         Map musList = {};
          //                                         List musListPass = [];
          //                                         for (int s = 0; s < release.data["Tracks"].length; s++) {
          //                                           final int tnum = release.data["Tracks"][s]["TrackNumber"] - 1;
          //                                           musList[tnum] = release.data["Tracks"][s];
          //                                         }
          //                                         for(int g = 0; g < musList.length; g++){
          //                                           musListPass.add(musList[g]);
          //                                         }
          //                                         Provider.of<musicPlayer>(context, listen: false).queueData = release.data["Release"];
          //                                         Provider.of<musicPlayer>(context, listen: false).playQueue(musListPass);
          //                                       },
          //                                       child: Icon(
          //                                         Icons.play_arrow_rounded,
          //                                         size: 32,
          //                                       ),
          //                                       style: ElevatedButton.styleFrom(
          //                                         backgroundColor: Colors.teal,
          //                                         shadowColor: Colors.transparent,
          //                                         shape: CircleBorder(),
          //                                         padding: EdgeInsets.all(10),
          //                                       ),
          //                                     )
          //                                   ],
          //                                 )
          //                               ],
          //                             ),
          //                           ),
          //                           Expanded(
          //                             child: ClipRRect(
          //                               borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          //                               child: ListView.builder(
          //                                 itemCount: musList.length,
          //                                 itemBuilder: (context, index) {
          //                                   return mcAlbumTrackLine(
          //                                       data: musList[index],
          //                                       width: scaffoldWidth
          //                                   );
          //                                 },
          //                               ),
          //                             ),
          //                           )
          //
          //
          //                         ],
          //                       );
          //                     } else {
          //                       return Padding(
          //                         padding: EdgeInsets.only(
          //                           left: 15,
          //                         ),
          //                         child: Row(
          //                           children: [
          //                             GestureDetector(
          //                               onTap: () {
          //                                 Navigator.pop(topContext);
          //                               },
          //                               child: const Padding(
          //                                 padding: EdgeInsets.only(right: 10, top: 15),
          //                                 child: Icon(
          //                                   Icons.arrow_back_rounded,
          //                                   size: 32,
          //                                 ),
          //                               ),
          //                             ),
          //                             Container(
          //                               width: scaffoldWidth - 80,
          //                               child: const Padding(
          //                                 padding: EdgeInsets.only(left: 10, top: 15),
          //                                 child: Text(
          //                                   "Couldn't load",
          //                                   style: TextStyle(
          //                                     fontSize: 32,
          //                                     height: 1,
          //                                     fontFamily: "Comfortaa",
          //                                     fontWeight: FontWeight.bold,
          //                                   ),
          //                                 ),
          //                               ),
          //                             )
          //                           ],
          //                         ),
          //                       );
          //                     }
          //                   }
          //                   return Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Padding(
          //                         padding: EdgeInsets.only(left: 15, bottom: 15),
          //                         child: Row(
          //                           children: [
          //                             GestureDetector(
          //                               onTap: () {
          //                                 Navigator.pop(topContext);
          //                               },
          //                               child: Padding(
          //                                 padding: EdgeInsets.only(right: 10, top: 15),
          //                                 child: Icon(
          //                                   Icons.arrow_back_rounded,
          //                                   color: isDarkTheme
          //                                       ? null
          //                                       : Colors.black,
          //                                   size: 32,
          //                                 ),
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                       Padding(
          //                         padding: EdgeInsets.only(left: 15),
          //                         child: Row(
          //                           crossAxisAlignment: CrossAxisAlignment.center,
          //                           children: [
          //                             Padding(
          //                               padding: EdgeInsets.only(right: 10),
          //                               child: Container(
          //                                 width: 96,
          //                                 height: 96,
          //                               ),
          //                             ),
          //                             SizedBox(
          //                               width: 15,
          //                             ),
          //                             Container(
          //                               width: scaffoldWidth - 142,
          //                               child: Column(
          //                                 crossAxisAlignment: CrossAxisAlignment.start,
          //                                 children: [
          //                                   Text(
          //                                     "Title",
          //                                     style: TextStyle(
          //                                       fontSize: 24,
          //                                       fontFamily: "Flow",
          //                                       fontWeight: FontWeight.bold,
          //                                     ),
          //                                   ),
          //                                   SizedBox(
          //                                     height: 5,
          //                                   ),
          //                                   Padding(
          //                                     padding: EdgeInsets.symmetric(vertical: 8),
          //                                     child: LinearProgressIndicator(
          //                                       backgroundColor: Colors.transparent,
          //                                       color: Colors.teal,
          //                                     ),
          //                                   ),
          //                                   SizedBox(
          //                                     height: 5,
          //                                   ),
          //                                   Text(
          //                                     "Playlist",
          //                                     overflow: TextOverflow.ellipsis,
          //                                     maxLines: 1,
          //                                     style: const TextStyle(fontSize: 20, fontFamily: 'Flow', height: 1, color: Colors.grey),
          //                                   ),
          //                                 ],
          //                               ),
          //                             )
          //                           ],
          //                         ),
          //                       ),
          //                       Padding(
          //                         padding: EdgeInsets.only(top: 10, left: 15, right: 15),
          //                         child: Column(
          //                           children: [
          //                             Text(
          //                               "Description",
          //                               overflow: TextOverflow.ellipsis,
          //                               maxLines: 1,
          //                               style: const TextStyle(
          //                                 fontSize: 18,
          //                                 fontFamily: 'Flow',
          //                                 height: 1.125,
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     ],
          //                   );
          //                 }),
          //           ));
          //     }
          //     return SafeArea(
          //         child: Padding(
          //           padding: EdgeInsets.symmetric(horizontal: 0),
          //           child: FutureBuilder(
          //               future: getRelease(release),
          //               builder: (BuildContext context, AsyncSnapshot release) {
          //                 if (release.hasData) {
          //                   if (release.data != "False") {
          //                     Map musList = {};
          //                     for (int s = 0; s < release.data["Tracks"].length; s++) {
          //                       final int tnum = release.data["Tracks"][s]["TrackNumber"] - 1;
          //                       musList[tnum] = release.data["Tracks"][s];
          //                     }
          //                     int musLength = 0;
          //                     for (int s = 0; s < release.data["Tracks"].length; s++) {
          //                       musLength = musLength + release.data["Tracks"][s]["Duration"] as int;
          //                     }
          //                     String formatDuration(int seconds) {
          //                       String hoursString = (seconds ~/ 3600).toString().padLeft(2, '0');
          //                       String minutesString = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
          //                       String secondsString = (seconds % 60).toString().padLeft(2, '0');
          //                       return '$hoursString:$minutesString:$secondsString';
          //                     }
          //                     return Row(
          //                       children: [
          //                         Expanded(
          //                             child: Column(
          //                               crossAxisAlignment: CrossAxisAlignment.start,
          //                               children: [
          //                                 Stack(
          //                                     children: [
          //                                       Stack(
          //                                         children: [
          //                                           Row(
          //                                             mainAxisAlignment: MainAxisAlignment.center,
          //                                             children: [
          //                                               Padding(
          //                                                 padding: EdgeInsets.all(15),
          //                                                 child: ClipRRect(
          //                                                   borderRadius: BorderRadius.circular(15.0),
          //                                                   child: LayoutBuilder(
          //                                                       builder: (BuildContext context, BoxConstraints constraintsS) {
          //                                                         double scaffoldHeight = constraints.maxHeight;
          //                                                         double scaffoldWidth = constraints.maxWidth;
          //                                                         double ratio = scaffoldWidth / scaffoldHeight;
          //                                                         if(ratio < 2){
          //                                                           return CachedNetworkImage(
          //                                                             imageUrl:
          //                                                             'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "1024"}&encoding=webp&url=https://www.monstercat.com/release/${release.data["Release"]["CatalogId"]}/cover',
          //                                                             width: ((scaffoldWidth / 2) - 30),
          //                                                             height: ((scaffoldWidth / 2) - 30), // Set the desired height
          //                                                             placeholder: (context, url) => Container(color: Colors.transparent),
          //                                                             errorWidget: (context, url, error) => const Icon(Icons.error),
          //                                                           );
          //                                                         }else if(ratio < 4){
          //                                                           return CachedNetworkImage(
          //                                                             imageUrl:
          //                                                             'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "1024"}&encoding=webp&url=https://www.monstercat.com/release/${release.data["Release"]["CatalogId"]}/cover',
          //                                                             width: ((scaffoldHeight / 1.5) - 30),
          //                                                             height: ((scaffoldHeight / 1.5) - 30), // Set the desired height
          //                                                             placeholder: (context, url) => Container(color: Colors.transparent),
          //                                                             errorWidget: (context, url, error) => const Icon(Icons.error),
          //                                                           );
          //                                                         }
          //                                                         return CachedNetworkImage(
          //                                                           imageUrl:
          //                                                           'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "1024"}&encoding=webp&url=https://www.monstercat.com/release/${release.data["Release"]["CatalogId"]}/cover',
          //                                                           width: (scaffoldHeight / 2),
          //                                                           height: (scaffoldHeight / 2), // Set the desired height
          //                                                           placeholder: (context, url) => Container(color: Colors.transparent),
          //                                                           errorWidget: (context, url, error) => const Icon(Icons.error),
          //                                                         );
          //                                                       }
          //                                                   ),
          //                                                 ),
          //                                               )
          //                                             ],
          //                                           ),
          //                                           Padding(
          //                                             padding: EdgeInsets.only(left: 30, top: 15),
          //                                             child: Row(
          //                                               crossAxisAlignment: CrossAxisAlignment.center,
          //                                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                                               children: [
          //                                                 GestureDetector(
          //                                                   onTap: () {
          //                                                     Navigator.pop(topContext);
          //                                                   },
          //                                                   child: Padding(
          //                                                     padding: EdgeInsets.only(right: 10, top: 15),
          //                                                     child: Icon(
          //                                                       Icons.arrow_back_rounded,
          //                                                       color: isDarkTheme
          //                                                           ? null
          //                                                           : Colors.black,
          //                                                       size: 32,
          //                                                     ),
          //                                                   ),
          //                                                 ),
          //                                                 Container()
          //                                               ],
          //                                             ),
          //                                           ),
          //                                         ],
          //                                       ),
          //                                       Container(
          //                                         height: scaffoldHeight - 30,
          //                                           child: Column(
          //                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                                             children: [
          //                                               Container(),
          //                                               Column(
          //                                                 children: [
          //                                                   Padding(
          //                                                     padding: EdgeInsets.only(left: 15),
          //                                                     child: Row(
          //                                                       crossAxisAlignment: CrossAxisAlignment.center,
          //                                                       children: [
          //                                                         Column(
          //                                                           crossAxisAlignment: CrossAxisAlignment.start,
          //                                                           children: [
          //                                                             Container(
          //                                                               width: scaffoldWidth / 2 - 130,
          //                                                               child: Text(
          //                                                                 release.data["Release"]["Title"],
          //                                                                 style: TextStyle(
          //                                                                   backgroundColor: backgroundColor,
          //                                                                   fontSize: 22,
          //                                                                   fontFamily: "Comfortaa",
          //                                                                   fontWeight: FontWeight.bold,
          //                                                                 ),
          //                                                               ),
          //                                                             ),
          //                                                             Container(
          //                                                               width: scaffoldWidth / 2 - 130,
          //                                                               child: Text(
          //                                                                 "${release.data["Release"]["Type"]} by ${release.data["Release"]["ArtistsTitle"]}",
          //                                                                 overflow: TextOverflow.ellipsis,
          //                                                                 maxLines: 2,
          //                                                                 style: TextStyle(
          //                                                                     backgroundColor: backgroundColor, fontSize: 20, fontFamily: 'Comfortaa', height: 1.25, color: Colors.grey),
          //                                                               ),
          //                                                             ),
          //                                                             Text(
          //                                                               release.data["Tracks"].length == 1
          //                                                                   ? "${release.data["Tracks"].length} song | ${formatDuration(musLength)}"
          //                                                                   : "${release.data["Tracks"].length} songs | ${formatDuration(musLength)}",
          //                                                               overflow: TextOverflow.ellipsis,
          //                                                               maxLines: 1,
          //                                                               style: TextStyle(
          //                                                                   backgroundColor: backgroundColor,
          //                                                                   fontSize: 20,
          //                                                                   fontFamily: 'Comfortaa',
          //                                                                   height: 1.25,
          //                                                                   color: Colors.grey),
          //                                                             ),
          //                                                           ],
          //                                                         )
          //                                                       ],
          //                                                     ),
          //                                                   ),
          //                                                   Padding(
          //                                                     padding: EdgeInsets.symmetric(
          //                                                         vertical: 0, horizontal: 15
          //                                                     ),
          //                                                     child: Row(
          //                                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                                                       children: [
          //                                                         Row(
          //                                                           mainAxisAlignment: MainAxisAlignment.start,
          //                                                           children: [
          //                                                             Padding(
          //                                                               padding: EdgeInsets.only(left:0),
          //                                                               child: Container(
          //                                                                 width:38,
          //                                                                 height:38,
          //                                                                 child: ElevatedButton(
          //                                                                   onPressed: () {},
          //                                                                   child: Icon(
          //                                                                     Icons.download_rounded,
          //                                                                     color: isDarkTheme
          //                                                                         ? null
          //                                                                         : Colors.black,
          //                                                                     size: 28,
          //                                                                   ),
          //                                                                   style: ElevatedButton.styleFrom(
          //                                                                     backgroundColor: Colors.transparent,
          //                                                                     shadowColor: Colors.transparent,
          //                                                                     shape: CircleBorder(),
          //                                                                     padding: EdgeInsets.zero,
          //                                                                   ),
          //                                                                 ),
          //                                                               ),
          //                                                             ),
          //                                                             Padding(
          //                                                               padding: EdgeInsets.only(left: 5),
          //                                                               child: Container(
          //                                                                 width:38,
          //                                                                 height:38,
          //                                                                 child: ElevatedButton(
          //                                                                   onPressed: () {
          //                                                                     Share.share('https://player.monstercat.app/release/${release.data["Release"]["CatalogId"]}');
          //                                                                   },
          //                                                                   child: Icon(
          //                                                                     Icons.share_rounded,
          //                                                                     color: isDarkTheme
          //                                                                         ? null
          //                                                                         : Colors.black,
          //                                                                     size: 28,
          //                                                                   ),
          //                                                                   style: ElevatedButton.styleFrom(
          //                                                                     backgroundColor: Colors.transparent,
          //                                                                     shadowColor: Colors.transparent,
          //                                                                     shape: CircleBorder(),
          //                                                                     padding: EdgeInsets.zero,
          //                                                                   ),
          //                                                                 ),
          //                                                               ),
          //                                                             ),
          //                                                           ],
          //                                                         ),
          //                                                         Row(
          //                                                           children: [
          //                                                             ElevatedButton(
          //                                                               onPressed: () {},
          //                                                               child: Icon(
          //                                                                 Icons.shuffle_rounded,
          //                                                                 color: isDarkTheme
          //                                                                     ? null
          //                                                                     : Colors.black,
          //                                                                 size: 28,
          //                                                               ),
          //                                                               style: ElevatedButton.styleFrom(
          //                                                                 backgroundColor: Colors.transparent,
          //                                                                 shadowColor: Colors.transparent,
          //                                                                 shape: CircleBorder(),
          //                                                                 padding: EdgeInsets.all(0),
          //                                                               ),
          //                                                             ),
          //                                                             ElevatedButton(
          //                                                               onPressed: () {},
          //                                                               child: Icon(
          //                                                                 Icons.play_arrow_rounded,
          //                                                                 size: 32,
          //                                                               ),
          //                                                               style: ElevatedButton.styleFrom(
          //                                                                 backgroundColor: Colors.teal,
          //                                                                 shadowColor: Colors.transparent,
          //                                                                 shape: CircleBorder(),
          //                                                                 padding: EdgeInsets.all(10),
          //                                                               ),
          //                                                             )
          //                                                           ],
          //                                                         )
          //                                                       ],
          //                                                     ),
          //                                                   ),
          //                                                 ],
          //                                               )
          //                                             ],
          //                                           ),
          //                                       )
          //
          //                                     ],
          //                                 ),
          //
          //                               ],
          //                             ),
          //                         ),
          //                         Expanded(
          //                           child: ClipRRect(
          //                             borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          //                             child: ListView.builder(
          //                               itemCount: musList.length,
          //                               itemBuilder: (context, index) {
          //                                 return mcAlbumTrackLine(
          //                                     data: musList[index],
          //                                     width: scaffoldWidth / 2 - 15
          //                                 );
          //                               },
          //                             ),
          //                           ),
          //                         )
          //
          //
          //                       ],
          //                     );
          //                   } else {
          //                     return Padding(
          //                       padding: EdgeInsets.only(
          //                         left: 15,
          //                       ),
          //                       child: Row(
          //                         children: [
          //                           GestureDetector(
          //                             onTap: () {
          //                               Navigator.pop(topContext);
          //                             },
          //                             child: const Padding(
          //                               padding: EdgeInsets.only(right: 10, top: 15),
          //                               child: Icon(
          //                                 Icons.arrow_back_rounded,
          //                                 size: 32,
          //                               ),
          //                             ),
          //                           ),
          //                           Container(
          //                             width: scaffoldWidth - 80,
          //                             child: const Padding(
          //                               padding: EdgeInsets.only(left: 10, top: 15),
          //                               child: Text(
          //                                 "Couldn't load",
          //                                 style: TextStyle(
          //                                   fontSize: 32,
          //                                   height: 1,
          //                                   fontFamily: "Comfortaa",
          //                                   fontWeight: FontWeight.bold,
          //                                 ),
          //                               ),
          //                             ),
          //                           )
          //                         ],
          //                       ),
          //                     );
          //                   }
          //                 }
          //                 return Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Padding(
          //                       padding: EdgeInsets.only(left: 15, bottom: 15),
          //                       child: Row(
          //                         children: [
          //                           GestureDetector(
          //                             onTap: () {
          //                               Navigator.pop(topContext);
          //                             },
          //                             child: Padding(
          //                               padding: EdgeInsets.only(right: 10, top: 15),
          //                               child: Icon(
          //                                 Icons.arrow_back_rounded,
          //                                 color: isDarkTheme
          //                                     ? null
          //                                     : Colors.black,
          //                                 size: 32,
          //                               ),
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                     Padding(
          //                       padding: EdgeInsets.only(left: 15),
          //                       child: Row(
          //                         crossAxisAlignment: CrossAxisAlignment.center,
          //                         children: [
          //                           Padding(
          //                             padding: EdgeInsets.only(right: 10),
          //                             child: Container(
          //                               width: 96,
          //                               height: 96,
          //                             ),
          //                           ),
          //                           SizedBox(
          //                             width: 15,
          //                           ),
          //                           Container(
          //                             width: scaffoldWidth - 142,
          //                             child: Column(
          //                               crossAxisAlignment: CrossAxisAlignment.start,
          //                               children: [
          //                                 Text(
          //                                   "Title",
          //                                   style: TextStyle(
          //                                     fontSize: 24,
          //                                     fontFamily: "Flow",
          //                                     fontWeight: FontWeight.bold,
          //                                   ),
          //                                 ),
          //                                 SizedBox(
          //                                   height: 5,
          //                                 ),
          //                                 Padding(
          //                                   padding: EdgeInsets.symmetric(vertical: 8),
          //                                   child: LinearProgressIndicator(
          //                                     backgroundColor: Colors.transparent,
          //                                     color: Colors.teal,
          //                                   ),
          //                                 ),
          //                                 SizedBox(
          //                                   height: 5,
          //                                 ),
          //                                 Text(
          //                                   "Playlist",
          //                                   overflow: TextOverflow.ellipsis,
          //                                   maxLines: 1,
          //                                   style: const TextStyle(fontSize: 20, fontFamily: 'Flow', height: 1, color: Colors.grey),
          //                                 ),
          //                               ],
          //                             ),
          //                           )
          //                         ],
          //                       ),
          //                     ),
          //                     Padding(
          //                       padding: EdgeInsets.only(top: 10, left: 15, right: 15),
          //                       child: Column(
          //                         children: [
          //                           Text(
          //                             "Description",
          //                             overflow: TextOverflow.ellipsis,
          //                             maxLines: 1,
          //                             style: const TextStyle(
          //                               fontSize: 18,
          //                               fontFamily: 'Flow',
          //                               height: 1.125,
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ],
          //                 );
          //               }),
          //         ));
          //   }
          // );
        }),
      ),
    );
  }
}
