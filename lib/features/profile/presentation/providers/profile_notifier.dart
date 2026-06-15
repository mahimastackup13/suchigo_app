import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:suchigo_app/core/errors/result.dart';
import 'package:suchigo_app/features/profile/presentation/providers/profile_providers.dart';
import 'package:suchigo_app/features/profile/presentation/states/profile_state.dart';
import 'package:suchigo_app/features/profile/data/models/profile_model.dart';

part 'profile_notifier.g.dart';

@riverpod
class ProfileNotifier extends _$ProfileNotifier {
  @override
  ProfileState build() {
    // Fire and forget load on build
    Future.microtask(() => loadProfile());
    return const ProfileLoading();
  }

  Future<void> loadProfile({bool forceRefresh = false}) async {
    state = const ProfileLoading();
    final repository = ref.read(profileRepositoryProvider);
    final result = await repository.getProfile(forceRefresh: forceRefresh);

    if (result is Success<ProfileModel>) {
      // If we forced refresh, we know it's not from fallback unless remote failed.
      // The repository returns remoteResult if success. 
      state = ProfileLoaded(profile: result.data);
    } else {
      state = ProfileError((result as Failure).error);
    }
  }
}
