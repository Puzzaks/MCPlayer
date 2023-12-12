import 'dart:isolate';
import 'dart:ui';
import 'package:just_audio_background/just_audio_background.dart';
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
  bool playerOpened = false;
  @override
  void initState() {
    JustAudioBackground.init(
        androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidNotificationOngoing: false,
        notificationColor: Colors.teal,
        androidNotificationIcon: 'mipmap/ic_launcher',
      androidShowNotificationBadge: false
    );
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
        scaffoldBackgroundColor: Color(0xFF040707),
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
        bool tooWide = constraints.maxWidth <= scaffoldHeight ~/ 2;
        return Scaffold(
          bottomNavigationBar: isLoggedIn
              ? MediaQuery.of(context).orientation == Orientation.portrait
              ? Consumer<musicPlayer>(
            builder: (context, playerData, child) {
              String formatDuration(int seconds) {
                String hoursString = (seconds ~/ 3600).toString().padLeft(2, '0');
                String minutesString = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
                String secondsString = (seconds % 60).toString().padLeft(2, '0');
                if (seconds / 3600 >= 1){
                  return '$hoursString:$minutesString:$secondsString';
                }
                return '$minutesString:$secondsString';
              }
              return Container(
                color: backgroundColor,
                height: playerOpened ? scaffoldHeight: playerData.queue.length > 0 ? 130 : 60,
                child: !playerOpened ? GestureDetector(
                  onTap:(){
                    setState(() {
                      playerOpened = true;
                    });
                  },
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
                                    color: Colors.teal,
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
                ) : Stack(
                    children: [
                      Container(
                        color: Colors.black,
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25.0),
                        child: CachedNetworkImage(
                          imageUrl: 'https://cdx.monstercat.com/?width=1024&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${playerData.nowPlaying!["Release"]["CatalogId"]}%2Fcover',
                          width: scaffoldWidth, // Set the desired width
                          height: scaffoldHeight, // Set the desired height
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const CircularProgressIndicator(
                            color: Colors.teal,
                            backgroundColor: Colors.transparent,
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Adjust blur intensity
                            child: Container(
                              color: MediaQuery.of(context).platformBrightness == Brightness.light
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.black.withOpacity(0.5), // Adjust opacity
                              // Your content goes here, e.g., text or other widgets
                            )),
                      ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left:25, top:30),
                              child: GestureDetector(
                                onTap:(){
                                  setState(() {
                                    playerOpened = false;
                                  });
                                },
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  size: 32,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top:30),
                              child: Container(
                                width: scaffoldWidth - 155,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        "NOW PLAYING",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontFamily: "Comfortaa",
                                          fontSize: 20,
                                        )
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            "from ",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: "Comfortaa",
                                                height: 1.5,
                                                fontSize: 18,
                                                color: Colors.grey
                                            )
                                        ),
                                        Text(
                                            playerData.queueData["Title"],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontFamily: "Comfortaa",
                                                fontSize: 18,
                                                height: 1.5,
                                                color: Colors.teal
                                            )
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 25, top:30),
                              child: GestureDetector(
                                onTap:(){},
                                child: Icon(
                                  Icons.more_vert_rounded,
                                  size: 32,
                                ),
                              ),
                            ),
                          ],
                        ), // controls + nowplaying
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: CachedNetworkImage(
                            imageUrl: 'https://cdx.monstercat.com/?width=1024&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${playerData.nowPlaying!["Release"]["CatalogId"]}%2Fcover',
                            width: tooWide ? scaffoldWidth - 50 : scaffoldHeight / 2 - 50, // Set the desired width
                            height: tooWide ? scaffoldWidth - 50 : scaffoldHeight / 2 - 50, // Set the desired height
                            placeholder: (context, url) => const CircularProgressIndicator(
                              color: Colors.teal,
                              backgroundColor: Colors.transparent,
                            ),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        )
                        ), // thumbnail
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: scaffoldWidth,
                              ),
                              Text(
                                playerData.nowPlaying!["Title"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: "Comfortaa",
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                playerData.nowPlaying!["ArtistsTitle"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    height: 1.5,
                                    fontFamily: "Comfortaa",
                                    fontSize: 20,
                                    color: MediaQuery.of(context).platformBrightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 25
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      formatDuration(playerData.position),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: "Comfortaa",
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      formatDuration(playerData.nowPlaying["Duration"]),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: "Comfortaa",
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              LinearProgressIndicator(
                                value: 100,
                                backgroundColor: Colors.grey.withAlpha(64),
                                color: Colors.transparent,
                                minHeight: 10,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              LinearProgressIndicator(
                                value: playerData.buffered / playerData.nowPlaying["Duration"],
                                backgroundColor: Colors.transparent,
                                color: Colors.grey.withAlpha(128),
                                minHeight: 10,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              LinearProgressIndicator(
                                value: playerData.position / playerData.nowPlaying["Duration"],
                                backgroundColor: Colors.transparent,
                                color: Colors.white,
                                minHeight: 10,
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: Icon(
                                Icons.repeat_rounded,
                                size: 32,
                                color: MediaQuery.of(context).platformBrightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(10),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Provider.of<musicPlayer>(context, listen: false).playPrevious();
                              },
                              child: Icon(
                                Icons.skip_previous_rounded,
                                size: 42,
                                color: MediaQuery.of(context).platformBrightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(10),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: (){
                                playerData.isPlaying
                                    ? Provider.of<musicPlayer>(context, listen: false).pause()
                                    : Provider.of<musicPlayer>(context, listen: false).resume();
                              },
                              child: Icon(
                                playerData.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                size: 42,
                                color: MediaQuery.of(context).platformBrightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shadowColor: Colors.transparent,
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(10),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Provider.of<musicPlayer>(context, listen: false).playNext();
                              },
                              child: Icon(
                                Icons.skip_next_rounded,
                                size: 42,
                                color: MediaQuery.of(context).platformBrightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(10),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: Icon(
                                Icons.shuffle_rounded,
                                size: 32,
                                color: MediaQuery.of(context).platformBrightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(10),
                              ),
                            )
                          ],
                        ),
                        )

                      ],
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
                  ? Consumer<musicPlayer>(
                builder: (context, playerData, child) {
                  String formatDuration(int seconds) {
                    String hoursString = (seconds ~/ 3600).toString().padLeft(2, '0');
                    String minutesString = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
                    String secondsString = (seconds % 60).toString().padLeft(2, '0');
                    if (seconds / 3600 >= 1){
                      return '$hoursString:$minutesString:$secondsString';
                    }
                    return '$minutesString:$secondsString';
                  }
                  if (playerData.queue.length > 0){
                    return Row(
                      children: [
                        Container(
                          width: 320,
                          height: scaffoldHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              !playerOpened ? GestureDetector(
                                onTap:(){
                                  setState(() {
                                    playerOpened = true;
                                  });
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    playerData.queue.length > 0 ? Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(10.0),
                                              child: CachedNetworkImage(
                                                imageUrl: 'https://cdx.monstercat.com/?width=1024&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${playerData.nowPlaying!["Release"]["CatalogId"]}%2Fcover',
                                                width: 200, // Set the desired width
                                                height: 200, // Set the desired height
                                                placeholder: (context, url) => const CircularProgressIndicator(
                                                  color: Colors.teal,
                                                  backgroundColor: Colors.transparent,
                                                ),
                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  width: 235,
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
                                                      color: Colors.teal,
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
                                            ),
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
                                  ],
                                ),
                              ) : Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(0.0),
                                    child: CachedNetworkImage(
                                      imageUrl: 'https://cdx.monstercat.com/?width=1024&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${playerData.nowPlaying!["Release"]["CatalogId"]}%2Fcover',
                                      width: scaffoldWidth, // Set the desired width
                                      height: scaffoldHeight, // Set the desired height
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const CircularProgressIndicator(
                                        color: Colors.teal,
                                        backgroundColor: Colors.transparent,
                                      ),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                  ),
                                  BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Adjust blur intensity
                                      child: Container(
                                        height: scaffoldHeight,
                                        color: Colors.black.withOpacity(0.5), // Adjust opacity
                                        // Your content goes here, e.g., text or other widgets
                                      )),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left:25, top:30),
                                            child: GestureDetector(
                                              onTap:(){
                                                setState(() {
                                                  playerOpened = false;
                                                });
                                              },
                                              child: Icon(
                                                Icons.keyboard_arrow_down_rounded,
                                                size: 32,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(top:30),
                                              child: Container(
                                                width: 205,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        "NOW PLAYING",
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontFamily: "Comfortaa",
                                                          fontSize: 20,
                                                        )
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                            "from ",
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                fontFamily: "Comfortaa",
                                                                height: 1.5,
                                                                fontSize: 18,
                                                                color: Colors.grey
                                                            )
                                                        ),
                                                        Text(
                                                            playerData.queueData["Title"],
                                                            maxLines: 1,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: TextStyle(
                                                                fontFamily: "Comfortaa",
                                                                fontSize: 18,
                                                                height: 1.5,
                                                                color: Colors.teal
                                                            )
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(right: 25, top:30),
                                            child: GestureDetector(
                                              onTap:(){},
                                              child: Icon(
                                                Icons.more_vert_rounded,
                                                size: 32,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ), // controls + nowplaying
                                      Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 25),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(25.0),
                                            child: CachedNetworkImage(
                                              imageUrl: 'https://cdx.monstercat.com/?width=1024&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${playerData.nowPlaying!["Release"]["CatalogId"]}%2Fcover',
                                              width: tooWide ? scaffoldWidth - 75 : scaffoldHeight / 2 - 75, // Set the desired width
                                              height: tooWide ? scaffoldWidth - 75 : scaffoldHeight / 2 - 75, // Set the desired height
                                              placeholder: (context, url) => const CircularProgressIndicator(
                                                color: Colors.teal,
                                                backgroundColor: Colors.transparent,
                                              ),
                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                            ),
                                          )
                                      ), // thumbnail
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 25),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: scaffoldWidth,
                                            ),
                                            Text(
                                              playerData.nowPlaying!["Title"],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: "Comfortaa",
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              playerData.nowPlaying!["ArtistsTitle"],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  height: 1.5,
                                                  fontFamily: "Comfortaa",
                                                  fontSize: 20,
                                                  color: Colors.grey
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 25),
                                        child: Stack(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: 25
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    formatDuration(playerData.position),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: "Comfortaa",
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                  Text(
                                                    formatDuration(playerData.nowPlaying["Duration"]),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontFamily: "Comfortaa",
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            LinearProgressIndicator(
                                              value: 100,
                                              backgroundColor: Colors.grey.withAlpha(64),
                                              color: Colors.transparent,
                                              minHeight: 10,
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                            ),
                                            LinearProgressIndicator(
                                              value: playerData.buffered / playerData.nowPlaying["Duration"],
                                              backgroundColor: Colors.transparent,
                                              color: Colors.grey.withAlpha(128),
                                              minHeight: 10,
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                            ),
                                            LinearProgressIndicator(
                                              value: playerData.position / playerData.nowPlaying["Duration"],
                                              backgroundColor: Colors.transparent,
                                              color: Colors.white,
                                              minHeight: 10,
                                              borderRadius: BorderRadius.all(Radius.circular(5)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {},
                                              child: Icon(
                                                Icons.repeat_rounded,
                                                size: 32,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.transparent,
                                                shadowColor: Colors.transparent,
                                                shape: CircleBorder(),
                                                padding: EdgeInsets.all(10),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {},
                                              child: Icon(
                                                Icons.skip_previous_rounded,
                                                size: 42,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.transparent,
                                                shadowColor: Colors.transparent,
                                                shape: CircleBorder(),
                                                padding: EdgeInsets.all(10),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: (){
                                                playerData.isPlaying
                                                    ? Provider.of<musicPlayer>(context, listen: false).pause()
                                                    : Provider.of<musicPlayer>(context, listen: false).resume();
                                              },
                                              child: Icon(
                                                playerData.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                                size: 42,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.teal,
                                                shadowColor: Colors.transparent,
                                                shape: CircleBorder(),
                                                padding: EdgeInsets.all(10),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {},
                                              child: Icon(
                                                Icons.skip_next_rounded,
                                                size: 42,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.transparent,
                                                shadowColor: Colors.transparent,
                                                shape: CircleBorder(),
                                                padding: EdgeInsets.all(10),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {},
                                              child: Icon(
                                                Icons.shuffle_rounded,
                                                size: 32,
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.transparent,
                                                shadowColor: Colors.transparent,
                                                shape: CircleBorder(),
                                                padding: EdgeInsets.all(10),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              !playerOpened ? TabBar(
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
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    child: Tab(
                                      icon: Icon(
                                        Icons.home_rounded,
                                        size: 28,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    child: Tab(
                                        icon: Icon(
                                          Icons.search_rounded,
                                          size: 28,
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    child: Tab(
                                        icon: Icon(
                                          Icons.library_music_outlined,
                                          size: 28,
                                        )
                                    ),
                                  )
                                ],
                              ) : Container()
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return ColoredBox(
                      color: Color(0xFF040707),
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
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Tab(
                                  icon: Icon(
                                    Icons.home_rounded,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                            RotatedBox(
                              quarterTurns: -1,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
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
                                padding: EdgeInsets.symmetric(horizontal: 15),
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
                      ));
                },
              ): Container(),
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
