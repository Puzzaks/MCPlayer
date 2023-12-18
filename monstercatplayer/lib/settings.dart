import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:intl/intl.dart';
import 'package:monstercatplayer/home.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yaml/yaml.dart';

import 'elements.dart';
import 'memory.dart';
import 'network.dart';

class settingsPage extends StatefulWidget {
  const settingsPage({super.key});
  @override
  settingsPageState createState() => settingsPageState();
}

class settingsPageState extends State<settingsPage> {
  bool isLoggingOut = false;
  bool idShown = false;
  bool passwordsWrong = false;
  bool isSendingPasswords = false;
  bool nPasswordVisible = false;
  bool oPasswordVisible = false;
  bool reviewLeft = false;
  bool reviewsAvailable = false;
  bool isSending = false;
  bool dataLoaded = false;
  bool locationVariants = false;

  String NewPassword = "";
  String OldPassword = "";
  String locationString = "";

  List locations = [{}];

  Map<String, String> generalUserSettings = {};
  Map userData = {"Id": "", "Email": "", "HasGold": false, "CreatedAt": ""};

  final InAppReview review = InAppReview.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController snameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController nPasswordController = TextEditingController();
  TextEditingController oPasswordController = TextEditingController();

  @override
  void initState() {
    checkReviewsStatus().then((value) {
      reviewsAvailable = value;
      checkKey("reviewed").then((value) {
        reviewLeft = value;
      });
    });
    checkReviewsStatus().then((value) {
      reviewsAvailable = value;
    });
    getUser().then((value) {
      generalUserSettings["FirstName"] = value["User"]["FirstName"];
      generalUserSettings["LastName"] = value["User"]["LastName"];
      generalUserSettings["Birthday"] = value["User"]["Birthday"];
      generalUserSettings["GoogleMapsPlaceId"] = value["User"]["GoogleMapsPlaceId"];
      userData["Id"] = value["User"]["Id"];
      userData["Email"] = value["User"]["Email"];
      userData["CityName"] = value["User"]["PlaceNameFull"];
      userData["HasGold"] = value["User"]["HasGold"];
      userData["CreatedAt"] = value["User"]["CreatedAt"];
      if (value["User"]["Attributes"]["goldPerks"] == null) {
        userData["HadGold"] = false;
      } else {
        userData["HadGold"] = value["User"]["Attributes"]["goldPerks"];
      }
      userData["GivenDownloadAccess"] = value["User"]["GivenDownloadAccess"];
      _loadData().then((value) {
        super.initState();
      });
    });
  }

  Future<bool> checkReviewsStatus() async {
    await review.isAvailable().then((value) {
      return value;
    });
    return false;
  }

