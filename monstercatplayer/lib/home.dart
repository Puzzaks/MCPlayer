import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:monstercatplayer/memory.dart';
import 'package:monstercatplayer/settings.dart';
import 'package:monstercatplayer/view.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'elements.dart';
import 'search.dart';
import 'network.dart';
import 'package:intl/intl.dart';

class homePage extends StatefulWidget {
  @override
  ScrollablePageState createState() => ScrollablePageState();
}

class ScrollablePageState extends State<homePage> {
  final InAppReview review = InAppReview.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isDarkTheme = false;
  Map<String, String> userInfo = {};
  Map<String, String> appSettings = {};
  Map appInfo = {};
  List<String> greetings = ["MCPlayer"];
  @override
  void initState() {
    super.initState();
  }

  Future<Map> getAppData() async {
    final info = await PackageInfo.fromPlatform();
    Map output = {};
    output = {
      "version": info.version,
      "build": info.buildNumber,
    };
    return output;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext topContext) {
    return MaterialApp(
      theme: ThemeData(
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      darkTheme: ThemeData.dark().copyWith(
        cardColor: const Color(0xFF202020),
        scaffoldBackgroundColor: const Color(0xFF040707),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
            double scaffoldHeight = constraints.maxHeight;
            double scaffoldWidth = constraints.maxWidth;
            if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
              isDarkTheme = true;
            } else {
              isDarkTheme = false;
            }
            final backgroundColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor;
            final iconColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Brightness.light : Brightness.dark;
            final appBarColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF202020) : ThemeData.light().scaffoldBackgroundColor;

            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                statusBarColor: Colors.transparent,
                statusBarIconBrightness: iconColor,
                systemNavigationBarColor: const Color(0xFF040707),
              ),
            );
            return OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                if (orientation == Orientation.portrait) {
                  return SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30, bottom: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: scaffoldWidth - 134,
                                    child: Text(
                                      greetings[Random().nextInt(greetings.length)],
                                      overflow: TextOverflow.visible,
                                      maxLines: 3,
                                      style: const TextStyle(
                                        fontSize: 32,
                                        height: 1.25,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Comfortaa',
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            topContext,
                                            MaterialPageRoute(fullscreenDialog: true, builder: (ultraTopContext) => const settingsPage()),
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 15),
                                          child: Icon(
                                            Icons.settings_outlined,
                                            size: 32,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ), // Hello and controls
                            FutureBuilder(
                                future: getAppData(),
                                builder: (BuildContext context, AsyncSnapshot appData) {
                                  if (appData.hasData) {
                                    return FutureBuilder(
                                        future: checkKey("shown${appData.data["build"]}"),
                                        builder: (BuildContext context, AsyncSnapshot isInit) {
                                          if (isInit.hasData) {
                                            if (!isInit.data) {
                                              return Row(
                                                children: [
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          setBool("shown${appData.data["build"]}", true);
                                                          Navigator.push(
                                                            topContext,
                                                            MaterialPageRoute(builder: (context) => const changelogPage()),
                                                          );
                                                        },
                                                        child:
                                                            mcNotificationCard(title: "Update ${appData.data["version"]} [${appData.data["build"]}]", subtitle: "MCPlayer has been updated!\nTap here to read what's new!", icon: Icons.info_outline_rounded),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }
                                          }
                                          return Container();
                                        });
                                  }
                                  return Container();
                                }), // Current Beta info
                            FutureBuilder(
                                future: checkKey("initDone"),
                                builder: (BuildContext context, AsyncSnapshot isInit) {
                                  if (isInit.hasData) {
                                    if (!isInit.data) {
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  Navigator.push(
                                                    topContext,
                                                    MaterialPageRoute(builder: (context) => const finishSetupPage()),
                                                  );
                                                });
                                              },
                                              child: const mcNotificationCard(title: "Important information!", subtitle: "Please, read these notices in order to be aware of the current state of the app", icon: Icons.arrow_forward),
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  }
                                  return Container();
                                }), // Finish setup
                            FutureBuilder(
                                future: getRecent(),
                                builder: (BuildContext context, AsyncSnapshot recents) {
                                  if (recents.hasData) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Latest release",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 28,
                                              height: 1,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Comfortaa',
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 10),
                                            child: Text(
                                              "${recents.data["Data"][0]["Brand"]} - Released ${DateFormat('MMMM d, y').format(DateTime.parse(recents.data["Data"][0]["Release"]["ReleaseDate"]))}",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                height: 1.5,
                                                color: Colors.grey,
                                                fontFamily: 'Comfortaa',
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                useRootNavigator: false,
                                                isScrollControlled: true,
                                                constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth : 500),
                                                enableDrag: true,
                                                showDragHandle: true,
                                                shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                                ),
                                                useSafeArea: true,

                                                barrierColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                                backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                                builder: (BuildContext context) {
                                                  return albumView(
                                                    release: recents.data["Data"][0]["Release"]["CatalogId"],
                                                  );
                                                },
                                              );
                                              // Navigator.push(
                                              //   topContext,
                                              //   MaterialPageRoute(
                                              //       fullscreenDialog: true,
                                              //       allowSnapshotting: true,
                                              //       maintainState: true,
                                              //       builder: (context) => albumView(
                                              //         release: recents.data["Data"][0]["Release"]["CatalogId"],
                                              //       )),
                                              // );
                                            },
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(right: 10),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(15.0),
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${recents.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                                                      width: 100, // Set the desired width
                                                      height: 100, // Set the desired height
                                                      placeholder: (context, url) => Container(color: Colors.transparent),
                                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  height: 100,
                                                  width: scaffoldWidth - 168,
                                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                            padding: const EdgeInsets.only(bottom: 5),
                                                            child: Text(
                                                              recents.data["Data"][0]["Title"],
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 1,
                                                              style: const TextStyle(
                                                                fontSize: 24,
                                                                height: 1,
                                                                fontWeight: FontWeight.bold,
                                                                fontFamily: 'Comfortaa',
                                                              ),
                                                            )),
                                                        Text(
                                                          recents.data["Data"][0]["Release"]["ArtistsTitle"],
                                                          maxLines: 1,
                                                          style: const TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.teal,
                                                            fontFamily: 'Comfortaa',
                                                          ),
                                                        ),
                                                        Padding(
                                                            padding: const EdgeInsets.only(top: 5),
                                                            child: Text(
                                                              "${recents.data["Data"][0]["Release"]["Title"]} (${recents.data["Data"][0]["Release"]["Type"]})",
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 2,
                                                              style: const TextStyle(
                                                                fontSize: 18,
                                                                height: 1,
                                                                fontFamily: 'Comfortaa',
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ]),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Latest release",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 28,
                                              height: 1,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Flow',
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(bottom: 10),
                                            child: Text(
                                              "Loading Date",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                              style: TextStyle(
                                                fontSize: 18,
                                                height: 1.5,
                                                color: Colors.grey,
                                                fontFamily: 'Flow',
                                              ),
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                  child: Container(height: 128, width: 128, color: Colors.transparent),
                                                ),
                                              ),
                                              Container(
                                                height: 128,
                                                width: scaffoldWidth - 168,
                                                child: const Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                          padding: EdgeInsets.only(bottom: 5),
                                                          child: Text(
                                                            "Loading...",
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                            style: TextStyle(
                                                              fontSize: 24,
                                                              height: 1,
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: 'Flow',
                                                            ),
                                                          )),
                                                      Text(
                                                        "Loading...",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.teal,
                                                          fontFamily: 'Flow',
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding: EdgeInsets.only(top: 5),
                                                          child: Text(
                                                            "Loading...",
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                              height: 1,
                                                              fontFamily: 'Flow',
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.play_circle_outline_rounded,
                                                            size: 32,
                                                          ),
                                                          Icon(
                                                            Icons.add,
                                                            size: 32,
                                                          ),
                                                        ],
                                                      ),
                                                      Icon(
                                                        Icons.more_vert_rounded,
                                                        size: 32,
                                                      ),
                                                    ],
                                                  )
                                                ]),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                }), // Latest release
                            FutureBuilder(
                                future: getRecent(),
                                builder: (BuildContext context, AsyncSnapshot recents) {
                                  if (recents.hasData) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 15),
                                          child: Text(
                                            "Recent Releases",
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Comfortaa',
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              useRootNavigator: false,
                                              isScrollControlled: true,
                                              constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth - 20 : 500),
                                              enableDrag: true,
                                              showDragHandle: true,
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                              ),
                                              useSafeArea: true,
                                              backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                              builder: (BuildContext context) {
                                                return albumView(
                                                  release: recents.data["Data"][1]["Release"]["CatalogId"],
                                                );
                                              },
                                            );
                                            // Navigator.push(
                                            //   topContext,
                                            //   MaterialPageRoute(
                                            //       fullscreenDialog: true,
                                            //       allowSnapshotting: true,
                                            //       maintainState: true,
                                            //       builder: (context) => albumView(
                                            //             release: recents.data["Data"][1]["Release"]["CatalogId"],
                                            //           )),
                                            // );
                                          },
                                          child: mcRecentAlbum(
                                            data: recents.data["Data"][1],
                                            width: scaffoldWidth,
                                            appSettings: appSettings,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              useRootNavigator: false,
                                              isScrollControlled: true,
                                              constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth - 20 : 500),
                                              enableDrag: true,
                                              showDragHandle: true,
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                              ),
                                              useSafeArea: true,
                                              backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                              builder: (BuildContext context) {
                                                return albumView(
                                                  release: recents.data["Data"][2]["Release"]["CatalogId"],
                                                );
                                              },
                                            );
                                            // Navigator.push(
                                            //   topContext,
                                            //   MaterialPageRoute(
                                            //       fullscreenDialog: true,
                                            //       allowSnapshotting: true,
                                            //       maintainState: true,
                                            //       builder: (context) => albumView(
                                            //             release: recents.data["Data"][2]["Release"]["CatalogId"],
                                            //           )),
                                            // );
                                          },
                                          child: mcRecentAlbum(
                                            data: recents.data["Data"][2],
                                            width: scaffoldWidth,
                                            appSettings: appSettings,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              useRootNavigator: false,
                                              isScrollControlled: true,
                                              constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth - 20 : 500),
                                              enableDrag: true,
                                              showDragHandle: true,
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                              ),
                                              useSafeArea: true,
                                              backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                              builder: (BuildContext context) {
                                                return albumView(
                                                  release: recents.data["Data"][3]["Release"]["CatalogId"],
                                                );
                                              },
                                            );
                                            // Navigator.push(
                                            //   topContext,
                                            //   MaterialPageRoute(
                                            //       fullscreenDialog: true,
                                            //       allowSnapshotting: true,
                                            //       maintainState: true,
                                            //       builder: (context) => albumView(
                                            //             release: recents.data["Data"][3]["Release"]["CatalogId"],
                                            //           )),
                                            // );
                                          },
                                          child: mcRecentAlbum(
                                            data: recents.data["Data"][3],
                                            width: scaffoldWidth,
                                            appSettings: appSettings,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              useRootNavigator: false,
                                              isScrollControlled: true,
                                              constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth - 20 : 500),
                                              enableDrag: true,
                                              showDragHandle: true,
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                              ),
                                              useSafeArea: true,
                                              backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                              builder: (BuildContext context) {
                                                return albumView(
                                                  release: recents.data["Data"][4]["Release"]["CatalogId"],
                                                );
                                              },
                                            );
                                            // Navigator.push(
                                            //   topContext,
                                            //   MaterialPageRoute(
                                            //       fullscreenDialog: true,
                                            //       allowSnapshotting: true,
                                            //       maintainState: true,
                                            //       builder: (context) => albumView(
                                            //             release: recents.data["Data"][4]["Release"]["CatalogId"],
                                            //           )),
                                            // );
                                          },
                                          child: mcRecentAlbum(
                                            data: recents.data["Data"][4],
                                            width: scaffoldWidth,
                                            appSettings: appSettings,
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return const Center(
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                        Padding(
                                          padding: EdgeInsets.all(15),
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
                                        SizedBox(
                                          height: 280,
                                        ),
                                        Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 15, bottom: 15),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "View More",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Flow',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ]),
                                    );
                                  }
                                }), // Recent releases
                            FutureBuilder(
                                future: getPlaylists(),
                                builder: (BuildContext context, AsyncSnapshot playlists) {
                                  if (playlists.hasData) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 15, bottom: 5),
                                          child: Text(
                                            "Official playlists",
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Comfortaa',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(top: 5, bottom: 15),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(15.0),
                                              child: SizedBox(
                                                  height: 200,
                                                  child: ListView.builder(
                                                      scrollDirection: Axis.horizontal,
                                                      itemCount: playlists.data["Menu"]["Sections"][0]["Items"].length,
                                                      itemBuilder: (BuildContext context, int index) {
                                                        final isFirstItem = index == 0;
                                                        final isLastItem = index == playlists.data["Menu"]["Sections"][0]["Items"].length - 1;
                                                        return GestureDetector(
                                                          onTap: () {
                                                            showModalBottomSheet(
                                                              context: context,
                                                              useRootNavigator: false,
                                                              isScrollControlled: true,
                                                              constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth - 20 : 500),
                                                              enableDrag: true,
                                                              showDragHandle: true,
                                                              shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                                              ),
                                                              useSafeArea: true,
                                                              backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                                              builder: (BuildContext context) {
                                                                return playistView(playlist: playlists.data["Menu"]["Sections"][0]["Items"][index]["Link"].replaceAll('mcat://playlist:', ''));
                                                              },
                                                            );
                                                            // Navigator.push(
                                                            //   topContext,
                                                            //   MaterialPageRoute(
                                                            //       fullscreenDialog: true,
                                                            //       allowSnapshotting: true,
                                                            //       maintainState: true,
                                                            //       builder: (context) => playistView(playlist: playlists.data["Menu"]["Sections"][0]["Items"][index]["Link"].replaceAll('mcat://playlist:', ''))),
                                                            // );
                                                          },
                                                          child: Padding(
                                                              padding: EdgeInsets.only(
                                                                left: isFirstItem ? 0.0 : 5.0,
                                                                right: isLastItem ? 0.0 : 5.0,
                                                              ),
                                                              child: ClipRRect(
                                                                borderRadius: BorderRadius.circular(15.0),
                                                                child: CachedNetworkImage(
                                                                  imageUrl: 'https://monstercat.com/api/playlist/${playlists.data["Menu"]["Sections"][0]["Items"][index]["Link"].replaceAll('mcat://playlist:', '')}/tile',
                                                                  width: 200, // Set the desired width
                                                                  height: 200, // Set the desired height
                                                                  placeholder: (context, url) => Container(color: Colors.transparent),
                                                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                ),
                                                              )),
                                                        );
                                                      })),
                                            )),
                                      ],
                                    );
                                  } else {
                                    return const Center(
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
                                          child: Text(
                                            "Loading...",
                                            style: TextStyle(
                                              fontSize: 28,
                                              color: Colors.teal,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Flow',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                          child: Text(
                                            "Official Monstercat playlists",
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontFamily: 'Flow',
                                            ),
                                          ),
                                        ),
                                        LinearProgressIndicator(
                                          color: Colors.teal,
                                          backgroundColor: Colors.transparent,
                                        ),
                                        SizedBox(
                                          height: 220,
                                        ),
                                      ]),
                                    );
                                  }
                                }), // Official Playlists
                            FutureBuilder(
                                future: getMoods(),
                                builder: (BuildContext context, AsyncSnapshot moods) {
                                  if (moods.hasData) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 15, bottom: 5),
                                          child: Text(
                                            "Moods",
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Comfortaa',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                            padding: const EdgeInsets.only(top: 5, bottom: 15),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(15.0),
                                              child: SizedBox(
                                                  height: 200,
                                                  child: ListView.builder(
                                                      scrollDirection: Axis.horizontal,
                                                      itemCount: moods.data["Moods"]["Data"].length,
                                                      itemBuilder: (BuildContext context, int index) {
                                                        final isFirstItem = index == 0;
                                                        final isLastItem = index == moods.data["Moods"]["Data"].length - 1;
                                                        return Padding(
                                                          padding: EdgeInsets.only(
                                                            left: isFirstItem ? 0.0 : 5.0,
                                                            right: isLastItem ? 0.0 : 5.0,
                                                          ),
                                                          child: GestureDetector(
                                                            onTap: () {
                                                              showModalBottomSheet(
                                                                context: context,
                                                                useRootNavigator: false,
                                                                isScrollControlled: true,
                                                                constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth - 20 : 500),
                                                                enableDrag: true,
                                                                showDragHandle: true,
                                                                shape: const RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                                                ),
                                                                useSafeArea: true,
                                                                backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                                                builder: (BuildContext context) {
                                                                  return moodView(mood: moods.data["Moods"]["Data"][index]["Uri"]);
                                                                },
                                                              );
                                                              // Navigator.push(
                                                              //   topContext,
                                                              //   MaterialPageRoute(fullscreenDialog: true, allowSnapshotting: true, maintainState: true, builder: (context) => moodView(mood: moods.data["Moods"]["Data"][index]["Uri"])),
                                                              // );
                                                            },
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(15.0),
                                                              child: CachedNetworkImage(
                                                                imageUrl: 'https://player.monstercat.app/api/mood/${moods.data["Moods"]["Data"][index]["Id"]}/tile',
                                                                width: 200, // Set the desired width
                                                                height: 200, // Set the desired height
                                                                placeholder: (context, url) => Container(
                                                                  color: Colors.transparent,
                                                                ),
                                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      })),
                                            )),
                                      ],
                                    );
                                  } else {
                                    return const Center(
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
                                          child: Text(
                                            "Loading...",
                                            style: TextStyle(
                                              fontSize: 28,
                                              color: Colors.teal,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Flow',
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                          child: Text(
                                            "A selection of Monstercat songs to fit a variety of moods.",
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontFamily: 'Flow',
                                            ),
                                          ),
                                        ),
                                        LinearProgressIndicator(
                                          color: Colors.teal,
                                          backgroundColor: Colors.transparent,
                                        ),
                                        SizedBox(
                                          height: 220,
                                        ),
                                      ]),
                                    );
                                  }
                                }), // Moods
                            GestureDetector(
                              onTap: () {
                                review.openStoreListing();
                              },
                              child: const mcNotificationCard(title: "Got feedback?", subtitle: "Please, tap this card and share your thoughts", icon: Icons.arrow_forward_rounded),
                            ),
                            const SizedBox(
                              height: 15,
                            )
                          ],
                        )),
                  );
                }
                return SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 45),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30, bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: scaffoldWidth - 134,
                                  child: Text(
                                    greetings[Random().nextInt(greetings.length)],
                                    overflow: TextOverflow.visible,
                                    maxLines: 3,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      height: 1.25,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Comfortaa',
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          topContext,
                                          MaterialPageRoute(fullscreenDialog: true, builder: (ultraTopContext) => const settingsPage()),
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                        child: Icon(
                                          Icons.settings_outlined,
                                          size: 32,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ), // Hello and controls
                          FutureBuilder(
                              future: getAppData(),
                              builder: (BuildContext context, AsyncSnapshot appData) {
                                if (appData.hasData) {
                                  return FutureBuilder(
                                      future: checkKey("shown${appData.data["build"]}"),
                                      builder: (BuildContext context, AsyncSnapshot isInit) {
                                        if (isInit.hasData) {
                                          if (!isInit.data) {
                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setBool("shown${appData.data["build"]}", true);
                                                        Navigator.push(
                                                          topContext,
                                                          MaterialPageRoute(builder: (context) => const changelogPage()),
                                                        );
                                                      },
                                                      child: mcNotificationCard(title: "Update ${appData.data["version"]} [${appData.data["build"]}]", subtitle: "MCPlayer has been updated!\nTap here to read what's new!", icon: Icons.info_outline_rounded),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        }
                                        return Container();
                                      });
                                }
                                return Container();
                              }), // Current Beta info
                          FutureBuilder(
                              future: checkKey("initDone"),
                              builder: (BuildContext context, AsyncSnapshot isInit) {
                                if (isInit.hasData) {
                                  if (!isInit.data) {
                                    return Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                Navigator.push(
                                                  topContext,
                                                  MaterialPageRoute(builder: (context) => const finishSetupPage()),
                                                );
                                              });
                                            },
                                            child: const mcNotificationCard(title: "Finish setup", subtitle: "Tips on using Monstercat at 110% efficiency", icon: Icons.arrow_forward),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }
                                return Container();
                              }), // Finish setup
                          FutureBuilder(
                              future: getRecent(),
                              builder: (BuildContext context, AsyncSnapshot recents) {
                                if (recents.hasData) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Latest release",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 28,
                                            height: 1,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Comfortaa',
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            "${recents.data["Data"][0]["Brand"]} - Released ${DateFormat('MMMM d, y').format(DateTime.parse(recents.data["Data"][0]["Release"]["ReleaseDate"]))}",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              height: 1.5,
                                              color: Colors.grey,
                                              fontFamily: 'Comfortaa',
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              useRootNavigator: true,
                                              isScrollControlled: true,
                                              constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth - 20 : 500),
                                              enableDrag: true,
                                              showDragHandle: true,
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                              ),
                                              useSafeArea: true,
                                              backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                              builder: (BuildContext context) {
                                                return albumView(
                                                  release: recents.data["Data"][0]["Release"]["CatalogId"],
                                                );
                                              },
                                            );
                                            // Navigator.push(
                                            //   topContext,
                                            //   MaterialPageRoute(
                                            //       fullscreenDialog: true,
                                            //       allowSnapshotting: true,
                                            //       maintainState: true,
                                            //       builder: (context) => albumView(
                                            //         release: recents.data["Data"][0]["Release"]["CatalogId"],
                                            //       )),
                                            // );
                                          },
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(right: 10),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(15.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        'https://cdx.monstercat.com/?width=${appSettings["albumArtPreviewRes"] ?? "256"}&encoding=webp&url=https%3A%2F%2Fwww.monstercat.com%2Frelease%2F${recents.data["Data"][0]["Release"]["CatalogId"]}%2Fcover',
                                                    width: 100, // Set the desired width
                                                    height: 100, // Set the desired height
                                                    placeholder: (context, url) => Container(color: Colors.transparent),
                                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 100,
                                                width: scaffoldWidth - 170,
                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                          padding: const EdgeInsets.only(bottom: 5),
                                                          child: Text(
                                                            recents.data["Data"][0]["Title"],
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 1,
                                                            style: const TextStyle(
                                                              fontSize: 24,
                                                              height: 1,
                                                              fontWeight: FontWeight.bold,
                                                              fontFamily: 'Comfortaa',
                                                            ),
                                                          )),
                                                      Text(
                                                        recents.data["Data"][0]["Release"]["ArtistsTitle"],
                                                        maxLines: 1,
                                                        style: const TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.teal,
                                                          fontFamily: 'Comfortaa',
                                                        ),
                                                      ),
                                                      Padding(
                                                          padding: const EdgeInsets.only(top: 5),
                                                          child: Text(
                                                            "${recents.data["Data"][0]["Release"]["Title"]} (${recents.data["Data"][0]["Release"]["Type"]})",
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                            style: const TextStyle(
                                                              fontSize: 18,
                                                              height: 1,
                                                              fontFamily: 'Comfortaa',
                                                            ),
                                                          )),
                                                    ],
                                                  ),
                                                ]),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Latest release",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontSize: 28,
                                            height: 1,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Flow',
                                          ),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Text(
                                            "Loading Date",
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                            style: TextStyle(
                                              fontSize: 18,
                                              height: 1.5,
                                              color: Colors.grey,
                                              fontFamily: 'Flow',
                                            ),
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(15.0),
                                                child: Container(height: 128, width: 128, color: Colors.transparent),
                                              ),
                                            ),
                                            Container(
                                              height: 128,
                                              width: scaffoldWidth - 200,
                                              child: const Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                        padding: EdgeInsets.only(bottom: 5),
                                                        child: Text(
                                                          "Loading...",
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                            fontSize: 24,
                                                            height: 1,
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: 'Flow',
                                                          ),
                                                        )),
                                                    Text(
                                                      "Loading...",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.teal,
                                                        fontFamily: 'Flow',
                                                      ),
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets.only(top: 5),
                                                        child: Text(
                                                          "Loading...",
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            height: 1,
                                                            fontFamily: 'Flow',
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.play_circle_outline_rounded,
                                                          size: 32,
                                                        ),
                                                        Icon(
                                                          Icons.add,
                                                          size: 32,
                                                        ),
                                                      ],
                                                    ),
                                                    Icon(
                                                      Icons.more_vert_rounded,
                                                      size: 32,
                                                    ),
                                                  ],
                                                )
                                              ]),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                }
                              }), // Latest release
                          FutureBuilder(
                              future: getRecent(),
                              builder: (BuildContext context, AsyncSnapshot recents) {
                                if (recents.hasData) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                        child: Text(
                                          "Recent Releases",
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Comfortaa',
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            width: scaffoldWidth / 2 - 30,
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      useRootNavigator: true,
                                                      isScrollControlled: true,
                                                      constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth - 20 : 500),
                                                      enableDrag: true,
                                                      showDragHandle: true,
                                                      shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                                      ),
                                                      useSafeArea: true,
                                                      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                                      builder: (BuildContext context) {
                                                        return albumView(
                                                          release: recents.data["Data"][1]["Release"]["CatalogId"],
                                                        );
                                                      },
                                                    );
                                                    // Navigator.push(
                                                    //   topContext,
                                                    //   MaterialPageRoute(
                                                    //       fullscreenDialog: true,
                                                    //       allowSnapshotting: true,
                                                    //       maintainState: true,
                                                    //       builder: (context) => albumView(
                                                    //         release: recents.data["Data"][1]["Release"]["CatalogId"],
                                                    //       )),
                                                    // );
                                                  },
                                                  child: mcRecentAlbum(
                                                    data: recents.data["Data"][1],
                                                    width: scaffoldWidth / 2 - 30,
                                                    appSettings: appSettings,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      useRootNavigator: true,
                                                      isScrollControlled: true,
                                                      constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth - 20 : 500),
                                                      enableDrag: true,
                                                      showDragHandle: true,
                                                      shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                                      ),
                                                      useSafeArea: true,
                                                      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                                      builder: (BuildContext context) {
                                                        return albumView(
                                                          release: recents.data["Data"][2]["Release"]["CatalogId"],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: mcRecentAlbum(
                                                    data: recents.data["Data"][2],
                                                    width: scaffoldWidth / 2 - 30,
                                                    appSettings: appSettings,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      useRootNavigator: true,
                                                      isScrollControlled: true,
                                                      constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth - 20 : 500),
                                                      enableDrag: true,
                                                      showDragHandle: true,
                                                      shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                                      ),
                                                      useSafeArea: true,
                                                      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                                      builder: (BuildContext context) {
                                                        return albumView(
                                                          release: recents.data["Data"][3]["Release"]["CatalogId"],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: mcRecentAlbum(
                                                    data: recents.data["Data"][3],
                                                    width: scaffoldWidth / 2 - 30,
                                                    appSettings: appSettings,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      useRootNavigator: true,
                                                      isScrollControlled: true,
                                                      constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth - 20 : 500),
                                                      enableDrag: true,
                                                      showDragHandle: true,
                                                      shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                                      ),
                                                      useSafeArea: true,
                                                      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                                      builder: (BuildContext context) {
                                                        return albumView(
                                                          release: recents.data["Data"][4]["Release"]["CatalogId"],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: mcRecentAlbum(
                                                    data: recents.data["Data"][4],
                                                    width: scaffoldWidth / 2 - 30,
                                                    appSettings: appSettings,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: scaffoldWidth / 2 - 30,
                                            child: Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      useRootNavigator: true,
                                                      isScrollControlled: true,
                                                      constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth - 20 : 500),
                                                      enableDrag: true,
                                                      showDragHandle: true,
                                                      shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                                      ),
                                                      useSafeArea: true,
                                                      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                                      builder: (BuildContext context) {
                                                        return albumView(
                                                          release: recents.data["Data"][5]["Release"]["CatalogId"],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: mcRecentAlbum(
                                                    data: recents.data["Data"][5],
                                                    width: scaffoldWidth / 2 - 30,
                                                    appSettings: appSettings,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      useRootNavigator: true,
                                                      isScrollControlled: true,
                                                      constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth - 20 : 500),
                                                      enableDrag: true,
                                                      showDragHandle: true,
                                                      shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                                      ),
                                                      useSafeArea: true,
                                                      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                                      builder: (BuildContext context) {
                                                        return albumView(
                                                          release: recents.data["Data"][6]["Release"]["CatalogId"],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: mcRecentAlbum(
                                                    data: recents.data["Data"][6],
                                                    width: scaffoldWidth / 2 - 30,
                                                    appSettings: appSettings,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      useRootNavigator: true,
                                                      isScrollControlled: true,
                                                      constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth - 20 : 500),
                                                      enableDrag: true,
                                                      showDragHandle: true,
                                                      shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                                      ),
                                                      useSafeArea: true,
                                                      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                                      builder: (BuildContext context) {
                                                        return albumView(
                                                          release: recents.data["Data"][7]["Release"]["CatalogId"],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: mcRecentAlbum(
                                                    data: recents.data["Data"][7],
                                                    width: scaffoldWidth / 2 - 30,
                                                    appSettings: appSettings,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                      context: context,
                                                      useRootNavigator: true,
                                                      isScrollControlled: true,
                                                      constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth - 20 : 500),
                                                      enableDrag: true,
                                                      showDragHandle: true,
                                                      shape: const RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                                      ),
                                                      useSafeArea: true,
                                                      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                                      builder: (BuildContext context) {
                                                        return albumView(
                                                          release: recents.data["Data"][8]["Release"]["CatalogId"],
                                                        );
                                                      },
                                                    );
                                                  },
                                                  child: mcRecentAlbum(
                                                    data: recents.data["Data"][8],
                                                    width: scaffoldWidth / 2 - 30,
                                                    appSettings: appSettings,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  );
                                } else {
                                  return const Center(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                      Padding(
                                        padding: EdgeInsets.all(15),
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
                                      SizedBox(
                                        height: 280,
                                      ),
                                      Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 15, bottom: 15),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "View More",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Flow',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ]),
                                  );
                                }
                              }), // Recent releases
                          FutureBuilder(
                              future: getPlaylists(),
                              builder: (BuildContext context, AsyncSnapshot playlists) {
                                if (playlists.hasData) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 15, bottom: 5),
                                        child: Text(
                                          "Official playlists",
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Comfortaa',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(top: 5, bottom: 15),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15.0),
                                            child: SizedBox(
                                                height: 200,
                                                child: ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount: playlists.data["Menu"]["Sections"][0]["Items"].length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      final isFirstItem = index == 0;
                                                      final isLastItem = index == playlists.data["Menu"]["Sections"][0]["Items"].length - 1;
                                                      return GestureDetector(
                                                        onTap: () {
                                                          showModalBottomSheet(
                                                            context: context,
                                                            useRootNavigator: true,
                                                            isScrollControlled: true,
                                                            constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth - 20 : 500),
                                                            enableDrag: true,
                                                            showDragHandle: true,
                                                            shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                                            ),
                                                            useSafeArea: true,
                                                            backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                                            builder: (BuildContext context) {
                                                              return playistView(playlist: playlists.data["Menu"]["Sections"][0]["Items"][index]["Link"].replaceAll('mcat://playlist:', ''));
                                                            },
                                                          );
                                                        },
                                                        child: Padding(
                                                            padding: EdgeInsets.only(
                                                              left: isFirstItem ? 0.0 : 5.0,
                                                              right: isLastItem ? 0.0 : 5.0,
                                                            ),
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(15.0),
                                                              child: CachedNetworkImage(
                                                                imageUrl: 'https://monstercat.com/api/playlist/${playlists.data["Menu"]["Sections"][0]["Items"][index]["Link"].replaceAll('mcat://playlist:', '')}/tile',
                                                                width: 200, // Set the desired width
                                                                height: 200, // Set the desired height
                                                                placeholder: (context, url) => Container(color: Colors.transparent),
                                                                errorWidget: (context, url, error) => const Icon(Icons.error),
                                                              ),
                                                            )),
                                                      );
                                                    })),
                                          )),
                                    ],
                                  );
                                } else {
                                  return const Center(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
                                        child: Text(
                                          "Loading...",
                                          style: TextStyle(
                                            fontSize: 28,
                                            color: Colors.teal,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Flow',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                        child: Text(
                                          "Official Monstercat playlists",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: 'Flow',
                                          ),
                                        ),
                                      ),
                                      LinearProgressIndicator(
                                        color: Colors.teal,
                                        backgroundColor: Colors.transparent,
                                      ),
                                      SizedBox(
                                        height: 220,
                                      ),
                                    ]),
                                  );
                                }
                              }), // Official Playlists
                          FutureBuilder(
                              future: getMoods(),
                              builder: (BuildContext context, AsyncSnapshot moods) {
                                if (moods.hasData) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 15, bottom: 5),
                                        child: Text(
                                          "Moods",
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Comfortaa',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.only(top: 5, bottom: 15),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(15.0),
                                            child: SizedBox(
                                                height: 200,
                                                child: ListView.builder(
                                                    scrollDirection: Axis.horizontal,
                                                    itemCount: moods.data["Moods"]["Data"].length,
                                                    itemBuilder: (BuildContext context, int index) {
                                                      final isFirstItem = index == 0;
                                                      final isLastItem = index == moods.data["Moods"]["Data"].length - 1;
                                                      return Padding(
                                                        padding: EdgeInsets.only(
                                                          left: isFirstItem ? 0.0 : 5.0,
                                                          right: isLastItem ? 0.0 : 5.0,
                                                        ),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            showModalBottomSheet(
                                                              context: context,
                                                              useRootNavigator: true,
                                                              isScrollControlled: true,
                                                              constraints: BoxConstraints(maxWidth: scaffoldWidth < 500 ? scaffoldWidth - 20 : 500),
                                                              enableDrag: true,
                                                              showDragHandle: true,
                                                              shape: const RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                                                              ),
                                                              useSafeArea: true,
                                                              backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor,
                                                              builder: (BuildContext context) {
                                                                return moodView(mood: moods.data["Moods"]["Data"][index]["Uri"]);
                                                              },
                                                            );
                                                          },
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(15.0),
                                                            child: CachedNetworkImage(
                                                              imageUrl: 'https://player.monstercat.app/api/mood/${moods.data["Moods"]["Data"][index]["Id"]}/tile',
                                                              width: 200, // Set the desired width
                                                              height: 200, // Set the desired height
                                                              placeholder: (context, url) => Container(
                                                                color: Colors.transparent,
                                                              ),
                                                              errorWidget: (context, url, error) => const Icon(Icons.error),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    })),
                                          )),
                                    ],
                                  );
                                } else {
                                  return const Center(
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 5),
                                        child: Text(
                                          "Loading...",
                                          style: TextStyle(
                                            fontSize: 28,
                                            color: Colors.teal,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Flow',
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom: 5),
                                        child: Text(
                                          "A selection of Monstercat songs to fit a variety of moods.",
                                          style: TextStyle(
                                            fontSize: 22,
                                            fontFamily: 'Flow',
                                          ),
                                        ),
                                      ),
                                      LinearProgressIndicator(
                                        color: Colors.teal,
                                        backgroundColor: Colors.transparent,
                                      ),
                                      SizedBox(
                                        height: 220,
                                      ),
                                    ]),
                                  );
                                }
                              }), // Moods
                          GestureDetector(
                            onTap: () {
                              review.openStoreListing();
                            },
                            child: const mcNotificationCard(title: "Got feedback?", subtitle: "Please, tap this card and share our thoughts", icon: Icons.arrow_forward_rounded),
                          ),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      )),
                ); // Replace with your actual widget
              },
            );
          })),
    );
  }
}

