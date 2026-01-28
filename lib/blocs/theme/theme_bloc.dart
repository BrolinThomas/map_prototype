import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/storage_service.dart';
import 'theme_event.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final StorageService _storageService;

  ThemeBloc(this._storageService) : super(const ThemeInitial()) {
    on<LoadThemeEvent>(_onLoadTheme);
    on<ToggleThemeEvent>(_onToggleTheme);
  }

  Future<void> _onLoadTheme(
    LoadThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final isDark = await _storageService.getThemeMode();
    emit(ThemeLoaded(isDark));
  }

  Future<void> _onToggleTheme(
    ToggleThemeEvent event,
    Emitter<ThemeState> emit,
  ) async {
    final newMode = !state.isDarkMode;
    await _storageService.saveThemeMode(newMode);
    emit(ThemeLoaded(newMode));
  }
}
