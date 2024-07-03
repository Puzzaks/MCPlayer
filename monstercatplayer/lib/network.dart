import 'package:http/http.dart' as http;
import 'dart:convert';
import 'memory.dart';

Future getUserPlaylists() async {
  var token = "";
  await getString("session").then((value) async {
    token = value;
  });
  final headers = {
    'Content-Type': 'application/json;',
    'charset': 'utf-8;',
    'Cookie': 'cid=$token'
  };
  final params = {
    'fields': "name,tracks",
    'mylibrary': "1"
  };
  const endpoint = "player.monstercat.app";
  const method = "api/playlists";
  final response = await http.get(Uri.https(endpoint, method, params),
    headers: headers,);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return "Error";
  }
}

Future getPlaylist(String playlist) async {
  var token = "";
  await getString("session").then((value) async {
    token = value;
  });
  final headers = {
    'Content-Type': 'application/json;',
    'charset': 'utf-8;',
    'Cookie': 'cid=$token'
  };
  final params = {
    // 'limit': "4"
  };
  const endpoint = "player.monstercat.app";
  final method = "api/playlist/$playlist/catalog";
  final response = await http.get(Uri.https(endpoint, method, ), // + params when not empty
    headers: headers,);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return "Error";
  }
}

Future getMood(String mood) async {
  print("MoodLoading: $mood");
  var token = "";
  await getString("session").then((value) async {
    token = value;
  });
  final headers = {
    'Content-Type': 'application/json;',
    'charset': 'utf-8;',
    'Cookie': 'cid=$token'
  };
  final params = {
    // 'limit': "4"
  };
  const endpoint = "player.monstercat.app";
  final method = "api/catalog/mood/${mood.toLowerCase()}";
  final response = await http.get(Uri.https(endpoint, method, ), // + params when not empty
    headers: headers,);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return "Error";
  }
}

Future getChangelog() async {
  const endpoint = "raw.githubusercontent.com";
  final method = "Puzzak/MCPlayer/main/changelog.md";
  final response = await http.get(Uri.https(endpoint, method, ));
  if (response.statusCode == 200) {
    return response.body;
  } else {
    return "Error";
  }
}

Future getRelease(String release) async {
  var token = "";
  await getString("session").then((value) async {
    token = value;
  });
  final headers = {
    'Content-Type': 'application/json;',
    'charset': 'utf-8;',
    'Cookie': 'cid=$token'
  };
  final params = {
    // 'limit': "4"
  };
  const endpoint = "player.monstercat.app";
  final method = "api/catalog/release/$release";
  final response = await http.get(Uri.https(endpoint, method, ), // + params when not empty
    headers: headers,);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return "Error";
  }
}

Future getPlaylistInfo(String playlist) async {
  var token = "";
  await getString("session").then((value) async {
    token = value;
  });
  final headers = {
    'Content-Type': 'application/json;',
    'charset': 'utf-8;',
    'Cookie': 'cid=$token'
  };
  final params = {
    // 'limit': "4"
  };
  const endpoint = "player.monstercat.app";
  final method = "api/playlist/$playlist";
  final response = await http.get(Uri.https(endpoint, method, ), // + params when not empty
    headers: headers,);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return "Error";
  }
}

Future getMoodInfo(String mood) async {
  var token = "";
  await getString("session").then((value) async {
    token = value;
  });
  final headers = {
    'Content-Type': 'application/json;',
    'charset': 'utf-8;',
    'Cookie': 'cid=$token'
  };
  final params = {
    // 'limit': "4"
  };
  const endpoint = "player.monstercat.app";
  final method = "api/mood/${mood.toLowerCase()}";
  final response = await http.get(Uri.https(endpoint, method, ), // + params when not empty
    headers: headers,);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return "Error";
  }
}

Future getPlaylistAlbumArt(String playlist) async {
  var token = "";
  await getString("session").then((value) async {
    token = value;
  });
  final headers = {
    'Content-Type': 'application/json;',
    'charset': 'utf-8;',
    'Cookie': 'cid=$token'
  };
  final params = {
    'limit': "4"
  };
  const endpoint = "player.monstercat.app";
  final method = "api/playlist/$playlist/catalog";
  final response = await http.get(Uri.https(endpoint, method, params),
    headers: headers,);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return "Error";
  }
}

Future getUser() async {
  var token = "";
  await getString("session").then((value) async {
    token = value;
  });
  final headers = {
    'Content-Type': 'application/json;',
    'charset': 'utf-8;',
    'Cookie': 'cid=$token'
  };
  const endpoint = "player.monstercat.app";
  const method = "api/me";
  final response = await http.get(Uri.https(endpoint, method),
    headers: headers,);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return "Error";
  }
}

