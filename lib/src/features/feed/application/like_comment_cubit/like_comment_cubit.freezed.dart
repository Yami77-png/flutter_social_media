// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'like_comment_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LikeCommentState {

 int get count; String? get reaction;
/// Create a copy of LikeCommentState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LikeCommentStateCopyWith<LikeCommentState> get copyWith => _$LikeCommentStateCopyWithImpl<LikeCommentState>(this as LikeCommentState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LikeCommentState&&(identical(other.count, count) || other.count == count)&&(identical(other.reaction, reaction) || other.reaction == reaction));
}


@override
int get hashCode => Object.hash(runtimeType,count,reaction);

@override
String toString() {
  return 'LikeCommentState(count: $count, reaction: $reaction)';
}


}

/// @nodoc
abstract mixin class $LikeCommentStateCopyWith<$Res>  {
  factory $LikeCommentStateCopyWith(LikeCommentState value, $Res Function(LikeCommentState) _then) = _$LikeCommentStateCopyWithImpl;
@useResult
$Res call({
 int count, String? reaction
});




}
/// @nodoc
class _$LikeCommentStateCopyWithImpl<$Res>
    implements $LikeCommentStateCopyWith<$Res> {
  _$LikeCommentStateCopyWithImpl(this._self, this._then);

  final LikeCommentState _self;
  final $Res Function(LikeCommentState) _then;

/// Create a copy of LikeCommentState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? count = null,Object? reaction = freezed,}) {
  return _then(_self.copyWith(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,reaction: freezed == reaction ? _self.reaction : reaction // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LikeCommentState].
extension LikeCommentStatePatterns on LikeCommentState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Updated value)?  updated,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Updated() when updated != null:
return updated(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Updated value)  updated,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Updated():
return updated(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Updated value)?  updated,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Updated() when updated != null:
return updated(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int count,  String? reaction)?  initial,TResult Function( int count,  String? reaction)?  updated,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.count,_that.reaction);case _Updated() when updated != null:
return updated(_that.count,_that.reaction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int count,  String? reaction)  initial,required TResult Function( int count,  String? reaction)  updated,}) {final _that = this;
switch (_that) {
case _Initial():
return initial(_that.count,_that.reaction);case _Updated():
return updated(_that.count,_that.reaction);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int count,  String? reaction)?  initial,TResult? Function( int count,  String? reaction)?  updated,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.count,_that.reaction);case _Updated() when updated != null:
return updated(_that.count,_that.reaction);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements LikeCommentState {
  const _Initial({this.count = 0, this.reaction});
  

@override@JsonKey() final  int count;
@override final  String? reaction;

/// Create a copy of LikeCommentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitialCopyWith<_Initial> get copyWith => __$InitialCopyWithImpl<_Initial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial&&(identical(other.count, count) || other.count == count)&&(identical(other.reaction, reaction) || other.reaction == reaction));
}


@override
int get hashCode => Object.hash(runtimeType,count,reaction);

@override
String toString() {
  return 'LikeCommentState.initial(count: $count, reaction: $reaction)';
}


}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res> implements $LikeCommentStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) = __$InitialCopyWithImpl;
@override @useResult
$Res call({
 int count, String? reaction
});




}
/// @nodoc
class __$InitialCopyWithImpl<$Res>
    implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

/// Create a copy of LikeCommentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? reaction = freezed,}) {
  return _then(_Initial(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,reaction: freezed == reaction ? _self.reaction : reaction // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Updated implements LikeCommentState {
  const _Updated({required this.count, this.reaction});
  

@override final  int count;
@override final  String? reaction;

/// Create a copy of LikeCommentState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdatedCopyWith<_Updated> get copyWith => __$UpdatedCopyWithImpl<_Updated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Updated&&(identical(other.count, count) || other.count == count)&&(identical(other.reaction, reaction) || other.reaction == reaction));
}


@override
int get hashCode => Object.hash(runtimeType,count,reaction);

@override
String toString() {
  return 'LikeCommentState.updated(count: $count, reaction: $reaction)';
}


}

/// @nodoc
abstract mixin class _$UpdatedCopyWith<$Res> implements $LikeCommentStateCopyWith<$Res> {
  factory _$UpdatedCopyWith(_Updated value, $Res Function(_Updated) _then) = __$UpdatedCopyWithImpl;
@override @useResult
$Res call({
 int count, String? reaction
});




}
/// @nodoc
class __$UpdatedCopyWithImpl<$Res>
    implements _$UpdatedCopyWith<$Res> {
  __$UpdatedCopyWithImpl(this._self, this._then);

  final _Updated _self;
  final $Res Function(_Updated) _then;

/// Create a copy of LikeCommentState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? count = null,Object? reaction = freezed,}) {
  return _then(_Updated(
count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,reaction: freezed == reaction ? _self.reaction : reaction // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