  Future<bool> _loadData() async {
    setState(() {
      dataLoaded = true;
      fnameController = TextEditingController(text: generalUserSettings["FirstName"]);
      snameController = TextEditingController(text: generalUserSettings["LastName"]);
      locationController = TextEditingController(text: userData["CityName"]);
      emailController = TextEditingController(text: userData["Email"]);
      dateController = TextEditingController(
        text: DateFormat('dd.MM.yyyy').format(DateTime.parse(generalUserSettings["Birthday"]!)),
      );
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color(0xFFFFFFFF) : Color(0xFF000000);
    final appBarColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color(0xFF202020) : ThemeData.light().scaffoldBackgroundColor;
    final backgroundColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Color(0xFF040707) : ThemeData.light().scaffoldBackgroundColor;
    final iconColor = MediaQuery.of(context).platformBrightness == Brightness.dark ? Brightness.light : Brightness.dark;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: iconColor,
        systemNavigationBarColor: backgroundColor,
      ),
    );
    return MaterialApp(
      theme: ThemeData(
        iconTheme: const IconThemeData(color: Colors.teal),
      ),
      darkTheme: ThemeData.dark().copyWith(cardColor: Color(0xFF202020), scaffoldBackgroundColor: const Color(0xFF040707)), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: dataLoaded
                ? Padding(
                    padding: EdgeInsets.all(5),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: const BorderSide(color: Colors.transparent, width: 1),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.arrow_back_rounded,
                                    color: textColor,
                                    size: 32,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "Settings",
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 32,
                                      height: 1,
                                      fontFamily: "Comfortaa",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            "  ACCOUNT INFORMATION",
                            style: TextStyle(
                              height: 2,
                              fontSize: 14,
                              fontFamily: "Comfortaa",
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: GestureDetector(
                              child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Your ID",
                                              style: const TextStyle(fontSize: 20, fontFamily: "Comfortaa", fontWeight: FontWeight.bold),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Clipboard.setData(ClipboardData(text: userData["Id"]));
                                              },
                                              child: Text(
                                                "Copy",
                                                style: const TextStyle(fontSize: 14, fontFamily: "Comfortaa", color: Colors.teal, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        idShown
                                            ? Text(
                                                userData["Id"],
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Comfortaa",
                                                ),
                                              )
                                            : Text(
                                                "Tap to reveal Monstercat ID",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Comfortaa",
                                                ),
                                              ),
                                      ],
                                    ),
                                  )),
                              onTap: () {
                                setState(() {
                                  idShown = !idShown;
                                });
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Gold",
                                              style: const TextStyle(fontSize: 20, fontFamily: "Comfortaa", fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              userData["HasGold"] ? "Subscribed" : "Not subscribed",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Comfortaa",
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                ),
                                Expanded(
                                  child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Gold Perks",
                                              style: const TextStyle(fontSize: 20, fontFamily: "Comfortaa", fontWeight: FontWeight.bold),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              userData["HadGold"] ? "Active" : "None",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Comfortaa",
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 7.5),
                                child: Icon(
                                  Icons.info_outline_rounded,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                width: 12.5,
                              ),
                              Text(
                                "Account created: ${DateFormat('dd.MM.yyyy').format(DateTime.parse(userData["CreatedAt"]))}",
                                style: const TextStyle(fontFamily: "Comfortaa", color: Colors.grey, height: 1.25),
                              ),
                            ],
                          ),
                          const Text(
                            "  ACCOUNT SETTINGS",
                            style: TextStyle(
                              height: 2.5,
                              fontSize: 14,
                              fontFamily: "Comfortaa",
                              color: Colors.teal,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: const BorderSide(color: Colors.transparent, width: 1),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => generalSettingsPage(
                                          dateController: dateController,
                                          fnameController: fnameController,
                                          generalUserSettings: generalUserSettings,
                                          locationController: locationController,
                                          userData: userData,
                                          snameController: snameController,
                                        )),
                              );
                            },
                            child: const mcJumpSettingsButton(icon: Icons.person_outline_rounded, title: "User Information", subtitle: "Enter your name, birthday or location"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: const BorderSide(color: Colors.transparent, width: 1),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => userSettingsPage(
                                          userData: userData,
                                          nPasswordController: nPasswordController,
                                          oPasswordController: oPasswordController,
                                          emailController: emailController,
                                        )),
                              );
                            },
                            child: mcJumpSettingsButton(icon: Icons.lock_person_outlined, title: "Account and Security", subtitle: "Change your email, password and 2FA"),
                          ),
                          const Text(
                            "APP SETTINGS",
                            style: TextStyle(
                              height: 2.5,
                              fontSize: 14,
                              fontFamily: "Comfortaa",
                              color: Colors.teal,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: const BorderSide(color: Colors.transparent, width: 1),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => playerSettingsPage()),
                              );
                            },
                            child: mcJumpSettingsButton(icon: Icons.tune_rounded, title: "Player settings", subtitle: "Tweak your experience"),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: const BorderSide(color: Colors.transparent, width: 1),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => aboutSettingsPage()),
                              );
                            },
                            child: mcJumpSettingsButton(icon: Icons.info_outline_rounded, title: "About MCPlayer", subtitle: "Thanks, credentials and more info"),
                          ),
                          FutureBuilder(
                              future: checkReviewsStatus(),
                              builder: (BuildContext context, AsyncSnapshot reviewAval) {
                                if (reviewAval.hasData) {
                                  return ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: EdgeInsets.all(10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15.0),
                                        side: const BorderSide(color: Colors.transparent, width: 1),
                                      ),
                                    ),
                                    onPressed: () async {
                                      review.openStoreListing();
                                    },
                                    child: mcJumpSettingsButton(icon: Icons.star_outline_rounded, title: "Review MCPlayer", subtitle: "Leave the review on Play Store"),
                                  );
                                }
                                return Container();
                              }),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                                side: const BorderSide(color: Colors.transparent, width: 1),
                              ),
                            ),
                            onPressed: () async {
                              setState(() {
                                isLoggingOut = true;
                              });
                              await sendLogout().then((value) async {
                                if (value == "true") {
                                  await clearKey("session").then((value) async {
                                    await clearKey("signed in").then((value) async {
                                      setState(() {
                                        isLoggingOut = false;
                                        Restart.restartApp();
                                      });
                                    });
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                    msg: 'Issue while logging out, try clearing app data',
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                  );
                                  setState(() {
                                    isLoggingOut = false;
                                  });
                                }
                              });
                            },
                            child: mcJumpSettingsButton(icon: isLoggingOut ? Icons.delete_sweep_outlined : Icons.logout_rounded, title: "Log out", subtitle: isLoggingOut ? "Logging out..." : "Log out and restart app"),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container()),
      ),
    );
  }
}

class generalSettingsPage extends StatefulWidget {
  final Map<String, String> generalUserSettings;
  final TextEditingController fnameController;
  final TextEditingController snameController;
  final TextEditingController locationController;
  final TextEditingController dateController;
  final Map userData;
  const generalSettingsPage({super.key, required this.generalUserSettings, required this.fnameController, required this.snameController, required this.locationController, required this.dateController, required this.userData});
  @override
  generalSettingsPageState createState() => generalSettingsPageState();
}

class generalSettingsPageState extends State<generalSettingsPage> {
  bool isSending = false;
  List locations = [{}];
  bool locationVariants = false;
  String locationString = "";

