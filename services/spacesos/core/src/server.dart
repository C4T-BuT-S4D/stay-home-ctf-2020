import 'package:grpc/grpc.dart';
import 'package:grpc/src/server/call.dart';
import 'package:quiver/cache.dart';

import 'db.dart';
import 'messages.dart';
import 'protos/spacesos.pbgrpc.dart';

class SpaceSosCoreService extends SpaceSosServiceBase {
  MapCache<String, String> _sessionsCache;

  Repository _repository;
  MessageClient _messageClient;

  SpaceSosCoreService(this._repository, this._messageClient) {
    _sessionsCache = MapCache.lru(maximumSize: 2000);
  }

  Future<String> getBySessionId(String sessionId) async {
    var user = await _sessionsCache.get(sessionId);
    if (user != null) {
      return user;
    }

    var u = await _repository.GetBySession(sessionId);
    if (u == null) {
      return null;
    }
    _sessionsCache.set(sessionId, u);
    return u;
  }

  Future<String> getUsername(String sessionId) async {
    if (sessionId == null) {
      throw GrpcError.unauthenticated("Session id is empty");
    }
    final user = await getBySessionId(sessionId);
    if (user == null) {
      throw GrpcError.unauthenticated("Invalid Session id");
    }
    return user;
  }

  @override
  Future<AddToFriendResponse> addToFriend(
      ServiceCall call, AddToFriendRequest request) async {
    final user = await getUsername(request.sessionId);
    try {
      // If it's an answer for existing request.
      final haveRequest =
          await _repository.HaveFriendshipRequest(request.username, user);
      if (haveRequest) {
        await _repository.AddToFriends(request.username, user);
        await _repository.DeleteFriendshipRequest(request.username, user);
        return AddToFriendResponse()..mutual = true;
      }
      await _repository.AddFriendshipRequest(user, request.username);
      return AddToFriendResponse()..mutual = false;
    } catch (e) {
      throw GrpcError.aborted(e.toString());
    }
  }

  @override
  Future<CrashResponse> crash(ServiceCall call, CrashRequest request) async {
    final user = await getUsername(request.sessionId);
    try {
      if (request.expose) {
        await _repository.AddPublicCrash(request.crash, user);
      }
      var users = await _repository.ListFriends(user);
      users.add(user);
      final result = await _messageClient.Send(users, request.crash);
      return CrashResponse()..result = result.join(";");
    } catch (e) {
      throw GrpcError.aborted(e.toString());
    }
  }

  @override
  Future<FriendshipRequestResponse> friendshipRequests(
      ServiceCall call, FriendshipRequestsRequest request) async {
    final user = await getUsername(request.sessionId);
    final requests = await _repository.ListFriendshipRequests(user);
    final resp = FriendshipRequestResponse();
    resp.users.addAll(requests);
    return resp;
  }

  @override
  Future<GetCrashesResponse> getCrashes(
      ServiceCall call, GetCrashesRequest request) async {
    final user = await getUsername(request.sessionId);
    try {
      final messages = await _messageClient.Receive(user);
      var resp = GetCrashesResponse();
      resp.crashes.addAll(messages);
      return resp;
    } catch (e) {
      throw GrpcError.aborted(e.toString());
    }
  }

  @override
  Future<GetLatestCrashesResponse> getLatestCrashes(
      ServiceCall call, GetLatestCrashesRequest request) async {
    final resp = GetLatestCrashesResponse();
    final crashes = await _repository.LatestCrashes();
    resp.crashes.addAll(crashes);
    return resp;
  }

  @override
  Future<AuthResponse> login(ServiceCall call, AuthRequest request) async {
    final user =
        await _repository.FindUser(request.login, password: request.password);
    if (user == null) {
      throw GrpcError.notFound("User not found");
    }
    return AuthResponse()
      ..id = user["id"]
      ..sessionId = user["session_id"];
  }

  @override
  Future<AuthResponse> register(ServiceCall call, AuthRequest request) async {
    final user = await _repository.FindUser(request.login);
    if (user != null) {
      throw GrpcError.alreadyExists("User already exists");
    }
    try {
      final user = await _repository.AddUser(request.login, request.password);
      return AuthResponse()
        ..id = user["id"]
        ..sessionId = user["session_id"];
    } catch (e) {
      throw GrpcError.aborted(e.toString());
    }
  }

  @override
  Future<FriendsResponse> getFriends(
      ServiceCall call, FriendsRequest request) async {
    final sessionId = request.sessionId;
    String user = await getUsername(sessionId);
    var response = FriendsResponse();
    final users = await _repository.ListFriends(user);
    response.users.addAll(users);
    return response;
  }
}
