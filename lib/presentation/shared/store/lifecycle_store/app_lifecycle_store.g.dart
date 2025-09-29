// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_lifecycle_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppLifecycleStore on _AppLifecycleStore, Store {
  late final _$statusAtom =
      Atom(name: '_AppLifecycleStore.status', context: context);

  @override
  AppLifecycleStatus get status {
    _$statusAtom.reportRead();
    return super.status;
  }

  @override
  set status(AppLifecycleStatus value) {
    _$statusAtom.reportWrite(value, super.status, () {
      super.status = value;
    });
  }

  late final _$setForegroundAsyncAction =
      AsyncAction('_AppLifecycleStore.setForeground', context: context);

  @override
  Future<void> setForeground() {
    return _$setForegroundAsyncAction.run(() => super.setForeground());
  }

  late final _$setBackgroundAsyncAction =
      AsyncAction('_AppLifecycleStore.setBackground', context: context);

  @override
  Future<void> setBackground() {
    return _$setBackgroundAsyncAction.run(() => super.setBackground());
  }

  @override
  String toString() {
    return '''
status: ${status}
    ''';
  }
}
