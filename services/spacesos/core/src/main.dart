import 'package:mongo_dart/mongo_dart.dart';

import 'db.dart';
import 'protos/google/protobuf/timestamp.pb.dart' as tpb;
import 'protos/spacesos.pb.dart';

void main() async {
  var db = new Db("mongodb://localhost:27017/mongo_dart_kek");
  await db.open();
  var repo = Repository(db);
//  var u1 = await repo.AddUser("test1", "test");
//  var u2 = await repo.AddUser("test2", "test");
//  var u3 = await repo.AddUser("test3", "test");
//  repo.AddFriendshipRequest("test1", "test2");
//  var have = await repo.HaveFriendshipRequest("test1", "test10");
//  print(have);
//  var t = await repo.ListFriendshipRequests("test2");
//  print(t);
//  repo.AddToFriends("test2", "test1");
//  t = await repo.ListFriends("test2");
//  print(t);
//  t = await repo.ListFriends("test1");
//  print(t);
  var c = new Crash()..spaceshipAccessToken = "kek123huy";

  c.time = tpb.Timestamp.fromDateTime(DateTime.now());
  c.coordinates = Coordinates()
    ..distance = 3.14
    ..nearestPlanet = "camino"
    ..latitude = 1.337
    ..longitude = 3.771;
  await repo.AddPublicCrash(c, "test1");

  var res = await repo.LatestCrashes();
  print(res);
}
