/* Generated by the protocol buffer compiler.  DO NOT EDIT! */
/* Generated from: structs.proto */

#ifndef PROTOBUF_C_structs_2eproto__INCLUDED
#define PROTOBUF_C_structs_2eproto__INCLUDED

#include <protobuf-c/protobuf-c.h>

PROTOBUF_C__BEGIN_DECLS

#if PROTOBUF_C_VERSION_NUMBER < 1003000
# error This file was generated by a newer version of protoc-c which is incompatible with your libprotobuf-c headers. Please update your headers.
#elif 1003003 < PROTOBUF_C_MIN_COMPILER_VERSION
# error This file was generated by an older version of protoc-c which is incompatible with your libprotobuf-c headers. Please regenerate this file with a newer version of protoc-c.
#endif


typedef struct _Contact Contact;
typedef struct _User User;
typedef struct _RegisterRequest RegisterRequest;
typedef struct _LoginRequest LoginRequest;
typedef struct _MyData MyData;
typedef struct _MatchRequest MatchRequest;
typedef struct _Match Match;
typedef struct _Response Response;
typedef struct _UserList UserList;


/* --- enums --- */


/* --- messages --- */

struct  _Contact
{
  ProtobufCMessage base;
  char *text;
};
#define CONTACT__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&contact__descriptor) \
    , (char *)protobuf_c_empty_string }


struct  _User
{
  ProtobufCMessage base;
  char *username;
  char *password;
};
#define USER__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&user__descriptor) \
    , (char *)protobuf_c_empty_string, (char *)protobuf_c_empty_string }


struct  _RegisterRequest
{
  ProtobufCMessage base;
  User *user;
  size_t n_coordinates;
  double *coordinates;
  Contact *contact;
};
#define REGISTER_REQUEST__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&register_request__descriptor) \
    , NULL, 0,NULL, NULL }


struct  _LoginRequest
{
  ProtobufCMessage base;
  User *user;
};
#define LOGIN_REQUEST__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&login_request__descriptor) \
    , NULL }


struct  _MyData
{
  ProtobufCMessage base;
  User *user;
  Contact *contact;
};
#define MY_DATA__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&my_data__descriptor) \
    , NULL, NULL }


struct  _MatchRequest
{
  ProtobufCMessage base;
  char *username;
};
#define MATCH_REQUEST__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&match_request__descriptor) \
    , (char *)protobuf_c_empty_string }


struct  _Match
{
  ProtobufCMessage base;
  protobuf_c_boolean ok;
  double distance;
  Contact *secret;
};
#define MATCH__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&match__descriptor) \
    , 0, 0, NULL }


struct  _Response
{
  ProtobufCMessage base;
  protobuf_c_boolean ok;
  char *text;
};
#define RESPONSE__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&response__descriptor) \
    , 0, (char *)protobuf_c_empty_string }


struct  _UserList
{
  ProtobufCMessage base;
  size_t n_username;
  char **username;
};
#define USER_LIST__INIT \
 { PROTOBUF_C_MESSAGE_INIT (&user_list__descriptor) \
    , 0,NULL }


/* Contact methods */
void   contact__init
                     (Contact         *message);
size_t contact__get_packed_size
                     (const Contact   *message);
size_t contact__pack
                     (const Contact   *message,
                      uint8_t             *out);
size_t contact__pack_to_buffer
                     (const Contact   *message,
                      ProtobufCBuffer     *buffer);
Contact *
       contact__unpack
                     (ProtobufCAllocator  *allocator,
                      size_t               len,
                      const uint8_t       *data);
void   contact__free_unpacked
                     (Contact *message,
                      ProtobufCAllocator *allocator);
/* User methods */
void   user__init
                     (User         *message);
size_t user__get_packed_size
                     (const User   *message);
size_t user__pack
                     (const User   *message,
                      uint8_t             *out);
size_t user__pack_to_buffer
                     (const User   *message,
                      ProtobufCBuffer     *buffer);
User *
       user__unpack
                     (ProtobufCAllocator  *allocator,
                      size_t               len,
                      const uint8_t       *data);
void   user__free_unpacked
                     (User *message,
                      ProtobufCAllocator *allocator);
/* RegisterRequest methods */
void   register_request__init
                     (RegisterRequest         *message);
size_t register_request__get_packed_size
                     (const RegisterRequest   *message);
size_t register_request__pack
                     (const RegisterRequest   *message,
                      uint8_t             *out);
size_t register_request__pack_to_buffer
                     (const RegisterRequest   *message,
                      ProtobufCBuffer     *buffer);
RegisterRequest *
       register_request__unpack
                     (ProtobufCAllocator  *allocator,
                      size_t               len,
                      const uint8_t       *data);
void   register_request__free_unpacked
                     (RegisterRequest *message,
                      ProtobufCAllocator *allocator);
/* LoginRequest methods */
void   login_request__init
                     (LoginRequest         *message);
size_t login_request__get_packed_size
                     (const LoginRequest   *message);
