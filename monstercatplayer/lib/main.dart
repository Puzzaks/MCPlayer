import 'dart:isolate';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:monstercatplayer/library.dart';
import 'package:monstercatplayer/login.dart';
import 'package:monstercatplayer/player.dart';
import 'package:provider/provider.dart';
import 'search.dart';
import 'home.dart';
import 'memory.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (context) => musicPlayer(),
    child: MyApp(),
  ),
);

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool isLoggedIn = false;
  final ReceivePort receivePort = ReceivePort();
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }
  void setLogin(value) {
    setState(() {
      isLoggedIn = value;
    });
  }


  @override
  Widget build(BuildContext ultraTopContext) {
    return MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark().copyWith(
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: Colors.transparent
        ),
        scaffoldBackgroundColor: Color(0xFF202020),
        bottomNavigationBarTheme: BottomNavigationBarThemeData().copyWith(backgroundColor: Colors.transparent),
        tabBarTheme: TabBarTheme().copyWith(labelColor: Colors.yellow)
      ), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: checkLogin(),
    builder: (BuildContext context, AsyncSnapshot login){
      final backgroundColor = MediaQuery.of(context).platformBrightness == Brightness.dark
          ? Color(0xFF040707)
          : ThemeData.light().scaffoldBackgroundColor;
      final iconColor = MediaQuery.of(context).platformBrightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark;
      SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual, overlays: [
        SystemUiOverlay.top,
        SystemUiOverlay.bottom
      ]);
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: iconColor,
          systemNavigationBarColor: backgroundColor,
        ),
      );

      if (login.hasData) {
        isLoggedIn = login.data;
        return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double scaffoldHeight = constraints.maxHeight;
        double scaffoldWidth = constraints.maxWidth;
        return Scaffold(
          bottomNavigationBar: isLoggedIn
              ? MediaQuery.of(context).orientation == Orientation.portrait
              ? Consumer<musicPlayer>(
            builder: (context, playerData, child) {
              return Container(
                color: backgroundColor,
                height: playerData.queue.length > 0 ? 175 : 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    playerData.queue.length > 0 ? Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.playlist_play_rounded
                          ),
                          Text(
                            playerData.queueData["Title"],
                            style: TextStyle(
                              fontFamily: "Comfortaa",
                              fontSize: 18,
                            ),
                          )
                        ],
                      ),
                    ) : Container(),
                    playerData.queue.length > 0 ? Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: CachedNetworkImage(
                                    imageUrl: 'https://cdx.monstercat.com/?width=256&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${playerData.nowPlaying!["Release"]["CatalogId"]}%2Fcover',
                                    width: 50, // Set the desired width
                                    height: 50, // Set the desired height
                                    placeholder: (context, url) => const CircularProgressIndicator(
                                      color: Colors.teal,
                                      backgroundColor: Colors.transparent,
                                    ),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: scaffoldWidth - 144,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        playerData.nowPlaying!["Title"],
                                        style: TextStyle(
                                          fontFamily: "Comfortaa",
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        playerData.nowPlaying!["ArtistsTitle"],
                                        style: TextStyle(
                                            fontFamily: "Comfortaa",
                                            fontSize: 18,
                                            color: Colors.grey
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(0),
                              child: ElevatedButton(
                                onPressed: (){
                                  playerData.isPlaying
                                      ? Provider.of<musicPlayer>(context, listen: false).pause()
                                      : Provider.of<musicPlayer>(context, listen: false).resume();
                                },
                                onLongPress: (){
                                  Fluttertoast.showToast(
                                    msg: 'Tap to play',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                  );
                                },
                                child: Icon(
                                  playerData.isPlaying?Icons.pause:Icons.play_arrow_rounded,
                                  size: 32,
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(6),
                                ),
                              ),
                            )
                          ],
                        )
                    ) : Container(),
                    playerData.queue.length > 0 ? Stack(
                      children: [
                        LinearProgressIndicator(
                          value: playerData.buffered / playerData.nowPlaying["Duration"],
                          backgroundColor: Colors.transparent,
                          color: Colors.grey,
                          minHeight: 2,
                        ),
                        LinearProgressIndicator(
                          value: playerData.position / playerData.nowPlaying["Duration"],
                          backgroundColor: Colors.transparent,
                          color: Colors.teal,
                          minHeight: 2,
                        ),
                      ],
                    ) : Container(),
                    ColoredBox(
                      color: backgroundColor,
                      child: TabBar(
                        controller: tabController,
                        labelColor: Colors.teal,
                        indicatorColor: Colors.transparent,
                        unselectedLabelColor: Colors.grey,
                        labelPadding: EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 10
                        ),
                        tabs: [
                          Tab(
                              icon: Icon(
                                Icons.home_rounded,
                                size: 28,
                              )
                          ),
                          Tab(
                              icon: Icon(
                                Icons.search_rounded,
                                size: 28,
                              )
                          ),
                          Tab(
                              icon: Icon(
                                Icons.library_music_outlined,
                                size: 28,
                              )
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          )
              : null : null,
          resizeToAvoidBottomInset: false,
          body: isLoggedIn
              ? Row(
            children: [
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? ColoredBox(
                  color: backgroundColor,
                  child: RotatedBox(
                    quarterTurns: 1,
                    child: TabBar(
                      controller: tabController,
                      labelColor: Colors.teal,
                      indicatorColor: Colors.transparent,
                      unselectedLabelColor: Colors.grey,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelPadding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 10
                      ),
                      tabs: const [
                        RotatedBox(
                          quarterTurns: -1,
                          child: Padding(
                            padding: EdgeInsets.only(left:30),
                            child: Tab(
                                icon: Icon(
                                  Icons.home_rounded,
                                  size: 28,
                                )
                            ),
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: -1,
                          child: Padding(
                            padding: EdgeInsets.only(left:30),
                            child: Tab(
                                icon: Icon(
                                  Icons.search_rounded,
                                  size: 28,
                                )
                            ),
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: -1,
                          child: Padding(
                            padding: EdgeInsets.only(left:30),
                            child: Tab(
                                icon: Icon(
                                  Icons.library_music_outlined,
                                  size: 28,
                                )
                            ),
                          ),
                        )
                      ],
                    ),
                  )): Container(),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    homePage(),
                    searchPage(),
                    libraryPage()
                  ],
                ),
              )

            ],
          )
              : loginPage(),
        );
      }
    );
      }else{
        return Center(
          child:
            CircularProgressIndicator(
              color: Colors.teal,
              backgroundColor: Colors.transparent,
            )
        );
      }
    }
      ),
    );
  }
}
