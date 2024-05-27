import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'theme_event.dart';

ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ThemeData.light().colorScheme,
);

ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ThemeData.dark().colorScheme,
);

class ThemeBloc extends Bloc<ThemeEvent, ThemeMode> {
  ThemeBloc() : super(ThemeMode.light) {
    on<ThemeChange>((event, emit) {
      emit (event.isDark? ThemeMode.dark: ThemeMode.light);
    });
  }
}
