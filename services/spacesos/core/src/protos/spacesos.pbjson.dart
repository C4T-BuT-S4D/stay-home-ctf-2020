///
//  Generated code. Do not modify.
//  source: spacesos.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

const Coordinates$json = const {
  '1': 'Coordinates',
  '2': const [
    const {'1': 'nearest_planet', '3': 1, '4': 1, '5': 9, '10': 'nearestPlanet'},
    const {'1': 'longitude', '3': 2, '4': 1, '5': 2, '10': 'longitude'},
    const {'1': 'latitude', '3': 3, '4': 1, '5': 2, '10': 'latitude'},
    const {'1': 'distance', '3': 4, '4': 1, '5': 2, '10': 'distance'},
  ],
};

const Crash$json = const {
  '1': 'Crash',
  '2': const [
    const {'1': 'spaceship_access_token', '3': 1, '4': 1, '5': 9, '10': 'spaceshipAccessToken'},
    const {'1': 'coordinates', '3': 2, '4': 1, '5': 11, '6': '.spacesos.Coordinates', '10': 'coordinates'},
    const {'1': 'time', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'time'},
  ],
};

const PublicCrash$json = const {
  '1': 'PublicCrash',
  '2': const [
    const {'1': 'user_name', '3': 1, '4': 1, '5': 9, '10': 'userName'},
    const {'1': 'coordinates', '3': 2, '4': 1, '5': 11, '6': '.spacesos.Coordinates', '10': 'coordinates'},
  ],
};

const AuthRequest$json = const {
  '1': 'AuthRequest',
  '2': const [
    const {'1': 'login', '3': 1, '4': 1, '5': 9, '10': 'login'},
    const {'1': 'password', '3': 2, '4': 1, '5': 9, '10': 'password'},
  ],
};

const CrashRequest$json = const {
  '1': 'CrashRequest',
  '2': const [
    const {'1': 'sessionId', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'crash', '3': 2, '4': 1, '5': 11, '6': '.spacesos.Crash', '10': 'crash'},
  ],
};

const GetCrashesRequest$json = const {
  '1': 'GetCrashesRequest',
  '2': const [
    const {'1': 'sessionId', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

const AddToFriendRequest$json = const {
  '1': 'AddToFriendRequest',
  '2': const [
    const {'1': 'sessionId', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'user_name', '3': 2, '4': 1, '5': 9, '10': 'userName'},
  ],
};

const FriendshipRequestsRequest$json = const {
  '1': 'FriendshipRequestsRequest',
  '2': const [
    const {'1': 'sessionId', '3': 1, '4': 1, '5': 9, '10': 'sessionId'},
  ],
};

const GetLatestCrashesRequest$json = const {
  '1': 'GetLatestCrashesRequest',
};

const AuthResponse$json = const {
  '1': 'AuthResponse',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    const {'1': 'sessionId', '3': 2, '4': 1, '5': 9, '10': 'sessionId'},
    const {'1': 'error', '3': 3, '4': 1, '5': 9, '10': 'error'},
  ],
};

const AddToFriendResponse$json = const {
  '1': 'AddToFriendResponse',
  '2': const [
    const {'1': 'mutual', '3': 1, '4': 1, '5': 8, '10': 'mutual'},
  ],
};

const FriendshipRequestResponse$json = const {
  '1': 'FriendshipRequestResponse',
  '2': const [
    const {'1': 'users', '3': 1, '4': 3, '5': 9, '10': 'users'},
  ],
};

const CrashResponse$json = const {
  '1': 'CrashResponse',
  '2': const [
    const {'1': 'confirmed', '3': 1, '4': 1, '5': 8, '10': 'confirmed'},
  ],
};

const GetCrashesResponse$json = const {
  '1': 'GetCrashesResponse',
  '2': const [
    const {'1': 'crashes', '3': 1, '4': 3, '5': 11, '6': '.spacesos.Crash', '10': 'crashes'},
  ],
};

const GetLatestCrashesResponse$json = const {
  '1': 'GetLatestCrashesResponse',
  '2': const [
    const {'1': 'crashes', '3': 1, '4': 3, '5': 11, '6': '.spacesos.PublicCrash', '10': 'crashes'},
  ],
};

