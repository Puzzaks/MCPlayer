import 'dart:convert';
import 'dart:ui';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:monstercatplayer/memory.dart';
import 'package:restart_app/restart_app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'network.dart';

class loginPage extends StatefulWidget {
  @override
  loginPageState createState() => loginPageState();

  const loginPage({
    super.key,
  });
}

class loginPageState extends State<loginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext topContext) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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
            child: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                if (orientation == Orientation.portrait) {
                  return Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            children: [
                              MediaQuery.of(context).platformBrightness == Brightness.light
                                  ? ColorFiltered(
                                colorFilter: const ColorFilter.matrix([
                                  -1, 0, 0, 0, 255, // Red channel
                                  0, -1, 0, 0, 255, // Green channel
                                  0, 0, -1, 0, 255, // Blue channel
                                  0, 0, 0, 1, 0, // Alpha channel
                                ]),
                                child: Image.asset(
                                  "assets/app_logo.png",
                                  width: 200,
                                ),
                              )
                                  : Image.asset(
                                "assets/app_logo.png",
                                width: 200,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text("Welcome to",
                                  style: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const Text("MCPlayer",
                                  style: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const Text("A Monstercat player",
                                  style: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    fontSize: 24,
                                  )),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25.0),
                                          side: const BorderSide(color: Colors.transparent, width: 2),
                                        ),
                                      ),
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const loginEntryPage()),
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                        child: Text(
                                          "Sign in",
                                          style: TextStyle(
                                            fontFamily: "Comfortaa",
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ), //sign in
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                            side: const BorderSide(color: Colors.transparent, width: 2),
                                          ),
                                        ),
                                        onPressed: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const signInPage()),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Text(
                                            "Create account",
                                            style: TextStyle(
                                              fontFamily: "Comfortaa",
                                              fontWeight: FontWeight.bold,
                                              color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ), //create account
                              Row(
                                children: [
                                  Expanded(
                                    child: Card(
                                      margin: const EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Theme(
                                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                        child: ExpansionTile(
                                          iconColor: Colors.teal,
                                          textColor: Colors.teal,
                                          title: Row(
                                            children: [
                                              const Icon(Icons.info_outline_rounded),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              const Text(
                                                "Privacy information",
                                                style: TextStyle(
                                                  fontFamily: 'Comfortaa',
                                                ),
                                              ),
                                            ],
                                          ),
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: const [
                                                Padding(
                                                  padding: EdgeInsets.only(bottom: 15, right: 15, left: 15),
                                                  child: Text(
                                                    "Not affiliated with Monstercat.\nThis app does not share any data with third-parties.",
                                                    style: TextStyle(
                                                      fontFamily: 'Comfortaa',
                                                      height: 1.25,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ) //privacy
                            ],
                          ),
                        ],
                      ));
                }
                return Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MediaQuery.of(context).platformBrightness == Brightness.light
                                  ? ColorFiltered(
                                colorFilter: const ColorFilter.matrix([
                                  -1, 0, 0, 0, 255, // Red channel
                                  0, -1, 0, 0, 255, // Green channel
                                  0, 0, -1, 0, 255, // Blue channel
                                  0, 0, 0, 1, 0, // Alpha channel
                                ]),
                                child: Image.asset(
                                  "assets/app_logo.png",
                                  width: 128,
                                ),
                              )
                                  : Image.asset(
                                "assets/app_logo.png",
                                width: 128,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text("Welcome to",
                                  style: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const Text("MCPlayer",
                                  style: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const Text("A Monstercat player",
                                  style: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    fontSize: 24,
                                  )),
                            ],
                          ),
                        ),
                        Expanded(
                          child:  Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25.0),
                                          side: const BorderSide(color: Colors.transparent, width: 2),
                                        ),
                                      ),
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const loginEntryPage()),
                                        );
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                        child: Text(
                                          "Sign in",
                                          style: TextStyle(
                                            fontFamily: "Comfortaa",
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ), //sign in
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15.0),
                                            side: const BorderSide(color: Colors.transparent, width: 2),
                                          ),
                                        ),
                                        onPressed: () async {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const signInPage()),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 20),
                                          child: Text(
                                            "Create account",
                                            style: TextStyle(
                                              fontFamily: "Comfortaa",
                                              fontWeight: FontWeight.bold,
                                              color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ), //create account
                              Card(
                                margin: const EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    iconColor: Colors.teal,
                                    textColor: Colors.teal,
                                    title: Row(
                                      children: [
                                        const Icon(Icons.info_outline_rounded),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text(
                                          "Privacy information",
                                          style: TextStyle(
                                            fontFamily: 'Comfortaa',
                                          ),
                                        ),
                                      ],
                                    ),
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 15, right: 15, left: 15),
                                            child: Text(
                                              "Not affiliated with Monstercat.\nThis app does not share any data with third-parties.",
                                              style: TextStyle(
                                                fontFamily: 'Comfortaa',
                                                height: 1.25,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ) //privacy
                            ],
                          ),
                        ),
                      ],
                    ));
              },
            ),
        ),
      ),
    );
  }
}

class loginEntryPage extends StatefulWidget {
  const loginEntryPage({super.key});
  @override
  loginEntryPageState createState() => loginEntryPageState();
}

class loginEntryPageState extends State<loginEntryPage> {
  TextEditingController OTPController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;
  bool credentialsWrong = true;
  bool isSending = false;
  bool isValidated = false;
  String email = "";
  String password = "";
  String OTPcode = "";
  List<String> emailVariants = ["gmail.com", "outlook.com", "yahoo.com"];
  bool stagePassword = false;
  bool isOTP2FA = false;
  bool isEmail2FA = false;
  bool showOTP2FA = false;
  bool showEmail2FA = false;

