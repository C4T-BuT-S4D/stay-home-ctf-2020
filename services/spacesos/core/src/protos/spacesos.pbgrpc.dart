///
//  Generated code. Do not modify.
//  source: spacesos.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'spacesos.pb.dart' as $0;
export 'spacesos.pb.dart';

class SpaceSosClient extends $grpc.Client {
  static final _$register = $grpc.ClientMethod<$0.AuthRequest, $0.AuthResponse>(
      '/spacesos.SpaceSos/Register',
      ($0.AuthRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.AuthResponse.fromBuffer(value));
  static final _$login = $grpc.ClientMethod<$0.AuthRequest, $0.AuthResponse>(
      '/spacesos.SpaceSos/Login',
      ($0.AuthRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.AuthResponse.fromBuffer(value));
  static final _$addToFriend =
      $grpc.ClientMethod<$0.AddToFriendRequest, $0.AddToFriendResponse>(
          '/spacesos.SpaceSos/AddToFriend',
          ($0.AddToFriendRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.AddToFriendResponse.fromBuffer(value));
  static final _$friendshipRequests = $grpc.ClientMethod<
          $0.FriendshipRequestsRequest, $0.FriendshipRequestResponse>(
      '/spacesos.SpaceSos/FriendshipRequests',
      ($0.FriendshipRequestsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.FriendshipRequestResponse.fromBuffer(value));
  static final _$getFriends =
      $grpc.ClientMethod<$0.FriendsRequest, $0.FriendsResponse>(
          '/spacesos.SpaceSos/GetFriends',
          ($0.FriendsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.FriendsResponse.fromBuffer(value));
  static final _$crash = $grpc.ClientMethod<$0.CrashRequest, $0.CrashResponse>(
      '/spacesos.SpaceSos/Crash',
      ($0.CrashRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.CrashResponse.fromBuffer(value));
  static final _$getCrashes =
      $grpc.ClientMethod<$0.GetCrashesRequest, $0.GetCrashesResponse>(
          '/spacesos.SpaceSos/GetCrashes',
          ($0.GetCrashesRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.GetCrashesResponse.fromBuffer(value));
  static final _$getLatestCrashes = $grpc.ClientMethod<
          $0.GetLatestCrashesRequest, $0.GetLatestCrashesResponse>(
      '/spacesos.SpaceSos/GetLatestCrashes',
      ($0.GetLatestCrashesRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.GetLatestCrashesResponse.fromBuffer(value));

  SpaceSosClient($grpc.ClientChannel channel, {$grpc.CallOptions options})
      : super(channel, options: options);

  $grpc.ResponseFuture<$0.AuthResponse> register($0.AuthRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$register, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.AuthResponse> login($0.AuthRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$login, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.AddToFriendResponse> addToFriend(
      $0.AddToFriendRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$addToFriend, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.FriendshipRequestResponse> friendshipRequests(
      $0.FriendshipRequestsRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$friendshipRequests, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.FriendsResponse> getFriends($0.FriendsRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getFriends, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.CrashResponse> crash($0.CrashRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(_$crash, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.GetCrashesResponse> getCrashes(
      $0.GetCrashesRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getCrashes, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }

  $grpc.ResponseFuture<$0.GetLatestCrashesResponse> getLatestCrashes(
      $0.GetLatestCrashesRequest request,
      {$grpc.CallOptions options}) {
    final call = $createCall(
        _$getLatestCrashes, $async.Stream.fromIterable([request]),
        options: options);
    return $grpc.ResponseFuture(call);
  }
}

abstract class SpaceSosServiceBase extends $grpc.Service {
  $core.String get $name => 'spacesos.SpaceSos';

  SpaceSosServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.AuthRequest, $0.AuthResponse>(
        'Register',
        register_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AuthRequest.fromBuffer(value),
        ($0.AuthResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.AuthRequest, $0.AuthResponse>(
        'Login',
        login_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.AuthRequest.fromBuffer(value),
        ($0.AuthResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.AddToFriendRequest, $0.AddToFriendResponse>(
            'AddToFriend',
            addToFriend_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.AddToFriendRequest.fromBuffer(value),
            ($0.AddToFriendResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FriendshipRequestsRequest,
            $0.FriendshipRequestResponse>(
        'FriendshipRequests',
        friendshipRequests_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.FriendshipRequestsRequest.fromBuffer(value),
        ($0.FriendshipRequestResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.FriendsRequest, $0.FriendsResponse>(
        'GetFriends',
        getFriends_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.FriendsRequest.fromBuffer(value),
        ($0.FriendsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.CrashRequest, $0.CrashResponse>(
        'Crash',
        crash_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.CrashRequest.fromBuffer(value),
        ($0.CrashResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetCrashesRequest, $0.GetCrashesResponse>(
        'GetCrashes',
        getCrashes_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetCrashesRequest.fromBuffer(value),
        ($0.GetCrashesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetLatestCrashesRequest,
            $0.GetLatestCrashesResponse>(
        'GetLatestCrashes',
        getLatestCrashes_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.GetLatestCrashesRequest.fromBuffer(value),
        ($0.GetLatestCrashesResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.AuthResponse> register_Pre(
      $grpc.ServiceCall call, $async.Future<$0.AuthRequest> request) async {
    return register(call, await request);
  }

  $async.Future<$0.AuthResponse> login_Pre(
      $grpc.ServiceCall call, $async.Future<$0.AuthRequest> request) async {
    return login(call, await request);
  }

  $async.Future<$0.AddToFriendResponse> addToFriend_Pre($grpc.ServiceCall call,
      $async.Future<$0.AddToFriendRequest> request) async {
    return addToFriend(call, await request);
  }

  $async.Future<$0.FriendshipRequestResponse> friendshipRequests_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.FriendshipRequestsRequest> request) async {
    return friendshipRequests(call, await request);
  }

  $async.Future<$0.FriendsResponse> getFriends_Pre(
      $grpc.ServiceCall call, $async.Future<$0.FriendsRequest> request) async {
    return getFriends(call, await request);
  }

  $async.Future<$0.CrashResponse> crash_Pre(
      $grpc.ServiceCall call, $async.Future<$0.CrashRequest> request) async {
    return crash(call, await request);
  }

  $async.Future<$0.GetCrashesResponse> getCrashes_Pre($grpc.ServiceCall call,
      $async.Future<$0.GetCrashesRequest> request) async {
    return getCrashes(call, await request);
  }

  $async.Future<$0.GetLatestCrashesResponse> getLatestCrashes_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.GetLatestCrashesRequest> request) async {
    return getLatestCrashes(call, await request);
  }

  $async.Future<$0.AuthResponse> register(
      $grpc.ServiceCall call, $0.AuthRequest request);
  $async.Future<$0.AuthResponse> login(
      $grpc.ServiceCall call, $0.AuthRequest request);
  $async.Future<$0.AddToFriendResponse> addToFriend(
      $grpc.ServiceCall call, $0.AddToFriendRequest request);
  $async.Future<$0.FriendshipRequestResponse> friendshipRequests(
      $grpc.ServiceCall call, $0.FriendshipRequestsRequest request);
  $async.Future<$0.FriendsResponse> getFriends(
      $grpc.ServiceCall call, $0.FriendsRequest request);
  $async.Future<$0.CrashResponse> crash(
      $grpc.ServiceCall call, $0.CrashRequest request);
  $async.Future<$0.GetCrashesResponse> getCrashes(
      $grpc.ServiceCall call, $0.GetCrashesRequest request);
  $async.Future<$0.GetLatestCrashesResponse> getLatestCrashes(
      $grpc.ServiceCall call, $0.GetLatestCrashesRequest request);
}
