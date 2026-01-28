// Theme States
sealed class ThemeState {
  final bool isDarkMode;
  const ThemeState(this.isDarkMode);
}

class ThemeInitial extends ThemeState {
  const ThemeInitial() : super(false);
}

class ThemeLoaded extends ThemeState {
  const ThemeLoaded(super.isDarkMode);
}
