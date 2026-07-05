// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'issue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Issue {

 String get id; String get seriesId; String get seriesName; String get number; String? get coverDate; String? get coverUrl; String? get desc; List<String> get creators;
/// Create a copy of Issue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IssueCopyWith<Issue> get copyWith => _$IssueCopyWithImpl<Issue>(this as Issue, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Issue&&(identical(other.id, id) || other.id == id)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.seriesName, seriesName) || other.seriesName == seriesName)&&(identical(other.number, number) || other.number == number)&&(identical(other.coverDate, coverDate) || other.coverDate == coverDate)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.desc, desc) || other.desc == desc)&&const DeepCollectionEquality().equals(other.creators, creators));
}


@override
int get hashCode => Object.hash(runtimeType,id,seriesId,seriesName,number,coverDate,coverUrl,desc,const DeepCollectionEquality().hash(creators));

@override
String toString() {
  return 'Issue(id: $id, seriesId: $seriesId, seriesName: $seriesName, number: $number, coverDate: $coverDate, coverUrl: $coverUrl, desc: $desc, creators: $creators)';
}


}

/// @nodoc
abstract mixin class $IssueCopyWith<$Res>  {
  factory $IssueCopyWith(Issue value, $Res Function(Issue) _then) = _$IssueCopyWithImpl;
@useResult
$Res call({
 String id, String seriesId, String seriesName, String number, String? coverDate, String? coverUrl, String? desc, List<String> creators
});




}
/// @nodoc
class _$IssueCopyWithImpl<$Res>
    implements $IssueCopyWith<$Res> {
  _$IssueCopyWithImpl(this._self, this._then);

  final Issue _self;
  final $Res Function(Issue) _then;

/// Create a copy of Issue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? seriesId = null,Object? seriesName = null,Object? number = null,Object? coverDate = freezed,Object? coverUrl = freezed,Object? desc = freezed,Object? creators = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seriesId: null == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as String,seriesName: null == seriesName ? _self.seriesName : seriesName // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,coverDate: freezed == coverDate ? _self.coverDate : coverDate // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,desc: freezed == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String?,creators: null == creators ? _self.creators : creators // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Issue].
extension IssuePatterns on Issue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Issue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Issue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Issue value)  $default,){
final _that = this;
switch (_that) {
case _Issue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Issue value)?  $default,){
final _that = this;
switch (_that) {
case _Issue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String seriesId,  String seriesName,  String number,  String? coverDate,  String? coverUrl,  String? desc,  List<String> creators)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Issue() when $default != null:
return $default(_that.id,_that.seriesId,_that.seriesName,_that.number,_that.coverDate,_that.coverUrl,_that.desc,_that.creators);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String seriesId,  String seriesName,  String number,  String? coverDate,  String? coverUrl,  String? desc,  List<String> creators)  $default,) {final _that = this;
switch (_that) {
case _Issue():
return $default(_that.id,_that.seriesId,_that.seriesName,_that.number,_that.coverDate,_that.coverUrl,_that.desc,_that.creators);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String seriesId,  String seriesName,  String number,  String? coverDate,  String? coverUrl,  String? desc,  List<String> creators)?  $default,) {final _that = this;
switch (_that) {
case _Issue() when $default != null:
return $default(_that.id,_that.seriesId,_that.seriesName,_that.number,_that.coverDate,_that.coverUrl,_that.desc,_that.creators);case _:
  return null;

}
}

}

/// @nodoc


class _Issue implements Issue {
  const _Issue({required this.id, required this.seriesId, required this.seriesName, required this.number, this.coverDate, this.coverUrl, this.desc, final  List<String> creators = const []}): _creators = creators;
  

@override final  String id;
@override final  String seriesId;
@override final  String seriesName;
@override final  String number;
@override final  String? coverDate;
@override final  String? coverUrl;
@override final  String? desc;
 final  List<String> _creators;
@override@JsonKey() List<String> get creators {
  if (_creators is EqualUnmodifiableListView) return _creators;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_creators);
}


/// Create a copy of Issue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IssueCopyWith<_Issue> get copyWith => __$IssueCopyWithImpl<_Issue>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Issue&&(identical(other.id, id) || other.id == id)&&(identical(other.seriesId, seriesId) || other.seriesId == seriesId)&&(identical(other.seriesName, seriesName) || other.seriesName == seriesName)&&(identical(other.number, number) || other.number == number)&&(identical(other.coverDate, coverDate) || other.coverDate == coverDate)&&(identical(other.coverUrl, coverUrl) || other.coverUrl == coverUrl)&&(identical(other.desc, desc) || other.desc == desc)&&const DeepCollectionEquality().equals(other._creators, _creators));
}


@override
int get hashCode => Object.hash(runtimeType,id,seriesId,seriesName,number,coverDate,coverUrl,desc,const DeepCollectionEquality().hash(_creators));

@override
String toString() {
  return 'Issue(id: $id, seriesId: $seriesId, seriesName: $seriesName, number: $number, coverDate: $coverDate, coverUrl: $coverUrl, desc: $desc, creators: $creators)';
}


}

/// @nodoc
abstract mixin class _$IssueCopyWith<$Res> implements $IssueCopyWith<$Res> {
  factory _$IssueCopyWith(_Issue value, $Res Function(_Issue) _then) = __$IssueCopyWithImpl;
@override @useResult
$Res call({
 String id, String seriesId, String seriesName, String number, String? coverDate, String? coverUrl, String? desc, List<String> creators
});




}
/// @nodoc
class __$IssueCopyWithImpl<$Res>
    implements _$IssueCopyWith<$Res> {
  __$IssueCopyWithImpl(this._self, this._then);

  final _Issue _self;
  final $Res Function(_Issue) _then;

/// Create a copy of Issue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? seriesId = null,Object? seriesName = null,Object? number = null,Object? coverDate = freezed,Object? coverUrl = freezed,Object? desc = freezed,Object? creators = null,}) {
  return _then(_Issue(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,seriesId: null == seriesId ? _self.seriesId : seriesId // ignore: cast_nullable_to_non_nullable
as String,seriesName: null == seriesName ? _self.seriesName : seriesName // ignore: cast_nullable_to_non_nullable
as String,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as String,coverDate: freezed == coverDate ? _self.coverDate : coverDate // ignore: cast_nullable_to_non_nullable
as String?,coverUrl: freezed == coverUrl ? _self.coverUrl : coverUrl // ignore: cast_nullable_to_non_nullable
as String?,desc: freezed == desc ? _self.desc : desc // ignore: cast_nullable_to_non_nullable
as String?,creators: null == creators ? _self._creators : creators // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