class finishSetupPage extends StatefulWidget {
  @override
  finishSetupPageState createState() => finishSetupPageState();

  const finishSetupPage({
    super.key,
  });
}

class finishSetupPageState extends State<finishSetupPage> {
  bool tipsEnabled2FA = false;
  bool tips2FASending = false;
  bool tipsLeftReview = false;
  bool tipsReviewAvailable = false;

  final InAppReview review = InAppReview.instance;

  Future<bool> checkReviewsStatus() async {
    await review.isAvailable().then((value) {
      return value;
    });
    return false;
  }

  @override
  void initState() {
    checkReviewsStatus().then((value) {
      tipsReviewAvailable = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appBarColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: appBarColor,
        systemNavigationBarColor: appBarColor,
        statusBarIconBrightness: MediaQuery.of(context).platformBrightness == Brightness.dark ? Brightness.light : Brightness.dark,
      ),
    );
    return MaterialApp(
      theme: ThemeData(iconTheme: const IconThemeData(color: Colors.teal)),
      darkTheme: ThemeData.dark().copyWith(
        cardColor: const Color(0xFF202020),
        scaffoldBackgroundColor: const Color(0xFF040707),
      ), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: null,
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Open links in app",
                                              style: TextStyle(fontSize: 20, fontFamily: "Comfortaa", fontWeight: FontWeight.bold),
                                            ),
                                            Icon(Icons.info_outline_rounded)
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "Since v.0.0.8, MCPlayer can open links from monstercat web player. To allow it, open Android settings for this app, tap on \"Open by default\", and select all available options in \"Add link\".",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Comfortaa",
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: null,
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Registration is no more",
                                              style: TextStyle(fontSize: 20, fontFamily: "Comfortaa", fontWeight: FontWeight.bold),
                                            ),
                                            Icon(Icons.info_outline_rounded)
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "In v.0.0.15, we've had to remove registration from the app. This is due to Monstercat adding Captcha to the registration flow. You can only register from their website and we will guide you to there if you'll need new account!",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Comfortaa",
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: null,
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Authorisation is no more",
                                              style: TextStyle(fontSize: 20, fontFamily: "Comfortaa", fontWeight: FontWeight.bold),
                                            ),
                                            Icon(Icons.info_outline_rounded)
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          "In v.0.0.16, we've had to remove authrorisation too. Same reason as for registration removal. You can still listen to music, but you can't log in and use your playlists or change your account settings. Unfortunately, from now on this app enables piracy. Please, create your own account, purchase Gold and only then use this app. We can no longer validate if user has Gold access.",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Comfortaa",
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 5,
                                left: 5,
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: const BorderSide(color: Colors.transparent, width: 2),
                                  ),
                                ),
                                onPressed: () {
                                  setBool("initDone", true);
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Done",
                                  style: TextStyle(
                                    fontFamily: "Comfortaa",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7.5),
                              child: Icon(
                                Icons.favorite_outline_rounded,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Thanks for choosing MCPlayer!",
                              style: TextStyle(fontFamily: "Comfortaa", color: Colors.grey, height: 1.25),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))),
      ),
    );
  }
}

