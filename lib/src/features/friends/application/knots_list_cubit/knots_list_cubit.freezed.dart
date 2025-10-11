// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'knots_list_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KnotsListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KnotsListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KnotsListState()';
}


}

/// @nodoc
class $KnotsListStateCopyWith<$Res>  {
$KnotsListStateCopyWith(KnotsListState _, $Res Function(KnotsListState) __);
}


/// Adds pattern-matching-related methods to [KnotsListState].
extension KnotsListStatePatterns on KnotsListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _KnotsLoaded value)?  knotsLoaded,TResult Function( _RequestedKnotsLoaded value)?  requestedKnotsLoaded,TResult Function( _IncomingKnotsLoaded value)?  incomingKnotsLoaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _KnotsLoaded() when knotsLoaded != null:
return knotsLoaded(_that);case _RequestedKnotsLoaded() when requestedKnotsLoaded != null:
return requestedKnotsLoaded(_that);case _IncomingKnotsLoaded() when incomingKnotsLoaded != null:
return incomingKnotsLoaded(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _KnotsLoaded value)  knotsLoaded,required TResult Function( _RequestedKnotsLoaded value)  requestedKnotsLoaded,required TResult Function( _IncomingKnotsLoaded value)  incomingKnotsLoaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _KnotsLoaded():
return knotsLoaded(_that);case _RequestedKnotsLoaded():
return requestedKnotsLoaded(_that);case _IncomingKnotsLoaded():
return incomingKnotsLoaded(_that);case _Error():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _KnotsLoaded value)?  knotsLoaded,TResult? Function( _RequestedKnotsLoaded value)?  requestedKnotsLoaded,TResult? Function( _IncomingKnotsLoaded value)?  incomingKnotsLoaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _KnotsLoaded() when knotsLoaded != null:
return knotsLoaded(_that);case _RequestedKnotsLoaded() when requestedKnotsLoaded != null:
return requestedKnotsLoaded(_that);case _IncomingKnotsLoaded() when incomingKnotsLoaded != null:
return incomingKnotsLoaded(_that);case _Error() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<KnotModel> knots)?  knotsLoaded,TResult Function( List<KnotModel> knots)?  requestedKnotsLoaded,TResult Function( List<KnotModel> knots)?  incomingKnotsLoaded,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _KnotsLoaded() when knotsLoaded != null:
return knotsLoaded(_that.knots);case _RequestedKnotsLoaded() when requestedKnotsLoaded != null:
return requestedKnotsLoaded(_that.knots);case _IncomingKnotsLoaded() when incomingKnotsLoaded != null:
return incomingKnotsLoaded(_that.knots);case _Error() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<KnotModel> knots)  knotsLoaded,required TResult Function( List<KnotModel> knots)  requestedKnotsLoaded,required TResult Function( List<KnotModel> knots)  incomingKnotsLoaded,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _KnotsLoaded():
return knotsLoaded(_that.knots);case _RequestedKnotsLoaded():
return requestedKnotsLoaded(_that.knots);case _IncomingKnotsLoaded():
return incomingKnotsLoaded(_that.knots);case _Error():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<KnotModel> knots)?  knotsLoaded,TResult? Function( List<KnotModel> knots)?  requestedKnotsLoaded,TResult? Function( List<KnotModel> knots)?  incomingKnotsLoaded,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _KnotsLoaded() when knotsLoaded != null:
return knotsLoaded(_that.knots);case _RequestedKnotsLoaded() when requestedKnotsLoaded != null:
return requestedKnotsLoaded(_that.knots);case _IncomingKnotsLoaded() when incomingKnotsLoaded != null:
return incomingKnotsLoaded(_that.knots);case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements KnotsListState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KnotsListState.initial()';
}


}




/// @nodoc


class _Loading implements KnotsListState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KnotsListState.loading()';
}


}




/// @nodoc


class _KnotsLoaded implements KnotsListState {
  const _KnotsLoaded(final  List<KnotModel> knots): _knots = knots;
  

 final  List<KnotModel> _knots;
 List<KnotModel> get knots {
  if (_knots is EqualUnmodifiableListView) return _knots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_knots);
}


/// Create a copy of KnotsListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$KnotsLoadedCopyWith<_KnotsLoaded> get copyWith => __$KnotsLoadedCopyWithImpl<_KnotsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _KnotsLoaded&&const DeepCollectionEquality().equals(other._knots, _knots));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_knots));

@override
String toString() {
  return 'KnotsListState.knotsLoaded(knots: $knots)';
}


}

