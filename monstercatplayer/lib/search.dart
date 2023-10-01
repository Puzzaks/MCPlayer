import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monstercatplayer/elements.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'network.dart';

class searchPage extends StatefulWidget {

  @override
  searchPageState createState() => searchPageState();
}

class searchPageState extends State<searchPage> {
  List<Map> _data = [];
  bool _isLoading = false;
  int lastNum = 0;
  String search = "";
  TextEditingController searchController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  Future getSettings(key) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(key)) {
      return prefs.getString(key);
    } else {
      return "";
    }
  }

  Future setSettings(key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    getSettings("filters").then((value) {
      if (value == "") {
        selectedOptions = {};
      } else {
        selectedOptions = Map<String, String>.from(jsonDecode(value));
      }
      getSettings("search").then((value) {
        search = value;
        searchController = TextEditingController(text: search);
        addMusic(lastNum).then((value) {
          super.initState();
        });
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      addMusic(_data.length);
    }
  }

  void resetList() {
    lastNum = 0;
    _data.clear();
    addMusic(lastNum);
  }

  Future addMusic(int pos) async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      Map<String, String> filters = {};
      for (int a = 0; a < selectedOptions.length; a++) {
        final name = selectedOptions.keys.toList()[a];
        final type = selectedOptions[name];
        filters["$type[]"] = name;
      }
      getMusic(pos, 25, true, '-date', filters, search).then((value) {
        final rawmusic = value["Data"];
        lastNum = value["Offset"] + value["Limit"];
        for (var s = 0; s < rawmusic.length; s++) {
          _data.add(rawmusic[s]);
        }
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  Map<String, String> selectedOptions = {};

  Color bgColor = Color(0xFF202020);

  final buttonKey = GlobalKey();

  bool showFilters = true;


  @override
  Widget build(BuildContext topContext) {
    return MaterialApp(
      theme: ThemeData(iconTheme: const IconThemeData(color: Colors.teal)),
      darkTheme: ThemeData.dark().copyWith(
        cardColor: Color(0xFF202020),
        scaffoldBackgroundColor: const Color(0xFF040707),
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final appBarColor = MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Color(0xFF040707)
                : ThemeData.light().scaffoldBackgroundColor;

            SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle(
                systemNavigationBarColor: Color(0xFF040707),
              ),
            );
            double scaffoldHeight = constraints.maxHeight;
            double scaffoldWidth = constraints.maxWidth;
            if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
              bgColor = Color(0xFF202020);
            } else {
              bgColor = Colors.teal.withAlpha(64);
            }
            OutlineInputBorder searchBorder = const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(
                color: Colors.transparent, // Set the focused border color
                width: 2.0,
              ),
            );
            return OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                if (orientation == Orientation.portrait) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 10,bottom: 5, top:10),
                          child: TextField(
                            controller: searchController,
                            textInputAction: TextInputAction.search,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.25,
                              fontFamily: 'Comfortaa',
                            ),
                            cursorColor: Colors.teal,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.search_rounded),
                              suffixIconColor: Colors.teal,
                              contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                              filled: true,
                              fillColor: bgColor,
                              enabledBorder: searchBorder,
                              focusedBorder: searchBorder,
                              border: searchBorder,
                              hintText: 'Search Monstercat',
                              hintStyle: TextStyle(
                                fontSize: 16,
                                height: 1.25,
                                fontFamily: 'Comfortaa',
                              ),
                            ),
                            onTap: (){
                              setState(() {
                                showFilters = true;
                              });
                            },
                            onSubmitted: (value) async {
                              search = value;
                              await setSettings("search", value).then((value) {
                                resetList();
                                setState(() {
                                  showFilters = false;
                                });
                              });
                            },
                          ),
                        ),  // Search
                        showFilters
                            ? FutureBuilder(
                            future: getFilters(),
                            builder: (BuildContext context, AsyncSnapshot filters) {
                              if (filters.hasData) {
                                return Container(
                                  constraints: BoxConstraints(
                                    maxHeight: scaffoldHeight - 94.143,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                    child: SingleChildScrollView(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 15),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              filters.data.keys.toList()[0],
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Comfortaa',
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 15),
                                                child: Wrap(
                                                  spacing: 5.0, // Adjust the spacing between chips as needed
                                                  runSpacing: -10,
                                                  children: filters.data[filters.data.keys.toList()[0]]
                                                      .map((option) {
                                                    bool isSelected = selectedOptions.containsKey(option["Id"].toString());
                                                    return GestureDetector(
                                                      onTap: () async {
                                                        setState(() {
                                                          if (isSelected) {
                                                            selectedOptions.remove(option["Id"].toString());
                                                          } else {
                                                            selectedOptions[option["Id"].toString()] = filters.data.keys.toList()[0].toLowerCase();
                                                          }
                                                        });
                                                        await setSettings("filters", jsonEncode(selectedOptions)).then((value) {
                                                          resetList();
                                                        });
                                                      },
                                                      child: Chip(
                                                        label: Text(
                                                          option["Title"],
                                                          style: const TextStyle(
                                                            fontFamily: 'Comfortaa',
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        backgroundColor: isSelected ? Colors.teal : bgColor,
                                                        elevation: 1.0,
                                                        shadowColor: Colors.transparent,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                      ),
                                                    );
                                                  })
                                                      .toList()
                                                      .cast<Widget>(),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              filters.data.keys.toList()[1],
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Comfortaa',
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 15),
                                                child: Wrap(
                                                  spacing: 5.0, // Adjust the spacing between chips as needed
                                                  runSpacing: -10, // Adjust the run spacing as needed
                                                  children: filters.data[filters.data.keys.toList()[1]]
                                                      .map((option) {
                                                    bool isSelected = selectedOptions.containsKey(option);
                                                    return GestureDetector(
                                                      onTap: () async {
                                                        setState(() {
                                                          if (isSelected) {
                                                            selectedOptions.remove(option);
                                                          } else {
                                                            selectedOptions[option] = filters.data.keys.toList()[1].toLowerCase();
                                                          }
                                                        });
                                                        await setSettings("filters", jsonEncode(selectedOptions)).then((value) {
                                                          resetList();
                                                        });
                                                      },
                                                      child: Chip(
                                                        label: Text(
                                                          option,
                                                          style: const TextStyle(
                                                            fontFamily: 'Comfortaa',
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        backgroundColor: isSelected ? Colors.teal : bgColor,
                                                        elevation: 1.0,
                                                        shadowColor: Colors.transparent,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList().cast<Widget>(),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              filters.data.keys.toList()[2],
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Comfortaa',
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 15),
                                                child: Wrap(
                                                  spacing: 5.0, // Adjust the spacing between chips as needed
                                                  runSpacing: -10, // Adjust the run spacing as needed
                                                  children: filters.data[filters.data.keys.toList()[2]]
                                                      .map((option) {
                                                    bool isSelected = selectedOptions.containsKey(option);

                                                    return GestureDetector(
                                                      onTap: () async {
                                                        setState(() {
                                                          if (isSelected) {
                                                            selectedOptions.remove(option);
                                                          } else {
                                                            selectedOptions[option] = filters.data.keys.toList()[2].toLowerCase();
                                                          }
                                                        });
                                                        await setSettings("filters", jsonEncode(selectedOptions)).then((value) {
                                                          resetList();
                                                        });
                                                      },
                                                      child: Chip(
                                                        label: Text(
                                                          option,
                                                          style: const TextStyle(
                                                            fontFamily: 'Comfortaa',
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        backgroundColor: isSelected ? Colors.teal : bgColor,
                                                        elevation: 1.0,
                                                        shadowColor: Colors.transparent,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10.0),
                                                        ),
                                                      ),
                                                    );
                                                  })
                                                      .toList()
                                                      .cast<Widget>(),
                                                ),
                                              ),
                                            ),
                                            Text(
                                              filters.data.keys.toList()[3],
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Comfortaa',
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              child: Padding(
                                                padding: const EdgeInsets.only(bottom: 15),
                                                child: Wrap(
                                                  spacing: 5.0, // Adjust the spacing between chips as needed
                                                  runSpacing: -10, // Adjust the run spacing as needed
                                                  children: filters.data[filters.data.keys.toList()[3]]
                                                      .map((option) {
                                                    bool isSelected = selectedOptions.containsKey(option);
                                                    return GestureDetector(
                                                      onTap: () async {
                                                        setState(() {
                                                          if (isSelected) {
                                                            selectedOptions.remove(option);
                                                          } else {
                                                            selectedOptions[option] = filters.data.keys.toList()[3].toLowerCase();
                                                          }
                                                        });
                                                        await setSettings("filters", jsonEncode(selectedOptions)).then((value) {
                                                          resetList();
                                                        });
                                                      },
                                                      child: Chip(
                                                        label: Text(
                                                          option,
                                                          style: const TextStyle(
                                                            fontFamily: 'Comfortaa',
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        backgroundColor: isSelected ? Colors.teal : bgColor,
                                                        elevation: 1.0,
                                                        shadowColor: Colors.transparent,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10.0),
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
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                return const LinearProgressIndicator(
                                  color: Colors.teal,
                                  backgroundColor: Colors.transparent,
                                );
                              }
                            })
                            : Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                            child: ListView.builder(
                              controller: _scrollController,
                              itemCount: _data.length + 1,
                              itemBuilder: (context, index) {
                                if (index == _data.length) {
                                  return _isLoading
                                      ? const Center(
                                      child: LinearProgressIndicator(
                                        backgroundColor: Colors.transparent,
                                        color: Colors.teal,
                                      ))
                                      : Container();
                                }
                                return mcSearchTrackLine(
                                    data: _data[index],
                                    width: scaffoldWidth
                                );
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10, top: 28),
                            child: TextField(
                              controller: searchController,
                              textInputAction: TextInputAction.search,
                              style: const TextStyle(
                                fontSize: 16,
                                height: 1.25,
                                fontFamily: 'Comfortaa',
                              ),
                              cursorColor: Colors.teal,
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.search_rounded),
                                suffixIconColor: Colors.teal,
                                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                filled: true,
                                fillColor: bgColor,
                                enabledBorder: searchBorder,
                                focusedBorder: searchBorder,
                                border: searchBorder,
                                hintText: 'Search Monstercat',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  height: 1.25,
                                  fontFamily: 'Comfortaa',
                                ),
                              ),
                              onTap: (){
                                setState(() {
                                  showFilters = true;
                                });
                              },
                              onSubmitted: (value) async {
                                search = value;
                                await setSettings("search", value).then((value) {
                                  resetList();
                                  setState(() {
                                    showFilters = false;
                                  });
                                });
                              },
                            ),
                          ),  // Search
                          FutureBuilder(
                              future: getFilters(),
                              builder: (BuildContext context, AsyncSnapshot filters) {
                                if (filters.hasData) {
                                  return Container(
                                    constraints: BoxConstraints(
                                      maxHeight: scaffoldHeight - 76,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 15),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                filters.data.keys.toList()[0],
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Comfortaa',
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 15),
                                                  child: Wrap(
                                                    spacing: 5.0, // Adjust the spacing between chips as needed
                                                    runSpacing: -10,
                                                    children: filters.data[filters.data.keys.toList()[0]]
                                                        .map((option) {
                                                      bool isSelected = selectedOptions.containsKey(option["Id"].toString());
                                                      return GestureDetector(
                                                        onTap: () async {
                                                          setState(() {
                                                            if (isSelected) {
                                                              selectedOptions.remove(option["Id"].toString());
                                                            } else {
                                                              selectedOptions[option["Id"].toString()] = filters.data.keys.toList()[0].toLowerCase();
                                                            }
                                                          });
                                                          await setSettings("filters", jsonEncode(selectedOptions)).then((value) {
                                                            resetList();
                                                          });
                                                        },
                                                        child: Chip(
                                                          label: Text(
                                                            option["Title"],
                                                            style: const TextStyle(
                                                              fontFamily: 'Comfortaa',
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          backgroundColor: isSelected ? Colors.teal : bgColor,
                                                          elevation: 1.0,
                                                          shadowColor: Colors.transparent,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10.0),
                                                          ),
                                                        ),
                                                      );
                                                    })
                                                        .toList()
                                                        .cast<Widget>(),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                filters.data.keys.toList()[1],
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Comfortaa',
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 15),
                                                  child: Wrap(
                                                    spacing: 5.0, // Adjust the spacing between chips as needed
                                                    runSpacing: -10, // Adjust the run spacing as needed
                                                    children: filters.data[filters.data.keys.toList()[1]]
                                                        .map((option) {
                                                      bool isSelected = selectedOptions.containsKey(option);
                                                      return GestureDetector(
                                                        onTap: () async {
                                                          setState(() {
                                                            if (isSelected) {
                                                              selectedOptions.remove(option);
                                                            } else {
                                                              selectedOptions[option] = filters.data.keys.toList()[1].toLowerCase();
                                                            }
                                                          });
                                                          await setSettings("filters", jsonEncode(selectedOptions)).then((value) {
                                                            resetList();
                                                          });
                                                        },
                                                        child: Chip(
                                                          label: Text(
                                                            option,
                                                            style: const TextStyle(
                                                              fontFamily: 'Comfortaa',
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          backgroundColor: isSelected ? Colors.teal : bgColor,
                                                          elevation: 1.0,
                                                          shadowColor: Colors.transparent,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10.0),
                                                          ),
                                                        ),
                                                      );
                                                    }).toList().cast<Widget>(),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                filters.data.keys.toList()[2],
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Comfortaa',
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 15),
                                                  child: Wrap(
                                                    spacing: 5.0, // Adjust the spacing between chips as needed
                                                    runSpacing: -10, // Adjust the run spacing as needed
                                                    children: filters.data[filters.data.keys.toList()[2]]
                                                        .map((option) {
                                                      bool isSelected = selectedOptions.containsKey(option);

                                                      return GestureDetector(
                                                        onTap: () async {
                                                          setState(() {
                                                            if (isSelected) {
                                                              selectedOptions.remove(option);
                                                            } else {
                                                              selectedOptions[option] = filters.data.keys.toList()[2].toLowerCase();
                                                            }
                                                          });
                                                          await setSettings("filters", jsonEncode(selectedOptions)).then((value) {
                                                            resetList();
                                                          });
                                                        },
                                                        child: Chip(
                                                          label: Text(
                                                            option,
                                                            style: const TextStyle(
                                                              fontFamily: 'Comfortaa',
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          backgroundColor: isSelected ? Colors.teal : bgColor,
                                                          elevation: 1.0,
                                                          shadowColor: Colors.transparent,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10.0),
                                                          ),
                                                        ),
                                                      );
                                                    })
                                                        .toList()
                                                        .cast<Widget>(),
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                filters.data.keys.toList()[3],
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Comfortaa',
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(bottom: 15),
                                                  child: Wrap(
                                                    spacing: 5.0, // Adjust the spacing between chips as needed
                                                    runSpacing: -10, // Adjust the run spacing as needed
                                                    children: filters.data[filters.data.keys.toList()[3]]
                                                        .map((option) {
                                                      bool isSelected = selectedOptions.containsKey(option);
                                                      return GestureDetector(
                                                        onTap: () async {
                                                          setState(() {
                                                            if (isSelected) {
                                                              selectedOptions.remove(option);
                                                            } else {
                                                              selectedOptions[option] = filters.data.keys.toList()[3].toLowerCase();
                                                            }
                                                          });
                                                          await setSettings("filters", jsonEncode(selectedOptions)).then((value) {
                                                            resetList();
                                                          });
                                                        },
                                                        child: Chip(
                                                          label: Text(
                                                            option,
                                                            style: const TextStyle(
                                                              fontFamily: 'Comfortaa',
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                          backgroundColor: isSelected ? Colors.teal : bgColor,
                                                          elevation: 1.0,
                                                          shadowColor: Colors.transparent,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10.0),
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
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const LinearProgressIndicator(
                                    color: Colors.teal,
                                    backgroundColor: Colors.transparent,
                                  );
                                }
                              })
                        ],
                      ),
                    ),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: _data.length + 1,
                          itemBuilder: (context, index) {
                            if (index == _data.length) {
                              return _isLoading
                                  ? const Center(
                                  child: LinearProgressIndicator(
                                    backgroundColor: Colors.transparent,
                                    color: Colors.teal,
                                  ))
                                  : Container();
                            }
                            return mcSearchTrackLine(
                                data: _data[index],
                                width: scaffoldWidth / 2
                            );
                          },
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
