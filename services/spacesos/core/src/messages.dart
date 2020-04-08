import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'protos/spacesos.pb.dart';

class MessageClient {
  String _baseUrl;

  MessageClient(this._baseUrl) {}

  Future<List<String>> Send(List<String> users, Crash crash) async {
    final jsonData = crash.writeToJson();
    List<Future<http.Response>> futures = new List();
    List<String> errors = new List();
    users.forEach((u) {
      futures.add(
          http.post("${_baseUrl}/send/${u}", body: jsonData).catchError((e) {
        errors.add(e.toString());
      }));
    });
    await Future.wait(futures);
    if (errors.length > 0) {
      throw errors[0];
    }
    List<String> results = new List();
    await futures.toList().forEach((response) async {
      var resp = await response;
      if (resp == null) {
        return;
      }
      if (resp.statusCode == 200) {
        results.add(resp.body);
      }
    });
    return results;
  }

  Future<List<Crash>> Receive(String user) async {
    final resp = await http.get("${_baseUrl}/recv/?user=${user}");
    List<Crash> crashes = new List();
    if (resp.statusCode == 200) {
      LineSplitter.split(resp.body).forEach((record) {
        crashes.add(Crash.fromJson(record));
      });
    }
    return crashes;
  }
}
