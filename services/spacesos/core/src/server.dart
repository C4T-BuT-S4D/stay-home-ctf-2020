import 'package:grpc/src/server/call.dart';

import 'protos/spacesos.pbgrpc.dart';

class SpaceSosCoreService extends SpaceSosServiceBase {
  @override
  Future<AddToFriendResponse> addToFriend(ServiceCall call, AddToFriendRequest request) {
    // TODO: implement addToFriend
    return null;
  }

  @override
  Future<CrashResponse> crash(ServiceCall call, CrashRequest request) {
    return null;
  }

  @override
  Future<FriendshipRequestResponse> friendshipRequests(ServiceCall call, FriendshipRequestsRequest request) {
    // TODO: implement friendshipRequests
    return null;
  }

  @override
  Future<GetCrashesResponse> getCrashes(ServiceCall call, GetCrashesRequest request) {
    // TODO: implement getCrashes
    return null;
  }

  @override
  Future<GetLatestCrashesResponse> getLatestCrashes(ServiceCall call, GetLatestCrashesRequest request) {
    // TODO: implement getLatestCrashes
    return null;
  }

  @override
  Future<AuthResponse> login(ServiceCall call, AuthRequest request) {
    // TODO: implement login
    return null;
  }

  @override
  Future<AuthResponse> register(ServiceCall call, AuthRequest request) {
    // TODO: implement register
    return null;
  }

}
