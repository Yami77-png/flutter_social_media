// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'like_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LikeState {

 int get score; VoteType get vote; bool get isLoading;
/// Create a copy of LikeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LikeStateCopyWith<LikeState> get copyWith => _$LikeStateCopyWithImpl<LikeState>(this as LikeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LikeState&&(identical(other.score, score) || other.score == score)&&(identical(other.vote, vote) || other.vote == vote)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,score,vote,isLoading);

@override
String toString() {
  return 'LikeState(score: $score, vote: $vote, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $LikeStateCopyWith<$Res>  {
  factory $LikeStateCopyWith(LikeState value, $Res Function(LikeState) _then) = _$LikeStateCopyWithImpl;
@useResult
$Res call({
 int score, VoteType vote, bool isLoading
});




}
/// @nodoc
class _$LikeStateCopyWithImpl<$Res>
    implements $LikeStateCopyWith<$Res> {
  _$LikeStateCopyWithImpl(this._self, this._then);

  final LikeState _self;
  final $Res Function(LikeState) _then;

/// Create a copy of LikeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? score = null,Object? vote = null,Object? isLoading = null,}) {
  return _then(_self.copyWith(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,vote: null == vote ? _self.vote : vote // ignore: cast_nullable_to_non_nullable
as VoteType,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [LikeState].
extension LikeStatePatterns on LikeState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LikeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LikeState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LikeState value)  $default,){
final _that = this;
switch (_that) {
case _LikeState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LikeState value)?  $default,){
final _that = this;
switch (_that) {
case _LikeState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int score,  VoteType vote,  bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LikeState() when $default != null:
return $default(_that.score,_that.vote,_that.isLoading);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int score,  VoteType vote,  bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _LikeState():
return $default(_that.score,_that.vote,_that.isLoading);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int score,  VoteType vote,  bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _LikeState() when $default != null:
return $default(_that.score,_that.vote,_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _LikeState implements LikeState {
  const _LikeState({required this.score, required this.vote, required this.isLoading});
  

@override final  int score;
@override final  VoteType vote;
@override final  bool isLoading;

/// Create a copy of LikeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LikeStateCopyWith<_LikeState> get copyWith => __$LikeStateCopyWithImpl<_LikeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LikeState&&(identical(other.score, score) || other.score == score)&&(identical(other.vote, vote) || other.vote == vote)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,score,vote,isLoading);

@override
String toString() {
  return 'LikeState(score: $score, vote: $vote, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$LikeStateCopyWith<$Res> implements $LikeStateCopyWith<$Res> {
  factory _$LikeStateCopyWith(_LikeState value, $Res Function(_LikeState) _then) = __$LikeStateCopyWithImpl;
@override @useResult
$Res call({
 int score, VoteType vote, bool isLoading
});




}
/// @nodoc
class __$LikeStateCopyWithImpl<$Res>
    implements _$LikeStateCopyWith<$Res> {
  __$LikeStateCopyWithImpl(this._self, this._then);

  final _LikeState _self;
  final $Res Function(_LikeState) _then;

/// Create a copy of LikeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? score = null,Object? vote = null,Object? isLoading = null,}) {
  return _then(_LikeState(
score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,vote: null == vote ? _self.vote : vote // ignore: cast_nullable_to_non_nullable
as VoteType,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
