import 'dart:async';
import 'package:flutter/foundation.dart';
import '../services/logger_service.dart';

/// A mixin to standardize loading/updating/error lifecycle and notifications
/// across providers.
mixin BaseProvider on ChangeNotifier {
  // Implement these in the host class (typically backed by private fields)
  bool get loading;
  set loading(bool v);
  bool get updating;
  set updating(bool v);
  String? get error;
  set error(String? v);

  // Notify listeners safely (microtask) to avoid build-cycle issues.
  void notifySafe() => Future.microtask(() => notifyListeners());

  void startLoading() {
    this.logd('startLoading');
    loading = true;
    error = null;
    notifySafe();
  }

  void endLoading() {
    this.logd('endLoading');
    loading = false;
    notifySafe();
  }

  void startUpdating() {
    this.logd('startUpdating');
    updating = true;
    error = null;
    notifySafe();
  }

  void endUpdating() {
    this.logd('endUpdating');
    updating = false;
    notifySafe();
  }

  void clearErrorAndNotify() {
    this.logd('clearErrorAndNotify');
    error = null;
    notifySafe();
  }

  /// Set error message and notify listeners safely.
  void setErrorAndNotify(String? message) {
    this.logw('setErrorAndNotify: $message');
    error = message;
    notifySafe();
  }

  /// Wrap an async/sync action with loading lifecycle toggles.
  /// Ensures startLoading() is called before and endLoading() is called after,
  /// even if the action throws. Returns the action's result.
  Future<T> usingLoading<T>(FutureOr<T> Function() action) async {
    this.logd('usingLoading: begin');
    startLoading();
    try {
      return await Future.sync(action);
    } finally {
      this.logd('usingLoading: end');
      endLoading();
    }
  }

  /// Wrap an async/sync action with updating lifecycle toggles.
  /// Ensures startUpdating() is called before and endUpdating() is called after,
  /// even if the action throws. Returns the action's result.
  Future<T> usingUpdating<T>(FutureOr<T> Function() action) async {
    this.logd('usingUpdating: begin');
    startUpdating();
    try {
      return await Future.sync(action);
    } finally {
      this.logd('usingUpdating: end');
      endUpdating();
    }
  }
}
