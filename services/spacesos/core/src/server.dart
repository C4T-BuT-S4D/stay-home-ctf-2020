import 'package:grpc/grpc.dart';
import 'package:grpc/src/server/call.dart';
import 'package:quiver/cache.dart';

import 'db.dart';
import 'protos/spacesos.pbgrpc.dart';

class SpaceSosCoreService extends SpaceSosServiceBase {
  MapCache<String, String> _sessionsCache;

  Repository _repository;

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
  Future<CrashResponse> crash(ServiceCall call, CrashRequest request) {
    return null;
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
      ServiceCall call, GetCrashesRequest request) {
    // TODO: implement getCrashes
    return null;
  }

  @override
  Future<GetLatestCrashesResponse> getLatestCrashes(
      ServiceCall call, GetLatestCrashesRequest request) {

    return null;
  }

  @override
  Future<AuthResponse> login(ServiceCall call, AuthRequest request) async {
    final user =
        await _repository.FindUser(request.login, password: request.password);
    if (user != null) {
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