Future setUser(data) async {
  var token = "";
  await getString("session").then((value) async {
    token = value;
  });
  final headers = {
    'Content-Type': 'application/json',
    'charset': 'utf-8',
    'Cookie': 'cid=$token'
  };
  const endpoint = "player.monstercat.app";
  const method = "api/me";
  final response = await http.post(Uri.https(endpoint, method),headers: headers, body: jsonEncode({"User": data}));
  if (response.statusCode == 204) {
    return true;
  } else {
    return false;
  }
}

Future sendCreatePlaylist(String name, String description, bool publicity) async {
  var token = "";
  await getString("session").then((value) async {
    token = value;
  });
  final headers = {
    'Content-Type': 'application/json',
    'charset': 'utf-8',
    'Cookie': 'cid=$token'
  };
  const endpoint = "player.monstercat.app";
  const method = "api/playlist";
  final response = await http.post(Uri.https(endpoint, method),headers: headers, body: jsonEncode({"Title": name, "Description": description, "IsPublic": publicity}));
  if (response.statusCode == 201) {
    final playlistID = jsonDecode(response.body)["Id"];
    return playlistID;
  } else {
    return "Error";
  }
}

Future sendEditPlaylist(String playlistID, playlistData) async {
  var token = "";
  await getString("session").then((value) async {
    token = value;
  });
  final headers = {
    'Content-Type': 'application/json',
    'charset': 'utf-8',
    'Cookie': 'cid=$token'
  };
  const endpoint = "player.monstercat.app";
  final method = "api/playlist/$playlistID";
  final response = await http.post(Uri.https(endpoint, method),headers: headers, body: jsonEncode(playlistData));
  if (response.statusCode == 200) {
    final playlistID = jsonDecode(response.body)["Id"];
    return playlistID;
  } else {
    return "Error";
  }
}

Future sendAddToPlaylist(String playlistID, songData) async {
  var token = "";
  await getString("session").then((value) async {
    token = value;
  });
  final parameters = {
    "type": "add"
  };
  final headers = {
    'Content-Type': 'application/json',
    'charset': 'utf-8',
    'Cookie': 'cid=$token'
  };
  const endpoint = "player.monstercat.app";
  final method = "api/playlist/$playlistID/modify-items";
  final response = await http.post(
      Uri.https(endpoint, method, parameters),
      headers: headers,
      body: jsonEncode(
        {
          "Records": [
            {
              "PlaylistId": playlistID,
              "ReleaseId": songData["Release"]["Id"],
              "TrackId": songData["Id"],
            }
          ]
        }
      )
  );
  if (response.statusCode == 204) {
    return true;
  } else {
    return false;
  }
}

Future sendDeletePlaylist(String playlistID) async {
  var token = "";
  await getString("session").then((value) async {
    token = value;
  });
  final headers = {
    'Content-Type': 'application/json',
    'charset': 'utf-8',
    'Cookie': 'cid=$token'
  };
  const endpoint = "player.monstercat.app";
  final method = "api/playlist/$playlistID/delete";
  final response = await http.post(Uri.https(endpoint, method),headers: headers);
  if (response.statusCode == 202) {
    return true;
  } else {
    return "Error";
  }
}

Future setEmail(email) async {
  var token = "";
  await getString("session").then((value) async {
    token = value;
  });
  final headers = {
    'Content-Type': 'application/json',
    'charset': 'utf-8',
    'Cookie': 'cid=$token'
  };
  const endpoint = "player.monstercat.app";
  const method = "api/me/email";
  final response = await http.post(Uri.https(endpoint, method),headers: headers, body: jsonEncode({"NewEmail": email}));
  if (response.statusCode == 204) {
    return true;
  } else {
    return false;
  }
}

Future setPassword(String newPassword, String oldPassword) async {
  var token = "";
  var status = "Error";
  await getString("session").then((value) async {
    token = value;
  });
  final headers = {
    'Content-Type': 'application/json',
    'charset': 'utf-8',
    'Cookie': 'cid=$token',
    'Accept': 'application/json'
  };
  const endpoint = "www.monstercat.com";
  const method = "api/me/password";
  final response = await http.post(Uri.https(endpoint, method),headers: headers, body: jsonEncode({"NewPassword": newPassword, "OldPassword": oldPassword}));
  if (response.statusCode == 204) {
    return true;
  } else {
    status = jsonDecode(response.body)["Message"];
    return status;
  }
}

Future searchLocation(String search) async {
  final headers = {
    'Content-Type': 'application/json;',
    'charset': 'utf-8;',
  };
  final parameters = {
    "search": search
  };
  const endpoint = "player.monstercat.app";
  const method = "api/location-search";
  final response = await http.get(Uri.https(endpoint, method, parameters), headers: headers,);
  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return "Error";
  }
}