  TextEditingController fnameController = TextEditingController();
  TextEditingController snameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  Map<String, String> generalUserSettings = {};
  Map<String, String> userData = {};
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    generalUserSettings = widget.generalUserSettings;
    Map userData = widget.userData;
    locationString = userData["CityName"];
    fnameController = widget.fnameController;
    snameController = widget.snameController;
    locationController = TextEditingController(text: locationString);
    dateController = TextEditingController(
      text: DateFormat('dd.MM.yyyy').format(DateTime.parse(generalUserSettings["Birthday"]!)),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF040707),
      ), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                              size: 32,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "User information",
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
                    const Text(
                      "  USER DATA",
                      style: TextStyle(
                        height: 2,
                        fontSize: 14,
                        fontFamily: "Comfortaa",
                        color: Colors.teal,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 5, top: 10),
                            child: TextField(
                              controller: fnameController,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(fontFamily: 'Comfortaa', height: 1),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    strokeAlign: BorderSide.strokeAlignInside,
                                    color: Colors.teal,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.teal,
                                    width: 2.0,
                                  ),
                                ),
                                labelText: 'First Name (required)',
                                labelStyle: TextStyle(color: Colors.grey),
                              ),
                              onChanged: (value) async {
                                generalUserSettings["FirstName"] = value;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15, left: 5, top: 10),
                            child: TextField(
                              controller: snameController,
                              textInputAction: TextInputAction.next,
                              style: const TextStyle(fontFamily: 'Comfortaa', height: 1),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    strokeAlign: BorderSide.strokeAlignInside,
                                    color: Colors.teal,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.teal,
                                    width: 2.0,
                                  ),
                                ),
                                focusColor: Colors.teal,
                                labelText: "Last name",
                                labelStyle: TextStyle(color: Colors.grey),
                              ),
                              onChanged: (value) async {
                                generalUserSettings["LastName"] = value;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: TextField(
                        controller: dateController,
                        enableInteractiveSelection: false,
                        enabled: true,
                        onChanged: null,
                        onTap: () async {
                          await showDatePicker(context: context, initialDate: DateTime.parse(generalUserSettings["Birthday"]!), firstDate: DateTime(1950), lastDate: DateTime.now()).then((value) {
                            generalUserSettings["Birthday"] = "${value!.toIso8601String()}Z";
                            setState(() {
                              dateController = TextEditingController(
                                text: DateFormat('dd.MM.yyyy').format(value),
                              );
                            });
                          });
                        },
                        keyboardType: TextInputType.none,
                        textInputAction: TextInputAction.none,
                        showCursor: false,
                        style: const TextStyle(fontFamily: 'Comfortaa', height: 1),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(
                              strokeAlign: BorderSide.strokeAlignInside,
                              color: Colors.teal,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.teal,
                              width: 2.0,
                            ),
                          ),
                          hintText: 'Enter you birthday',
                          focusColor: Colors.teal,
                          labelText: "Birthday",
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(
                            fontFamily: 'Comfortaa',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: locationController,
                              textInputAction: TextInputAction.none,
                              style: const TextStyle(fontFamily: 'Comfortaa', height: 1),
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    strokeAlign: BorderSide.strokeAlignInside,
                                    color: Colors.teal,
                                    width: 2.0,
                                  ),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.teal,
                                    width: 2.0,
                                  ),
                                ),
                                focusColor: Colors.teal,
                                labelText: "Location",
                                labelStyle: TextStyle(color: Colors.grey),
                              ),
                              onChanged: (value) async {
                                locationString = value;
                                await searchLocation(value).then((value) {
                                  locations = value["Results"];
                                  setState(() {
                                    locationVariants = true;
                                  });
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    locationVariants
                        ? Container(
                            height: 44,
                            width: double.infinity,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10, right: 10),
                                child: Wrap(
                                  spacing: 10.0, // Adjust the spacing between chips as needed
                                  runSpacing: -7.5, // Adjust the run spacing as needed
                                  children: locations
                                      .map((option) {
                                        return GestureDetector(
                                          onTap: () async {
                                            locationString = option["Description"];
                                            generalUserSettings["GoogleMapsPlaceId"] = option["PlaceId"];
                                            locationController = TextEditingController(text: option["Description"]);
                                            setState(() {
                                              locationVariants = false;
                                            });
                                          },
                                          child: Chip(
                                            label: Text(
                                              option["Description"],
                                              style: const TextStyle(
                                                fontFamily: 'Comfortaa',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Color(0xFF040707) : Colors.transparent,
                                            elevation: 5.0,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Colors.teal, // Border color
                                                width: 2.0, // Border width
                                              ),
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        );
                                      })
                                      .toList()
                                      .cast<Widget>(),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  side: const BorderSide(color: Colors.teal, width: 2),
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  isSending = true;
                                });
                                await setUser(generalUserSettings).then((value) {
                                  if (value) {
                                    Fluttertoast.showToast(
                                      msg: 'Saved',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                    setState(() {
                                      isSending = false;
                                    });
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: 'Failed to save settings',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                    setState(() {
                                      isSending = false;
                                    });
                                  }
                                });
                              },
                              child: isSending
                                  ? const LinearProgressIndicator(
                                      color: Colors.white,
                                      backgroundColor: Colors.transparent,
                                    )
                                  : const Text(
                                      "Save changes",
                                      style: TextStyle(
                                        fontFamily: "Comfortaa",
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class userSettingsPage extends StatefulWidget {
  final Map userData;
  final TextEditingController nPasswordController;
  final TextEditingController oPasswordController;
  final TextEditingController emailController;
  const userSettingsPage({super.key, required this.userData, required this.nPasswordController, required this.oPasswordController, required this.emailController});
  @override
  userSettingsPageState createState() => userSettingsPageState();
}

class userSettingsPageState extends State<userSettingsPage> {
  bool passwordsWrong = false;
  bool isSendingPasswords = false;
  bool nPasswordVisible = false;
  bool oPasswordVisible = false;
  String NewPassword = "";
  String OldPassword = "";
  TextEditingController nPasswordController = TextEditingController();
  TextEditingController oPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  Map<String, String> userData = {};

  @override
  void initState() {
    Map userData = widget.userData;
    emailController = widget.emailController;
    nPasswordController = widget.nPasswordController;
    oPasswordController = widget.oPasswordController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF040707),
      ), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                              size: 32,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "Your account",
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
                    const Text(
                      "  ACCOUNT SETTINGS",
                      style: TextStyle(
                        height: 2,
                        fontSize: 14,
                        fontFamily: "Comfortaa",
                        color: Colors.teal,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => emailSettingsPage(
                                    emailController: emailController,
                                    userData: userData,
                                  )),
                        );
                      },
                      child: mcJumpSettingsButton(icon: Icons.email_outlined, title: "Email settings", subtitle: "Update your email address"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => passwordSettingsPage(
                                    nPasswordController: nPasswordController,
                                    oPasswordController: oPasswordController,
                                  )),
                        );
                      },
                      child: mcJumpSettingsButton(icon: Icons.password_rounded, title: "Password settings", subtitle: "Change your password"),
                    ),
                    const Text(
                      "  EXTERNAL LINKS",
                      style: TextStyle(
                        height: 3,
                        fontSize: 14,
                        fontFamily: "Comfortaa",
                        color: Colors.teal,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      onPressed: () {
                        launchUrl(Uri.parse("https://monstercat.com/settings/my-account#two-factor-TOTP"), mode: LaunchMode.externalApplication);
                      },
                      child: mcJumpSettingsButton(icon: Icons.security_rounded, title: "2FA Settings", subtitle: "Set up two-factor autentication"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      onPressed: () {
                        launchUrl(Uri.parse("https://monstercat.com/settings/gold-subscription"), mode: LaunchMode.externalApplication);
                      },
                      child: mcJumpSettingsButton(icon: Icons.payment_rounded, title: "Monstercat Gold", subtitle: "Manage your subscription"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      onPressed: () {
                        launchUrl(Uri.parse("https://monstercat.com/settings/connections"), mode: LaunchMode.externalApplication);
                      },
                      child: mcJumpSettingsButton(icon: Icons.link_rounded, title: "Linked accounts", subtitle: "Edit connected accounts"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      onPressed: () {
                        launchUrl(Uri.parse("https://monstercat.com/settings/creator-licenses"), mode: LaunchMode.externalApplication);
                      },
                      child: mcJumpSettingsButton(icon: Icons.music_video_rounded, title: "Creator licenses", subtitle: "Update licenses and remove claims"),
                    ),
                    GestureDetector(
                      onTap: () {
                        launchUrl(Uri.parse("https://monstercat.com/settings/my-account"), mode: LaunchMode.externalApplication);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 7.5),
                              child: Icon(
                                Icons.info_outline_rounded,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              width: 12.5,
                            ),
                            Text(
                              "See more settings at Monstercat.com",
                              style: TextStyle(fontFamily: "Comfortaa", color: Colors.teal.withAlpha(200), height: 1.25),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class passwordSettingsPage extends StatefulWidget {
  final TextEditingController nPasswordController;
  final TextEditingController oPasswordController;
  const passwordSettingsPage({
    super.key,
    required this.nPasswordController,
    required this.oPasswordController,
  });
  @override
  passwordSettingsPageState createState() => passwordSettingsPageState();
}

class passwordSettingsPageState extends State<passwordSettingsPage> {
  String reasonWrong = "";
  bool passwordsWrong = false;
  bool isSendingPasswords = false;
  bool nPasswordVisible = false;
  bool oPasswordVisible = false;
  String NewPassword = "";
  String OldPassword = "";

  TextEditingController nPasswordController = TextEditingController();
  TextEditingController oPasswordController = TextEditingController();

  void toggleNpwdVis() {
    if (nPasswordVisible) {
      setState(() {
        nPasswordVisible = false;
      });
    } else {
      setState(() {
        nPasswordVisible = true;
      });
    }
  }

  void toggleOpwdVis() {
    if (oPasswordVisible) {
      setState(() {
        oPasswordVisible = false;
      });
    } else {
      setState(() {
        oPasswordVisible = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF040707),
      ), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                              size: 32,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "Password",
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
                    const Text(
                      "  PASSWORD SETTINGS",
                      style: TextStyle(
                        height: 2,
                        fontSize: 14,
                        fontFamily: "Comfortaa",
                        color: Colors.teal,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5, top: 5, bottom: 5),
                                  child: TextField(
                                    controller: oPasswordController,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: !oPasswordVisible,
                                    style: const TextStyle(
                                      fontFamily: 'Comfortaa',
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
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
                                          color: OldPassword.length > 5 ? Colors.teal : Colors.red, // Set the focused border color
                                          width: 2.0,
                                        ),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: OldPassword.length > 5 ? Colors.teal : Colors.red,
                                          width: 2.0,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: OldPassword.length > 5 ? Colors.teal : Colors.red,
                                          width: 2.0,
                                        ),
                                      ),
                                      labelText: 'Current password',
                                      labelStyle: TextStyle(color: Colors.grey),
                                    ),
                                    onChanged: (value) async {
                                      setState(() {
                                        passwordsWrong = false;
                                        OldPassword = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5, top: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    toggleOpwdVis();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: (Icon(
                                      oPasswordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                      color: oPasswordVisible ? null : Colors.grey,
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ), // Password old
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5, top: 5, bottom: 5),
                                  child: TextField(
                                    controller: nPasswordController,
                                    textInputAction: TextInputAction.done,
                                    keyboardType: TextInputType.visiblePassword,
                                    obscureText: !nPasswordVisible,
                                    style: const TextStyle(
                                      fontFamily: 'Comfortaa',
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
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
                                          color: NewPassword.length > 5 ? Colors.teal : Colors.red, // Set the focused border color
                                          width: 2.0,
                                        ),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: NewPassword.length > 5 ? Colors.teal : Colors.red,
                                          width: 2.0,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: NewPassword.length > 5 ? Colors.teal : Colors.red,
                                          width: 2.0,
                                        ),
                                      ),
                                      labelText: 'New password',
                                      labelStyle: TextStyle(color: Colors.grey),
                                    ),
                                    onChanged: (value) async {
                                      setState(() {
                                        passwordsWrong = false;
                                        NewPassword = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5, top: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    toggleNpwdVis();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: (Icon(
                                      nPasswordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                      color: nPasswordVisible ? null : Colors.grey,
                                    )),
                                  ),
                                ),
                              ),
                            ],
                          ), // Password new
                          passwordsWrong
                              ? Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.info_outline_rounded,
                                        color: Colors.red,
                                      ),
                                      Text(
                                        " $reasonWrong",
                                        maxLines: 2,
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          height: 1.5,
                                          fontSize: 18,
                                          fontFamily: "Comfortaa",
                                          color: Colors.red,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Container(),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 0,
                                    bottom: 5,
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: (OldPassword.length > 5 && NewPassword.length > 5 && !passwordsWrong) ? Colors.teal : Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                        side: BorderSide(color: Colors.transparent, width: 2),
                                      ),
                                    ),
                                    onPressed: (OldPassword.length > 5 && NewPassword.length > 5 && !passwordsWrong)
                                        ? () async {
                                            setState(() {
                                              isSendingPasswords = true;
                                            });
                                            setPassword(NewPassword, OldPassword).then((value) {
                                              if (value == true) {
                                                setState(() {
                                                  isSendingPasswords = false;
                                                });
                                                Fluttertoast.showToast(
                                                  msg: 'Password updated, careful',
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                );
                                              } else {
                                                setState(() {
                                                  passwordsWrong = true;
                                                  reasonWrong = value;
                                                  isSendingPasswords = false;
                                                });
                                                Fluttertoast.showToast(
                                                  msg: value,
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                );
                                              }
                                            });
                                          }
                                        : null,
                                    child: isSendingPasswords
                                        ? const LinearProgressIndicator(
                                            color: Colors.white,
                                            backgroundColor: Colors.transparent,
                                          )
                                        : Text(
                                            "Update password",
                                            style: TextStyle(
                                              fontFamily: "Comfortaa",
                                              fontWeight: FontWeight.bold,
                                              color: (OldPassword.length > 5 && NewPassword.length > 5 && !passwordsWrong)
                                                  ? Colors.white
                                                  : MediaQuery.of(context).platformBrightness == Brightness.dark
                                                      ? Colors.white
                                                      : Colors.black,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class emailSettingsPage extends StatefulWidget {
  final TextEditingController emailController;
  final Map<String, String> userData;
  const emailSettingsPage({
    super.key,
    required this.emailController,
    required this.userData,
  });
  @override
  emailSettingsPageState createState() => emailSettingsPageState();
}

class emailSettingsPageState extends State<emailSettingsPage> {
  bool isSending = false;
  String initialEmail = "";
  TextEditingController emailController = TextEditingController();
  Map<String, String> userData = {};
  List<String> emailVariants = ["gmail.com", "outlook.com", "yahoo.com"];

  @override
  void initState() {
    Map<String, String> userData = widget.userData;
    emailController = widget.emailController;
    initialEmail = emailController.text;
    super.initState();
  }

  bool validateEmail(String input) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(input);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF040707),
      ), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                              size: 32,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "User information",
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
                    const Text(
                      "  EMAIL SETTINGS",
                      style: TextStyle(
                        height: 2,
                        fontSize: 14,
                        fontFamily: "Comfortaa",
                        color: Colors.teal,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Current email address",
                            style: TextStyle(
                              height: 2,
                              fontSize: 14,
                              fontFamily: "Comfortaa",
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            initialEmail,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              height: 1.25,
                              fontSize: 16,
                              fontFamily: "Comfortaa",
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 5),
                                  child: TextField(
                                    controller: emailController,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(
                                      fontFamily: 'Comfortaa',
                                    ),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 0),
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
                                          color: validateEmail(emailController.text) ? Colors.teal : Colors.red, // Set the focused border color
                                          width: 2.0,
                                        ),
                                      ),
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: validateEmail(emailController.text) ? Colors.teal : Colors.red,
                                          width: 2.0,
                                        ),
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: validateEmail(emailController.text) ? Colors.teal : Colors.red,
                                          width: 2.0,
                                        ),
                                      ),
                                      labelText: 'New email address',
                                      labelStyle: TextStyle(color: Colors.grey),
                                    ),
                                    onChanged: (value) async {
                                      setState(() {
                                        userData["Email"] = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            height: 44,
                            width: double.infinity,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.only(),
                                child: Wrap(
                                  spacing: 10.0, // Adjust the spacing between chips as needed
                                  runSpacing: -7.5, // Adjust the run spacing as needed
                                  children: emailVariants
                                      .map((option) {
                                        return GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              emailController = TextEditingController(text: "${emailController.text.split("@")[0]}@$option");
                                            });
                                          },
                                          child: Chip(
                                            shadowColor: Colors.transparent,
                                            avatar: Icon(
                                              Icons.alternate_email_rounded,
                                            ),
                                            label: Text(
                                              option,
                                              style: const TextStyle(
                                                fontFamily: 'Comfortaa',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? Color(0xFF040707) : Colors.transparent,
                                            elevation: 5.0,
                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(
                                                color: Colors.teal, // Border color
                                                width: 2.0, // Border width
                                              ),
                                              borderRadius: BorderRadius.circular(16.0),
                                            ),
                                          ),
                                        );
                                      })
                                      .toList()
                                      .cast<Widget>(),
                                ),
                              ),
                            ),
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
                                      backgroundColor: validateEmail(emailController.text) ? Colors.teal : Colors.red.withAlpha(128),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20.0),
                                        side: BorderSide(color: validateEmail(emailController.text) ? Colors.teal : Colors.red.withAlpha(128), width: 2),
                                      ),
                                    ),
                                    onPressed: validateEmail(emailController.text)
                                        ? () async {
                                            setState(() {
                                              isSending = true;
                                              setEmail(emailController.text).then((value) {
                                                if (value) {
                                                  Fluttertoast.showToast(
                                                    msg: 'Email updated, careful',
                                                    toastLength: Toast.LENGTH_SHORT,
                                                    gravity: ToastGravity.BOTTOM,
                                                  );
                                                  setState(() {
                                                    isSending = false;
                                                    initialEmail = emailController.text;
                                                  });
                                                }
                                              });
                                            });
                                          }
                                        : () async {
                                            Fluttertoast.showToast(
                                              msg: 'Wrong email format',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                            );
                                          },
                                    child: isSending
                                        ? const LinearProgressIndicator(
                                            color: Colors.white,
                                            backgroundColor: Colors.transparent,
                                          )
                                        : Text(
                                            "Update email",
                                            style: TextStyle(
                                              fontFamily: "Comfortaa",
                                              fontWeight: FontWeight.bold,
                                              color: validateEmail(emailController.text) ? Colors.white : Colors.grey,
                                            ),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class playerSettingsPage extends StatefulWidget {
  const playerSettingsPage({super.key});
  @override
  playerSettingsPageState createState() => playerSettingsPageState();
}

class playerSettingsPageState extends State<playerSettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF040707),
      ), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                              size: 32,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "Player settings",
                              style: TextStyle(
                                color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                fontSize: 32,
                                height: 1,
                                fontFamily: "Comfortaa",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      "  APP SETTINGS",
                      style: TextStyle(
                        height: 2,
                        fontSize: 14,
                        fontFamily: "Comfortaa",
                        color: Colors.teal,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => cacheSettingsPage()),
                        );
                      },
                      child: mcJumpSettingsButton(icon: Icons.data_saver_off_rounded, title: "Downloads & Cache", subtitle: "Manage saved content"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => cacheSettingsPage()),
                        // );
                      },
                      child: mcJumpSettingsButton(icon: Icons.image_outlined, title: "Image quality settings", subtitle: "Set up resolutions for album art"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => cacheSettingsPage()),
                        // );
                      },
                      child: mcJumpSettingsButton(icon: Icons.music_note_outlined, title: "Music quality settings", subtitle: "Change music quality"),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class cacheSettingsPage extends StatefulWidget {
  const cacheSettingsPage({super.key});
  @override
  cacheSettingsPageState createState() => cacheSettingsPageState();
}

