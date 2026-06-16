import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/features/home/data/models/home_model.dart';
import 'package:suchigo_app/features/home/presentation/providers/home_providers.dart';
import 'package:suchigo_app/features/home/presentation/states/home_state.dart';

part 'home_notifier.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  HomeState build() {
    Future.microtask(loadHome);
    return const HomeLoading();
  }

  Future<void> loadHome() async {
    state = const HomeLoading();
    final result = await ref.read(homeRepositoryProvider).getHomeData();
    state = switch (result) {
      Success(:final data) => HomeLoaded(data),
      Failure(:final error) => HomeError(error),
    };
  }
}
