// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'comic_collection_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ComicCollectionEntry {

 String get issueId; String get seriesName; String get issueNumber; String? get coverUrl; OwnershipStatus get ownershipStatus;// null quando ownershipStatus == none ou wishlist.
 ReadingStatus? get readingStatus; bool get isFavorite;
/// Create a copy of ComicCollectionEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ComicCollectionEntryCopyWith<ComicCollectionEntry> get copyWith => _$ComicCollectionEntryCopyWithImpl<ComicCollectionEntry>(this as ComicCollectionEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ComicCollectionEntry&&(identical(other.issueId, issueId) || other.issueId == issueId)&&(identical(other.seriesName, seriesName) || other.seriesName == seriesName)&&(identical(other.issueNumber, issueNumber) || other.issueNumber == issueNumber)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.ownershipStatus, ownershipStatus) || other.ownershipStatus == ownershipStatus)&&(identical(other.readingStatus, readingStatus) || other.readingStatus == readingStatus)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}


@override
int get hashCode => Object.hash(runtimeType,issueId,seriesName,issueNumber,coverUrl,ownershipStatus,readingStatus,isFavorite);

@override
String toString() {
  return 'ComicCollectionEntry(issueId: $issueId, seriesName: $seriesName, issueNumber: $issueNumber, coverUrl: $coverUrl, ownershipStatus: $ownershipStatus, readingStatus: $readingStatus, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class $ComicCollectionEntryCopyWith<$Res>  {
  factory $ComicCollectionEntryCopyWith(ComicCollectionEntry value, $Res Function(ComicCollectionEntry) _then) = _$ComicCollectionEntryCopyWithImpl;
@useResult
$Res call({
 String issueId, String seriesName, String issueNumber, String? coverUrl, OwnershipStatus ownershipStatus, ReadingStatus? readingStatus, bool isFavorite
});




}
/// @nodoc
class _$ComicCollectionEntryCopyWithImpl<$Res>
    implements $ComicCollectionEntryCopyWith<$Res> {
  _$ComicCollectionEntryCopyWithImpl(this._self, this._then);

  final ComicCollectionEntry _self;
  final $Res Function(ComicCollectionEntry) _then;

/// Create a copy of ComicCollectionEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? issueId = null,Object? seriesName = null,Object? issueNumber = null,Object? coverUrl = freezed,Object? ownershipStatus = null,Object? readingStatus = freezed,Object? isFavorite = null,}) {
  return _then(_self.copyWith(
issueId: null == issueId ? _self.issueId : issueId // ignore: cast_nullable_to_non_nullable
as String,seriesName: null == seriesName ? _self.seriesName : seriesName // ignore: cast_nullable_to_non_nullable
as String,issueNumber: null == issueNumber ? _self.issueNumber : issueNumber // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,ownershipStatus: null == ownershipStatus ? _self.ownershipStatus : ownershipStatus // ignore: cast_nullable_to_non_nullable
as OwnershipStatus,readingStatus: freezed == readingStatus ? _self.readingStatus : readingStatus // ignore: cast_nullable_to_non_nullable
as ReadingStatus?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ComicCollectionEntry].
extension ComicCollectionEntryPatterns on ComicCollectionEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ComicCollectionEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ComicCollectionEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ComicCollectionEntry value)  $default,){
final _that = this;
switch (_that) {
case _ComicCollectionEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ComicCollectionEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ComicCollectionEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String issueId,  String seriesName,  String issueNumber,  String? coverUrl,  OwnershipStatus ownershipStatus,  ReadingStatus? readingStatus,  bool isFavorite)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ComicCollectionEntry() when $default != null:
return $default(_that.issueId,_that.seriesName,_that.issueNumber,_that.coverUrl,_that.ownershipStatus,_that.readingStatus,_that.isFavorite);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String issueId,  String seriesName,  String issueNumber,  String? coverUrl,  OwnershipStatus ownershipStatus,  ReadingStatus? readingStatus,  bool isFavorite)  $default,) {final _that = this;
switch (_that) {
case _ComicCollectionEntry():
return $default(_that.issueId,_that.seriesName,_that.issueNumber,_that.coverUrl,_that.ownershipStatus,_that.readingStatus,_that.isFavorite);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String issueId,  String seriesName,  String issueNumber,  String? coverUrl,  OwnershipStatus ownershipStatus,  ReadingStatus? readingStatus,  bool isFavorite)?  $default,) {final _that = this;
switch (_that) {
case _ComicCollectionEntry() when $default != null:
return $default(_that.issueId,_that.seriesName,_that.issueNumber,_that.coverUrl,_that.ownershipStatus,_that.readingStatus,_that.isFavorite);case _:
  return null;

}
}

}