class cacheSettingsPageState extends State<cacheSettingsPage> {
  String formatSize(int size) {
    if (size < 1024) {
      return '$size B';
    } else if (size < 10240) {
      double sizeKb = size / 1024;
      return '${sizeKb.toStringAsFixed(2)} KB';
    } else if (size < 1048576) {
      double sizeKb = size / 1024;
      return '${sizeKb.toStringAsFixed(1)} KB';
    } else if (size < 10485760) {
      double sizeMb = size / 1048576;
      return '${sizeMb.toStringAsFixed(2)} MB';
    } else if (size < 104857600) {
      double sizeMb = size / 1048576;
      return '${sizeMb.toStringAsFixed(1)} MB';
    } else {
      double sizeMb = size / 1048576;
      return '${sizeMb.toInt()} MB';
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext topContext) {
    return MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark().copyWith(
        cardColor: Color(0xFF202020),
        scaffoldBackgroundColor: const Color(0xFF040707),
      ), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        double scaffoldHeight = constraints.maxHeight;
        double scaffoldWidth = constraints.maxWidth;
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
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
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              size: 32,
                            ),
                          ),
                          Container(
                            width: scaffoldWidth - 80,
                            child: const Text(
                              "Storage usage",
                              style: TextStyle(
                                fontSize: 32,
                                height: 1.25,
                                fontFamily: "Comfortaa",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      "CACHE",
                      style: TextStyle(
                        height: 3,
                        fontSize: 14,
                        fontFamily: "Comfortaa",
                        color: Colors.teal,
                      ),
                    ),
                    FutureBuilder(
                      future: cacheInfo(),
                      builder: (BuildContext context, AsyncSnapshot cache) {
                        if (cache.hasData) {
                          double musicWidth = (((scaffoldWidth - 55) / 100) * ((100 / cache.data["size"]) * cache.data["music"]["size"]));
                          double imagesWidth = (((scaffoldWidth - 50) / 100) * ((100 / cache.data["size"]) * cache.data["images"]["size"]));
                          double imagesPercent = (100 / cache.data["size"]) * cache.data["images"]["size"];
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Container(
                                                      width: imagesPercent < 75
                                                          ? imagesPercent > 75
                                                              ? ((scaffoldWidth - 55) / 100) * 25
                                                              : imagesWidth
                                                          : ((scaffoldWidth - 55) / 100) * 75,
                                                      child: Center(
                                                        child: Text(
                                                          formatSize(cache.data["images"]["size"]),
                                                          style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: "Comfortaa",
                                                          ),
                                                        ),
                                                      )),
                                                  Container(
                                                      width: imagesPercent < 75
                                                          ? imagesPercent > 75
                                                              ? ((scaffoldWidth - 55) / 100) * 75
                                                              : musicWidth
                                                          : ((scaffoldWidth - 55) / 100) * 25,
                                                      child: Center(
                                                          child: Text(
                                                        formatSize(cache.data["music"]["size"]),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.visible,
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: "Comfortaa",
                                                        ),
                                                      ))),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 2,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  ClipRRect(
                                                      borderRadius: BorderRadius.circular(20),
                                                      child: Container(
                                                        color: Colors.teal,
                                                        height: 5,
                                                        width: imagesWidth,
                                                      )),
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(20),
                                                    child: Container(
                                                      color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                                      height: 5,
                                                      width: musicWidth,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Images",
                                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "Comfortaa", color: Colors.grey),
                                                  ),
                                                  Text(
                                                    "Music",
                                                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "Comfortaa", color: Colors.grey),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                            color: Colors.teal,
                          );
                        }
                      },
                    ),
                    const Text(
                      "DOWNLOADS",
                      style: TextStyle(
                        height: 3,
                        fontSize: 14,
                        fontFamily: "Comfortaa",
                        color: Colors.teal,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                            width: (scaffoldWidth - 70) / 2,
                                            child: Center(
                                              child: Text(
                                                "-",
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "Comfortaa",
                                                ),
                                              ),
                                            )),
                                        Container(
                                            width: (scaffoldWidth - 70) / 2,
                                            child: Center(
                                                child: Text(
                                              "-",
                                              maxLines: 1,
                                              overflow: TextOverflow.visible,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Comfortaa",
                                              ),
                                            ))),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
                                            child: Container(
                                              color: Colors.teal,
                                              height: 5,
                                              width: (scaffoldWidth - 70) / 2,
                                            )),
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: Container(
                                            color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                            height: 5,
                                            width: (scaffoldWidth - 70) / 2,
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Images",
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "Comfortaa", color: Colors.grey),
                                        ),
                                        Text(
                                          "Music",
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: "Comfortaa", color: Colors.grey),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                )),
          ),
        );
      })),
    );
  }
}

