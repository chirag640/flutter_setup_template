import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:setup/core/providers/base_provider.dart';

class _TestNotifier extends StateNotifier<SimpleBaseState>
    with BaseNotifierMixin<SimpleBaseState> {
  _TestNotifier() : super(const SimpleBaseState());

  Future<int> performLoad(int value) => usingLoading(() async => value);

  Future<void> performUpdate() => usingUpdating(() async {});
}

void main() {
  test('BaseNotifierMixin toggles loading and updating flags', () async {
    final notifier = _TestNotifier();

    expect(notifier.state.loading, isFalse);
    expect(notifier.state.updating, isFalse);

    final result = await notifier.performLoad(42);
    expect(result, 42);
    expect(notifier.state.loading, isFalse);

    await notifier.performUpdate();
    expect(notifier.state.updating, isFalse);

    notifier.startLoading();
    expect(notifier.state.loading, isTrue);

    notifier.setErrorAndNotify('oops');
    expect(notifier.state.error, 'oops');

    notifier.clearErrorAndNotify();
    expect(notifier.state.error, isNull);
  });

  test('baseNotifierProvider exposes default status state', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final state = container.read(baseNotifierProvider);
    expect(state.loading, isFalse);
    expect(state.updating, isFalse);
  });
}
