import 'package:flutter/material.dart';
import 'package:final_portfolio/bloc/theme_bloc.dart';
import 'package:final_portfolio/presentation/screens/home_page.dart';
import 'package:provider/provider.dart';
import 'package:final_portfolio/providers/weather_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentWeather()),
        ChangeNotifierProvider(create: (_) => FiveDaysWeather()),
      ],
      child: BlocProvider<ThemeBloc>(
        create: (context) => ThemeBloc(),
        child: BlocBuilder<ThemeBloc, ThemeMode>(
          builder: (context, state) {
            return MaterialApp(
              title: 'Weather',
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: state,
              debugShowCheckedModeBanner: false,
              home: HomePage(),
            );
          },
        ),
      ),
    );
  }
}
