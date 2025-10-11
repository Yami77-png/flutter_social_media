// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'videos_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VideosEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideosEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VideosEvent()';
}


}

/// @nodoc
class $VideosEventCopyWith<$Res>  {
$VideosEventCopyWith(VideosEvent _, $Res Function(VideosEvent) __);
}


/// Adds pattern-matching-related methods to [VideosEvent].
extension VideosEventPatterns on VideosEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _FetchVideos value)?  fetchVideos,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _FetchVideos() when fetchVideos != null:
return fetchVideos(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _FetchVideos value)  fetchVideos,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _FetchVideos():
return fetchVideos(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _FetchVideos value)?  fetchVideos,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _FetchVideos() when fetchVideos != null:
return fetchVideos(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  fetchVideos,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _FetchVideos() when fetchVideos != null:
return fetchVideos();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  fetchVideos,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _FetchVideos():
return fetchVideos();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  fetchVideos,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _FetchVideos() when fetchVideos != null:
return fetchVideos();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements VideosEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VideosEvent.started()';
}


}




/// @nodoc


class _FetchVideos implements VideosEvent {
  const _FetchVideos();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FetchVideos);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VideosEvent.fetchVideos()';
}


}




/// @nodoc
mixin _$VideosState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideosState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VideosState()';
}


}

/// @nodoc
class $VideosStateCopyWith<$Res>  {
$VideosStateCopyWith(VideosState _, $Res Function(VideosState) __);
}


/// Adds pattern-matching-related methods to [VideosState].
extension VideosStatePatterns on VideosState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _VideosLoading value)?  videosLoading,TResult Function( _VideosLoaded value)?  videosLoaded,TResult Function( _VideosError value)?  videosError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _VideosLoading() when videosLoading != null:
return videosLoading(_that);case _VideosLoaded() when videosLoaded != null:
return videosLoaded(_that);case _VideosError() when videosError != null:
return videosError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _VideosLoading value)  videosLoading,required TResult Function( _VideosLoaded value)  videosLoaded,required TResult Function( _VideosError value)  videosError,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _VideosLoading():
return videosLoading(_that);case _VideosLoaded():
return videosLoaded(_that);case _VideosError():
return videosError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _VideosLoading value)?  videosLoading,TResult? Function( _VideosLoaded value)?  videosLoaded,TResult? Function( _VideosError value)?  videosError,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _VideosLoading() when videosLoading != null:
return videosLoading(_that);case _VideosLoaded() when videosLoaded != null:
return videosLoaded(_that);case _VideosError() when videosError != null:
return videosError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  videosLoading,TResult Function( List<VideoModel> videos)?  videosLoaded,TResult Function()?  videosError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _VideosLoading() when videosLoading != null:
return videosLoading();case _VideosLoaded() when videosLoaded != null:
return videosLoaded(_that.videos);case _VideosError() when videosError != null:
return videosError();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  videosLoading,required TResult Function( List<VideoModel> videos)  videosLoaded,required TResult Function()  videosError,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _VideosLoading():
return videosLoading();case _VideosLoaded():
return videosLoaded(_that.videos);case _VideosError():
return videosError();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  videosLoading,TResult? Function( List<VideoModel> videos)?  videosLoaded,TResult? Function()?  videosError,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _VideosLoading() when videosLoading != null:
return videosLoading();case _VideosLoaded() when videosLoaded != null:
return videosLoaded(_that.videos);case _VideosError() when videosError != null:
return videosError();case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements VideosState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VideosState.initial()';
}


}




/// @nodoc


class _VideosLoading implements VideosState {
  const _VideosLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideosLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VideosState.videosLoading()';
}


}




/// @nodoc


class _VideosLoaded implements VideosState {
  const _VideosLoaded(final  List<VideoModel> videos): _videos = videos;
  

 final  List<VideoModel> _videos;
 List<VideoModel> get videos {
  if (_videos is EqualUnmodifiableListView) return _videos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_videos);
}


/// Create a copy of VideosState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideosLoadedCopyWith<_VideosLoaded> get copyWith => __$VideosLoadedCopyWithImpl<_VideosLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideosLoaded&&const DeepCollectionEquality().equals(other._videos, _videos));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_videos));

@override
String toString() {
  return 'VideosState.videosLoaded(videos: $videos)';
}


}

/// @nodoc
abstract mixin class _$VideosLoadedCopyWith<$Res> implements $VideosStateCopyWith<$Res> {
  factory _$VideosLoadedCopyWith(_VideosLoaded value, $Res Function(_VideosLoaded) _then) = __$VideosLoadedCopyWithImpl;
@useResult
$Res call({
 List<VideoModel> videos
});




}
/// @nodoc
class __$VideosLoadedCopyWithImpl<$Res>
    implements _$VideosLoadedCopyWith<$Res> {
  __$VideosLoadedCopyWithImpl(this._self, this._then);

  final _VideosLoaded _self;
  final $Res Function(_VideosLoaded) _then;

/// Create a copy of VideosState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? videos = null,}) {
  return _then(_VideosLoaded(
null == videos ? _self._videos : videos // ignore: cast_nullable_to_non_nullable
as List<VideoModel>,
  ));
}


}

/// @nodoc


class _VideosError implements VideosState {
  const _VideosError();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideosError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'VideosState.videosError()';
}


}




// dart format on
