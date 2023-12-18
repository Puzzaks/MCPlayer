import 'dart:convert';
import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:monstercatplayer/view.dart';

import 'memory.dart';
import 'network.dart';

class libraryPage extends StatefulWidget {
  const libraryPage({super.key});
  @override
  libraryPageState createState() => libraryPageState();
}

class libraryPageState extends State<libraryPage> {
  bool isDarkTheme = false;

  Map<String, String> userInfo = {};
  Map<String, String> appSettings = {};

  String myLibraryId = "";

  late BuildContext inContext;

  Widget mcPlaylistLine(context, data, width){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          data["NumRecords"] > 0
              ? FutureBuilder(
              future: getPlaylistAlbumArt(data["Id"]),
              builder: (BuildContext context, AsyncSnapshot plist) {
                if (plist.hasData) {
                  if (plist.data != "False") {
                    if(plist.data["Data"].length == 1){
                      return Padding(
                        padding: EdgeInsets.only(right:10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: CachedNetworkImage(
                            imageUrl: 'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                            width: 64, // Set the desired width
                            height: 64, // Set the desired height
                            placeholder: (context, url) => Container(color: Colors.transparent),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                      );
                    }
                    if(plist.data["Data"].length == 2){
                      return Padding(
                        padding: EdgeInsets.only(right:10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: 'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                                    width: 32, // Set the desired width
                                    height: 32, // Set the desired height
                                    placeholder: (context, url) => Container(color: Colors.transparent),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                  CachedNetworkImage(
                                    imageUrl: 'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][1]["Release"]["CatalogId"]}%2Fcover',
                                    width: 32, // Set the desired width
                                    height: 32, // Set the desired height
                                    placeholder: (context, url) => Container(color: Colors.transparent),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: 'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][1]["Release"]["CatalogId"]}%2Fcover',
                                    width: 32, // Set the desired width
                                    height: 32, // Set the desired height
                                    placeholder: (context, url) => Container(color: Colors.transparent),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                  CachedNetworkImage(
                                    imageUrl: 'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                                    width: 32, // Set the desired width
                                    height: 32, // Set the desired height
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
                    if(plist.data["Data"].length == 3){
                      return Padding(
                        padding: EdgeInsets.only(right:10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: 'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                                    width: 32, // Set the desired width
                                    height: 32, // Set the desired height
                                    placeholder: (context, url) => Container(color: Colors.transparent),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                  CachedNetworkImage(
                                    imageUrl: 'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][1]["Release"]["CatalogId"]}%2Fcover',
                                    width: 32, // Set the desired width
                                    height: 32, // Set the desired height
                                    placeholder: (context, url) => Container(color: Colors.transparent),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: 'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][2]["Release"]["CatalogId"]}%2Fcover',
                                    width: 32, // Set the desired width
                                    height: 32, // Set the desired height
                                    placeholder: (context, url) => Container(color: Colors.transparent),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                  CachedNetworkImage(
                                    imageUrl: 'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                                    width: 32, // Set the desired width
                                    height: 32, // Set the desired height
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
                    if(plist.data["Data"].length >= 4){
                      return Padding(
                        padding: EdgeInsets.only(right:10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: 'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                                    width: 32, // Set the desired width
                                    height: 32, // Set the desired height
                                    placeholder: (context, url) => Container(color: Colors.transparent),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                  CachedNetworkImage(
                                    imageUrl: 'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][1]["Release"]["CatalogId"]}%2Fcover',
                                    width: 32, // Set the desired width
                                    height: 32, // Set the desired height
                                    placeholder: (context, url) => Container(color: Colors.transparent),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: 'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][2]["Release"]["CatalogId"]}%2Fcover',
                                    width: 32, // Set the desired width
                                    height: 32, // Set the desired height
                                    placeholder: (context, url) => Container(color: Colors.transparent),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                  CachedNetworkImage(
                                    imageUrl: 'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][3]["Release"]["CatalogId"]}%2Fcover',
                                    width: 32, // Set the desired width
                                    height: 32, // Set the desired height
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
                      padding: EdgeInsets.only(right:10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: CachedNetworkImage(
                          imageUrl: 'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${plist.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                          width: 64, // Set the desired width
                          height: 64, // Set the desired height
                          placeholder: (context, url) => Container(color: Colors.transparent),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    );
                  }
                }
                return Padding(
                  padding: EdgeInsets.only(right:10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Container(
                      height: 64,
                      width: 64,
                    ),
                  ),
                );
              }
          )
              : Padding(
            padding: EdgeInsets.only(top:8,bottom:8, left: 8, right:18),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.asset(
                "assets/app_logo.png",
                height: 48,
                width: 48,
              ),
            ),
          ),
          Container(
            width: width - 165,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    data["Title"],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Comfortaa',
                    ),
                  ),
                  Text(
                    "${data["NumRecords"].toString()[data["NumRecords"].toString().length - 1] == "1"? "${data["NumRecords"]} track":"${data["NumRecords"]} tracks"}${data["IsPublic"]?", public":""}${data["Archived"]?", archived":""}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Comfortaa',
                        height: 1.25,
                        color: Colors.grey),
                  ),
                ]),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.navigate_next_rounded,
              size: 32,
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    getUser().then((value) {
      myLibraryId = value["User"]["MyLibrary"];
      checkKey("albumArtPreviewRes").then((value){
        if(value) {
          getString("albumArtPreviewRes").then((value) {
            if(value == Null){
              appSettings["albumArtPreviewRes"] = "256";
            }else {
              appSettings["albumArtPreviewRes"] = value;
            }
            super.initState();
          });
        }else{
          super.initState();
        }
      });
    });
  }

  @override
  Widget build(BuildContext topContext) {
    return MaterialApp(
      theme: ThemeData(iconTheme: const IconThemeData(color: Colors.teal)),
      darkTheme: ThemeData.dark().copyWith(
          cardColor: Color(0xFF202020),
          scaffoldBackgroundColor:
          const Color(0xFF040707)), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          inContext = context;
          double scaffoldHeight = constraints.maxHeight;
          double scaffoldWidth = constraints.maxWidth;
          if (MediaQuery
              .of(context)
              .platformBrightness == Brightness.dark) {
            isDarkTheme = true;
          } else {
            isDarkTheme = false;
          }
          final appBarColor = MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Color(0xFF040707)
              : ThemeData.light().scaffoldBackgroundColor;
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              systemNavigationBarColor: appBarColor,
            ),
          );
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 45,),
                    child: Row(
                      children: [
                        Text(
                          "Library",
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: "Comfortaa",
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                      future: getUserPlaylists(),
                      builder: (BuildContext context, AsyncSnapshot playlists) {
                        int amount = 0;
                        if (playlists.hasData) {
                          if(playlists.data != "False"){
                            return GestureDetector(
                              onTap: (){
                                showModalBottomSheet(
                                  context: context,
                                  useRootNavigator: false,
                                  isScrollControlled: true,
                                  constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth - 20 : 500),
                                  enableDrag: true,
                                  showDragHandle: true,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                  ),
                                  useSafeArea: true,
                                  backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                  builder: (BuildContext context) {
                                    return playistView(
                                        playlist: playlists.data["Playlists"]["Data"][0]["Id"]
                                    );
                                  },
                                );
                                // Navigator.push(
                                //   topContext,
                                //   MaterialPageRoute(
                                //       fullscreenDialog: true,
                                //       allowSnapshotting: true,
                                //       maintainState: true,
                                //       builder: (context) => playistView(
                                //           playlist: playlists.data["Playlists"]["Data"][0]["Id"]
                                //       )
                                //   ),
                                // );
                              },
                              child: Card(
                                margin: EdgeInsets.only(top:15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(top: 5, bottom: 10, left: 5),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              playlists.data["Playlists"]["Data"][0]["Title"],
                                              style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Comfortaa',
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.zero,
                                              child: Icon(
                                                Icons.navigate_next_rounded,
                                                size: 32,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Text(
                                        playlists.data["Playlists"]["Data"][0]["NumRecords"].toString()[playlists.data["Playlists"]["Data"][0]["NumRecords"].toString().length - 1] == "1"
                                            ? " ${playlists.data["Playlists"]["Data"][0]["NumRecords"]} track, since ${DateFormat('dd.MM.yyyy').format(DateTime.parse(playlists.data["Playlists"]["Data"][0]["CreatedAt"]))}"
                                            :" ${playlists.data["Playlists"]["Data"][0]["NumRecords"]} tracks, since ${DateFormat('dd.MM.yyyy').format(DateTime.parse(playlists.data["Playlists"]["Data"][0]["CreatedAt"]))}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Comfortaa',
                                            height: 1.25,
                                            color: Colors.teal),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                          return Container();
                        } else {
                          return Center(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: const [
                              Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
                                child: Text(
                                  "Loading...",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Flow',
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
                      }),
                  FutureBuilder(
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
                                const Padding(
                                  padding: EdgeInsets.only(top: 30, bottom: 10),
                                  child: Text(
                                    "Playlists",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Comfortaa',
                                    ),
                                  ),
                                ),
                                playlists.data["Playlists"]["Count"] < 2
                                    ? Text(
                                  "You haven't added any playlists yet.\nTo add one, click the plus button below!",
                                  style: TextStyle(
                                    fontFamily: 'Comfortaa',
                                  ),
                                )
                                    : Column(
                                    children: playlists.data["Playlists"]["Data"].map((option) {
                                      if(!option["MyLibrary"]) {
                                        return GestureDetector(
                                          onTap: (){
                                            showModalBottomSheet(
                                              context: context,
                                              useRootNavigator: false,
                                              isScrollControlled: true,
                                              constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth - 20 : 500),
                                              enableDrag: true,
                                              showDragHandle: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                              ),
                                              useSafeArea: true,
                                              backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                              builder: (BuildContext context) {
                                                return playistView(playlist: option["Id"]);
                                              },
                                            );
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //       fullscreenDialog: false,
                                            //       allowSnapshotting: false,
                                            //       maintainState: false,
                                            //       builder: (context) => playistView(playlist: option["Id"])),
                                            // );
                                          },
                                          child: mcPlaylistLine(topContext, option, scaffoldWidth),
                                        );
                                      }else{
                                        return Container();
                                      }
                                    }).toList().cast<Widget>()
                                ),
                                SizedBox(
                                  height: 15,
                                )
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
                                  "Loading...",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Flow',
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
                      }),
                ],
              ),
            ),
          );
        }),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              inContext,
              MaterialPageRoute(
                  builder: (context) => createPlaylist()),
            );
          },
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          child: Icon(
            Icons.add_rounded,
            size: 42,
          ),
        ),
      ),
    );
  }
}

class createPlaylist extends StatefulWidget {
  const createPlaylist({super.key});
  @override
  createPlaylistState createState() => createPlaylistState();
}

class createPlaylistState extends State<createPlaylist> {
  bool isDarkTheme = false;
  bool playlistPublicity = false;
  bool isSending = false;
  TextEditingController playlistNameController = TextEditingController();
  TextEditingController playlistDescController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext topContext) {
    return MaterialApp(
      theme: ThemeData(iconTheme: const IconThemeData(color: Colors.teal)),
      darkTheme: ThemeData.dark().copyWith(
          cardColor: Color(0xFF202020),
          scaffoldBackgroundColor:
          const Color(0xFF040707)), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          double scaffoldHeight = constraints.maxHeight;
          double scaffoldWidth = constraints.maxWidth;
          if (MediaQuery
              .of(context)
              .platformBrightness == Brightness.dark) {
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
          return SafeArea(child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(topContext);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 10,),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              size: 32,
                            ),
                          ),
                        ),
                        Text(
                          "Create playlist",
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: "Comfortaa",
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 0, top: 10, bottom: 5),
                          child: TextField(
                            controller: playlistNameController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(
                              fontFamily: 'Comfortaa',
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0),
                              errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              focusedErrorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: playlistNameController.text.length > 0 && playlistNameController.text.length < 32
                                      ? Colors.teal
                                      : Colors
                                      .red, // Set the focused border color
                                  width: 2.0,
                                ),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: playlistNameController.text.length > 0 && playlistNameController.text.length < 32
                                      ? Colors.teal
                                      : Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: playlistNameController.text.length > 0 && playlistNameController.text.length < 32
                                      ? Colors.teal
                                      : Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                            onChanged: (value) async {
                              setState(() {

                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ), // Name
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 0, right: 0, top: 10, bottom: 5),
                          child: TextField(
                            controller: playlistDescController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            style: const TextStyle(
                              fontFamily: 'Comfortaa',
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 0),
                              errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              focusedErrorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.teal, // Set the focused border color
                                  width: 2.0,
                                ),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                              ),
                              labelText: 'Description',
                              labelStyle: TextStyle(color: Colors.grey),
                            ),
                            onChanged: (value) async {
                              setState(() {

                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ), // Description
                  SwitchListTile(
                    value: playlistPublicity,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(
                      "Public playlist",
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        fontFamily: "Comfortaa",
                      ),
                    ),
                    activeColor: Colors.teal,
                    onChanged: (value) async {
                      setState(() {
                        playlistPublicity = !playlistPublicity;
                      });
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                            bottom: 5,
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              backgroundColor:
                              playlistNameController.text.length > 0 && playlistNameController.text.length < 32
                                  ? Colors.teal
                                  : Colors.red.withAlpha(128),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                side: BorderSide(
                                    color: playlistNameController.text.length > 0 && playlistNameController.text.length < 32
                                        ? Colors.teal
                                        : Colors.red.withAlpha(128),
                                    width: 2),
                              ),
                            ),
                            onPressed: playlistNameController.text.length > 0 && playlistNameController.text.length < 32
                                ? () async {
                              setState(() {
                                isSending = true;
                                sendCreatePlaylist(playlistNameController.text, playlistDescController.text, playlistPublicity).then((value){
                                  if(value != "Error"){
                                    Navigator.pushReplacement(
                                      topContext,
                                      MaterialPageRoute(
                                          fullscreenDialog: false,
                                          allowSnapshotting: true,
                                          maintainState: true,
                                          builder: (context) => playistView(playlist: value)),
                                    );
                                  }else{
                                    Fluttertoast.showToast(
                                      msg: 'Couldn\'t create playlist',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                  }
                                });
                              });
                            }
                                : null,
                            child: isSending
                                ? const LinearProgressIndicator(
                              color: Colors.white,
                              backgroundColor: Colors.transparent,
                            )
                                : Text(
                              "Save playlist",
                              style: TextStyle(
                                fontFamily: "Comfortaa",
                                fontWeight: FontWeight.bold,
                                color:
                                playlistNameController.text.length > 0
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.teal,
                      ),
                      Container(
                        width: scaffoldWidth - 55,
                        child: Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            " Public playlists are accessible via link",
                            maxLines: 3,
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              height: 1,
                              fontSize: 16,
                              fontFamily: "Comfortaa",
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
          );
        }),
      ),
    );
  }
}

class editPlaylist extends StatefulWidget {
  final String playlistID;
  final BuildContext preContext;
  const editPlaylist({super.key, required this.playlistID, required this.preContext});
  @override
  editPlaylistState createState() => editPlaylistState();
}

class editPlaylistState extends State<editPlaylist> {
  late BuildContext preContext;
  bool isDarkTheme = false;
  bool isSending = false;
  bool playlistPublicity = false;
  TextEditingController playlistNameController = TextEditingController();
  TextEditingController playlistDescController = TextEditingController();
  String playlistID = "";
  @override
  void initState() {
    playlistID = widget.playlistID;
    preContext = widget.preContext;
    getPlaylistInfo(playlistID).then((value){
      playlistNameController = TextEditingController(
          text: value["Playlist"]["Title"]
      );
      playlistDescController = TextEditingController(
          text: value["Playlist"]["Description"]
      );
      playlistPublicity = value["Playlist"]["IsPublic"];
      super.initState();
    });
  }

