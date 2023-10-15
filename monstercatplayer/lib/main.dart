import 'dart:isolate';
import 'package:monstercatplayer/view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uni_links/uni_links.dart';
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
  int lastLinkShown = 0;
  double scaffoldWidth = 0;
  late TabController tabController;
  bool isLoggedIn = false;
  final ReceivePort receivePort = ReceivePort();
  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }
  Future<void> initDeepLinks(context) async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification,
    ].request();
    final initialLink = await getInitialLink();
    // _handleDeepLink(initialLink);

    uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        _handleDeepLink(uri.toString(), context);
      }
    });
  }

  void _handleDeepLink(String? link, BuildContext context) {
    if (link != null && (DateTime.now().millisecondsSinceEpoch - lastLinkShown) > 100) {
      if (link.startsWith('https://player.monstercat.app/release/')) {
        showModalBottomSheet(
          context: context,
          useRootNavigator: false,
          isScrollControlled: true,
          constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth : 500),
          enableDrag: true,
          showDragHandle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
          ),
          useSafeArea: true,
          backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
          builder: (BuildContext context) {
            return albumView(
              release: link.replaceAll("https://player.monstercat.app/release/", ""),
            );
          },
        );
      }
      if (link.startsWith('https://player.monstercat.app/playlist/')) {
        showModalBottomSheet(
          context: context,
          useRootNavigator: false,
          isScrollControlled: true,
          constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth : 500),
          enableDrag: true,
          showDragHandle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
          ),
          useSafeArea: true,
          backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
          builder: (BuildContext context) {
            return playistView(
              playlist: link.replaceAll("https://player.monstercat.app/playlist/", ""),
            );
          },
        );
      }
    }
    lastLinkShown = DateTime.now().millisecondsSinceEpoch;
  }

  void setLogin(value) {
    setState(() {
      isLoggedIn = value;
    });
  }


  @override
  Widget build(BuildContext ultraTopContext) {
    return MaterialApp(
      routes: {

      },
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
        initDeepLinks(context);
        double scaffoldHeight = constraints.maxHeight;
        scaffoldWidth = constraints.maxWidth;
        return Scaffold(
          bottomNavigationBar: isLoggedIn
              ? MediaQuery.of(context).orientation == Orientation.portrait
              ? Consumer<musicPlayer>(
            builder: (context, playerData, child) {
              return Container(
                color: backgroundColor,
                height: playerData.queue.length > 0 ? 130 : 60,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: "Comfortaa",
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        playerData.nowPlaying!["ArtistsTitle"],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