Future<bool> ask2FA(String emailID, String email, String password) async {
  final headers = {
    'Content-Type': 'application/json',
    'charset': 'utf-8',
    'Accept': 'application/json'
  };
  const endpoint = "player.monstercat.app";
  const method = "api/sign-in";
  final payload = json.encode({
    "Auth":{
      "Email": emailID
    },
    "Email": email,
    "Password": password,
  });
  final response = await http.post(Uri.https(endpoint, method),
      headers: headers, body: payload);
  if (response.statusCode == 200) {
    String cookie = "";
    String session = "";
    cookie = response.headers["set-cookie"]!;
    int startIndex = cookie.indexOf("cid=") + 4;
    int? endIndex = cookie.indexOf(";", startIndex);
    if (startIndex != -1 && endIndex != -1) {
      session =  cookie.substring(startIndex, endIndex);
    }
    await setString("session", session);
    return true;
  }
  return false;
}

Future<String> sendSignup(Map input) async {
  final headers = {
    'Content-Type': 'application/json',
    'charset': 'utf-8',
    'Accept': 'application/json'
  };
  const endpoint = "player.monstercat.app";
  const method = "api/sign-up";
  final payload = json.encode({
    "Email": input["Email"],
    "Password": input["Password"],
  });
  final response = await http.post(Uri.https(endpoint, method),
      headers: headers, body: payload);
  print(response.body);
  if (response.statusCode == 204) {
    String cookie = "";
    String session = "";
    cookie = response.headers["set-cookie"]!;
    int startIndex = cookie.indexOf("cid=") + 4;
    int? endIndex = cookie.indexOf(";", startIndex);
    if (startIndex != -1 && endIndex != -1) {
      session =  cookie.substring(startIndex, endIndex);
    }
    await setString("session", session);
    return "Success";
  }
  return response.body;
}

Future<String> sendEmail2FA(String email, String password) async {
  final headers = {
    'Content-Type': 'application/json',
    'charset': 'utf-8',
    'Accept': 'application/json'
  };
  const endpoint = "player.monstercat.app";
  const method = "api/me/two-factor/resend-email";
  final payload = json.encode({
    "Email": email,
    "Password": password,
  });
  final response = await http.post(Uri.https(endpoint, method),
      headers: headers, body: payload);
  if (response.statusCode == 200) {
    return jsonDecode(response.body)["Id"];
  }
  return "false";
}

Future<bool> send2FA(String OTP, String email, String password) async {
  final headers = {
    'Content-Type': 'application/json',
    'charset': 'utf-8',
    'Accept': 'application/json'
  };
  const endpoint = "player.monstercat.app";
  const method = "api/sign-in";
  final payload = json.encode({
    "Auth":{
      "TOTP": OTP
    },
    "Email": email,
    "Password": password,
  });
  final response = await http.post(Uri.https(endpoint, method),
      headers: headers, body: payload);
  if (response.statusCode == 200) {
    if(jsonDecode(response.body)["Needs2FA"]){
      return false;
    }else{
      String cookie = "";
      String session = "";
      cookie = response.headers["set-cookie"]!;
      int startIndex = cookie.indexOf("cid=") + 4;
      int? endIndex = cookie.indexOf(";", startIndex);
      if (startIndex != -1 && endIndex != -1) {
        session =  cookie.substring(startIndex, endIndex);
      }
      await setString("session", session);
      return true;
    }
  }
  return false;
}

Future<String> sendLogin(String email, String password) async {
  final headers = {
    'Content-Type': 'application/json',
    'charset': 'utf-8',
    'Accept': 'application/json'
  };
  const endpoint = "player.monstercat.app";
  const method = "api/sign-in";
  final payload = json.encode({
    "Email": email,
    "Password": password,
  });
  final response = await http.post(Uri.https(endpoint, method),
      headers: headers, body: payload);
  if (response.statusCode == 200) {
    if(jsonDecode(response.body)["Needs2FA"]){
      return response.body;
    }else{
      String cookie = "";
      String session = "";
      cookie = response.headers["set-cookie"]!;
      int startIndex = cookie.indexOf("cid=") + 4;
      int? endIndex = cookie.indexOf(";", startIndex);
      if (startIndex != -1 && endIndex != -1) {
        session =  cookie.substring(startIndex, endIndex);
      }
      await setString("session", session);
      return response.body;
    }
  }
  return "error";
}