  @override
  Widget build(BuildContext topContext) {
    return MaterialApp(
      theme: ThemeData(iconTheme: const IconThemeData(color: Colors.teal)),
      darkTheme: ThemeData.dark().copyWith(
          useMaterial3: false,
          cardColor: Color(0xFF202020),
          scaffoldBackgroundColor:
          const Color(0xFF040707)), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          double scaffoldHeight = constraints.maxHeight;
          double scaffoldWidth = constraints.maxWidth;
          if (MediaQuery
              .of(context)
              .platformBrightness == Brightness.dark) {
            isDarkTheme = true;
          } else {
            isDarkTheme = false;
          }
          final appBarColor = MediaQuery.of(context).platformBrightness == Brightness.dark
              ? Color(0xFF202020)
              : ThemeData.light().scaffoldBackgroundColor;
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
              systemNavigationBarColor: appBarColor,
            ),
          );
          return SafeArea(child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(topContext);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(right: 10,),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              size: 32,
                            ),
                          ),
                        ),
                        Text(
                          "Edit playlist",
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: "Comfortaa",
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                      future: getPlaylistInfo(playlistID),
                      builder: (BuildContext context, AsyncSnapshot playlistInfo){
                        if (playlistInfo.hasData) {
                          if (playlistInfo.data != "False") {

                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0, right: 0, top: 10, bottom: 5),
                                        child: TextField(
                                          controller: playlistNameController,
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.text,
                                          style: const TextStyle(
                                            fontFamily: 'Comfortaa',
                                          ),
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(
                                                vertical: 0.0, horizontal: 0),
                                            errorBorder: const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.red,
                                                width: 2.0,
                                              ),
                                            ),
                                            focusedErrorBorder: const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.red,
                                                width: 2.0,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: playlistNameController.text.length > 0 && playlistNameController.text.length < 32
                                                    ? Colors.teal
                                                    : Colors
                                                    .red, // Set the focused border color
                                                width: 2.0,
                                              ),
                                            ),
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: playlistNameController.text.length > 0 && playlistNameController.text.length < 32
                                                    ? Colors.teal
                                                    : Colors.red,
                                                width: 2.0,
                                              ),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: playlistNameController.text.length > 0 && playlistNameController.text.length < 32
                                                    ? Colors.teal
                                                    : Colors.red,
                                                width: 2.0,
                                              ),
                                            ),
                                            labelText: 'Name',
                                            labelStyle: TextStyle(color: Colors.grey),
                                          ),
                                          onChanged: (value) async {
                                            setState(() {

                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ), // Name
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0, right: 0, top: 10, bottom: 5),
                                        child: TextField(
                                          controller: playlistDescController,
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.text,
                                          style: const TextStyle(
                                            fontFamily: 'Comfortaa',
                                          ),
                                          decoration: InputDecoration(
                                            contentPadding: const EdgeInsets.symmetric(
                                                vertical: 0.0, horizontal: 0),
                                            errorBorder: const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.red,
                                                width: 2.0,
                                              ),
                                            ),
                                            focusedErrorBorder: const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.red,
                                                width: 2.0,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.teal, // Set the focused border color
                                                width: 2.0,
                                              ),
                                            ),
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.teal,
                                                width: 2.0,
                                              ),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.teal,
                                                width: 2.0,
                                              ),
                                            ),
                                            labelText: 'Description',
                                            labelStyle: TextStyle(color: Colors.grey),
                                          ),
                                          onChanged: (value) async {
                                            setState(() {

                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ), // Description
                                SwitchListTile(
                                  value: playlistPublicity,
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  title: Text(
                                    "Public playlist",
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 1.5,
                                      fontFamily: "Comfortaa",
                                    ),
                                  ),
                                  activeColor: Colors.teal,
                                  onChanged: (value) async {
                                    setState(() {
                                      playlistPublicity = !playlistPublicity;
                                    });
                                  },
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                        ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shadowColor: Colors.transparent,
                                            backgroundColor:
                                            playlistNameController.text.length > 0 && playlistNameController.text.length < 32
                                                ? Colors.teal
                                                : Colors.red.withAlpha(128),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                              side: BorderSide(
                                                  color: playlistNameController.text.length > 0 && playlistNameController.text.length < 32
                                                      ? Colors.teal
                                                      : Colors.red.withAlpha(128),
                                                  width: 2),
                                            ),
                                          ),
                                          onPressed: playlistNameController.text.length > 0 && playlistNameController.text.length < 32
                                              ? () async {
                                            setState(() {
                                              isSending = true;
                                              final playlistData = {
                                                "Title": playlistNameController.text,
                                                "Description": playlistDescController.text,
                                                "IsPublic": playlistPublicity
                                              };
                                              sendEditPlaylist(playlistID, playlistData).then((value){
                                                if(value != "Error"){
                                                  Navigator.pushReplacement(
                                                    topContext,
                                                    MaterialPageRoute(
                                                        fullscreenDialog: true,
                                                        allowSnapshotting: true,
                                                        maintainState: true,
                                                        builder: (topContext) => playistView(playlist: value)),
                                                  );
                                                }else{
                                                  Fluttertoast.showToast(
                                                    msg: 'Couldn\'t update playlist',
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                }
                                              });
                                            });
                                          }
                                              : null,
                                          child: isSending
                                              ? const LinearProgressIndicator(
                                            color: Colors.white,
                                            backgroundColor: Colors.transparent,
                                          )
                                              : Text(
                                            "Save playlist",
                                            style: TextStyle(
                                              fontFamily: "Comfortaa",
                                              fontWeight: FontWeight.bold,
                                              color:
                                              playlistNameController.text.length > 0
                                                  ? Colors.white
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                        ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shadowColor: Colors.transparent,
                                            backgroundColor: Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.0),
                                              side: BorderSide(
                                                  color: Colors.transparent,
                                                  width: 2),
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              showDialog(
                                                context: topContext,
                                                builder: (topContext) => AlertDialog(
                                                  shadowColor: Colors.transparent,
                                                  contentPadding: EdgeInsets.only(
                                                      top: 10,
                                                      left: 15, right: 15
                                                  ),
                                                  titlePadding: EdgeInsets.only(
                                                      top: 15,
                                                      left: 15, right: 15
                                                  ),
                                                  actionsPadding: EdgeInsets.only(
                                                      left: 15, right: 15
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    side: BorderSide(
                                                        color: Colors.transparent,
                                                        width: 2),
                                                  ),
                                                  backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark
                                                      ? Color(0xFF202020)
                                                      : ThemeData.light().scaffoldBackgroundColor,
                                                  title: Text(
                                                    "Delete playlist?",
                                                    style: TextStyle(
                                                      fontFamily: "Comfortaa",
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  content: Text(
                                                    "This action cannot be undone",
                                                    style: TextStyle(
                                                      fontFamily: "Comfortaa",
                                                    ),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () => Navigator.pop(topContext),
                                                      child: Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                          fontFamily: "Comfortaa",
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.teal,
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        sendDeletePlaylist(playlistID).then((value){
                                                          if(value != "Error" && value){
                                                            Navigator.pop(topContext);
                                                            Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                  fullscreenDialog: false,
                                                                  allowSnapshotting: false,
                                                                  maintainState: false,
                                                                  builder: (context) => libraryPage()
                                                              ),
                                                            );
                                                          }else{
                                                            Fluttertoast.showToast(
                                                              msg: 'Couldn\'t delete playlist',
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              gravity: ToastGravity.BOTTOM,
                                                            );
                                                          }
                                                        });
                                                      },
                                                      child: Text(
                                                        "Delete",
                                                        style: TextStyle(
                                                          fontFamily: "Comfortaa",
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                          },
                                          child: Text(
                                            "Delete playlist",
                                            style: TextStyle(
                                              fontFamily: "Comfortaa",
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }else{
                            return Center(
                              child: Text(
                                "Couldn't load",
                                style: TextStyle(
                                  fontSize: 32,
                                  height: 1,
                                  fontFamily: "Comfortaa",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }
                        }
                        return Center(
                          child: LinearProgressIndicator(
                            color: Colors.teal,
                            backgroundColor: Colors.transparent,
                          ),
                        );
                      }
                  ),
                ],
              ),
            ),
          )
          );
        }),
      ),
    );
  }
}