/// @nodoc


class _ComicCollectionEntry extends ComicCollectionEntry {
  const _ComicCollectionEntry({required this.issueId, required this.seriesName, required this.issueNumber, this.coverUrl, required this.ownershipStatus, this.readingStatus, this.isFavorite = false}): super._();
  

@override final  String issueId;
@override final  String seriesName;
@override final  String issueNumber;
@override final  String? coverUrl;
@override final  OwnershipStatus ownershipStatus;
// null quando ownershipStatus == none ou wishlist.
@override final  ReadingStatus? readingStatus;
@override@JsonKey() final  bool isFavorite;

/// Create a copy of ComicCollectionEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ComicCollectionEntryCopyWith<_ComicCollectionEntry> get copyWith => __$ComicCollectionEntryCopyWithImpl<_ComicCollectionEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ComicCollectionEntry&&(identical(other.issueId, issueId) || other.issueId == issueId)&&(identical(other.seriesName, seriesName) || other.seriesName == seriesName)&&(identical(other.issueNumber, issueNumber) || other.issueNumber == issueNumber)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.ownershipStatus, ownershipStatus) || other.ownershipStatus == ownershipStatus)&&(identical(other.readingStatus, readingStatus) || other.readingStatus == readingStatus)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite));
}


@override
int get hashCode => Object.hash(runtimeType,issueId,seriesName,issueNumber,coverUrl,ownershipStatus,readingStatus,isFavorite);

@override
String toString() {
  return 'ComicCollectionEntry(issueId: $issueId, seriesName: $seriesName, issueNumber: $issueNumber, coverUrl: $coverUrl, ownershipStatus: $ownershipStatus, readingStatus: $readingStatus, isFavorite: $isFavorite)';
}


}

/// @nodoc
abstract mixin class _$ComicCollectionEntryCopyWith<$Res> implements $ComicCollectionEntryCopyWith<$Res> {
  factory _$ComicCollectionEntryCopyWith(_ComicCollectionEntry value, $Res Function(_ComicCollectionEntry) _then) = __$ComicCollectionEntryCopyWithImpl;
@override @useResult
$Res call({
 String issueId, String seriesName, String issueNumber, String? coverUrl, OwnershipStatus ownershipStatus, ReadingStatus? readingStatus, bool isFavorite
});




}
/// @nodoc
class __$ComicCollectionEntryCopyWithImpl<$Res>
    implements _$ComicCollectionEntryCopyWith<$Res> {
  __$ComicCollectionEntryCopyWithImpl(this._self, this._then);

  final _ComicCollectionEntry _self;
  final $Res Function(_ComicCollectionEntry) _then;

/// Create a copy of ComicCollectionEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? issueId = null,Object? seriesName = null,Object? issueNumber = null,Object? coverUrl = freezed,Object? ownershipStatus = null,Object? readingStatus = freezed,Object? isFavorite = null,}) {
  return _then(_ComicCollectionEntry(
issueId: null == issueId ? _self.issueId : issueId // ignore: cast_nullable_to_non_nullable
as String,seriesName: null == seriesName ? _self.seriesName : seriesName // ignore: cast_nullable_to_non_nullable
as String,issueNumber: null == issueNumber ? _self.issueNumber : issueNumber // ignore: cast_nullable_to_non_nullable
as String,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,ownershipStatus: null == ownershipStatus ? _self.ownershipStatus : ownershipStatus // ignore: cast_nullable_to_non_nullable
as OwnershipStatus,readingStatus: freezed == readingStatus ? _self.readingStatus : readingStatus // ignore: cast_nullable_to_non_nullable
as ReadingStatus?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