size_t login_request__pack
                     (const LoginRequest   *message,
                      uint8_t             *out);
size_t login_request__pack_to_buffer
                     (const LoginRequest   *message,
                      ProtobufCBuffer     *buffer);
LoginRequest *
       login_request__unpack
                     (ProtobufCAllocator  *allocator,
                      size_t               len,
                      const uint8_t       *data);
void   login_request__free_unpacked
                     (LoginRequest *message,
                      ProtobufCAllocator *allocator);
/* MyData methods */
void   my_data__init
                     (MyData         *message);
size_t my_data__get_packed_size
                     (const MyData   *message);
size_t my_data__pack
                     (const MyData   *message,
                      uint8_t             *out);
size_t my_data__pack_to_buffer
                     (const MyData   *message,
                      ProtobufCBuffer     *buffer);
MyData *
       my_data__unpack
                     (ProtobufCAllocator  *allocator,
                      size_t               len,
                      const uint8_t       *data);
void   my_data__free_unpacked
                     (MyData *message,
                      ProtobufCAllocator *allocator);
/* MatchRequest methods */
void   match_request__init
                     (MatchRequest         *message);
size_t match_request__get_packed_size
                     (const MatchRequest   *message);
size_t match_request__pack
                     (const MatchRequest   *message,
                      uint8_t             *out);
size_t match_request__pack_to_buffer
                     (const MatchRequest   *message,
                      ProtobufCBuffer     *buffer);
MatchRequest *
       match_request__unpack
                     (ProtobufCAllocator  *allocator,
                      size_t               len,
                      const uint8_t       *data);
void   match_request__free_unpacked
                     (MatchRequest *message,
                      ProtobufCAllocator *allocator);
/* Match methods */
void   match__init
                     (Match         *message);
size_t match__get_packed_size
                     (const Match   *message);
size_t match__pack
                     (const Match   *message,
                      uint8_t             *out);
size_t match__pack_to_buffer
                     (const Match   *message,
                      ProtobufCBuffer     *buffer);
Match *
       match__unpack
                     (ProtobufCAllocator  *allocator,
                      size_t               len,
                      const uint8_t       *data);
void   match__free_unpacked
                     (Match *message,
                      ProtobufCAllocator *allocator);
/* Response methods */
void   response__init
                     (Response         *message);
size_t response__get_packed_size
                     (const Response   *message);
size_t response__pack
                     (const Response   *message,
                      uint8_t             *out);
size_t response__pack_to_buffer
                     (const Response   *message,
                      ProtobufCBuffer     *buffer);
Response *
       response__unpack
                     (ProtobufCAllocator  *allocator,
                      size_t               len,
                      const uint8_t       *data);
void   response__free_unpacked
                     (Response *message,
                      ProtobufCAllocator *allocator);
/* UserList methods */
void   user_list__init
                     (UserList         *message);
size_t user_list__get_packed_size
                     (const UserList   *message);
size_t user_list__pack
                     (const UserList   *message,
                      uint8_t             *out);
size_t user_list__pack_to_buffer
                     (const UserList   *message,
                      ProtobufCBuffer     *buffer);
UserList *
       user_list__unpack
                     (ProtobufCAllocator  *allocator,
                      size_t               len,
                      const uint8_t       *data);
void   user_list__free_unpacked
                     (UserList *message,
                      ProtobufCAllocator *allocator);
/* --- per-message closures --- */

typedef void (*Contact_Closure)
                 (const Contact *message,
                  void *closure_data);
typedef void (*User_Closure)
                 (const User *message,
                  void *closure_data);
typedef void (*RegisterRequest_Closure)
                 (const RegisterRequest *message,
                  void *closure_data);
typedef void (*LoginRequest_Closure)
                 (const LoginRequest *message,
                  void *closure_data);
typedef void (*MyData_Closure)
                 (const MyData *message,
                  void *closure_data);
typedef void (*MatchRequest_Closure)
                 (const MatchRequest *message,
                  void *closure_data);
typedef void (*Match_Closure)
                 (const Match *message,
                  void *closure_data);
typedef void (*Response_Closure)
                 (const Response *message,
                  void *closure_data);
typedef void (*UserList_Closure)
                 (const UserList *message,
                  void *closure_data);

/* --- services --- */


/* --- descriptors --- */

extern const ProtobufCMessageDescriptor contact__descriptor;
extern const ProtobufCMessageDescriptor user__descriptor;
extern const ProtobufCMessageDescriptor register_request__descriptor;
extern const ProtobufCMessageDescriptor login_request__descriptor;
extern const ProtobufCMessageDescriptor my_data__descriptor;
extern const ProtobufCMessageDescriptor match_request__descriptor;
extern const ProtobufCMessageDescriptor match__descriptor;
extern const ProtobufCMessageDescriptor response__descriptor;
extern const ProtobufCMessageDescriptor user_list__descriptor;

PROTOBUF_C__END_DECLS


#endif  /* PROTOBUF_C_structs_2eproto__INCLUDED */
