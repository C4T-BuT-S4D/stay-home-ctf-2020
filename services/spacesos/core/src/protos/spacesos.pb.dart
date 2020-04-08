///
//  Generated code. Do not modify.
//  source: spacesos.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'google/protobuf/timestamp.pb.dart' as $1;

class Coordinates extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Coordinates', package: const $pb.PackageName('spacesos'), createEmptyInstance: create)
    ..aOS(1, 'nearestPlanet')
    ..a<$core.double>(2, 'longitude', $pb.PbFieldType.OF)
    ..a<$core.double>(3, 'latitude', $pb.PbFieldType.OF)
    ..a<$core.double>(4, 'distance', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  Coordinates._() : super();
  factory Coordinates() => create();
  factory Coordinates.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Coordinates.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Coordinates clone() => Coordinates()..mergeFromMessage(this);
  Coordinates copyWith(void Function(Coordinates) updates) => super.copyWith((message) => updates(message as Coordinates));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Coordinates create() => Coordinates._();
  Coordinates createEmptyInstance() => create();
  static $pb.PbList<Coordinates> createRepeated() => $pb.PbList<Coordinates>();
  @$core.pragma('dart2js:noInline')
  static Coordinates getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Coordinates>(create);
  static Coordinates _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nearestPlanet => $_getSZ(0);
  @$pb.TagNumber(1)
  set nearestPlanet($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNearestPlanet() => $_has(0);
  @$pb.TagNumber(1)
  void clearNearestPlanet() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get longitude => $_getN(1);
  @$pb.TagNumber(2)
  set longitude($core.double v) { $_setFloat(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLongitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLongitude() => clearField(2);

  @$pb.TagNumber(3)
  $core.double get latitude => $_getN(2);
  @$pb.TagNumber(3)
  set latitude($core.double v) { $_setFloat(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasLatitude() => $_has(2);
  @$pb.TagNumber(3)
  void clearLatitude() => clearField(3);

  @$pb.TagNumber(4)
  $core.double get distance => $_getN(3);
  @$pb.TagNumber(4)
  set distance($core.double v) { $_setFloat(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDistance() => $_has(3);
  @$pb.TagNumber(4)
  void clearDistance() => clearField(4);
}

class Crash extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Crash', package: const $pb.PackageName('spacesos'), createEmptyInstance: create)
    ..aOS(1, 'spaceshipAccessToken')
    ..aOM<Coordinates>(2, 'coordinates', subBuilder: Coordinates.create)
    ..aOM<$1.Timestamp>(3, 'time', subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false
  ;

  Crash._() : super();
  factory Crash() => create();
  factory Crash.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Crash.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  Crash clone() => Crash()..mergeFromMessage(this);
  Crash copyWith(void Function(Crash) updates) => super.copyWith((message) => updates(message as Crash));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Crash create() => Crash._();
  Crash createEmptyInstance() => create();
  static $pb.PbList<Crash> createRepeated() => $pb.PbList<Crash>();
  @$core.pragma('dart2js:noInline')
  static Crash getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Crash>(create);
  static Crash _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get spaceshipAccessToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set spaceshipAccessToken($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSpaceshipAccessToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearSpaceshipAccessToken() => clearField(1);

  @$pb.TagNumber(2)
  Coordinates get coordinates => $_getN(1);
  @$pb.TagNumber(2)
  set coordinates(Coordinates v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCoordinates() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoordinates() => clearField(2);
  @$pb.TagNumber(2)
  Coordinates ensureCoordinates() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.Timestamp get time => $_getN(2);
  @$pb.TagNumber(3)
  set time($1.Timestamp v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearTime() => clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureTime() => $_ensure(2);
}

class PublicCrash extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PublicCrash', package: const $pb.PackageName('spacesos'), createEmptyInstance: create)
    ..aOS(1, 'user')
    ..aOM<Coordinates>(2, 'coordinates', subBuilder: Coordinates.create)
    ..hasRequiredFields = false
  ;

  PublicCrash._() : super();
  factory PublicCrash() => create();
  factory PublicCrash.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PublicCrash.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PublicCrash clone() => PublicCrash()..mergeFromMessage(this);
  PublicCrash copyWith(void Function(PublicCrash) updates) => super.copyWith((message) => updates(message as PublicCrash));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PublicCrash create() => PublicCrash._();
  PublicCrash createEmptyInstance() => create();
  static $pb.PbList<PublicCrash> createRepeated() => $pb.PbList<PublicCrash>();
  @$core.pragma('dart2js:noInline')
  static PublicCrash getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PublicCrash>(create);
  static PublicCrash _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get user => $_getSZ(0);
  @$pb.TagNumber(1)
  set user($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);

  @$pb.TagNumber(2)
  Coordinates get coordinates => $_getN(1);
  @$pb.TagNumber(2)
  set coordinates(Coordinates v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCoordinates() => $_has(1);
  @$pb.TagNumber(2)
  void clearCoordinates() => clearField(2);
  @$pb.TagNumber(2)
  Coordinates ensureCoordinates() => $_ensure(1);
}

class AuthRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AuthRequest', package: const $pb.PackageName('spacesos'), createEmptyInstance: create)
    ..aOS(1, 'login')
    ..aOS(2, 'password')
    ..hasRequiredFields = false
  ;

  AuthRequest._() : super();
  factory AuthRequest() => create();
  factory AuthRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  AuthRequest clone() => AuthRequest()..mergeFromMessage(this);
  AuthRequest copyWith(void Function(AuthRequest) updates) => super.copyWith((message) => updates(message as AuthRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AuthRequest create() => AuthRequest._();
  AuthRequest createEmptyInstance() => create();
  static $pb.PbList<AuthRequest> createRepeated() => $pb.PbList<AuthRequest>();
  @$core.pragma('dart2js:noInline')
  static AuthRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthRequest>(create);
  static AuthRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get login => $_getSZ(0);
  @$pb.TagNumber(1)
  set login($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLogin() => $_has(0);
  @$pb.TagNumber(1)
  void clearLogin() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => clearField(2);
}

class AuthResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AuthResponse', package: const $pb.PackageName('spacesos'), createEmptyInstance: create)
    ..aOS(1, 'id')
    ..aOS(2, 'sessionId', protoName: 'sessionId')
    ..hasRequiredFields = false
  ;

  AuthResponse._() : super();
  factory AuthResponse() => create();
  factory AuthResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AuthResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  AuthResponse clone() => AuthResponse()..mergeFromMessage(this);
  AuthResponse copyWith(void Function(AuthResponse) updates) => super.copyWith((message) => updates(message as AuthResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AuthResponse create() => AuthResponse._();
  AuthResponse createEmptyInstance() => create();
  static $pb.PbList<AuthResponse> createRepeated() => $pb.PbList<AuthResponse>();
  @$core.pragma('dart2js:noInline')
  static AuthResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AuthResponse>(create);
  static AuthResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sessionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set sessionId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSessionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearSessionId() => clearField(2);
}

class AddToFriendRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AddToFriendRequest', package: const $pb.PackageName('spacesos'), createEmptyInstance: create)
    ..aOS(1, 'sessionId', protoName: 'sessionId')
    ..aOS(2, 'username')
    ..hasRequiredFields = false
  ;

  AddToFriendRequest._() : super();
  factory AddToFriendRequest() => create();
  factory AddToFriendRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddToFriendRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  AddToFriendRequest clone() => AddToFriendRequest()..mergeFromMessage(this);
  AddToFriendRequest copyWith(void Function(AddToFriendRequest) updates) => super.copyWith((message) => updates(message as AddToFriendRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddToFriendRequest create() => AddToFriendRequest._();
  AddToFriendRequest createEmptyInstance() => create();
  static $pb.PbList<AddToFriendRequest> createRepeated() => $pb.PbList<AddToFriendRequest>();
  @$core.pragma('dart2js:noInline')
  static AddToFriendRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddToFriendRequest>(create);
  static AddToFriendRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get username => $_getSZ(1);
  @$pb.TagNumber(2)
  set username($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasUsername() => $_has(1);
  @$pb.TagNumber(2)
  void clearUsername() => clearField(2);
}

class AddToFriendResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('AddToFriendResponse', package: const $pb.PackageName('spacesos'), createEmptyInstance: create)
    ..aOB(1, 'mutual')
    ..hasRequiredFields = false
  ;

  AddToFriendResponse._() : super();
  factory AddToFriendResponse() => create();
  factory AddToFriendResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddToFriendResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  AddToFriendResponse clone() => AddToFriendResponse()..mergeFromMessage(this);
  AddToFriendResponse copyWith(void Function(AddToFriendResponse) updates) => super.copyWith((message) => updates(message as AddToFriendResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddToFriendResponse create() => AddToFriendResponse._();
  AddToFriendResponse createEmptyInstance() => create();
  static $pb.PbList<AddToFriendResponse> createRepeated() => $pb.PbList<AddToFriendResponse>();
  @$core.pragma('dart2js:noInline')
  static AddToFriendResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddToFriendResponse>(create);
  static AddToFriendResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get mutual => $_getBF(0);
  @$pb.TagNumber(1)
  set mutual($core.bool v) { $_setBool(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasMutual() => $_has(0);
  @$pb.TagNumber(1)
  void clearMutual() => clearField(1);
}

class FriendshipRequestsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FriendshipRequestsRequest', package: const $pb.PackageName('spacesos'), createEmptyInstance: create)
    ..aOS(1, 'sessionId', protoName: 'sessionId')
    ..hasRequiredFields = false
  ;

  FriendshipRequestsRequest._() : super();
  factory FriendshipRequestsRequest() => create();
  factory FriendshipRequestsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FriendshipRequestsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  FriendshipRequestsRequest clone() => FriendshipRequestsRequest()..mergeFromMessage(this);
  FriendshipRequestsRequest copyWith(void Function(FriendshipRequestsRequest) updates) => super.copyWith((message) => updates(message as FriendshipRequestsRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FriendshipRequestsRequest create() => FriendshipRequestsRequest._();
  FriendshipRequestsRequest createEmptyInstance() => create();
  static $pb.PbList<FriendshipRequestsRequest> createRepeated() => $pb.PbList<FriendshipRequestsRequest>();
  @$core.pragma('dart2js:noInline')
  static FriendshipRequestsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FriendshipRequestsRequest>(create);
  static FriendshipRequestsRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);
}

class FriendshipRequestResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FriendshipRequestResponse', package: const $pb.PackageName('spacesos'), createEmptyInstance: create)
    ..pPS(1, 'users')
    ..hasRequiredFields = false
  ;

  FriendshipRequestResponse._() : super();
  factory FriendshipRequestResponse() => create();
  factory FriendshipRequestResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FriendshipRequestResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  FriendshipRequestResponse clone() => FriendshipRequestResponse()..mergeFromMessage(this);
  FriendshipRequestResponse copyWith(void Function(FriendshipRequestResponse) updates) => super.copyWith((message) => updates(message as FriendshipRequestResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FriendshipRequestResponse create() => FriendshipRequestResponse._();
  FriendshipRequestResponse createEmptyInstance() => create();
  static $pb.PbList<FriendshipRequestResponse> createRepeated() => $pb.PbList<FriendshipRequestResponse>();
  @$core.pragma('dart2js:noInline')
  static FriendshipRequestResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FriendshipRequestResponse>(create);
  static FriendshipRequestResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get users => $_getList(0);
}

class FriendsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FriendsRequest', package: const $pb.PackageName('spacesos'), createEmptyInstance: create)
    ..aOS(1, 'sessionId', protoName: 'sessionId')
    ..hasRequiredFields = false
  ;

  FriendsRequest._() : super();
  factory FriendsRequest() => create();
  factory FriendsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FriendsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  FriendsRequest clone() => FriendsRequest()..mergeFromMessage(this);
  FriendsRequest copyWith(void Function(FriendsRequest) updates) => super.copyWith((message) => updates(message as FriendsRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FriendsRequest create() => FriendsRequest._();
  FriendsRequest createEmptyInstance() => create();
  static $pb.PbList<FriendsRequest> createRepeated() => $pb.PbList<FriendsRequest>();
  @$core.pragma('dart2js:noInline')
  static FriendsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FriendsRequest>(create);
  static FriendsRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);
}

class FriendsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FriendsResponse', package: const $pb.PackageName('spacesos'), createEmptyInstance: create)
    ..pPS(1, 'users')
    ..hasRequiredFields = false
  ;

  FriendsResponse._() : super();
  factory FriendsResponse() => create();
  factory FriendsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory FriendsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  FriendsResponse clone() => FriendsResponse()..mergeFromMessage(this);
  FriendsResponse copyWith(void Function(FriendsResponse) updates) => super.copyWith((message) => updates(message as FriendsResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static FriendsResponse create() => FriendsResponse._();
  FriendsResponse createEmptyInstance() => create();
  static $pb.PbList<FriendsResponse> createRepeated() => $pb.PbList<FriendsResponse>();
  @$core.pragma('dart2js:noInline')
  static FriendsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FriendsResponse>(create);
  static FriendsResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get users => $_getList(0);
}

class CrashRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CrashRequest', package: const $pb.PackageName('spacesos'), createEmptyInstance: create)
    ..aOS(1, 'sessionId', protoName: 'sessionId')
    ..aOM<Crash>(2, 'crash', subBuilder: Crash.create)
    ..hasRequiredFields = false
  ;

  CrashRequest._() : super();
  factory CrashRequest() => create();
  factory CrashRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CrashRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CrashRequest clone() => CrashRequest()..mergeFromMessage(this);
  CrashRequest copyWith(void Function(CrashRequest) updates) => super.copyWith((message) => updates(message as CrashRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CrashRequest create() => CrashRequest._();
  CrashRequest createEmptyInstance() => create();
  static $pb.PbList<CrashRequest> createRepeated() => $pb.PbList<CrashRequest>();
  @$core.pragma('dart2js:noInline')
  static CrashRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CrashRequest>(create);
  static CrashRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);

  @$pb.TagNumber(2)
  Crash get crash => $_getN(1);
  @$pb.TagNumber(2)
  set crash(Crash v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCrash() => $_has(1);
  @$pb.TagNumber(2)
  void clearCrash() => clearField(2);
  @$pb.TagNumber(2)
  Crash ensureCrash() => $_ensure(1);
}

class CrashResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CrashResponse', package: const $pb.PackageName('spacesos'), createEmptyInstance: create)
    ..aOS(1, 'result')
    ..hasRequiredFields = false
  ;

  CrashResponse._() : super();
  factory CrashResponse() => create();
  factory CrashResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CrashResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  CrashResponse clone() => CrashResponse()..mergeFromMessage(this);
  CrashResponse copyWith(void Function(CrashResponse) updates) => super.copyWith((message) => updates(message as CrashResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CrashResponse create() => CrashResponse._();
  CrashResponse createEmptyInstance() => create();
  static $pb.PbList<CrashResponse> createRepeated() => $pb.PbList<CrashResponse>();
  @$core.pragma('dart2js:noInline')
  static CrashResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CrashResponse>(create);
  static CrashResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get result => $_getSZ(0);
  @$pb.TagNumber(1)
  set result($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasResult() => $_has(0);
  @$pb.TagNumber(1)
  void clearResult() => clearField(1);
}

class GetCrashesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetCrashesRequest', package: const $pb.PackageName('spacesos'), createEmptyInstance: create)
    ..aOS(1, 'sessionId', protoName: 'sessionId')
    ..hasRequiredFields = false
  ;

  GetCrashesRequest._() : super();
  factory GetCrashesRequest() => create();
  factory GetCrashesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCrashesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  GetCrashesRequest clone() => GetCrashesRequest()..mergeFromMessage(this);
  GetCrashesRequest copyWith(void Function(GetCrashesRequest) updates) => super.copyWith((message) => updates(message as GetCrashesRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetCrashesRequest create() => GetCrashesRequest._();
  GetCrashesRequest createEmptyInstance() => create();
  static $pb.PbList<GetCrashesRequest> createRepeated() => $pb.PbList<GetCrashesRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCrashesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCrashesRequest>(create);
  static GetCrashesRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sessionId => $_getSZ(0);
  @$pb.TagNumber(1)
  set sessionId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSessionId() => $_has(0);
  @$pb.TagNumber(1)
  void clearSessionId() => clearField(1);
}

class GetCrashesResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetCrashesResponse', package: const $pb.PackageName('spacesos'), createEmptyInstance: create)
    ..pc<Crash>(1, 'crashes', $pb.PbFieldType.PM, subBuilder: Crash.create)
    ..hasRequiredFields = false
  ;

  GetCrashesResponse._() : super();
  factory GetCrashesResponse() => create();
  factory GetCrashesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCrashesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  GetCrashesResponse clone() => GetCrashesResponse()..mergeFromMessage(this);
  GetCrashesResponse copyWith(void Function(GetCrashesResponse) updates) => super.copyWith((message) => updates(message as GetCrashesResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetCrashesResponse create() => GetCrashesResponse._();
  GetCrashesResponse createEmptyInstance() => create();
  static $pb.PbList<GetCrashesResponse> createRepeated() => $pb.PbList<GetCrashesResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCrashesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCrashesResponse>(create);
  static GetCrashesResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<Crash> get crashes => $_getList(0);
}

class GetLatestCrashesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetLatestCrashesRequest', package: const $pb.PackageName('spacesos'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  GetLatestCrashesRequest._() : super();
  factory GetLatestCrashesRequest() => create();
  factory GetLatestCrashesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetLatestCrashesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  GetLatestCrashesRequest clone() => GetLatestCrashesRequest()..mergeFromMessage(this);
  GetLatestCrashesRequest copyWith(void Function(GetLatestCrashesRequest) updates) => super.copyWith((message) => updates(message as GetLatestCrashesRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetLatestCrashesRequest create() => GetLatestCrashesRequest._();
  GetLatestCrashesRequest createEmptyInstance() => create();
  static $pb.PbList<GetLatestCrashesRequest> createRepeated() => $pb.PbList<GetLatestCrashesRequest>();
  @$core.pragma('dart2js:noInline')
  static GetLatestCrashesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetLatestCrashesRequest>(create);
  static GetLatestCrashesRequest _defaultInstance;
}

class GetLatestCrashesResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GetLatestCrashesResponse', package: const $pb.PackageName('spacesos'), createEmptyInstance: create)
    ..pc<PublicCrash>(1, 'crashes', $pb.PbFieldType.PM, subBuilder: PublicCrash.create)
    ..hasRequiredFields = false
  ;

  GetLatestCrashesResponse._() : super();
  factory GetLatestCrashesResponse() => create();
  factory GetLatestCrashesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetLatestCrashesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  GetLatestCrashesResponse clone() => GetLatestCrashesResponse()..mergeFromMessage(this);
  GetLatestCrashesResponse copyWith(void Function(GetLatestCrashesResponse) updates) => super.copyWith((message) => updates(message as GetLatestCrashesResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetLatestCrashesResponse create() => GetLatestCrashesResponse._();
  GetLatestCrashesResponse createEmptyInstance() => create();
  static $pb.PbList<GetLatestCrashesResponse> createRepeated() => $pb.PbList<GetLatestCrashesResponse>();
  @$core.pragma('dart2js:noInline')
  static GetLatestCrashesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetLatestCrashesResponse>(create);
  static GetLatestCrashesResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<PublicCrash> get crashes => $_getList(0);
}