class aboutSettingsPage extends StatefulWidget {
  const aboutSettingsPage({super.key});
  @override
  aboutSettingsPageState createState() => aboutSettingsPageState();
}

class aboutSettingsPageState extends State<aboutSettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<int> getPackagesCount() async {
    Map dependencies = jsonDecode(jsonEncode(loadYaml(await rootBundle.loadString("pubspec.yaml"))["dependencies"]));
    return dependencies.length - 1;
  }

  Future<Map> getAppData() async {
    final info = await PackageInfo.fromPlatform();
    final output = {
      "version": info.version,
      "build": info.buildNumber,
    };
    return output;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark().copyWith(
        cardColor: Color(0xFF202020),
        scaffoldBackgroundColor: const Color(0xFF040707),
      ), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                              size: 32,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              "About",
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
                    const Text(
                      "  APP INFORMATION",
                      style: TextStyle(
                        height: 2,
                        fontSize: 14,
                        fontFamily: "Comfortaa",
                        color: Colors.teal,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Fluttertoast.showToast(
                                msg: 'Stop tapping everywhere!',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                              launchUrl(Uri.parse("https://youtube.com/watch?v=dQw4w9WgXcQ"), mode: LaunchMode.externalApplication);
                            },
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(15),
                                        child: MediaQuery.of(context).platformBrightness == Brightness.light
                                            ? ColorFiltered(
                                                colorFilter: ColorFilter.matrix([
                                                  -1, 0, 0, 0, 255, // Red channel
                                                  0, -1, 0, 0, 255, // Green channel
                                                  0, 0, -1, 0, 255, // Blue channel
                                                  0, 0, 0, 1, 0, // Alpha channel
                                                ]),
                                                child: Image.asset(
                                                  "assets/app_logo.png",
                                                  height: 64,
                                                ),
                                              )
                                            : Image.asset(
                                                "assets/app_logo.png",
                                                height: 64,
                                              ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "MCPlayer",
                                        style: const TextStyle(fontSize: 32, fontFamily: "Comfortaa", fontWeight: FontWeight.bold),
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
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "MCPlayer",
                                        style: const TextStyle(fontSize: 20, fontFamily: "Comfortaa", fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      FutureBuilder(
                                        future: getAppData(),
                                        builder: (BuildContext context, AsyncSnapshot appData) {
                                          if (appData.hasData) {
                                            return Text(
                                              "Version ${appData.data["version"]} [${appData.data["build"]}]",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Comfortaa",
                                              ),
                                            );
                                          } else {
                                            return LinearProgressIndicator(
                                              backgroundColor: Colors.transparent,
                                              color: Colors.teal,
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                )),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => changelogPage()),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => packagesSettingsPage()),
                              );
                            },
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Packages",
                                            style: const TextStyle(fontSize: 20, fontFamily: "Comfortaa", fontWeight: FontWeight.bold),
                                          ),
                                          Icon(
                                            Icons.info_outline_rounded,
                                            color: Colors.teal,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      FutureBuilder(
                                        future: getPackagesCount(),
                                        builder: (BuildContext context, AsyncSnapshot packages) {
                                          if (packages.hasData) {
                                            return Text(
                                              "${packages.data.toString()} installed",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontFamily: "Comfortaa",
                                              ),
                                            );
                                          } else {
                                            return LinearProgressIndicator(
                                              backgroundColor: Colors.transparent,
                                              color: Colors.teal,
                                            );
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        )
                      ],
                    ),
                    const Text(
                      "  ABOUT MCPLAYER",
                      style: TextStyle(
                        height: 3,
                        fontSize: 14,
                        fontFamily: "Comfortaa",
                        color: Colors.teal,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => creatorsSettingsPage()),
                        );
                      },
                      child: mcJumpSettingsButton(icon: Icons.people_outlined, title: "Creators", subtitle: "Learn who's behind MCPlayer"),
                    ), // Creators
                    ElevatedButton(
                      onPressed: () async {
                        launchUrl(
                            Uri(
                              scheme: 'mailto',
                              path: 'puzzaks@gmail.com',
                              queryParameters: {
                                'subject': 'MCPlayer_Feedback',
                              },
                            ),
                            mode: LaunchMode.externalApplication);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      child: mcJumpSettingsButton(icon: Icons.email_outlined, title: "Send feedback", subtitle: "Report bugs and tell your thoughts"),
                    ), // Feedback
                    ElevatedButton(
                      onPressed: () async {
                        launchUrl(Uri.parse("https://stories.puzzak.page/privacy_policy.html"), mode: LaunchMode.externalApplication);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      child: mcJumpSettingsButton(icon: Icons.privacy_tip_outlined, title: "Privacy policy", subtitle: "We take privacy seriously, read how"),
                    ), // Privacy
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => packagesSettingsPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      child: mcJumpSettingsButton(icon: Icons.list_rounded, title: "Used packages", subtitle: "Dart & Flutter modules used in app"),
                    ), // Packages
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => changelogPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: const BorderSide(color: Colors.transparent, width: 1),
                        ),
                      ),
                      child: mcJumpSettingsButton(icon: Icons.change_circle_outlined, title: "Changelog", subtitle: "List of changes for this app"),
                    ), // Changelog
                  ],
                )),
          ),
        ),
      ),
    );
  }
}

