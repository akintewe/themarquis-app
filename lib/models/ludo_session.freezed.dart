// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ludo_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LudoSessionData _$LudoSessionDataFromJson(Map<String, dynamic> json) {
  return _LudoSessionData.fromJson(json);
}

/// @nodoc
mixin _$LudoSessionData {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  int get playerCount => throw _privateConstructorUsedError;
  @HiveField(2)
  String get status => throw _privateConstructorUsedError;
  @HiveField(3)
  String get nextPlayer => throw _privateConstructorUsedError;
  @HiveField(4)
  String get nonce => throw _privateConstructorUsedError;
  @HiveField(5)
  String get color => throw _privateConstructorUsedError;
  @HiveField(6)
  String get playAmount => throw _privateConstructorUsedError;
  @HiveField(7)
  String get playToken => throw _privateConstructorUsedError;
  @HiveField(8)
  List<LudoSessionUserStatus> get sessionUserStatus =>
      throw _privateConstructorUsedError;
  @HiveField(9)
  int get nextPlayerId => throw _privateConstructorUsedError;
  @HiveField(10)
  String get creator => throw _privateConstructorUsedError;
  @HiveField(11)
  DateTime get createdAt => throw _privateConstructorUsedError;
  @HiveField(12)
  List<String> get v => throw _privateConstructorUsedError;
  @HiveField(13)
  List<String> get r => throw _privateConstructorUsedError;
  @HiveField(14)
  List<String> get s => throw _privateConstructorUsedError;
  @HiveField(15)
  List<String> get randomNumbers => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LudoSessionDataCopyWith<LudoSessionData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LudoSessionDataCopyWith<$Res> {
  factory $LudoSessionDataCopyWith(
          LudoSessionData value, $Res Function(LudoSessionData) then) =
      _$LudoSessionDataCopyWithImpl<$Res, LudoSessionData>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) int playerCount,
      @HiveField(2) String status,
      @HiveField(3) String nextPlayer,
      @HiveField(4) String nonce,
      @HiveField(5) String color,
      @HiveField(6) String playAmount,
      @HiveField(7) String playToken,
      @HiveField(8) List<LudoSessionUserStatus> sessionUserStatus,
      @HiveField(9) int nextPlayerId,
      @HiveField(10) String creator,
      @HiveField(11) DateTime createdAt,
      @HiveField(12) List<String> v,
      @HiveField(13) List<String> r,
      @HiveField(14) List<String> s,
      @HiveField(15) List<String> randomNumbers});
}

/// @nodoc
class _$LudoSessionDataCopyWithImpl<$Res, $Val extends LudoSessionData>
    implements $LudoSessionDataCopyWith<$Res> {
  _$LudoSessionDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerCount = null,
    Object? status = null,
    Object? nextPlayer = null,
    Object? nonce = null,
    Object? color = null,
    Object? playAmount = null,
    Object? playToken = null,
    Object? sessionUserStatus = null,
    Object? nextPlayerId = null,
    Object? creator = null,
    Object? createdAt = null,
    Object? v = null,
    Object? r = null,
    Object? s = null,
    Object? randomNumbers = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      playerCount: null == playerCount
          ? _value.playerCount
          : playerCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      nextPlayer: null == nextPlayer
          ? _value.nextPlayer
          : nextPlayer // ignore: cast_nullable_to_non_nullable
              as String,
      nonce: null == nonce
          ? _value.nonce
          : nonce // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      playAmount: null == playAmount
          ? _value.playAmount
          : playAmount // ignore: cast_nullable_to_non_nullable
              as String,
      playToken: null == playToken
          ? _value.playToken
          : playToken // ignore: cast_nullable_to_non_nullable
              as String,
      sessionUserStatus: null == sessionUserStatus
          ? _value.sessionUserStatus
          : sessionUserStatus // ignore: cast_nullable_to_non_nullable
              as List<LudoSessionUserStatus>,
      nextPlayerId: null == nextPlayerId
          ? _value.nextPlayerId
          : nextPlayerId // ignore: cast_nullable_to_non_nullable
              as int,
      creator: null == creator
          ? _value.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      v: null == v
          ? _value.v
          : v // ignore: cast_nullable_to_non_nullable
              as List<String>,
      r: null == r
          ? _value.r
          : r // ignore: cast_nullable_to_non_nullable
              as List<String>,
      s: null == s
          ? _value.s
          : s // ignore: cast_nullable_to_non_nullable
              as List<String>,
      randomNumbers: null == randomNumbers
          ? _value.randomNumbers
          : randomNumbers // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LudoSessionDataImplCopyWith<$Res>
    implements $LudoSessionDataCopyWith<$Res> {
  factory _$$LudoSessionDataImplCopyWith(_$LudoSessionDataImpl value,
          $Res Function(_$LudoSessionDataImpl) then) =
      __$$LudoSessionDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) int playerCount,
      @HiveField(2) String status,
      @HiveField(3) String nextPlayer,
      @HiveField(4) String nonce,
      @HiveField(5) String color,
      @HiveField(6) String playAmount,
      @HiveField(7) String playToken,
      @HiveField(8) List<LudoSessionUserStatus> sessionUserStatus,
      @HiveField(9) int nextPlayerId,
      @HiveField(10) String creator,
      @HiveField(11) DateTime createdAt,
      @HiveField(12) List<String> v,
      @HiveField(13) List<String> r,
      @HiveField(14) List<String> s,
      @HiveField(15) List<String> randomNumbers});
}

