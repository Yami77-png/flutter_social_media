// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'knot_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$KnotState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is KnotState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KnotState()';
}


}

/// @nodoc
class $KnotStateCopyWith<$Res>  {
$KnotStateCopyWith(KnotState _, $Res Function(KnotState) __);
}


/// Adds pattern-matching-related methods to [KnotState].
extension KnotStatePatterns on KnotState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Success value)?  success,TResult Function( _CanceledRequest value)?  cancaledRequest,TResult Function( _RejectedRequest value)?  rejectedRequest,TResult Function( _AccepetedRequest value)?  accepetedRequest,TResult Function( _CheckingKnots value)?  checkingKnot,TResult Function( _HasRequestedKnots value)?  hasRequestedKnot,TResult Function( _HasIncomingKnots value)?  hasIncomingKnot,TResult Function( _IsKnotted value)?  isKnotted,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _CanceledRequest() when cancaledRequest != null:
return cancaledRequest(_that);case _RejectedRequest() when rejectedRequest != null:
return rejectedRequest(_that);case _AccepetedRequest() when accepetedRequest != null:
return accepetedRequest(_that);case _CheckingKnots() when checkingKnot != null:
return checkingKnot(_that);case _HasRequestedKnots() when hasRequestedKnot != null:
return hasRequestedKnot(_that);case _HasIncomingKnots() when hasIncomingKnot != null:
return hasIncomingKnot(_that);case _IsKnotted() when isKnotted != null:
return isKnotted(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Success value)  success,required TResult Function( _CanceledRequest value)  cancaledRequest,required TResult Function( _RejectedRequest value)  rejectedRequest,required TResult Function( _AccepetedRequest value)  accepetedRequest,required TResult Function( _CheckingKnots value)  checkingKnot,required TResult Function( _HasRequestedKnots value)  hasRequestedKnot,required TResult Function( _HasIncomingKnots value)  hasIncomingKnot,required TResult Function( _IsKnotted value)  isKnotted,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Success():
return success(_that);case _CanceledRequest():
return cancaledRequest(_that);case _RejectedRequest():
return rejectedRequest(_that);case _AccepetedRequest():
return accepetedRequest(_that);case _CheckingKnots():
return checkingKnot(_that);case _HasRequestedKnots():
return hasRequestedKnot(_that);case _HasIncomingKnots():
return hasIncomingKnot(_that);case _IsKnotted():
return isKnotted(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Success value)?  success,TResult? Function( _CanceledRequest value)?  cancaledRequest,TResult? Function( _RejectedRequest value)?  rejectedRequest,TResult? Function( _AccepetedRequest value)?  accepetedRequest,TResult? Function( _CheckingKnots value)?  checkingKnot,TResult? Function( _HasRequestedKnots value)?  hasRequestedKnot,TResult? Function( _HasIncomingKnots value)?  hasIncomingKnot,TResult? Function( _IsKnotted value)?  isKnotted,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Success() when success != null:
return success(_that);case _CanceledRequest() when cancaledRequest != null:
return cancaledRequest(_that);case _RejectedRequest() when rejectedRequest != null:
return rejectedRequest(_that);case _AccepetedRequest() when accepetedRequest != null:
return accepetedRequest(_that);case _CheckingKnots() when checkingKnot != null:
return checkingKnot(_that);case _HasRequestedKnots() when hasRequestedKnot != null:
return hasRequestedKnot(_that);case _HasIncomingKnots() when hasIncomingKnot != null:
return hasIncomingKnot(_that);case _IsKnotted() when isKnotted != null:
return isKnotted(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function()?  success,TResult Function()?  cancaledRequest,TResult Function()?  rejectedRequest,TResult Function()?  accepetedRequest,TResult Function()?  checkingKnot,TResult Function()?  hasRequestedKnot,TResult Function()?  hasIncomingKnot,TResult Function()?  isKnotted,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success();case _CanceledRequest() when cancaledRequest != null:
return cancaledRequest();case _RejectedRequest() when rejectedRequest != null:
return rejectedRequest();case _AccepetedRequest() when accepetedRequest != null:
return accepetedRequest();case _CheckingKnots() when checkingKnot != null:
return checkingKnot();case _HasRequestedKnots() when hasRequestedKnot != null:
return hasRequestedKnot();case _HasIncomingKnots() when hasIncomingKnot != null:
return hasIncomingKnot();case _IsKnotted() when isKnotted != null:
return isKnotted();case _Error() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function()  success,required TResult Function()  cancaledRequest,required TResult Function()  rejectedRequest,required TResult Function()  accepetedRequest,required TResult Function()  checkingKnot,required TResult Function()  hasRequestedKnot,required TResult Function()  hasIncomingKnot,required TResult Function()  isKnotted,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Success():
return success();case _CanceledRequest():
return cancaledRequest();case _RejectedRequest():
return rejectedRequest();case _AccepetedRequest():
return accepetedRequest();case _CheckingKnots():
return checkingKnot();case _HasRequestedKnots():
return hasRequestedKnot();case _HasIncomingKnots():
return hasIncomingKnot();case _IsKnotted():
return isKnotted();case _Error():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function()?  success,TResult? Function()?  cancaledRequest,TResult? Function()?  rejectedRequest,TResult? Function()?  accepetedRequest,TResult? Function()?  checkingKnot,TResult? Function()?  hasRequestedKnot,TResult? Function()?  hasIncomingKnot,TResult? Function()?  isKnotted,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Success() when success != null:
return success();case _CanceledRequest() when cancaledRequest != null:
return cancaledRequest();case _RejectedRequest() when rejectedRequest != null:
return rejectedRequest();case _AccepetedRequest() when accepetedRequest != null:
return accepetedRequest();case _CheckingKnots() when checkingKnot != null:
return checkingKnot();case _HasRequestedKnots() when hasRequestedKnot != null:
return hasRequestedKnot();case _HasIncomingKnots() when hasIncomingKnot != null:
return hasIncomingKnot();case _IsKnotted() when isKnotted != null:
return isKnotted();case _Error() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements KnotState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KnotState.initial()';
}


}




/// @nodoc


class _Loading implements KnotState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KnotState.loading()';
}


}




/// @nodoc


class _Success implements KnotState {
  const _Success();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Success);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KnotState.success()';
}


}




/// @nodoc


class _CanceledRequest implements KnotState {
  const _CanceledRequest();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CanceledRequest);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KnotState.cancaledRequest()';
}


}




/// @nodoc


class _RejectedRequest implements KnotState {
  const _RejectedRequest();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RejectedRequest);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KnotState.rejectedRequest()';
}


}




/// @nodoc


class _AccepetedRequest implements KnotState {
  const _AccepetedRequest();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccepetedRequest);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KnotState.accepetedRequest()';
}


}




/// @nodoc


class _CheckingKnots implements KnotState {
  const _CheckingKnots();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CheckingKnots);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KnotState.checkingKnot()';
}


}




/// @nodoc


class _HasRequestedKnots implements KnotState {
  const _HasRequestedKnots();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HasRequestedKnots);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KnotState.hasRequestedKnot()';
}


}




/// @nodoc


class _HasIncomingKnots implements KnotState {
  const _HasIncomingKnots();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HasIncomingKnots);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KnotState.hasIncomingKnot()';
}


}




/// @nodoc


class _IsKnotted implements KnotState {
  const _IsKnotted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IsKnotted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'KnotState.isKnotted()';
}


}




/// @nodoc


class _Error implements KnotState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of KnotState
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
  return 'KnotState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $KnotStateCopyWith<$Res> {
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

/// Create a copy of KnotState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
