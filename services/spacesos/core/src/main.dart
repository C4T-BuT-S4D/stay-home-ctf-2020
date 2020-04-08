import 'package:grpc/grpc.dart' as grpc;
import 'package:mongo_dart/mongo_dart.dart';

import 'db.dart';
import 'messages.dart';
import 'server.dart';

void main() async {
  var dbPool = new ConnectionPool(
      50, () => Db("mongodb://db:27017/spacesos"));

  final repo = Repository(dbPool);
  final ms = MessageClient("http://messenger:8080");
  final service = SpaceSosCoreService(repo, ms);
  final server = grpc.Server([service]);
  await server.serve(port: 3333);
  print('Server listening on port ${server.port}...');
}