/// @nodoc
class __$$LudoSessionDataImplCopyWithImpl<$Res>
    extends _$LudoSessionDataCopyWithImpl<$Res, _$LudoSessionDataImpl>
    implements _$$LudoSessionDataImplCopyWith<$Res> {
  __$$LudoSessionDataImplCopyWithImpl(
      _$LudoSessionDataImpl _value, $Res Function(_$LudoSessionDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? playerCount = null,
    Object? status = null,
    Object? nextPlayer = null,
    Object? nonce = null,
    Object? color = null,
    Object? playAmount = null,
    Object? playToken = null,
    Object? sessionUserStatus = null,
    Object? nextPlayerId = null,
    Object? creator = null,
    Object? createdAt = null,
    Object? v = null,
    Object? r = null,
    Object? s = null,
    Object? randomNumbers = null,
  }) {
    return _then(_$LudoSessionDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      playerCount: null == playerCount
          ? _value.playerCount
          : playerCount // ignore: cast_nullable_to_non_nullable
              as int,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      nextPlayer: null == nextPlayer
          ? _value.nextPlayer
          : nextPlayer // ignore: cast_nullable_to_non_nullable
              as String,
      nonce: null == nonce
          ? _value.nonce
          : nonce // ignore: cast_nullable_to_non_nullable
              as String,
      color: null == color
          ? _value.color
          : color // ignore: cast_nullable_to_non_nullable
              as String,
      playAmount: null == playAmount
          ? _value.playAmount
          : playAmount // ignore: cast_nullable_to_non_nullable
              as String,
      playToken: null == playToken
          ? _value.playToken
          : playToken // ignore: cast_nullable_to_non_nullable
              as String,
      sessionUserStatus: null == sessionUserStatus
          ? _value._sessionUserStatus
          : sessionUserStatus // ignore: cast_nullable_to_non_nullable
              as List<LudoSessionUserStatus>,
      nextPlayerId: null == nextPlayerId
          ? _value.nextPlayerId
          : nextPlayerId // ignore: cast_nullable_to_non_nullable
              as int,
      creator: null == creator
          ? _value.creator
          : creator // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      v: null == v
          ? _value._v
          : v // ignore: cast_nullable_to_non_nullable
              as List<String>,
      r: null == r
          ? _value._r
          : r // ignore: cast_nullable_to_non_nullable
              as List<String>,
      s: null == s
          ? _value._s
          : s // ignore: cast_nullable_to_non_nullable
              as List<String>,
      randomNumbers: null == randomNumbers
          ? _value._randomNumbers
          : randomNumbers // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 2)
class _$LudoSessionDataImpl extends _LudoSessionData {
  _$LudoSessionDataImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.playerCount,
      @HiveField(2) required this.status,
      @HiveField(3) required this.nextPlayer,
      @HiveField(4) required this.nonce,
      @HiveField(5) required this.color,
      @HiveField(6) required this.playAmount,
      @HiveField(7) required this.playToken,
      @HiveField(8)
      required final List<LudoSessionUserStatus> sessionUserStatus,
      @HiveField(9) required this.nextPlayerId,
      @HiveField(10) required this.creator,
      @HiveField(11) required this.createdAt,
      @HiveField(12) required final List<String> v,
      @HiveField(13) required final List<String> r,
      @HiveField(14) required final List<String> s,
      @HiveField(15) required final List<String> randomNumbers})
      : _sessionUserStatus = sessionUserStatus,
        _v = v,
        _r = r,
        _s = s,
        _randomNumbers = randomNumbers,
        super._();

  factory _$LudoSessionDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$LudoSessionDataImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final int playerCount;
  @override
  @HiveField(2)
  final String status;
  @override
  @HiveField(3)
  final String nextPlayer;
  @override
  @HiveField(4)
  final String nonce;
  @override
  @HiveField(5)
  final String color;
  @override
  @HiveField(6)
  final String playAmount;
  @override
  @HiveField(7)
  final String playToken;
  final List<LudoSessionUserStatus> _sessionUserStatus;
  @override
  @HiveField(8)
  List<LudoSessionUserStatus> get sessionUserStatus {
    if (_sessionUserStatus is EqualUnmodifiableListView)
      return _sessionUserStatus;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sessionUserStatus);
  }

  @override
  @HiveField(9)
  final int nextPlayerId;
  @override
  @HiveField(10)
  final String creator;
  @override
  @HiveField(11)
  final DateTime createdAt;
  final List<String> _v;
  @override
  @HiveField(12)
  List<String> get v {
    if (_v is EqualUnmodifiableListView) return _v;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_v);
  }

  final List<String> _r;
  @override
  @HiveField(13)
  List<String> get r {
    if (_r is EqualUnmodifiableListView) return _r;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_r);
  }

  final List<String> _s;
  @override
  @HiveField(14)
  List<String> get s {
    if (_s is EqualUnmodifiableListView) return _s;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_s);
  }

  final List<String> _randomNumbers;
  @override
  @HiveField(15)
  List<String> get randomNumbers {
    if (_randomNumbers is EqualUnmodifiableListView) return _randomNumbers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_randomNumbers);
  }

  @override
  String toString() {
    return 'LudoSessionData(id: $id, playerCount: $playerCount, status: $status, nextPlayer: $nextPlayer, nonce: $nonce, color: $color, playAmount: $playAmount, playToken: $playToken, sessionUserStatus: $sessionUserStatus, nextPlayerId: $nextPlayerId, creator: $creator, createdAt: $createdAt, v: $v, r: $r, s: $s, randomNumbers: $randomNumbers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LudoSessionDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.playerCount, playerCount) ||
                other.playerCount == playerCount) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.nextPlayer, nextPlayer) ||
                other.nextPlayer == nextPlayer) &&
            (identical(other.nonce, nonce) || other.nonce == nonce) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.playAmount, playAmount) ||
                other.playAmount == playAmount) &&
            (identical(other.playToken, playToken) ||
                other.playToken == playToken) &&
            const DeepCollectionEquality()
                .equals(other._sessionUserStatus, _sessionUserStatus) &&
            (identical(other.nextPlayerId, nextPlayerId) ||
                other.nextPlayerId == nextPlayerId) &&
            (identical(other.creator, creator) || other.creator == creator) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._v, _v) &&
            const DeepCollectionEquality().equals(other._r, _r) &&
            const DeepCollectionEquality().equals(other._s, _s) &&
            const DeepCollectionEquality()
                .equals(other._randomNumbers, _randomNumbers));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      playerCount,
      status,
      nextPlayer,
      nonce,
      color,
      playAmount,
      playToken,
      const DeepCollectionEquality().hash(_sessionUserStatus),
      nextPlayerId,
      creator,
      createdAt,
      const DeepCollectionEquality().hash(_v),
      const DeepCollectionEquality().hash(_r),
      const DeepCollectionEquality().hash(_s),
      const DeepCollectionEquality().hash(_randomNumbers));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LudoSessionDataImplCopyWith<_$LudoSessionDataImpl> get copyWith =>
      __$$LudoSessionDataImplCopyWithImpl<_$LudoSessionDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LudoSessionDataImplToJson(
      this,
    );
  }
}

