// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_search_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileSearchState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileSearchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileSearchState()';
}


}

/// @nodoc
class $ProfileSearchStateCopyWith<$Res>  {
$ProfileSearchStateCopyWith(ProfileSearchState _, $Res Function(ProfileSearchState) __);
}


/// Adds pattern-matching-related methods to [ProfileSearchState].
extension ProfileSearchStatePatterns on ProfileSearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Error():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( Userx user,  IndividualProfileModel? individualProfile,  BusinessProfileModel? businessProfile,  ContentCreatorProfileModel? contentCreatorProfile,  ProfessionalProfileModel? professionalProfile,  bool personalInformationEdited)?  loaded,TResult Function( String e)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.user,_that.individualProfile,_that.businessProfile,_that.contentCreatorProfile,_that.professionalProfile,_that.personalInformationEdited);case _Error() when error != null:
return error(_that.e);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( Userx user,  IndividualProfileModel? individualProfile,  BusinessProfileModel? businessProfile,  ContentCreatorProfileModel? contentCreatorProfile,  ProfessionalProfileModel? professionalProfile,  bool personalInformationEdited)  loaded,required TResult Function( String e)  error,}) {final _that = this;
switch (_that) {
case _Loading():
return loading();case _Loaded():
return loaded(_that.user,_that.individualProfile,_that.businessProfile,_that.contentCreatorProfile,_that.professionalProfile,_that.personalInformationEdited);case _Error():
return error(_that.e);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( Userx user,  IndividualProfileModel? individualProfile,  BusinessProfileModel? businessProfile,  ContentCreatorProfileModel? contentCreatorProfile,  ProfessionalProfileModel? professionalProfile,  bool personalInformationEdited)?  loaded,TResult? Function( String e)?  error,}) {final _that = this;
switch (_that) {
case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.user,_that.individualProfile,_that.businessProfile,_that.contentCreatorProfile,_that.professionalProfile,_that.personalInformationEdited);case _Error() when error != null:
return error(_that.e);case _:
  return null;

}
}

}

/// @nodoc


class _Loading implements ProfileSearchState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileSearchState.loading()';
}


}




/// @nodoc


class _Loaded implements ProfileSearchState {
  const _Loaded({required this.user, required this.individualProfile, required this.businessProfile, required this.contentCreatorProfile, required this.professionalProfile, this.personalInformationEdited = false});
  

 final  Userx user;
 final  IndividualProfileModel? individualProfile;
 final  BusinessProfileModel? businessProfile;
 final  ContentCreatorProfileModel? contentCreatorProfile;
 final  ProfessionalProfileModel? professionalProfile;
@JsonKey() final  bool personalInformationEdited;

/// Create a copy of ProfileSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.user, user) || other.user == user)&&(identical(other.individualProfile, individualProfile) || other.individualProfile == individualProfile)&&(identical(other.businessProfile, businessProfile) || other.businessProfile == businessProfile)&&(identical(other.contentCreatorProfile, contentCreatorProfile) || other.contentCreatorProfile == contentCreatorProfile)&&(identical(other.professionalProfile, professionalProfile) || other.professionalProfile == professionalProfile)&&(identical(other.personalInformationEdited, personalInformationEdited) || other.personalInformationEdited == personalInformationEdited));
}


@override
int get hashCode => Object.hash(runtimeType,user,individualProfile,businessProfile,contentCreatorProfile,professionalProfile,personalInformationEdited);

@override
String toString() {
  return 'ProfileSearchState.loaded(user: $user, individualProfile: $individualProfile, businessProfile: $businessProfile, contentCreatorProfile: $contentCreatorProfile, professionalProfile: $professionalProfile, personalInformationEdited: $personalInformationEdited)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $ProfileSearchStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 Userx user, IndividualProfileModel? individualProfile, BusinessProfileModel? businessProfile, ContentCreatorProfileModel? contentCreatorProfile, ProfessionalProfileModel? professionalProfile, bool personalInformationEdited
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of ProfileSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? user = null,Object? individualProfile = freezed,Object? businessProfile = freezed,Object? contentCreatorProfile = freezed,Object? professionalProfile = freezed,Object? personalInformationEdited = null,}) {
  return _then(_Loaded(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as Userx,individualProfile: freezed == individualProfile ? _self.individualProfile : individualProfile // ignore: cast_nullable_to_non_nullable
as IndividualProfileModel?,businessProfile: freezed == businessProfile ? _self.businessProfile : businessProfile // ignore: cast_nullable_to_non_nullable
as BusinessProfileModel?,contentCreatorProfile: freezed == contentCreatorProfile ? _self.contentCreatorProfile : contentCreatorProfile // ignore: cast_nullable_to_non_nullable
as ContentCreatorProfileModel?,professionalProfile: freezed == professionalProfile ? _self.professionalProfile : professionalProfile // ignore: cast_nullable_to_non_nullable
as ProfessionalProfileModel?,personalInformationEdited: null == personalInformationEdited ? _self.personalInformationEdited : personalInformationEdited // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Error implements ProfileSearchState {
  const _Error(this.e);
  

 final  String e;

/// Create a copy of ProfileSearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.e, e) || other.e == e));
}


@override
int get hashCode => Object.hash(runtimeType,e);

@override
String toString() {
  return 'ProfileSearchState.error(e: $e)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ProfileSearchStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String e
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of ProfileSearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? e = null,}) {
  return _then(_Error(
null == e ? _self.e : e // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