class packagesSettingsPage extends StatefulWidget {
  const packagesSettingsPage({super.key});
  @override
  packagesSettingsPageState createState() => packagesSettingsPageState();
}

class packagesSettingsPageState extends State<packagesSettingsPage> {
  Map packagesList = {};

  Future<Map> getPackages() async {
    Map dependencies = jsonDecode(jsonEncode(loadYaml(await rootBundle.loadString("pubspec.yaml"))["dependencies"]));
    return dependencies;
  }

  @override
  void initState() {
    getPackages().then((value) {
      packagesList = value;
      super.initState();
    });
  }

  @override
  Widget build(BuildContext topContext) {
    return MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF040707),
      ), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double scaffoldHeight = constraints.maxHeight;
              double scaffoldWidth = constraints.maxWidth;
              return SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.all(10),
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
                              padding: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                size: 32,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Text(
                                "Used packages",
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
                    FutureBuilder(
                      future: getPackages(),
                      builder: (BuildContext context, AsyncSnapshot packagesList) {
                        if (packagesList.hasData) {
                          return Container(
                            height: scaffoldHeight - 92,
                            child: ListView.builder(
                              itemCount: packagesList.data.length,
                              itemBuilder: (context, index) {
                                if (packagesList.data.keys.toList()[index] != "flutter") {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: GestureDetector(
                                      onTap: () {
                                        launchUrl(Uri.parse("https://pub.dev/packages/${packagesList.data.keys.toList()[index]}/versions/${packagesList.data[packagesList.data.keys.toList()[index]].replaceAll('^', '')}"),
                                            mode: LaunchMode.externalApplication);
                                      },
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 5, right: 15),
                                            child: Icon(
                                              Icons.code_rounded,
                                              size: 35,
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: scaffoldWidth - 70,
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: scaffoldWidth - 160,
                                                      child: Text(
                                                        packagesList.data.keys.toList()[index],
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 20,
                                                          height: 1.5,
                                                          fontFamily: "Comfortaa",
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      packagesList.data[packagesList.data.keys.toList()[index]].replaceAll('^', ' v'),
                                                      style: TextStyle(
                                                        height: 1.5,
                                                        fontSize: 20,
                                                        fontFamily: "Comfortaa",
                                                        color: Colors.grey,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                "Tap to learn more",
                                                style: TextStyle(
                                                  height: 1,
                                                  fontSize: 14,
                                                  fontFamily: "Comfortaa",
                                                  color: Colors.grey,
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          );
                        } else {
                          return LinearProgressIndicator(
                            backgroundColor: Colors.transparent,
                            color: Colors.teal,
                          );
                        }
                      },
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class creatorsSettingsPage extends StatefulWidget {
  const creatorsSettingsPage({super.key});
  @override
  creatorsSettingsPageState createState() => creatorsSettingsPageState();
}

class creatorsSettingsPageState extends State<creatorsSettingsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext topContext) {
    return MaterialApp(
      theme: ThemeData(),
      darkTheme: ThemeData.dark().copyWith(
        cardColor: Color(0xFF202020),
        scaffoldBackgroundColor: const Color(0xFF040707),
      ), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double scaffoldHeight = constraints.maxHeight;
              double scaffoldWidth = constraints.maxWidth;
              return SafeArea(
                child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: EdgeInsets.all(10),
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
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.arrow_back_rounded,
                                  color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                  size: 32,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Contributors",
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
                        FutureBuilder(
                            future: rootBundle.loadString('assets/data/authors.json'),
                            builder: (BuildContext context, AsyncSnapshot authorsRaw) {
                              if (authorsRaw.hasData) {
                                Map authors = jsonDecode(authorsRaw.data);
                                return Column(
                                    children: authors["Authors"]
                                        .map((option) {
                                          return Row(
                                            children: [
                                              Expanded(
                                                child: Card(
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.all(15),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.center,
                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding: EdgeInsets.only(right: 15),
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(59.0),
                                                                  child: Image.asset(
                                                                    option["Avatar"],
                                                                    height: 50,
                                                                  ),
                                                                ),
                                                              ),
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Text(
                                                                    option["Name"],
                                                                    style: const TextStyle(fontSize: 24,height: 1, fontFamily: "Comfortaa", fontWeight: FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                    "${option["Rank"]} ${option["Role"]}",
                                                                    style: const TextStyle(fontSize: 18, height: 1.25, fontFamily: "Comfortaa", color: Colors.grey),
                                                                  ), // Buttons
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                          SizedBox(height: 10,),
                                                          SingleChildScrollView(
                                                            scrollDirection: Axis.horizontal,
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(),
                                                              child: Wrap(
                                                                spacing: 10.0, // Adjust the spacing between chips as needed
                                                                runSpacing: -7.5, // Adjust the run spacing as needed
                                                                children: option["Links"]
                                                                    .map((option) {
                                                                  return GestureDetector(
                                                                    onTap: () {
                                                                      launchUrl(Uri.parse(option["Link"]), mode: LaunchMode.externalApplication);
                                                                    },
                                                                    child: Chip(
                                                                      shadowColor: Colors.transparent,
                                                                      // avatar: Icon(
                                                                      //     Icons.alternate_email_rounded,
                                                                      //     color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black
                                                                      // ),
                                                                      label: Text(
                                                                        option["Title"],
                                                                        style: const TextStyle(
                                                                          fontFamily: 'Comfortaa',
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      backgroundColor: MediaQuery.of(context).platformBrightness == Brightness.dark ? const Color(0xFF040707) : Colors.transparent,
                                                                      elevation: 5.0,
                                                                      shape: RoundedRectangleBorder(
                                                                        side: const BorderSide(
                                                                          color: Colors.teal, // Border color
                                                                          width: 2.0, // Border width
                                                                        ),
                                                                        borderRadius: BorderRadius.circular(16.0),
                                                                      ),
                                                                    ),
                                                                  );
                                                                })
                                                                    .toList()
                                                                    .cast<Widget>(),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                              ),
                                            ],
                                          );
                                        })
                                        .toList()
                                        .cast<Widget>());
                              }
                              return Text("Loading");
                            }), //AIO
                      ],
                    )),
              );
            },
          ),
        ),
      ),
    );
  }
}