Future<String> sendLogout() async {
  const endpoint = "player.monstercat.app";
  const method = "api/sign-out";
  String token = "";
  await getString("session").then((value) async {
    token = value;
  });
  final headers = {
    'Content-Type': 'application/json',
    'charset': 'utf-8',
    'Cookie': 'cid=$token',
    'Accept': 'application/json'
  };
  final response = await http.post(Uri.https(endpoint, method),
    headers: headers,);
  if (response.statusCode == 204) {
    return "true";
  } else {
    return "error";
  }
}

Future<String> enable2FA() async {
  const endpoint = "www.monstercat.com";
  const method = "api/me/two-factor/enable-email";
  String token = "";
  await getString("session").then((value) async {
    token = value;
  });
  final headers = {
    'Content-Type': 'application/json',
    'charset': 'utf-8',
    'Cookie': 'cid=$token',
    'Accept': 'application/json'
  };
  final response = await http.post(Uri.https(endpoint, method),
    headers: headers,);
  if (response.statusCode == 200) {
    return "true";
  } else {
    return response.body;
  }
}

Future<String> disable2FA() async {
  const endpoint = "www.monstercat.com";
  const method = "api/me/two-factor/disable-email";
  String token = "";
  await getString("session").then((value) async {
    token = value;
  });
  final headers = {
    'Content-Type': 'application/json',
    'charset': 'utf-8',
    'Cookie': 'cid=$token',
    'Accept': 'application/json'
  };
  final response = await http.post(Uri.https(endpoint, method),
    headers: headers,);
  if (response.statusCode == 204) {
    return "true";
  } else {
    return response.body;
  }
}

Future<bool> resetPassword(String email) async {
  final headers = {'Content-Type': 'application/json; charset=utf-8'};
  const endpoint = "www.monstercat.com";
  const method = "api/password/send-verification";
  final payload = json.encode({
    "Email": email,
    "ReturnUrl": "https://www.monstercat.com/reset-password?key=:code",
  });
  final response = await http.post(Uri.https(endpoint, method),
      headers: headers, body: payload);
  if (response.statusCode == 204) {
    return true;
  } else {
    return false;
  }
}

Future getMusic(int offset, int limit, bool streamerMode, String sort, Map<String, String> filters, String search) async {
  final headers = {'Content-Type': 'application/json; charset=utf-8'};
  const endpoint = "player.monstercat.app";
  const method = "api/catalog/browse";
  final params = {
    'offset': offset.toString(),
    'limit': limit.toString(),
    'streamerMode': streamerMode.toString(),
    'sort': sort.toString(),
    'search': search.toString()
  };
  params.addAll(filters);
  final response =
  await http.get(Uri.https(endpoint, method, params), headers: headers);
  if (response.statusCode == 200) {
    String decoded = utf8.decode(response.bodyBytes);
    final data = jsonDecode(decoded);
    return data;
  } else {
    throw Exception(response.body);
  }
}

Future getMoods() async {
  final headers = {'Content-Type': 'application/json; charset=utf-8'};
  const endpoint = "player.monstercat.app";
  const method = "api/moods";
  final response =
  await http.get(Uri.https(endpoint, method), headers: headers);
  if (response.statusCode == 200) {
    String decoded = utf8.decode(response.bodyBytes);
    final data = jsonDecode(decoded);
    return data;
  } else {
    throw Exception(response.body);
  }
}

Future getPlaylists() async {
  final headers = {'Content-Type': 'application/json; charset=utf-8'};
  const endpoint = "player.monstercat.app";
  const method = "api/menu-code/official_playlists";
  final response =
  await http.get(Uri.https(endpoint, method), headers: headers);
  if (response.statusCode == 200) {
    String decoded = utf8.decode(response.bodyBytes);
    final data = jsonDecode(decoded);
    return data;
  } else {
    throw Exception(response.body);
  }
}

Future getFilters() async {
  final headers = {'Content-Type': 'application/json; charset=utf-8'};
  const endpoint = "player.monstercat.app";
  const method = "api/catalog/filters";
  final response =
  await http.get(Uri.https(endpoint, method), headers: headers);
  if (response.statusCode == 200) {
    String decoded = utf8.decode(response.bodyBytes);
    final data = jsonDecode(decoded);
    return data;
  } else {
    throw Exception(response.body);
  }
}

Future getRecent() async {
    final headers = {'Content-Type': 'application/json; charset=utf-8'};
    const endpoint = "player.monstercat.app";
    const method = "api/catalog/latest-releases";
    final params = {
      'offset': "0",
      'limit': "20",
      'streamerMode': "true",
      'sort': "-date"
    };
    final response =
    await http.get(Uri.https(endpoint, method, params), headers: headers);
    if (response.statusCode == 200) {
      String decoded = utf8.decode(response.bodyBytes);
      final data = jsonDecode(decoded);
      return data;
    } else {
      throw Exception(response.body);
    }
  }