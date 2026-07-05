// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaginatedResult<T> {

 List<T> get items; int get total; String? get nextUrl; String? get previousUrl;
/// Create a copy of PaginatedResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedResultCopyWith<T, PaginatedResult<T>> get copyWith => _$PaginatedResultCopyWithImpl<T, PaginatedResult<T>>(this as PaginatedResult<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedResult<T>&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.total, total) || other.total == total)&&(identical(other.nextUrl, nextUrl) || other.nextUrl == nextUrl)&&(identical(other.previousUrl, previousUrl) || other.previousUrl == previousUrl));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),total,nextUrl,previousUrl);

@override
String toString() {
  return 'PaginatedResult<$T>(items: $items, total: $total, nextUrl: $nextUrl, previousUrl: $previousUrl)';
}


}

/// @nodoc
abstract mixin class $PaginatedResultCopyWith<T,$Res>  {
  factory $PaginatedResultCopyWith(PaginatedResult<T> value, $Res Function(PaginatedResult<T>) _then) = _$PaginatedResultCopyWithImpl;
@useResult
$Res call({
 List<T> items, int total, String? nextUrl, String? previousUrl
});




}
/// @nodoc
class _$PaginatedResultCopyWithImpl<T,$Res>
    implements $PaginatedResultCopyWith<T, $Res> {
  _$PaginatedResultCopyWithImpl(this._self, this._then);

  final PaginatedResult<T> _self;
  final $Res Function(PaginatedResult<T>) _then;

/// Create a copy of PaginatedResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? total = null,Object? nextUrl = freezed,Object? previousUrl = freezed,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<T>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextUrl: freezed == nextUrl ? _self.nextUrl : nextUrl // ignore: cast_nullable_to_non_nullable
as String?,previousUrl: freezed == previousUrl ? _self.previousUrl : previousUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginatedResult].
extension PaginatedResultPatterns<T> on PaginatedResult<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedResult<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedResult<T> value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedResult<T> value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<T> items,  int total,  String? nextUrl,  String? previousUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedResult() when $default != null:
return $default(_that.items,_that.total,_that.nextUrl,_that.previousUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<T> items,  int total,  String? nextUrl,  String? previousUrl)  $default,) {final _that = this;
switch (_that) {
case _PaginatedResult():
return $default(_that.items,_that.total,_that.nextUrl,_that.previousUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<T> items,  int total,  String? nextUrl,  String? previousUrl)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedResult() when $default != null:
return $default(_that.items,_that.total,_that.nextUrl,_that.previousUrl);case _:
  return null;

}
}

}

/// @nodoc


class _PaginatedResult<T> implements PaginatedResult<T> {
  const _PaginatedResult({required final  List<T> items, required this.total, this.nextUrl, this.previousUrl}): _items = items;
  

 final  List<T> _items;
@override List<T> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int total;
@override final  String? nextUrl;
@override final  String? previousUrl;

/// Create a copy of PaginatedResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedResultCopyWith<T, _PaginatedResult<T>> get copyWith => __$PaginatedResultCopyWithImpl<T, _PaginatedResult<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedResult<T>&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.total, total) || other.total == total)&&(identical(other.nextUrl, nextUrl) || other.nextUrl == nextUrl)&&(identical(other.previousUrl, previousUrl) || other.previousUrl == previousUrl));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),total,nextUrl,previousUrl);

@override
String toString() {
  return 'PaginatedResult<$T>(items: $items, total: $total, nextUrl: $nextUrl, previousUrl: $previousUrl)';
}


}

/// @nodoc
abstract mixin class _$PaginatedResultCopyWith<T,$Res> implements $PaginatedResultCopyWith<T, $Res> {
  factory _$PaginatedResultCopyWith(_PaginatedResult<T> value, $Res Function(_PaginatedResult<T>) _then) = __$PaginatedResultCopyWithImpl;
@override @useResult
$Res call({
 List<T> items, int total, String? nextUrl, String? previousUrl
});




}
/// @nodoc
class __$PaginatedResultCopyWithImpl<T,$Res>
    implements _$PaginatedResultCopyWith<T, $Res> {
  __$PaginatedResultCopyWithImpl(this._self, this._then);

  final _PaginatedResult<T> _self;
  final $Res Function(_PaginatedResult<T>) _then;

/// Create a copy of PaginatedResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? total = null,Object? nextUrl = freezed,Object? previousUrl = freezed,}) {
  return _then(_PaginatedResult<T>(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<T>,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,nextUrl: freezed == nextUrl ? _self.nextUrl : nextUrl // ignore: cast_nullable_to_non_nullable
as String?,previousUrl: freezed == previousUrl ? _self.previousUrl : previousUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
