import 'package:mongo_dart/mongo_dart.dart';
import 'package:uuid/uuid.dart';

import 'protos/spacesos.pb.dart';

class Repository {
  ConnectionPool pool;

  Repository(this.pool) {}

  Future<Map<String, String>> FindUser(String username,
      {String password = null}) async {
    var db = await pool.connect();
    final coll = db.collection("users");
    var builder = where.eq("username", username);
    if (password != null) {
      builder = builder.eq("password", password);
    }
    final res = await coll.findOne(builder);
    if (res == null) {
      return null;
    }
    final id = res["_id"] as ObjectId;
    return {
      "id": id.toHexString(),
      "session_id": res["session_id"],
      "username": res["username"]
    };
  }

  Future<Map<String, String>> AddUser(String username, String password,
      {String sessionId = null}) async {
    if (sessionId == null) {
      sessionId = Uuid().v4();
    }
    var db = await pool.connect();
    final coll = db.collection("users");
    final res = await coll.insert(
        {"username": username, "password": password, "session_id": sessionId});
    if (res["err"] != null) {
      throw StateError(res["err"]);
    }
    return await FindUser(username);
  }

  Future<String> GetBySession(String sessionId) async {
    var db = await pool.connect();
    final coll = db.collection("users");
    final res = await coll.findOne(where.eq("session_id", sessionId));
    if (res == null) {
      return null;
    }
    return res["username"];
  }

  void AddFriendshipRequest(String fromUser, String toUser) async {
    var db = await pool.connect();
    final coll = db.collection("friend_requests");
    final res = await coll.insert({"from": fromUser, "to": toUser});
    if (res["err"] != null) {
      throw StateError(res["err"]);
    }
  }

  void AddToFriends(String firstUser, String secondUser) async {
    var db = await pool.connect();
    final coll = db.collection("users");
    var res = await coll.update(
        where.eq("username", firstUser), modify.push("friends", secondUser));
    if (res["err"] != null) {
      throw StateError(res["err"]);
    }
    res = await coll.update(
        where.eq("username", secondUser), modify.push("friends", firstUser));
    if (res["err"] != null) {
      throw StateError(res["err"]);
    }
  }

  Future<List<String>> ListFriends(String user) async {
    var db = await pool.connect();
    final coll = db.collection("users");
    final res = await coll.findOne(where.eq("username", user));
    if (res == null || res["friends"] == null) {
      return [];
    }
    return List<String>.from(res["friends"]);
  }

  Future<List<String>> ListFriendshipRequests(String user) async {
    var db = await pool.connect();
    final coll = db.collection("friend_requests");
    final res = await coll.find(where.eq("to", user).fields(["from"])).toList();
    if (res == null) {
      return null;
    }
    List<String> userIds = new List();
    res.forEach((userId) {
      userIds.add(userId["from"]);
    });
    return userIds;
  }

  Future<bool> HaveFriendshipRequest(String from, String to) async {
    var db = await pool.connect();
    final coll = db.collection("friend_requests");
    final res = await coll.findOne(where.eq("to", to).eq("from", from));
    return res != null;
  }

  void DeleteFriendshipRequest(String from, String to) async {
    var db = await pool.connect();
    final coll = db.collection("friend_requests");
    final res = await coll.remove(where.eq("to", to).eq("from", from));
    if (res["err"] != null) {
      throw StateError(res["err"]);
    }
  }

  Future<List<PublicCrash>> LatestCrashes({int limit = 150}) async {
    var db = await pool.connect();
    final coll = db.collection("crashes");
    final mongoRes = await coll
        .find(
            new SelectorBuilder().sortBy("time", descending: true).limit(limit))
        .toList();
    List<PublicCrash> result = new List();
    mongoRes.forEach((record) {
      var coordinates = record["coordinates"];
      final protoCords = Coordinates()
        ..distance = coordinates["distance"]
        ..latitude = coordinates["lat"]
        ..longitude = coordinates["long"]
        ..nearestPlanet = coordinates["planet"];

      result.add(PublicCrash()
        ..user = record["username"]
        ..coordinates = protoCords);
    });
    return result;
  }

  void AddPublicCrash(Crash crash, String user) async {
    var db = await pool.connect();
    final coll = db.collection("crashes");
    final coordinates = {
      "lat": crash.coordinates.latitude,
      "long": crash.coordinates.longitude,
      "planet": crash.coordinates.nearestPlanet,
      "distance": crash.coordinates.distance,
    };
    final res = await coll.insert({
      "coordinates": coordinates,
      "username": user,
      "time": crash.time.seconds.toInt(),
    });
    if (res["err"] != null) {
      throw StateError(res["err"]);
    }
  }
}