/// @nodoc
abstract mixin class _$KnotsLoadedCopyWith<$Res> implements $KnotsListStateCopyWith<$Res> {
  factory _$KnotsLoadedCopyWith(_KnotsLoaded value, $Res Function(_KnotsLoaded) _then) = __$KnotsLoadedCopyWithImpl;
@useResult
$Res call({
 List<KnotModel> knots
});




}
/// @nodoc
class __$KnotsLoadedCopyWithImpl<$Res>
    implements _$KnotsLoadedCopyWith<$Res> {
  __$KnotsLoadedCopyWithImpl(this._self, this._then);

  final _KnotsLoaded _self;
  final $Res Function(_KnotsLoaded) _then;

/// Create a copy of KnotsListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? knots = null,}) {
  return _then(_KnotsLoaded(
null == knots ? _self._knots : knots // ignore: cast_nullable_to_non_nullable
as List<KnotModel>,
  ));
}


}

/// @nodoc


class _RequestedKnotsLoaded implements KnotsListState {
  const _RequestedKnotsLoaded(final  List<KnotModel> knots): _knots = knots;
  

 final  List<KnotModel> _knots;
 List<KnotModel> get knots {
  if (_knots is EqualUnmodifiableListView) return _knots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_knots);
}


/// Create a copy of KnotsListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequestedKnotsLoadedCopyWith<_RequestedKnotsLoaded> get copyWith => __$RequestedKnotsLoadedCopyWithImpl<_RequestedKnotsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequestedKnotsLoaded&&const DeepCollectionEquality().equals(other._knots, _knots));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_knots));

@override
String toString() {
  return 'KnotsListState.requestedKnotsLoaded(knots: $knots)';
}


}

/// @nodoc
abstract mixin class _$RequestedKnotsLoadedCopyWith<$Res> implements $KnotsListStateCopyWith<$Res> {
  factory _$RequestedKnotsLoadedCopyWith(_RequestedKnotsLoaded value, $Res Function(_RequestedKnotsLoaded) _then) = __$RequestedKnotsLoadedCopyWithImpl;
@useResult
$Res call({
 List<KnotModel> knots
});




}
/// @nodoc
class __$RequestedKnotsLoadedCopyWithImpl<$Res>
    implements _$RequestedKnotsLoadedCopyWith<$Res> {
  __$RequestedKnotsLoadedCopyWithImpl(this._self, this._then);

  final _RequestedKnotsLoaded _self;
  final $Res Function(_RequestedKnotsLoaded) _then;

/// Create a copy of KnotsListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? knots = null,}) {
  return _then(_RequestedKnotsLoaded(
null == knots ? _self._knots : knots // ignore: cast_nullable_to_non_nullable
as List<KnotModel>,
  ));
}


}

/// @nodoc


class _IncomingKnotsLoaded implements KnotsListState {
  const _IncomingKnotsLoaded(final  List<KnotModel> knots): _knots = knots;
  

 final  List<KnotModel> _knots;
 List<KnotModel> get knots {
  if (_knots is EqualUnmodifiableListView) return _knots;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_knots);
}


/// Create a copy of KnotsListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IncomingKnotsLoadedCopyWith<_IncomingKnotsLoaded> get copyWith => __$IncomingKnotsLoadedCopyWithImpl<_IncomingKnotsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IncomingKnotsLoaded&&const DeepCollectionEquality().equals(other._knots, _knots));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_knots));

@override
String toString() {
  return 'KnotsListState.incomingKnotsLoaded(knots: $knots)';
}


}

/// @nodoc
abstract mixin class _$IncomingKnotsLoadedCopyWith<$Res> implements $KnotsListStateCopyWith<$Res> {
  factory _$IncomingKnotsLoadedCopyWith(_IncomingKnotsLoaded value, $Res Function(_IncomingKnotsLoaded) _then) = __$IncomingKnotsLoadedCopyWithImpl;
@useResult
$Res call({
 List<KnotModel> knots
});




}
/// @nodoc
class __$IncomingKnotsLoadedCopyWithImpl<$Res>
    implements _$IncomingKnotsLoadedCopyWith<$Res> {
  __$IncomingKnotsLoadedCopyWithImpl(this._self, this._then);

  final _IncomingKnotsLoaded _self;
  final $Res Function(_IncomingKnotsLoaded) _then;

/// Create a copy of KnotsListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? knots = null,}) {
  return _then(_IncomingKnotsLoaded(
null == knots ? _self._knots : knots // ignore: cast_nullable_to_non_nullable
as List<KnotModel>,
  ));
}


}

/// @nodoc


class _Error implements KnotsListState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of KnotsListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'KnotsListState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $KnotsListStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of KnotsListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
