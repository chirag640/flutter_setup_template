import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

import '../services/logger_service.dart';

const Object _sentinel = Object();

/// Base status model that Riverpod notifiers can extend to expose
/// loading/updating/error flags in a consistent way.
@immutable
abstract class BaseState<T extends BaseState<T>> {
  const BaseState({this.loading = false, this.updating = false, this.error});

  /// Indicates the provider is performing an initial load.
  final bool loading;

  /// Indicates the provider is performing a background mutation.
  final bool updating;

  /// Latest user-facing error message, if any.
  final String? error;

  bool get hasError => error != null;

  /// Copy the state while updating the lifecycle flags.
  T copyWithStatus({bool? loading, bool? updating, Object? error = _sentinel});
}

/// Simple concrete implementation that only tracks the base status flags.
@immutable
class SimpleBaseState extends BaseState<SimpleBaseState> {
  const SimpleBaseState({super.loading, super.updating, super.error});

  @override
  SimpleBaseState copyWithStatus({
    bool? loading,
    bool? updating,
    Object? error = _sentinel,
  }) {
    return SimpleBaseState(
      loading: loading ?? this.loading,
      updating: updating ?? this.updating,
      error: identical(error, _sentinel) ? this.error : error as String?,
    );
  }
}

/// Mixin that ports the legacy ChangeNotifier helpers to Riverpod notifiers.
mixin BaseNotifierMixin<T extends BaseState<T>> on StateNotifier<T> {
  void _debug(String message) =>
      AppLogger.instance.d(message, tag: runtimeType.toString());

  void _warning(String message, {Object? extra}) =>
      AppLogger.instance.w(message, tag: runtimeType.toString(), extra: extra);

  void startLoading() {
    _debug('startLoading');
    if (!mounted) return;
    state = state.copyWithStatus(loading: true, error: null);
  }

  void endLoading() {
    _debug('endLoading');
    if (!mounted) return;
    state = state.copyWithStatus(loading: false);
  }

  void startUpdating() {
    _debug('startUpdating');
    if (!mounted) return;
    state = state.copyWithStatus(updating: true, error: null);
  }

  void endUpdating() {
    _debug('endUpdating');
    if (!mounted) return;
    state = state.copyWithStatus(updating: false);
  }

  void clearErrorAndNotify() {
    _debug('clearErrorAndNotify');
    if (!mounted) return;
    state = state.copyWithStatus(error: null);
  }

  void setErrorAndNotify(String? message) {
    _warning('setErrorAndNotify', extra: message);
    if (!mounted) return;
    state = state.copyWithStatus(error: message);
  }

  Future<R> usingLoading<R>(FutureOr<R> Function() action) async {
    _debug('usingLoading: begin');
    startLoading();
    try {
      return await Future.sync(action);
    } finally {
      _debug('usingLoading: end');
      endLoading();
    }
  }

  Future<R> usingUpdating<R>(FutureOr<R> Function() action) async {
    _debug('usingUpdating: begin');
    startUpdating();
    try {
      return await Future.sync(action);
    } finally {
      _debug('usingUpdating: end');
      endUpdating();
    }
  }
}

/// Default notifier that mirrors the old BaseProvider behaviour.
class BaseNotifier extends StateNotifier<SimpleBaseState>
    with BaseNotifierMixin<SimpleBaseState> {
  BaseNotifier() : super(const SimpleBaseState());
}

/// Convenience provider for simple lifecycle-driven UIs.
final baseNotifierProvider =
    StateNotifierProvider<BaseNotifier, SimpleBaseState>(
      (ref) => BaseNotifier(),
    );