  bool validateEmail(String input) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(input);
  }

  void validateForm() {
    if (validateEmail(email) && password.length > 5 && !credentialsWrong) {
      setState(() {
        isValidated = true;
      });
    } else {
      setState(() {
        isValidated = false;
      });
    }
  }

  void togglePwdVis() {
    if (passwordVisible) {
      setState(() {
        passwordVisible = false;
      });
    } else {
      setState(() {
        passwordVisible = true;
      });
    }
  }

  void setErrStat(bool status) {
    setState(() {
      credentialsWrong = status;
    });
  }

  Future<bool> check2FA(String input, String email, String password) async {
    bool approved = false;
    while (!approved) {
      bool approved = await ask2FA(input, email, password);
      if (approved) {
        return true;
      } else {
        await Future.delayed(const Duration(seconds: 5));
      }
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
        scaffoldBackgroundColor: const Color(0xFF040707),
      ), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          double scaffoldHeight = constraints.maxHeight;
          double scaffoldWidth = constraints.maxWidth;
          return SafeArea(
            child: OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                if (orientation == Orientation.portrait) {
                  return SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
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
                                const Padding(
                                  padding: EdgeInsets.only(left: 10, top: 15),
                                  child: Text(
                                    "Sign in",
                                    style: TextStyle(
                                      fontSize: 32,
                                      height: 1,
                                      fontFamily: "Comfortaa",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ), // Sign in heading
                              ],
                            ), // Back AND heading
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                showEmail2FA
                                    ? Container(
                                  width: scaffoldWidth,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Center(
                                        child: Text(
                                          "Check your email!",
                                          style: TextStyle(fontFamily: "Comfortaa", fontWeight: FontWeight.bold, fontSize: 28),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      const Center(
                                          child: Text(
                                            "We've sent you login confirmation to",
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(fontFamily: "Comfortaa", fontSize: 16),
                                          )),
                                      Center(
                                          child: Text(
                                            email,
                                            overflow: TextOverflow.fade,
                                            style: const TextStyle(fontFamily: "Comfortaa", fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                                          )),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        child: LinearProgressIndicator(
                                          backgroundColor: Colors.transparent,
                                          color: Colors.teal,
                                        ),
                                      ),
                                      const Center(
                                        child: Text(
                                          "To authorize sign in, click the button in email.",
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(fontFamily: "Comfortaa", fontSize: 16),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      isOTP2FA
                                          ? Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shadowColor: Colors.transparent,
                                                  backgroundColor: Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    side: const BorderSide(color: Colors.transparent, width: 2),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  setState(() {
                                                    showOTP2FA = true;
                                                    showEmail2FA = false;
                                                  });
                                                },
                                                child: Text(
                                                  "Use OTP 2FA",
                                                  style: TextStyle(
                                                    fontFamily: "Comfortaa",
                                                    fontWeight: FontWeight.bold,
                                                    color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                          : Container(),
                                    ],
                                  ),
                                )
                                    : // Email 2FA
                                showOTP2FA
                                    ? Container(
                                  child: Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(top: 20, bottom: 15),
                                        child: Text(
                                          "Enter the six digit code found in your authentificator app.",
                                          style: TextStyle(
                                            fontFamily: "Comfortaa",
                                          ),
                                        ),
                                      ),
                                      OtpTextField(
                                        numberOfFields: 6,
                                        enabledBorderColor: const Color(0xFF202020),
                                        showCursor: false,
                                        focusedBorderColor: Colors.teal,
                                        showFieldAsBox: true,
                                        onSubmit: (String verificationCode) {
                                          setState(() {
                                            isSending = true;
                                          });
                                          send2FA(verificationCode, email, password).then((value) async {
                                            if (value) {
                                              setState(() {
                                                isSending = false;
                                              });
                                              getUser().then((value) async {
                                                await setString("UID", value["User"]["Id"]);
                                                await setBool("signed in", true);
                                                Restart.restartApp();
                                              });
                                            } else {
                                              setState(() {
                                                isSending = false;
                                              });
                                              Fluttertoast.showToast(
                                                msg: 'Wrong OTP',
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                              );
                                            }
                                          });
                                        }, // end onSubmit
                                      ),
                                      isSending
                                          ? const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        child: LinearProgressIndicator(
                                          color: Colors.teal,
                                          backgroundColor: Colors.transparent,
                                        ),
                                      )
                                          : const SizedBox(
                                        height: 24,
                                      ),
                                      isEmail2FA
                                          ? Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shadowColor: Colors.transparent,
                                                  backgroundColor: Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    side: const BorderSide(color: Colors.transparent, width: 2),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  FlutterClipboard.paste().then((value) {
                                                    if (RegExp(r'^[0-9]{6}$').hasMatch(value)) {
                                                      setState(() {
                                                        isSending = true;
                                                      });
                                                      OTPcode = value;
                                                      send2FA(OTPcode, email, password).then((value) async {
                                                        if (value) {
                                                          setState(() {
                                                            isSending = false;
                                                          });
                                                          getUser().then((value) async {
                                                            await setString("UID", value["User"]["Id"]);
                                                            await setBool("signed in", true);
                                                            Restart.restartApp();
                                                          });
                                                        } else {
                                                          setState(() {
                                                            isSending = false;
                                                          });
                                                          Fluttertoast.showToast(
                                                            msg: 'Wrong OTP',
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            gravity: ToastGravity.BOTTOM,
                                                          );
                                                        }
                                                      });
                                                    } else {
                                                      Fluttertoast.showToast(
                                                        msg: 'Doesn\'t look like OTP code',
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.BOTTOM,
                                                      );
                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  "Copy from clipboard",
                                                  style: TextStyle(
                                                    fontFamily: "Comfortaa",
                                                    fontWeight: FontWeight.bold,
                                                    color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shadowColor: Colors.transparent,
                                                  backgroundColor: Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    side: const BorderSide(color: Colors.transparent, width: 2),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  setState(() {
                                                    showOTP2FA = false;
                                                    showEmail2FA = true;
                                                  });
                                                  final emailID = await sendEmail2FA(email, password);
                                                  await check2FA(emailID, email, password).then((value) async {
                                                    if (value) {
                                                      getUser().then((value) async {
                                                        await setString("UID", value["User"]["Id"]);
                                                        await setBool("signed in", true);
                                                        Restart.restartApp();
                                                      });
                                                    } else {
                                                      Fluttertoast.showToast(
                                                        msg: 'I don\'t know why it failed',
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.BOTTOM,
                                                      );
                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  "Use email 2FA",
                                                  style: TextStyle(
                                                    fontFamily: "Comfortaa",
                                                    fontWeight: FontWeight.bold,
                                                    color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                          : Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shadowColor: Colors.transparent,
                                                  backgroundColor: Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    side: const BorderSide(color: Colors.transparent, width: 2),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  FlutterClipboard.paste().then((value) {
                                                    if (RegExp(r'^[0-9]{6}$').hasMatch(value)) {
                                                      setState(() {
                                                        isSending = true;
                                                      });
                                                      OTPcode = value;
                                                      send2FA(OTPcode, email, password).then((value) async {
                                                        if (value) {
                                                          setState(() {
                                                            isSending = false;
                                                          });
                                                          getUser().then((value) async {
                                                            await setString("UID", value["User"]["Id"]);
                                                            await setBool("signed in", true);
                                                            Restart.restartApp();
                                                          });
                                                        } else {
                                                          setState(() {
                                                            isSending = false;
                                                          });
                                                          Fluttertoast.showToast(
                                                            msg: 'Wrong OTP',
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            gravity: ToastGravity.BOTTOM,
                                                          );
                                                        }
                                                      });
                                                    } else {
                                                      Fluttertoast.showToast(
                                                        msg: 'Doesn\'t look like OTP code',
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.BOTTOM,
                                                      );
                                                    }
                                                  });
                                                },
                                                child: Text(
                                                  "Copy from clipboard",
                                                  style: TextStyle(
                                                    fontFamily: "Comfortaa",
                                                    fontWeight: FontWeight.bold,
                                                    color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
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
                                    : //OTP 2FA
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    stagePassword
                                        ? const Padding(
                                      padding: EdgeInsets.only(top: 15),
                                      child: Text(
                                        "Email",
                                        style: TextStyle(fontFamily: "Comfortaa", fontSize: 12, color: Colors.grey),
                                      ),
                                    )
                                        : Container(), // "Email" small heading
                                    stagePassword
                                        ? Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Text(
                                        email,
                                        style: const TextStyle(fontFamily: "Comfortaa", fontSize: 16),
                                      ),
                                    )
                                        : Container(), // Actual email
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.only(top:15),
                                            child: stagePassword
                                                ? TextField(
                                              controller: passwordController,
                                              textInputAction: TextInputAction.done,
                                              keyboardType: TextInputType.visiblePassword,
                                              obscureText: !passwordVisible,
                                              style: const TextStyle(
                                                fontFamily: 'Comfortaa',
                                              ),
                                              cursorColor: Colors.teal,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.zero,
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
                                                    color: (password.length > 5 && !credentialsWrong) ? Colors.teal : Colors.red, // Set the focused border color
                                                    width: 2.0,
                                                  ),
                                                ),
                                                border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: (password.length > 5 && !credentialsWrong) ? Colors.teal : Colors.red,
                                                    width: 2.0,
                                                  ),
                                                ),
                                                enabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: (password.length > 5 && !credentialsWrong) ? Colors.teal : Colors.red,
                                                    width: 2.0,
                                                  ),
                                                ),
                                                labelText: 'Password',
                                                labelStyle: const TextStyle(color: Colors.grey),
                                              ),
                                              onChanged: (value) async {
                                                setState(() {
                                                  password = value;
                                                  setErrStat(false);
                                                  validateForm();
                                                });
                                              },
                                            )
                                                : // Password
                                            TextField(
                                              controller: emailController,
                                              textInputAction: TextInputAction.next,
                                              keyboardType: TextInputType.emailAddress,
                                              style: const TextStyle(
                                                fontFamily: 'Comfortaa',
                                              ),
                                              cursorColor: Colors.teal,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.zero,
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
                                                labelText: 'Email',
                                                labelStyle: const TextStyle(color: Colors.grey),
                                              ),
                                              onChanged: (value) async {
                                                setState(() {
                                                  email = value;
                                                });
                                              },
                                            ), // Email
                                          ),
                                        ),
                                        stagePassword ? Padding(
                                          padding: const EdgeInsets.only(left: 5, right: 0, top: 5, bottom: 5),
                                          child: GestureDetector(
                                            onTap: () {
                                              togglePwdVis();
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: (Icon(
                                                passwordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                                color: passwordVisible ? null : Colors.grey,
                                              )),
                                            ),
                                          ),
                                        )
                                            : Container(),
                                      ],
                                    ), // Password OR Email fields
                                    stagePassword
                                        ? Padding(
                                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'By logging in with MCPlayer, you agree to our ',
                                          style: TextStyle(
                                            color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                            fontFamily: 'Comfortaa',
                                          ),
                                          children: <TextSpan>[
                                            TextSpan(
                                              text: 'privacy policy',
                                              style: const TextStyle(
                                                decoration: TextDecoration.underline,
                                                color: Colors.teal,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  launchUrl(Uri.parse('https://stories.puzzak.page/privacy_policy.html'), mode: LaunchMode.externalApplication);
                                                },
                                            ),
                                            const TextSpan(
                                              text: ', Monstercat\'s ',
                                            ),
                                            TextSpan(
                                              text: 'terms of service',
                                              style: const TextStyle(
                                                decoration: TextDecoration.underline,
                                                color: Colors.teal,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  launch('https://monstercat.com/terms-of-service');
                                                },
                                            ),
                                            const TextSpan(
                                              text: ' and ',
                                            ),
                                            TextSpan(
                                              text: 'privacy policy',
                                              style: const TextStyle(
                                                decoration: TextDecoration.underline,
                                                color: Colors.teal,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  launch('https://monstercat.com/privacy-policy');
                                                },
                                            ),
                                            const TextSpan(
                                              text: '.',
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                        : // Disclaimer
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
                                                    email = "${emailController.text.split("@")[0]}@$option";
                                                    emailController = TextEditingController(text: "${emailController.text.split("@")[0]}@$option");
                                                  });
                                                },
                                                child: Chip(
                                                  shadowColor: Colors.transparent,
                                                  avatar: Icon(
                                                    Icons.alternate_email_rounded,
                                                    color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black
                                                  ),
                                                  label: Text(
                                                    option,
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
                                      ),
                                    ),
                                    stagePassword
                                        ? Column(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(),
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    shadowColor: Colors.transparent,
                                                    backgroundColor: isValidated ? Colors.teal : Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      side: const BorderSide(color: Colors.transparent, width: 2),
                                                    ),
                                                  ),
                                                  onPressed: (isValidated && !credentialsWrong)
                                                      ? () async {
                                                    setState(() {
                                                      isSending = true;
                                                    });
                                                    await sendLogin(email, password).then((value) async {
                                                      if (value != "error") {
                                                        if (jsonDecode(value)["Needs2FA"]) {
                                                          for (int s = 0; s < jsonDecode(value)["AuthData"].length; s++) {
                                                            if (jsonDecode(value)["AuthData"].keys.toList()[s] == "Email") {
                                                              isEmail2FA = true;
                                                            }else if (jsonDecode(value)["AuthData"].keys.toList()[s] == "TOTP") {
                                                              isOTP2FA = true;
                                                            }
                                                          }
                                                          switch (jsonDecode(value)["DefaultAuthType"]) {
                                                            case "TOTP":
                                                              setState(() {
                                                                showOTP2FA = true;
                                                                showEmail2FA = false;
                                                              });
                                                              break;
                                                            case "Email":
                                                              setState(() {
                                                                showOTP2FA = false;
                                                                showEmail2FA = true;
                                                              });
                                                              await check2FA(jsonDecode(value)["AuthData"]["Email"]["Id"], email, password).then((value) async {
                                                                if (value) {
                                                                  getUser().then((value) async {
                                                                    await setString("UID", value["User"]["Id"]);
                                                                    await setBool("signed in", true);
                                                                    Restart.restartApp();
                                                                  });
                                                                } else {
                                                                  Fluttertoast.showToast(
                                                                    msg: 'I don\'t know why it failed',
                                                                    toastLength: Toast.LENGTH_SHORT,
                                                                    gravity: ToastGravity.BOTTOM,
                                                                  );
                                                                }
                                                              });
                                                              break;
                                                          }
                                                        } else {
                                                          getUser().then((value) async {
                                                            await setString("UID", value["User"]["Id"]);
                                                            await setBool("signed in", true);
                                                            Restart.restartApp();
                                                          });
                                                        }
                                                      } else {
                                                        Fluttertoast.showToast(
                                                          msg: 'Error while logging in',
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.BOTTOM,
                                                        );
                                                        setErrStat(true);
                                                      }
                                                      isSending = false;
                                                    });
                                                  }
                                                      : () async {
                                                    Fluttertoast.showToast(
                                                      msg: credentialsWrong ? 'Check your credentials' : 'Please, enter your credentials',
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.BOTTOM,
                                                    );
                                                  },
                                                  child: isSending
                                                      ? Column(
                                                    children: const [
                                                      LinearProgressIndicator(
                                                        color: Colors.white,
                                                        backgroundColor: Colors.transparent,
                                                      ),
                                                    ],
                                                  )
                                                      : Text(
                                                    "Sign in",
                                                    style: TextStyle(
                                                      fontFamily: "Comfortaa",
                                                      fontWeight: FontWeight.bold,
                                                      color: (isValidated && !credentialsWrong)
                                                          ? MediaQuery.of(context).platformBrightness == Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black
                                                          : Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ), // Login button
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(left: 5),
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.transparent,
                                                    shadowColor: Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      side: const BorderSide(color: Colors.transparent, width: 2),
                                                    ),
                                                  ),
                                                  onPressed: (validateEmail(email))
                                                      ? () async {
                                                    setState(() {
                                                      resetPassword(email).then((value) {
                                                        if (value) {
                                                          Fluttertoast.showToast(
                                                            msg: 'Email sent',
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            gravity: ToastGravity.BOTTOM,
                                                          );
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
                                                  child: Text(
                                                    "Forgot password?",
                                                    style: TextStyle(
                                                      fontFamily: "Comfortaa",
                                                      fontWeight: FontWeight.bold,
                                                      color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ), // Reset password button
                                      ],
                                    )
                                        : // Login AND Reset buttons
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
                                                backgroundColor: validateEmail(emailController.text) ? Colors.teal : Colors.transparent,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20.0),
                                                  side: const BorderSide(color: Colors.transparent, width: 2),
                                                ),
                                              ),
                                              onPressed: validateEmail(emailController.text)
                                                  ? () async {
                                                setState(() {
                                                  stagePassword = true;
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
                                                "Continue",
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
                                    ), // Continue button
                                  ],
                                ), // Pre-2FA
                              ],
                            ) // Content
                          ],
                        )),
                  );
                }
                return Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
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
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10, top: 15),
                                      child: Text(
                                        "Sign in",
                                        style: TextStyle(
                                          fontSize: 32,
                                          height: 1,
                                          fontFamily: "Comfortaa",
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ), // Sign in heading
                                  ],
                                ), // Back AND heading
                                Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MediaQuery.of(context).platformBrightness == Brightness.light
                                  ? ColorFiltered(
                                colorFilter: const ColorFilter.matrix([
                                  -1, 0, 0, 0, 255, // Red channel
                                  0, -1, 0, 0, 255, // Green channel
                                  0, 0, -1, 0, 255, // Blue channel
                                  0, 0, 0, 1, 0, // Alpha channel
                                ]),
                                child: Image.asset(
                                  "assets/app_logo.png",
                                  width: 128,
                                ),
                              )
                                  : Image.asset(
                                "assets/app_logo.png",
                                width: 128,
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text("Welcome to",
                                  style: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const Text("MCPlayer",
                                  style: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  )),
                              const Text("A Monstercat player",
                                  style: TextStyle(
                                    fontFamily: 'Comfortaa',
                                    fontSize: 24,
                                  )),
                            ],
                          ),
                                Container()
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  showEmail2FA
                                      ? Container(
                                    width: scaffoldWidth,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const Center(
                                          child: Text(
                                            "Check your email!",
                                            style: TextStyle(fontFamily: "Comfortaa", fontWeight: FontWeight.bold, fontSize: 28),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        const Center(
                                            child: Text(
                                              "We've sent you login confirmation to",
                                              overflow: TextOverflow.fade,
                                              style: TextStyle(fontFamily: "Comfortaa", fontSize: 16),
                                            )),
                                        Center(
                                            child: Text(
                                              email,
                                              overflow: TextOverflow.fade,
                                              style: const TextStyle(fontFamily: "Comfortaa", fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal),
                                            )),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child: LinearProgressIndicator(
                                            backgroundColor: Colors.transparent,
                                            color: Colors.teal,
                                          ),
                                        ),
                                        const Center(
                                          child: Text(
                                            "To authorize sign in, click the button in email.",
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(fontFamily: "Comfortaa", fontSize: 16),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        isOTP2FA
                                            ? Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(),
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    shadowColor: Colors.transparent,
                                                    backgroundColor: Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      side: const BorderSide(color: Colors.transparent, width: 2),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    setState(() {
                                                      showOTP2FA = true;
                                                      showEmail2FA = false;
                                                    });
                                                  },
                                                  child: Text(
                                                    "Use OTP 2FA",
                                                    style: TextStyle(
                                                      fontFamily: "Comfortaa",
                                                      fontWeight: FontWeight.bold,
                                                      color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                            : Container(),
                                      ],
                                    ),
                                  )
                                      : // Email 2FA
                                  showOTP2FA
                                      ? Container(
                                    child: Column(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(top: 20, bottom: 15),
                                          child: Text(
                                            "Enter the six digit code found in your authentificator app.",
                                            style: TextStyle(
                                              fontFamily: "Comfortaa",
                                            ),
                                          ),
                                        ),
                                        OtpTextField(
                                          numberOfFields: 6,
                                          enabledBorderColor: const Color(0xFF202020),
                                          showCursor: false,
                                          focusedBorderColor: Colors.teal,
                                          showFieldAsBox: true,
                                          onSubmit: (String verificationCode) {
                                            setState(() {
                                              isSending = true;
                                            });
                                            send2FA(verificationCode, email, password).then((value) async {
                                              if (value) {
                                                setState(() {
                                                  isSending = false;
                                                });
                                                getUser().then((value) async {
                                                  await setString("UID", value["User"]["Id"]);
                                                  await setBool("signed in", true);
                                                  Restart.restartApp();
                                                });
                                              } else {
                                                setState(() {
                                                  isSending = false;
                                                });
                                                Fluttertoast.showToast(
                                                  msg: 'Wrong OTP',
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                );
                                              }
                                            });
                                          }, // end onSubmit
                                        ),
                                        isSending
                                            ? const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child: LinearProgressIndicator(
                                            color: Colors.teal,
                                            backgroundColor: Colors.transparent,
                                          ),
                                        )
                                            : const SizedBox(
                                          height: 24,
                                        ),
                                        isEmail2FA
                                            ? Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(),
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    shadowColor: Colors.transparent,
                                                    backgroundColor: Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      side: const BorderSide(color: Colors.transparent, width: 2),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    FlutterClipboard.paste().then((value) {
                                                      if (RegExp(r'^[0-9]{6}$').hasMatch(value)) {
                                                        setState(() {
                                                          isSending = true;
                                                        });
                                                        OTPcode = value;
                                                        send2FA(OTPcode, email, password).then((value) async {
                                                          if (value) {
                                                            setState(() {
                                                              isSending = false;
                                                            });
                                                            getUser().then((value) async {
                                                              await setString("UID", value["User"]["Id"]);
                                                              await setBool("signed in", true);
                                                              Restart.restartApp();
                                                            });
                                                          } else {
                                                            setState(() {
                                                              isSending = false;
                                                            });
                                                            Fluttertoast.showToast(
                                                              msg: 'Wrong OTP',
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              gravity: ToastGravity.BOTTOM,
                                                            );
                                                          }
                                                        });
                                                      } else {
                                                        Fluttertoast.showToast(
                                                          msg: 'Doesn\'t look like OTP code',
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.BOTTOM,
                                                        );
                                                      }
                                                    });
                                                  },
                                                  child: Text(
                                                    "Copy from clipboard",
                                                    style: TextStyle(
                                                      fontFamily: "Comfortaa",
                                                      fontWeight: FontWeight.bold,
                                                      color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(),
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    shadowColor: Colors.transparent,
                                                    backgroundColor: Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      side: const BorderSide(color: Colors.transparent, width: 2),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    setState(() {
                                                      showOTP2FA = false;
                                                      showEmail2FA = true;
                                                    });
                                                    final emailID = await sendEmail2FA(email, password);
                                                    await check2FA(emailID, email, password).then((value) async {
                                                      if (value) {
                                                        getUser().then((value) async {
                                                          await setString("UID", value["User"]["Id"]);
                                                          await setBool("signed in", true);
                                                          Restart.restartApp();
                                                        });
                                                      } else {
                                                        Fluttertoast.showToast(
                                                          msg: 'I don\'t know why it failed',
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.BOTTOM,
                                                        );
                                                      }
                                                    });
                                                  },
                                                  child: Text(
                                                    "Use email 2FA",
                                                    style: TextStyle(
                                                      fontFamily: "Comfortaa",
                                                      fontWeight: FontWeight.bold,
                                                      color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                            : Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(),
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    shadowColor: Colors.transparent,
                                                    backgroundColor: Colors.transparent,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20.0),
                                                      side: const BorderSide(color: Colors.transparent, width: 2),
                                                    ),
                                                  ),
                                                  onPressed: () async {
                                                    FlutterClipboard.paste().then((value) {
                                                      if (RegExp(r'^[0-9]{6}$').hasMatch(value)) {
                                                        setState(() {
                                                          isSending = true;
                                                        });
                                                        OTPcode = value;
                                                        send2FA(OTPcode, email, password).then((value) async {
                                                          if (value) {
                                                            setState(() {
                                                              isSending = false;
                                                            });
                                                            getUser().then((value) async {
                                                              await setString("UID", value["User"]["Id"]);
                                                              await setBool("signed in", true);
                                                              Restart.restartApp();
                                                            });
                                                          } else {
                                                            setState(() {
                                                              isSending = false;
                                                            });
                                                            Fluttertoast.showToast(
                                                              msg: 'Wrong OTP',
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              gravity: ToastGravity.BOTTOM,
                                                            );
                                                          }
                                                        });
                                                      } else {
                                                        Fluttertoast.showToast(
                                                          msg: 'Doesn\'t look like OTP code',
                                                          toastLength: Toast.LENGTH_SHORT,
                                                          gravity: ToastGravity.BOTTOM,
                                                        );
                                                      }
                                                    });
                                                  },
                                                  child: Text(
                                                    "Copy from clipboard",
                                                    style: TextStyle(
                                                      fontFamily: "Comfortaa",
                                                      fontWeight: FontWeight.bold,
                                                      color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                      : //OTP 2FA
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      stagePassword
                                          ? const Padding(
                                        padding: EdgeInsets.only(top: 15),
                                        child: Text(
                                          "Email",
                                          style: TextStyle(fontFamily: "Comfortaa", fontSize: 12, color: Colors.grey),
                                        ),
                                      )
                                          : Container(), // "Email" small heading
                                      stagePassword
                                          ? Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                        ),
                                        child: Text(
                                          email,
                                          style: const TextStyle(fontFamily: "Comfortaa", fontSize: 16),
                                        ),
                                      )
                                          : Container(), // Actual email
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(top:15),
                                              child: stagePassword
                                                  ? TextField(
                                                controller: passwordController,
                                                textInputAction: TextInputAction.done,
                                                keyboardType: TextInputType.visiblePassword,
                                                obscureText: !passwordVisible,
                                                style: const TextStyle(
                                                  fontFamily: 'Comfortaa',
                                                ),
                                                cursorColor: Colors.teal,
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.zero,
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
                                                      color: (password.length > 5 && !credentialsWrong) ? Colors.teal : Colors.red, // Set the focused border color
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: (password.length > 5 && !credentialsWrong) ? Colors.teal : Colors.red,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  enabledBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: (password.length > 5 && !credentialsWrong) ? Colors.teal : Colors.red,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  labelText: 'Password',
                                                  labelStyle: const TextStyle(color: Colors.grey),
                                                ),
                                                onChanged: (value) async {
                                                  setState(() {
                                                    password = value;
                                                    setErrStat(false);
                                                    validateForm();
                                                  });
                                                },
                                              )
                                                  : // Password
                                              TextField(
                                                controller: emailController,
                                                textInputAction: TextInputAction.next,
                                                keyboardType: TextInputType.emailAddress,
                                                style: const TextStyle(
                                                  fontFamily: 'Comfortaa',
                                                ),
                                                cursorColor: Colors.teal,
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.zero,
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
                                                  labelText: 'Email',
                                                  labelStyle: const TextStyle(color: Colors.grey),
                                                ),
                                                onChanged: (value) async {
                                                  setState(() {
                                                    email = value;
                                                  });
                                                },
                                              ), // Email
                                            ),
                                          ),
                                          stagePassword ? Padding(
                                            padding: const EdgeInsets.only(left: 5, right: 0, top: 5, bottom: 5),
                                            child: GestureDetector(
                                              onTap: () {
                                                togglePwdVis();
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: (Icon(
                                                  passwordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                                  color: passwordVisible ? null : Colors.grey,
                                                )),
                                              ),
                                            ),
                                          )
                                              : Container(),
                                        ],
                                      ), // Password OR Email fields
                                      stagePassword
                                          ? Padding(
                                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'By logging in with MCPlayer, you agree to our ',
                                            style: TextStyle(
                                              color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                              fontFamily: 'Comfortaa',
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'privacy policy',
                                                style: const TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  color: Colors.teal,
                                                ),
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () {
                                                    launchUrl(Uri.parse('https://stories.puzzak.page/privacy_policy.html'), mode: LaunchMode.externalApplication);
                                                  },
                                              ),
                                              const TextSpan(
                                                text: ', Monstercat\'s ',
                                              ),
                                              TextSpan(
                                                text: 'terms of service',
                                                style: const TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  color: Colors.teal,
                                                ),
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () {
                                                    launch('https://monstercat.com/terms-of-service');
                                                  },
                                              ),
                                              const TextSpan(
                                                text: ' and ',
                                              ),
                                              TextSpan(
                                                text: 'privacy policy',
                                                style: const TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  color: Colors.teal,
                                                ),
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () {
                                                    launch('https://monstercat.com/privacy-policy');
                                                  },
                                              ),
                                              const TextSpan(
                                                text: '.',
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                          : // Disclaimer
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
                                                      email = "${emailController.text.split("@")[0]}@$option";
                                                      emailController = TextEditingController(text: "${emailController.text.split("@")[0]}@$option");
                                                    });
                                                  },
                                                  child: Chip(
                                                    shadowColor: Colors.transparent,
                                                    avatar: const Icon(
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
                                        ),
                                      ),
                                      stagePassword
                                          ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      shadowColor: Colors.transparent,
                                                      backgroundColor: isValidated ? Colors.teal : Colors.transparent,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20.0),
                                                        side: const BorderSide(color: Colors.transparent, width: 2),
                                                      ),
                                                    ),
                                                    onPressed: (isValidated && !credentialsWrong)
                                                        ? () async {
                                                      setState(() {
                                                        isSending = true;
                                                      });
                                                      await sendLogin(email, password).then((value) async {
                                                        if (value != "error") {
                                                          if (jsonDecode(value)["Needs2FA"]) {
                                                            for (int s = 0; s < jsonDecode(value)["AuthData"].length; s++) {
                                                              if (jsonDecode(value)["AuthData"].keys.toList()[s] == "Email") {
                                                                isEmail2FA = true;
                                                              }
                                                              if (jsonDecode(value)["AuthData"].keys.toList()[s] == "TOTP") {
                                                                isOTP2FA = true;
                                                              }
                                                            }
                                                            switch (jsonDecode(value)["DefaultAuthType"]) {
                                                              case "TOTP":
                                                                setState(() {
                                                                  showOTP2FA = true;
                                                                  showEmail2FA = false;
                                                                });
                                                                break;
                                                              case "Email":
                                                                setState(() {
                                                                  showOTP2FA = false;
                                                                  showEmail2FA = true;
                                                                });
                                                                await check2FA(jsonDecode(value)["AuthData"]["Email"]["Id"], email, password).then((value) async {
                                                                  if (value) {
                                                                    getUser().then((value) async {
                                                                      await setString("UID", value["User"]["Id"]);
                                                                      await setBool("signed in", true);
                                                                      Restart.restartApp();
                                                                    });
                                                                  } else {
                                                                    Fluttertoast.showToast(
                                                                      msg: 'I don\'t know why it failed',
                                                                      toastLength: Toast.LENGTH_SHORT,
                                                                      gravity: ToastGravity.BOTTOM,
                                                                    );
                                                                  }
                                                                });
                                                                break;
                                                            }
                                                          } else {
                                                            getUser().then((value) async {
                                                              await setString("UID", value["User"]["Id"]);
                                                              await setBool("signed in", true);
                                                              Restart.restartApp();
                                                            });
                                                          }
                                                        } else {
                                                          Fluttertoast.showToast(
                                                            msg: 'Error while logging in',
                                                            toastLength: Toast.LENGTH_SHORT,
                                                            gravity: ToastGravity.BOTTOM,
                                                          );
                                                          setErrStat(true);
                                                        }
                                                        isSending = false;
                                                      });
                                                    }
                                                        : () async {
                                                      Fluttertoast.showToast(
                                                        msg: credentialsWrong ? 'Check your credentials' : 'Please, enter your credentials',
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.BOTTOM,
                                                      );
                                                    },
                                                    child: isSending
                                                        ? Column(
                                                      children: const [
                                                        LinearProgressIndicator(
                                                          color: Colors.white,
                                                          backgroundColor: Colors.transparent,
                                                        ),
                                                      ],
                                                    )
                                                        : Text(
                                                      "Sign in",
                                                      style: TextStyle(
                                                        fontFamily: "Comfortaa",
                                                        fontWeight: FontWeight.bold,
                                                        color: (isValidated && !credentialsWrong)
                                                            ? MediaQuery.of(context).platformBrightness == Brightness.dark
                                                            ? Colors.white
                                                            : Colors.black
                                                            : Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ), // Login button
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 5),
                                                  child: ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.transparent,
                                                      shadowColor: Colors.transparent,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20.0),
                                                        side: const BorderSide(color: Colors.transparent, width: 2),
                                                      ),
                                                    ),
                                                    onPressed: (validateEmail(email))
                                                        ? () async {
                                                      setState(() {
                                                        resetPassword(email).then((value) {
                                                          if (value) {
                                                            Fluttertoast.showToast(
                                                              msg: 'Email sent',
                                                              toastLength: Toast.LENGTH_SHORT,
                                                              gravity: ToastGravity.BOTTOM,
                                                            );
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
                                                    child: Text(
                                                      "Forgot password?",
                                                      style: TextStyle(
                                                        fontFamily: "Comfortaa",
                                                        fontWeight: FontWeight.bold,
                                                        color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ), // Reset password button
                                        ],
                                      )
                                          : // Login AND Reset buttons
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
                                                  backgroundColor: validateEmail(emailController.text) ? Colors.teal : Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    side: const BorderSide(color: Colors.transparent, width: 2),
                                                  ),
                                                ),
                                                onPressed: validateEmail(emailController.text)
                                                    ? () async {
                                                  setState(() {
                                                    stagePassword = true;
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
                                                  "Continue",
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
                                      ), // Continue button
                                    ],
                                  ), // Pre-2FA
                                ],
                              ) // Content
                            ],
                          ),
                        )
                      ],
                    ));
              },
            ),
          );
        }),
      ),
    );
  }
}

