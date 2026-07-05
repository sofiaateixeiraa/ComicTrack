// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'series.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Series {

 String get id; String get title; String get publisher; int? get yearBegan; String? get coverUrl; String? get synopsis;
/// Create a copy of Series
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeriesCopyWith<Series> get copyWith => _$SeriesCopyWithImpl<Series>(this as Series, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Series&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.yearBegan, yearBegan) || other.yearBegan == yearBegan)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.synopsis, synopsis) || other.synopsis == synopsis));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,publisher,yearBegan,coverUrl,synopsis);

@override
String toString() {
  return 'Series(id: $id, title: $title, publisher: $publisher, yearBegan: $yearBegan, coverUrl: $coverUrl, synopsis: $synopsis)';
}


}

/// @nodoc
abstract mixin class $SeriesCopyWith<$Res>  {
  factory $SeriesCopyWith(Series value, $Res Function(Series) _then) = _$SeriesCopyWithImpl;
@useResult
$Res call({
 String id, String title, String publisher, int? yearBegan, String? coverUrl, String? synopsis
});




}
/// @nodoc
class _$SeriesCopyWithImpl<$Res>
    implements $SeriesCopyWith<$Res> {
  _$SeriesCopyWithImpl(this._self, this._then);

  final Series _self;
  final $Res Function(Series) _then;

/// Create a copy of Series
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? publisher = null,Object? yearBegan = freezed,Object? coverUrl = freezed,Object? synopsis = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,publisher: null == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String,yearBegan: freezed == yearBegan ? _self.yearBegan : yearBegan // ignore: cast_nullable_to_non_nullable
as int?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,synopsis: freezed == synopsis ? _self.synopsis : synopsis // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Series].
extension SeriesPatterns on Series {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Series value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Series() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Series value)  $default,){
final _that = this;
switch (_that) {
case _Series():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Series value)?  $default,){
final _that = this;
switch (_that) {
case _Series() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String publisher,  int? yearBegan,  String? coverUrl,  String? synopsis)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Series() when $default != null:
return $default(_that.id,_that.title,_that.publisher,_that.yearBegan,_that.coverUrl,_that.synopsis);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String publisher,  int? yearBegan,  String? coverUrl,  String? synopsis)  $default,) {final _that = this;
switch (_that) {
case _Series():
return $default(_that.id,_that.title,_that.publisher,_that.yearBegan,_that.coverUrl,_that.synopsis);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String publisher,  int? yearBegan,  String? coverUrl,  String? synopsis)?  $default,) {final _that = this;
switch (_that) {
case _Series() when $default != null:
return $default(_that.id,_that.title,_that.publisher,_that.yearBegan,_that.coverUrl,_that.synopsis);case _:
  return null;

}
}

}

/// @nodoc


class _Series implements Series {
  const _Series({required this.id, required this.title, required this.publisher, this.yearBegan, this.coverUrl, this.synopsis});
  

@override final  String id;
@override final  String title;
@override final  String publisher;
@override final  int? yearBegan;
@override final  String? coverUrl;
@override final  String? synopsis;

/// Create a copy of Series
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeriesCopyWith<_Series> get copyWith => __$SeriesCopyWithImpl<_Series>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Series&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.yearBegan, yearBegan) || other.yearBegan == yearBegan)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.synopsis, synopsis) || other.synopsis == synopsis));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,publisher,yearBegan,coverUrl,synopsis);

@override
String toString() {
  return 'Series(id: $id, title: $title, publisher: $publisher, yearBegan: $yearBegan, coverUrl: $coverUrl, synopsis: $synopsis)';
}


}

/// @nodoc
abstract mixin class _$SeriesCopyWith<$Res> implements $SeriesCopyWith<$Res> {
  factory _$SeriesCopyWith(_Series value, $Res Function(_Series) _then) = __$SeriesCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String publisher, int? yearBegan, String? coverUrl, String? synopsis
});




}
/// @nodoc
class __$SeriesCopyWithImpl<$Res>
    implements _$SeriesCopyWith<$Res> {
  __$SeriesCopyWithImpl(this._self, this._then);

  final _Series _self;
  final $Res Function(_Series) _then;

/// Create a copy of Series
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? publisher = null,Object? yearBegan = freezed,Object? coverUrl = freezed,Object? synopsis = freezed,}) {
  return _then(_Series(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,publisher: null == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String,yearBegan: freezed == yearBegan ? _self.yearBegan : yearBegan // ignore: cast_nullable_to_non_nullable
as int?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,synopsis: freezed == synopsis ? _self.synopsis : synopsis // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