abstract class _LudoSessionData extends LudoSessionData {
  factory _LudoSessionData(
          {@HiveField(0) required final String id,
          @HiveField(1) required final int playerCount,
          @HiveField(2) required final String status,
          @HiveField(3) required final String nextPlayer,
          @HiveField(4) required final String nonce,
          @HiveField(5) required final String color,
          @HiveField(6) required final String playAmount,
          @HiveField(7) required final String playToken,
          @HiveField(8)
          required final List<LudoSessionUserStatus> sessionUserStatus,
          @HiveField(9) required final int nextPlayerId,
          @HiveField(10) required final String creator,
          @HiveField(11) required final DateTime createdAt,
          @HiveField(12) required final List<String> v,
          @HiveField(13) required final List<String> r,
          @HiveField(14) required final List<String> s,
          @HiveField(15) required final List<String> randomNumbers}) =
      _$LudoSessionDataImpl;
  _LudoSessionData._() : super._();

  factory _LudoSessionData.fromJson(Map<String, dynamic> json) =
      _$LudoSessionDataImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  int get playerCount;
  @override
  @HiveField(2)
  String get status;
  @override
  @HiveField(3)
  String get nextPlayer;
  @override
  @HiveField(4)
  String get nonce;
  @override
  @HiveField(5)
  String get color;
  @override
  @HiveField(6)
  String get playAmount;
  @override
  @HiveField(7)
  String get playToken;
  @override
  @HiveField(8)
  List<LudoSessionUserStatus> get sessionUserStatus;
  @override
  @HiveField(9)
  int get nextPlayerId;
  @override
  @HiveField(10)
  String get creator;
  @override
  @HiveField(11)
  DateTime get createdAt;
  @override
  @HiveField(12)
  List<String> get v;
  @override
  @HiveField(13)
  List<String> get r;
  @override
  @HiveField(14)
  List<String> get s;
  @override
  @HiveField(15)
  List<String> get randomNumbers;
  @override
  @JsonKey(ignore: true)
  _$$LudoSessionDataImplCopyWith<_$LudoSessionDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LudoSessionUserStatus _$LudoSessionUserStatusFromJson(
    Map<String, dynamic> json) {
  return _LudoSessionUserStatus.fromJson(json);
}

/// @nodoc
mixin _$LudoSessionUserStatus {
  @HiveField(0)
  int get playerId => throw _privateConstructorUsedError;
  @HiveField(1)
  List<String> get playerTokensPosition => throw _privateConstructorUsedError;
  @HiveField(2)
  List<bool> get playerWinningTokens => throw _privateConstructorUsedError;
  @HiveField(3)
  int get userId => throw _privateConstructorUsedError;
  @HiveField(4)
  String get email => throw _privateConstructorUsedError;
  @HiveField(5)
  String get role => throw _privateConstructorUsedError;
  @HiveField(6)
  String get status => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get profileImageUrl => throw _privateConstructorUsedError;
  @HiveField(8)
  int get points => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LudoSessionUserStatusCopyWith<LudoSessionUserStatus> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LudoSessionUserStatusCopyWith<$Res> {
  factory $LudoSessionUserStatusCopyWith(LudoSessionUserStatus value,
          $Res Function(LudoSessionUserStatus) then) =
      _$LudoSessionUserStatusCopyWithImpl<$Res, LudoSessionUserStatus>;
  @useResult
  $Res call(
      {@HiveField(0) int playerId,
      @HiveField(1) List<String> playerTokensPosition,
      @HiveField(2) List<bool> playerWinningTokens,
      @HiveField(3) int userId,
      @HiveField(4) String email,
      @HiveField(5) String role,
      @HiveField(6) String status,
      @HiveField(7) String? profileImageUrl,
      @HiveField(8) int points});
}

/// @nodoc
class _$LudoSessionUserStatusCopyWithImpl<$Res,
        $Val extends LudoSessionUserStatus>
    implements $LudoSessionUserStatusCopyWith<$Res> {
  _$LudoSessionUserStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerTokensPosition = null,
    Object? playerWinningTokens = null,
    Object? userId = null,
    Object? email = null,
    Object? role = null,
    Object? status = null,
    Object? profileImageUrl = freezed,
    Object? points = null,
  }) {
    return _then(_value.copyWith(
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as int,
      playerTokensPosition: null == playerTokensPosition
          ? _value.playerTokensPosition
          : playerTokensPosition // ignore: cast_nullable_to_non_nullable
              as List<String>,
      playerWinningTokens: null == playerWinningTokens
          ? _value.playerWinningTokens
          : playerWinningTokens // ignore: cast_nullable_to_non_nullable
              as List<bool>,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LudoSessionUserStatusImplCopyWith<$Res>
    implements $LudoSessionUserStatusCopyWith<$Res> {
  factory _$$LudoSessionUserStatusImplCopyWith(
          _$LudoSessionUserStatusImpl value,
          $Res Function(_$LudoSessionUserStatusImpl) then) =
      __$$LudoSessionUserStatusImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) int playerId,
      @HiveField(1) List<String> playerTokensPosition,
      @HiveField(2) List<bool> playerWinningTokens,
      @HiveField(3) int userId,
      @HiveField(4) String email,
      @HiveField(5) String role,
      @HiveField(6) String status,
      @HiveField(7) String? profileImageUrl,
      @HiveField(8) int points});
}

/// @nodoc
class __$$LudoSessionUserStatusImplCopyWithImpl<$Res>
    extends _$LudoSessionUserStatusCopyWithImpl<$Res,
        _$LudoSessionUserStatusImpl>
    implements _$$LudoSessionUserStatusImplCopyWith<$Res> {
  __$$LudoSessionUserStatusImplCopyWithImpl(_$LudoSessionUserStatusImpl _value,
      $Res Function(_$LudoSessionUserStatusImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? playerId = null,
    Object? playerTokensPosition = null,
    Object? playerWinningTokens = null,
    Object? userId = null,
    Object? email = null,
    Object? role = null,
    Object? status = null,
    Object? profileImageUrl = freezed,
    Object? points = null,
  }) {
    return _then(_$LudoSessionUserStatusImpl(
      playerId: null == playerId
          ? _value.playerId
          : playerId // ignore: cast_nullable_to_non_nullable
              as int,
      playerTokensPosition: null == playerTokensPosition
          ? _value._playerTokensPosition
          : playerTokensPosition // ignore: cast_nullable_to_non_nullable
              as List<String>,
      playerWinningTokens: null == playerWinningTokens
          ? _value._playerWinningTokens
          : playerWinningTokens // ignore: cast_nullable_to_non_nullable
              as List<bool>,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      profileImageUrl: freezed == profileImageUrl
          ? _value.profileImageUrl
          : profileImageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      points: null == points
          ? _value.points
          : points // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 3)
class _$LudoSessionUserStatusImpl extends _LudoSessionUserStatus {
  _$LudoSessionUserStatusImpl(
      {@HiveField(0) required this.playerId,
      @HiveField(1) required final List<String> playerTokensPosition,
      @HiveField(2) required final List<bool> playerWinningTokens,
      @HiveField(3) required this.userId,
      @HiveField(4) required this.email,
      @HiveField(5) required this.role,
      @HiveField(6) required this.status,
      @HiveField(7) this.profileImageUrl,
      @HiveField(8) required this.points})
      : _playerTokensPosition = playerTokensPosition,
        _playerWinningTokens = playerWinningTokens,
        super._();

  factory _$LudoSessionUserStatusImpl.fromJson(Map<String, dynamic> json) =>
      _$$LudoSessionUserStatusImplFromJson(json);

  @override
  @HiveField(0)
  final int playerId;
  final List<String> _playerTokensPosition;
  @override
  @HiveField(1)
  List<String> get playerTokensPosition {
    if (_playerTokensPosition is EqualUnmodifiableListView)
      return _playerTokensPosition;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playerTokensPosition);
  }

  final List<bool> _playerWinningTokens;
  @override
  @HiveField(2)
  List<bool> get playerWinningTokens {
    if (_playerWinningTokens is EqualUnmodifiableListView)
      return _playerWinningTokens;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_playerWinningTokens);
  }

  @override
  @HiveField(3)
  final int userId;
  @override
  @HiveField(4)
  final String email;
  @override
  @HiveField(5)
  final String role;
  @override
  @HiveField(6)
  final String status;
  @override
  @HiveField(7)
  final String? profileImageUrl;
  @override
  @HiveField(8)
  final int points;

  @override
  String toString() {
    return 'LudoSessionUserStatus(playerId: $playerId, playerTokensPosition: $playerTokensPosition, playerWinningTokens: $playerWinningTokens, userId: $userId, email: $email, role: $role, status: $status, profileImageUrl: $profileImageUrl, points: $points)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LudoSessionUserStatusImpl &&
            (identical(other.playerId, playerId) ||
                other.playerId == playerId) &&
            const DeepCollectionEquality()
                .equals(other._playerTokensPosition, _playerTokensPosition) &&
            const DeepCollectionEquality()
                .equals(other._playerWinningTokens, _playerWinningTokens) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.profileImageUrl, profileImageUrl) ||
                other.profileImageUrl == profileImageUrl) &&
            (identical(other.points, points) || other.points == points));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      playerId,
      const DeepCollectionEquality().hash(_playerTokensPosition),
      const DeepCollectionEquality().hash(_playerWinningTokens),
      userId,
      email,
      role,
      status,
      profileImageUrl,
      points);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$LudoSessionUserStatusImplCopyWith<_$LudoSessionUserStatusImpl>
      get copyWith => __$$LudoSessionUserStatusImplCopyWithImpl<
          _$LudoSessionUserStatusImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LudoSessionUserStatusImplToJson(
      this,
    );
  }
}