class signInPage extends StatefulWidget {
  @override
  signInPageState createState() => signInPageState();

  const signInPage({
    super.key,
  });
}

class signInPageState extends State<signInPage> {
  bool stagePassword = false;
  bool stagePersonal = false;
  bool stageTips = false;
  bool passwordVisible = false;
  bool isSending = false;
  bool locationVariants = false;

  List locations = [{}];
  List<String> emailVariants = ["gmail.com", "outlook.com", "yahoo.com"];

  String errorMessage = "";
  String email = "";
  String password = "";
  String locationString = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController snameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController dateController = TextEditingController();



  Map<String, String> generalUserSettings = {};



  bool validateEmail(String input) {
    final RegExp emailRegex = RegExp(
      r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(input);
  }

  void togglePwdVis() {
    if (passwordVisible) {
      setState(() {
        passwordVisible = false;
      });
    } else {
      setState(() {
        passwordVisible = true;
      });
    }
  }

  int evaluatePasswordStrength(String password) {
    int strength = 0;
    // Check if the password contains uppercase letters
    if (password.contains(RegExp(r'[A-Z]'))) {
      strength++;
    }
    // Check if the password contains lowercase letters
    if (password.contains(RegExp(r'[a-z]'))) {
      strength++;
    }
    // Check if the password contains digits
    if (password.contains(RegExp(r'[0-9]'))) {
      strength++;
    }
    // Check if the password contains special characters
    if (password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
      strength++;
    }
    if (password.length < 12) {
      strength = 0;
    }

    return strength;
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
        cardColor: const Color(0xFF202020),
        scaffoldBackgroundColor: const Color(0xFF040707),
      ), // standard dark theme
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          double scaffoldHeight = constraints.maxHeight;
          double scaffoldWidth = constraints.maxWidth;
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
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
                                const Padding(
                                  padding: EdgeInsets.only(left: 10, top: 15),
                                  child: Text(
                                    "Create Account",
                                    style: TextStyle(
                                      fontSize: 32,
                                      height: 1,
                                      fontFamily: "Comfortaa",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ), // Sign in heading
                              ],
                            ), // Back AND heading
                      const SizedBox(
                        height: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          stagePassword
                              ? Container(
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(),
                                              child: TextField(
                                                controller: passwordController,
                                                textInputAction: TextInputAction.done,
                                                keyboardType: TextInputType.visiblePassword,
                                                obscureText: !passwordVisible,
                                                style: const TextStyle(
                                                  fontFamily: 'Comfortaa',
                                                ),
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.zero,
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
                                                      color: evaluatePasswordStrength(passwordController.text) > 0 ? Colors.teal : Colors.red, // Set the focused border color
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: evaluatePasswordStrength(passwordController.text) > 0 ? Colors.teal : Colors.red,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  enabledBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: evaluatePasswordStrength(passwordController.text) > 0 ? Colors.teal : Colors.red,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  labelText: 'Password',
                                                  labelStyle: const TextStyle(color: Colors.grey),
                                                ),
                                                onChanged: (value) async {
                                                  setState(() {
                                                    errorMessage = "";
                                                    password = value;
                                                    generalUserSettings["Password"] = password;
                                                  });
                                                },
                                              ), // Pwd
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(left: 5, right: 0, top: 5, bottom: 5),
                                            child: GestureDetector(
                                              onTap: () {
                                                togglePwdVis();
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.all(15),
                                                child: (Icon(
                                                  passwordVisible ? Icons.visibility_rounded : Icons.visibility_off_rounded,
                                                  color: passwordVisible ? null : Colors.grey,
                                                )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 0),
                                            child: Icon(
                                              Icons.info_outline_rounded,
                                              color: Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            evaluatePasswordStrength(passwordController.text) == 1
                                                ? "This password is very weak"
                                                : evaluatePasswordStrength(passwordController.text) == 2
                                                    ? "This password is weak"
                                                    : evaluatePasswordStrength(passwordController.text) == 3
                                                        ? "This password is good"
                                                        : evaluatePasswordStrength(passwordController.text) == 4
                                                            ? "This password is Gold"
                                                            : "This password is too short (${passwordController.text.length}/12)",
                                            style: const TextStyle(fontFamily: "Comfortaa", color: Colors.grey, height: 1.25),
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
                                                  backgroundColor: (evaluatePasswordStrength(passwordController.text) > 0 && errorMessage == "" && validateEmail(emailController.text)) ? Colors.teal : Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    side: const BorderSide(color: Colors.transparent, width: 2),
                                                  ),
                                                ),
                                                onPressed: (evaluatePasswordStrength(passwordController.text) > 0 && errorMessage == "" && validateEmail(emailController.text))
                                                    ? () async {
                                                        setState(() {
                                                          isSending = true;
                                                        });
                                                        sendSignup(generalUserSettings).then((value) async {
                                                          setState(() {
                                                            isSending = false;
                                                          });
                                                          if (value == "Success") {
                                                            getUser().then((value) async {
                                                              await setString("UID", value["User"]["Id"]);
                                                              await setBool("signed in", true);
                                                              Restart.restartApp();
                                                            });
                                                          } else {
                                                            errorMessage = jsonDecode(value)["Message"];
                                                            setState(() {
                                                              isSending = false;
                                                            });
                                                          }
                                                        });
                                                      }
                                                    : null,
                                                child: isSending
                                                    ? const LinearProgressIndicator(
                                                        color: Colors.white,
                                                        backgroundColor: Colors.transparent,
                                                      )
                                                    : Text(
                                                        "Save",
                                                        style: TextStyle(
                                                          fontFamily: "Comfortaa",
                                                          fontWeight: FontWeight.bold,
                                                          color: (evaluatePasswordStrength(passwordController.text) > 0 && errorMessage == "" && validateEmail(emailController.text)) ? Colors.white : Colors.grey,
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      errorMessage != ""
                                          ? Padding(
                                              padding: const EdgeInsets.only(top: 5),
                                              child: Row(
                                                children: [
                                                  const Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 0),
                                                    child: Icon(
                                                      Icons.error_outline,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  SizedBox(
                                                    width: scaffoldWidth - 64,
                                                    child: Text(
                                                      errorMessage,
                                                      style: const TextStyle(fontFamily: "Comfortaa", color: Colors.red, height: 1.25),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      errorMessage != ""
                                          ? Container(
                                              height: 44,
                                              width: double.infinity,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.horizontal,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(),
                                                  child: Wrap(
                                                    spacing: 10.0, // Adjust the spacing between chips as needed
                                                    runSpacing: -7.5, // Adjust the run spacing as needed
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          setState(() {
                                                            stagePassword = false;
                                                            stagePersonal = false;
                                                            stageTips = false;
                                                          });
                                                        },
                                                        child: Chip(
                                                          shadowColor: Colors.transparent,
                                                          label: const Text(
                                                            "Edit email",
                                                            style: TextStyle(
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
                                                            borderRadius: BorderRadius.circular(18.0),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ) // Navigation
                                          : Container(),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'By signing up at Monstercat with MCPlayer, you agree to our ',
                                            style: TextStyle(
                                              color: MediaQuery.of(context).platformBrightness == Brightness.dark ? Colors.white : Colors.black,
                                              fontFamily: 'Comfortaa',
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'privacy policy',
                                                style: const TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  color: Colors.teal,
                                                ),
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () {
                                                    launchUrl(Uri.parse('https://stories.puzzak.page/privacy_policy.html'), mode: LaunchMode.externalApplication);
                                                  },
                                              ),
                                              const TextSpan(
                                                text: ', Monstercat\'s ',
                                              ),
                                              TextSpan(
                                                text: 'terms of service',
                                                style: const TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  color: Colors.teal,
                                                ),
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () {
                                                    launch('https://monstercat.com/terms-of-service');
                                                  },
                                              ),
                                              const TextSpan(
                                                text: ' and ',
                                              ),
                                              TextSpan(
                                                text: 'privacy policy',
                                                style: const TextStyle(
                                                  decoration: TextDecoration.underline,
                                                  color: Colors.teal,
                                                ),
                                                recognizer: TapGestureRecognizer()
                                                  ..onTap = () {
                                                    launch('https://monstercat.com/privacy-policy');
                                                  },
                                              ),
                                              const TextSpan(
                                                text: '.',
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ) //password
                              : Container(
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.only(),
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
                                                      labelText: 'Email',
                                                      labelStyle: const TextStyle(color: Colors.grey),
                                                    ),
                                                    onChanged: (value) async {
                                                      setState(() {
                                                        errorMessage = "";
                                                        email = value;
                                                      });
                                                    },
                                                  ), // Email
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
                                                              email = "${emailController.text.split("@")[0]}@$option";
                                                              emailController = TextEditingController(text: "${emailController.text.split("@")[0]}@$option");
                                                            });
                                                          },
                                                          child: Chip(
                                                            shadowColor: Colors.transparent,
                                                            avatar: const Icon(
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
                                                      backgroundColor: validateEmail(emailController.text) ? Colors.teal : Colors.transparent,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20.0),
                                                        side: const BorderSide(color: Colors.transparent, width: 2),
                                                      ),
                                                    ),
                                                    onPressed: validateEmail(emailController.text)
                                                        ? () async {
                                                            setState(() {
                                                              generalUserSettings["Email"] = email;
                                                              stagePassword = true;
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
                                                            "Continue",
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
                                          )
                                        ],
                                      ),
                                    ) //login
                        ],
                      ) // Content
                    ],
                  )),
            ),
          );
        }),
      ),
    );
  }
}