class changelogPage extends StatefulWidget {
  @override
  changelogPageState createState() => changelogPageState();

  const changelogPage({
    super.key,
  });
}

class changelogPageState extends State<changelogPage> {
  bool isDarkTheme = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext topContext) {
    final appBarColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: appBarColor,
        systemNavigationBarColor: appBarColor,
        statusBarIconBrightness: MediaQuery.of(context).platformBrightness == Brightness.dark ? Brightness.light : Brightness.dark,
      ),
    );
    return MaterialApp(
      theme: ThemeData(iconTheme: const IconThemeData(color: Colors.teal)),
      darkTheme: ThemeData.dark().copyWith(
        cardColor: const Color(0xFF202020),
        scaffoldBackgroundColor: const Color(0xFF040707),
      ), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          double scaffoldHeight = constraints.maxHeight;
          double scaffoldWidth = constraints.maxWidth;
          if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
            isDarkTheme = true;
          } else {
            isDarkTheme = false;
          }
          final appBarColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF202020) : ThemeData.light().scaffoldBackgroundColor;
          final backgroundColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor;
          final iconColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Brightness.light : Brightness.dark;
          SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: iconColor,
              systemNavigationBarColor: backgroundColor,
            ),
          );
          return SafeArea(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(color: Colors.transparent, width: 1),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(topContext);
                  },
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                          size: 32,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Changelog",
                          style: TextStyle(
                            fontSize: 32,
                            color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                            height: 1,
                            fontFamily: "Comfortaa",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: scaffoldHeight - 94,
                child: FutureBuilder(
                    future: getChangelog(),
                    builder: (BuildContext context, AsyncSnapshot changelog) {
                      if (changelog.hasData) {
                        if (changelog.data == "Error") {
                          return const Center(child: Text("Error while loading"));
                        }
                        return Markdown(
                            data: changelog.data,
                            styleSheet: MarkdownStyleSheet(
                              blockquoteDecoration: const BoxDecoration(color: Color(0x66009688)),
                            ));
                      }
                      return const Center(
                        child: LinearProgressIndicator(
                          color: Colors.teal,
                          backgroundColor: Colors.transparent,
                        ),
                      );
                    }),
              )
            ],
          ));
        }),
      ),
    );
  }
}
