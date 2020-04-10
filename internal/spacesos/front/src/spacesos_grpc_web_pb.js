/**
 * @fileoverview gRPC-Web generated client stub for spacesos
 * @enhanceable
 * @public
 */

// GENERATED CODE -- DO NOT EDIT!



const grpc = {};
grpc.web = require('grpc-web');


var google_protobuf_timestamp_pb = require('google-protobuf/google/protobuf/timestamp_pb.js')
const proto = {};
proto.spacesos = require('./spacesos_pb.js');

/**
 * @param {string} hostname
 * @param {?Object} credentials
 * @param {?Object} options
 * @constructor
 * @struct
 * @final
 */
proto.spacesos.SpaceSosClient =
    function(hostname, credentials, options) {
  if (!options) options = {};
  options['format'] = 'text';

  /**
   * @private @const {!grpc.web.GrpcWebClientBase} The client
   */
  this.client_ = new grpc.web.GrpcWebClientBase(options);

  /**
   * @private @const {string} The hostname
   */
  this.hostname_ = hostname;

};


/**
 * @param {string} hostname
 * @param {?Object} credentials
 * @param {?Object} options
 * @constructor
 * @struct
 * @final
 */
proto.spacesos.SpaceSosPromiseClient =
    function(hostname, credentials, options) {
  if (!options) options = {};
  options['format'] = 'text';

  /**
   * @private @const {!grpc.web.GrpcWebClientBase} The client
   */
  this.client_ = new grpc.web.GrpcWebClientBase(options);

  /**
   * @private @const {string} The hostname
   */
  this.hostname_ = hostname;

};


/**
 * @const
 * @type {!grpc.web.MethodDescriptor<
 *   !proto.spacesos.AuthRequest,
 *   !proto.spacesos.AuthResponse>}
 */
