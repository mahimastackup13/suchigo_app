import 'package:suchigo_app/core/errors/app_error.dart';
import 'package:suchigo_app/features/home/data/models/home_model.dart';

sealed class HomeState {
  const HomeState();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final HomeModel data;
  const HomeLoaded(this.data);
}

class HomeError extends HomeState {
  final AppError error;
  const HomeError(this.error);
}