abstract class _LudoSessionUserStatus extends LudoSessionUserStatus {
  factory _LudoSessionUserStatus(
      {@HiveField(0) required final int playerId,
      @HiveField(1) required final List<String> playerTokensPosition,
      @HiveField(2) required final List<bool> playerWinningTokens,
      @HiveField(3) required final int userId,
      @HiveField(4) required final String email,
      @HiveField(5) required final String role,
      @HiveField(6) required final String status,
      @HiveField(7) final String? profileImageUrl,
      @HiveField(8) required final int points}) = _$LudoSessionUserStatusImpl;
  _LudoSessionUserStatus._() : super._();

  factory _LudoSessionUserStatus.fromJson(Map<String, dynamic> json) =
      _$LudoSessionUserStatusImpl.fromJson;

  @override
  @HiveField(0)
  int get playerId;
  @override
  @HiveField(1)
  List<String> get playerTokensPosition;
  @override
  @HiveField(2)
  List<bool> get playerWinningTokens;
  @override
  @HiveField(3)
  int get userId;
  @override
  @HiveField(4)
  String get email;
  @override
  @HiveField(5)
  String get role;
  @override
  @HiveField(6)
  String get status;
  @override
  @HiveField(7)
  String? get profileImageUrl;
  @override
  @HiveField(8)
  int get points;
  @override
  @JsonKey(ignore: true)
  _$$LudoSessionUserStatusImplCopyWith<_$LudoSessionUserStatusImpl>
      get copyWith => throw _privateConstructorUsedError;
}