const methodDescriptor_SpaceSos_Register = new grpc.web.MethodDescriptor(
  '/spacesos.SpaceSos/Register',
  grpc.web.MethodType.UNARY,
  proto.spacesos.AuthRequest,
  proto.spacesos.AuthResponse,
  /**
   * @param {!proto.spacesos.AuthRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  proto.spacesos.AuthResponse.deserializeBinary
);


/**
 * @const
 * @type {!grpc.web.AbstractClientBase.MethodInfo<
 *   !proto.spacesos.AuthRequest,
 *   !proto.spacesos.AuthResponse>}
 */
const methodInfo_SpaceSos_Register = new grpc.web.AbstractClientBase.MethodInfo(
  proto.spacesos.AuthResponse,
  /**
   * @param {!proto.spacesos.AuthRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  proto.spacesos.AuthResponse.deserializeBinary
);


/**
 * @param {!proto.spacesos.AuthRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @param {function(?grpc.web.Error, ?proto.spacesos.AuthResponse)}
 *     callback The callback function(error, response)
 * @return {!grpc.web.ClientReadableStream<!proto.spacesos.AuthResponse>|undefined}
 *     The XHR Node Readable Stream
 */
proto.spacesos.SpaceSosClient.prototype.register =
    function(request, metadata, callback) {
  return this.client_.rpcCall(this.hostname_ +
      '/spacesos.SpaceSos/Register',
      request,
      metadata || {},
      methodDescriptor_SpaceSos_Register,
      callback);
};


/**
 * @param {!proto.spacesos.AuthRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @return {!Promise<!proto.spacesos.AuthResponse>}
 *     A native promise that resolves to the response
 */
proto.spacesos.SpaceSosPromiseClient.prototype.register =
    function(request, metadata) {
  return this.client_.unaryCall(this.hostname_ +
      '/spacesos.SpaceSos/Register',
      request,
      metadata || {},
      methodDescriptor_SpaceSos_Register);
};


/**
 * @const
 * @type {!grpc.web.MethodDescriptor<
 *   !proto.spacesos.AuthRequest,
 *   !proto.spacesos.AuthResponse>}
 */
const methodDescriptor_SpaceSos_Login = new grpc.web.MethodDescriptor(
  '/spacesos.SpaceSos/Login',
  grpc.web.MethodType.UNARY,
  proto.spacesos.AuthRequest,
  proto.spacesos.AuthResponse,
  /**
   * @param {!proto.spacesos.AuthRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  proto.spacesos.AuthResponse.deserializeBinary
);


/**
 * @const
 * @type {!grpc.web.AbstractClientBase.MethodInfo<
 *   !proto.spacesos.AuthRequest,
 *   !proto.spacesos.AuthResponse>}
 */
const methodInfo_SpaceSos_Login = new grpc.web.AbstractClientBase.MethodInfo(
  proto.spacesos.AuthResponse,
  /**
   * @param {!proto.spacesos.AuthRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  proto.spacesos.AuthResponse.deserializeBinary
);


/**
 * @param {!proto.spacesos.AuthRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @param {function(?grpc.web.Error, ?proto.spacesos.AuthResponse)}
 *     callback The callback function(error, response)
 * @return {!grpc.web.ClientReadableStream<!proto.spacesos.AuthResponse>|undefined}
 *     The XHR Node Readable Stream
 */
proto.spacesos.SpaceSosClient.prototype.login =
    function(request, metadata, callback) {
  return this.client_.rpcCall(this.hostname_ +
      '/spacesos.SpaceSos/Login',
      request,
      metadata || {},
      methodDescriptor_SpaceSos_Login,
      callback);
};


/**
 * @param {!proto.spacesos.AuthRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @return {!Promise<!proto.spacesos.AuthResponse>}
 *     A native promise that resolves to the response
 */
proto.spacesos.SpaceSosPromiseClient.prototype.login =
    function(request, metadata) {
  return this.client_.unaryCall(this.hostname_ +
      '/spacesos.SpaceSos/Login',
      request,
      metadata || {},
      methodDescriptor_SpaceSos_Login);
};


/**
 * @const
 * @type {!grpc.web.MethodDescriptor<
 *   !proto.spacesos.AddToFriendRequest,
 *   !proto.spacesos.AddToFriendResponse>}
 */
const methodDescriptor_SpaceSos_AddToFriend = new grpc.web.MethodDescriptor(
  '/spacesos.SpaceSos/AddToFriend',
  grpc.web.MethodType.UNARY,
  proto.spacesos.AddToFriendRequest,
  proto.spacesos.AddToFriendResponse,
  /**
   * @param {!proto.spacesos.AddToFriendRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  proto.spacesos.AddToFriendResponse.deserializeBinary
);


/**
 * @const
 * @type {!grpc.web.AbstractClientBase.MethodInfo<
 *   !proto.spacesos.AddToFriendRequest,
 *   !proto.spacesos.AddToFriendResponse>}
 */
const methodInfo_SpaceSos_AddToFriend = new grpc.web.AbstractClientBase.MethodInfo(
  proto.spacesos.AddToFriendResponse,
  /**
   * @param {!proto.spacesos.AddToFriendRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  proto.spacesos.AddToFriendResponse.deserializeBinary
);


/**
 * @param {!proto.spacesos.AddToFriendRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @param {function(?grpc.web.Error, ?proto.spacesos.AddToFriendResponse)}
 *     callback The callback function(error, response)
 * @return {!grpc.web.ClientReadableStream<!proto.spacesos.AddToFriendResponse>|undefined}
 *     The XHR Node Readable Stream
 */
proto.spacesos.SpaceSosClient.prototype.addToFriend =
    function(request, metadata, callback) {
  return this.client_.rpcCall(this.hostname_ +
      '/spacesos.SpaceSos/AddToFriend',
      request,
      metadata || {},
      methodDescriptor_SpaceSos_AddToFriend,
      callback);
};


/**
 * @param {!proto.spacesos.AddToFriendRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @return {!Promise<!proto.spacesos.AddToFriendResponse>}
 *     A native promise that resolves to the response
 */
proto.spacesos.SpaceSosPromiseClient.prototype.addToFriend =
    function(request, metadata) {
  return this.client_.unaryCall(this.hostname_ +
      '/spacesos.SpaceSos/AddToFriend',
      request,
      metadata || {},
      methodDescriptor_SpaceSos_AddToFriend);
};


/**
 * @const
 * @type {!grpc.web.MethodDescriptor<
 *   !proto.spacesos.FriendshipRequestsRequest,
 *   !proto.spacesos.FriendshipRequestResponse>}
 */
const methodDescriptor_SpaceSos_FriendshipRequests = new grpc.web.MethodDescriptor(
  '/spacesos.SpaceSos/FriendshipRequests',
  grpc.web.MethodType.UNARY,
  proto.spacesos.FriendshipRequestsRequest,
  proto.spacesos.FriendshipRequestResponse,
  /**
   * @param {!proto.spacesos.FriendshipRequestsRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  proto.spacesos.FriendshipRequestResponse.deserializeBinary
);


/**
 * @const
 * @type {!grpc.web.AbstractClientBase.MethodInfo<
 *   !proto.spacesos.FriendshipRequestsRequest,
 *   !proto.spacesos.FriendshipRequestResponse>}
 */
const methodInfo_SpaceSos_FriendshipRequests = new grpc.web.AbstractClientBase.MethodInfo(
  proto.spacesos.FriendshipRequestResponse,
  /**
   * @param {!proto.spacesos.FriendshipRequestsRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  proto.spacesos.FriendshipRequestResponse.deserializeBinary
);


/**
 * @param {!proto.spacesos.FriendshipRequestsRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @param {function(?grpc.web.Error, ?proto.spacesos.FriendshipRequestResponse)}
 *     callback The callback function(error, response)
 * @return {!grpc.web.ClientReadableStream<!proto.spacesos.FriendshipRequestResponse>|undefined}
 *     The XHR Node Readable Stream
 */
proto.spacesos.SpaceSosClient.prototype.friendshipRequests =
    function(request, metadata, callback) {
  return this.client_.rpcCall(this.hostname_ +
      '/spacesos.SpaceSos/FriendshipRequests',
      request,
      metadata || {},
      methodDescriptor_SpaceSos_FriendshipRequests,
      callback);
};


/**
 * @param {!proto.spacesos.FriendshipRequestsRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @return {!Promise<!proto.spacesos.FriendshipRequestResponse>}
 *     A native promise that resolves to the response
 */
proto.spacesos.SpaceSosPromiseClient.prototype.friendshipRequests =
    function(request, metadata) {
  return this.client_.unaryCall(this.hostname_ +
      '/spacesos.SpaceSos/FriendshipRequests',
      request,
      metadata || {},
      methodDescriptor_SpaceSos_FriendshipRequests);
};


/**
 * @const
 * @type {!grpc.web.MethodDescriptor<
 *   !proto.spacesos.FriendsRequest,
 *   !proto.spacesos.FriendsResponse>}
 */
const methodDescriptor_SpaceSos_GetFriends = new grpc.web.MethodDescriptor(
  '/spacesos.SpaceSos/GetFriends',
  grpc.web.MethodType.UNARY,
  proto.spacesos.FriendsRequest,
  proto.spacesos.FriendsResponse,
  /**
   * @param {!proto.spacesos.FriendsRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  proto.spacesos.FriendsResponse.deserializeBinary
);


/**
 * @const
 * @type {!grpc.web.AbstractClientBase.MethodInfo<
 *   !proto.spacesos.FriendsRequest,
 *   !proto.spacesos.FriendsResponse>}
 */
const methodInfo_SpaceSos_GetFriends = new grpc.web.AbstractClientBase.MethodInfo(
  proto.spacesos.FriendsResponse,
  /**
   * @param {!proto.spacesos.FriendsRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  proto.spacesos.FriendsResponse.deserializeBinary
);


/**
 * @param {!proto.spacesos.FriendsRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @param {function(?grpc.web.Error, ?proto.spacesos.FriendsResponse)}
 *     callback The callback function(error, response)
 * @return {!grpc.web.ClientReadableStream<!proto.spacesos.FriendsResponse>|undefined}
 *     The XHR Node Readable Stream
 */
proto.spacesos.SpaceSosClient.prototype.getFriends =
    function(request, metadata, callback) {
  return this.client_.rpcCall(this.hostname_ +
      '/spacesos.SpaceSos/GetFriends',
      request,
      metadata || {},
      methodDescriptor_SpaceSos_GetFriends,
      callback);
};


/**
 * @param {!proto.spacesos.FriendsRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @return {!Promise<!proto.spacesos.FriendsResponse>}
 *     A native promise that resolves to the response
 */
proto.spacesos.SpaceSosPromiseClient.prototype.getFriends =
    function(request, metadata) {
  return this.client_.unaryCall(this.hostname_ +
      '/spacesos.SpaceSos/GetFriends',
      request,
      metadata || {},
      methodDescriptor_SpaceSos_GetFriends);
};


/**
 * @const
 * @type {!grpc.web.MethodDescriptor<
 *   !proto.spacesos.CrashRequest,
 *   !proto.spacesos.CrashResponse>}
 */
const methodDescriptor_SpaceSos_Crash = new grpc.web.MethodDescriptor(
  '/spacesos.SpaceSos/Crash',
  grpc.web.MethodType.UNARY,
  proto.spacesos.CrashRequest,
  proto.spacesos.CrashResponse,
  /**
   * @param {!proto.spacesos.CrashRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  proto.spacesos.CrashResponse.deserializeBinary
);


/**
 * @const
 * @type {!grpc.web.AbstractClientBase.MethodInfo<
 *   !proto.spacesos.CrashRequest,
 *   !proto.spacesos.CrashResponse>}
 */
const methodInfo_SpaceSos_Crash = new grpc.web.AbstractClientBase.MethodInfo(
  proto.spacesos.CrashResponse,
  /**
   * @param {!proto.spacesos.CrashRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  proto.spacesos.CrashResponse.deserializeBinary
);


/**
 * @param {!proto.spacesos.CrashRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @param {function(?grpc.web.Error, ?proto.spacesos.CrashResponse)}
 *     callback The callback function(error, response)
 * @return {!grpc.web.ClientReadableStream<!proto.spacesos.CrashResponse>|undefined}
 *     The XHR Node Readable Stream
 */
proto.spacesos.SpaceSosClient.prototype.crash =
    function(request, metadata, callback) {
  return this.client_.rpcCall(this.hostname_ +
      '/spacesos.SpaceSos/Crash',
      request,
      metadata || {},
      methodDescriptor_SpaceSos_Crash,
      callback);
};


/**
 * @param {!proto.spacesos.CrashRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @return {!Promise<!proto.spacesos.CrashResponse>}
 *     A native promise that resolves to the response
 */
proto.spacesos.SpaceSosPromiseClient.prototype.crash =
    function(request, metadata) {
  return this.client_.unaryCall(this.hostname_ +
      '/spacesos.SpaceSos/Crash',
      request,
      metadata || {},
      methodDescriptor_SpaceSos_Crash);
};


/**
 * @const
 * @type {!grpc.web.MethodDescriptor<
 *   !proto.spacesos.GetCrashesRequest,
 *   !proto.spacesos.GetCrashesResponse>}
 */
const methodDescriptor_SpaceSos_GetCrashes = new grpc.web.MethodDescriptor(
  '/spacesos.SpaceSos/GetCrashes',
  grpc.web.MethodType.UNARY,
  proto.spacesos.GetCrashesRequest,
  proto.spacesos.GetCrashesResponse,
  /**
   * @param {!proto.spacesos.GetCrashesRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  proto.spacesos.GetCrashesResponse.deserializeBinary
);


/**
 * @const
 * @type {!grpc.web.AbstractClientBase.MethodInfo<
 *   !proto.spacesos.GetCrashesRequest,
 *   !proto.spacesos.GetCrashesResponse>}
 */
const methodInfo_SpaceSos_GetCrashes = new grpc.web.AbstractClientBase.MethodInfo(
  proto.spacesos.GetCrashesResponse,
  /**
   * @param {!proto.spacesos.GetCrashesRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  proto.spacesos.GetCrashesResponse.deserializeBinary
);


/**
 * @param {!proto.spacesos.GetCrashesRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @param {function(?grpc.web.Error, ?proto.spacesos.GetCrashesResponse)}
 *     callback The callback function(error, response)
 * @return {!grpc.web.ClientReadableStream<!proto.spacesos.GetCrashesResponse>|undefined}
 *     The XHR Node Readable Stream
 */
proto.spacesos.SpaceSosClient.prototype.getCrashes =
    function(request, metadata, callback) {
  return this.client_.rpcCall(this.hostname_ +
      '/spacesos.SpaceSos/GetCrashes',
      request,
      metadata || {},
      methodDescriptor_SpaceSos_GetCrashes,
      callback);
};


/**
 * @param {!proto.spacesos.GetCrashesRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @return {!Promise<!proto.spacesos.GetCrashesResponse>}
 *     A native promise that resolves to the response
 */
proto.spacesos.SpaceSosPromiseClient.prototype.getCrashes =
    function(request, metadata) {
  return this.client_.unaryCall(this.hostname_ +
      '/spacesos.SpaceSos/GetCrashes',
      request,
      metadata || {},
      methodDescriptor_SpaceSos_GetCrashes);
};


/**
 * @const
 * @type {!grpc.web.MethodDescriptor<
 *   !proto.spacesos.GetLatestCrashesRequest,
 *   !proto.spacesos.GetLatestCrashesResponse>}
 */
const methodDescriptor_SpaceSos_GetLatestCrashes = new grpc.web.MethodDescriptor(
  '/spacesos.SpaceSos/GetLatestCrashes',
  grpc.web.MethodType.UNARY,
  proto.spacesos.GetLatestCrashesRequest,
  proto.spacesos.GetLatestCrashesResponse,
  /**
   * @param {!proto.spacesos.GetLatestCrashesRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  proto.spacesos.GetLatestCrashesResponse.deserializeBinary
);


/**
 * @const
 * @type {!grpc.web.AbstractClientBase.MethodInfo<
 *   !proto.spacesos.GetLatestCrashesRequest,
 *   !proto.spacesos.GetLatestCrashesResponse>}
 */
const methodInfo_SpaceSos_GetLatestCrashes = new grpc.web.AbstractClientBase.MethodInfo(
  proto.spacesos.GetLatestCrashesResponse,
  /**
   * @param {!proto.spacesos.GetLatestCrashesRequest} request
   * @return {!Uint8Array}
   */
  function(request) {
    return request.serializeBinary();
  },
  proto.spacesos.GetLatestCrashesResponse.deserializeBinary
);


/**
 * @param {!proto.spacesos.GetLatestCrashesRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @param {function(?grpc.web.Error, ?proto.spacesos.GetLatestCrashesResponse)}
 *     callback The callback function(error, response)
 * @return {!grpc.web.ClientReadableStream<!proto.spacesos.GetLatestCrashesResponse>|undefined}
 *     The XHR Node Readable Stream
 */
proto.spacesos.SpaceSosClient.prototype.getLatestCrashes =
    function(request, metadata, callback) {
  return this.client_.rpcCall(this.hostname_ +
      '/spacesos.SpaceSos/GetLatestCrashes',
      request,
      metadata || {},
      methodDescriptor_SpaceSos_GetLatestCrashes,
      callback);
};


/**
 * @param {!proto.spacesos.GetLatestCrashesRequest} request The
 *     request proto
 * @param {?Object<string, string>} metadata User defined
 *     call metadata
 * @return {!Promise<!proto.spacesos.GetLatestCrashesResponse>}
 *     A native promise that resolves to the response
 */
proto.spacesos.SpaceSosPromiseClient.prototype.getLatestCrashes =
    function(request, metadata) {
  return this.client_.unaryCall(this.hostname_ +
      '/spacesos.SpaceSos/GetLatestCrashes',
      request,
      metadata || {},
      methodDescriptor_SpaceSos_GetLatestCrashes);
};


module.exports = proto.spacesos;

