import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'blocs/theme/theme_bloc.dart';
import 'blocs/theme/theme_event.dart';
import 'blocs/theme/theme_state.dart';
import 'constants/app_colors.dart';
import 'services/storage_service.dart';
import 'utils/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final storageService = StorageService();
    return MultiBlocProvider(
      providers:[
         BlocProvider(
          create: (context) => ThemeBloc(storageService)..add(LoadThemeEvent()),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light,
                ),
              ),
              scaffoldBackgroundColor: AppColors.background,
              canvasColor: AppColors.background,
              fontFamily: "SF PRO DISPLAY",
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              appBarTheme: const AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.light,
                  statusBarBrightness: Brightness.dark,
                ),
              ),
              scaffoldBackgroundColor: AppColors.background,
              canvasColor: AppColors.background,
              fontFamily: "SF PRO DISPLAY",
              brightness: Brightness.dark,
            ),
            themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: AppRouter.map,
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
