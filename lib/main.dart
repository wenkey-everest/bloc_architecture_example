import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_list/app.dart';
import 'package:infinite_list/simple_bloc_observer.dart';

void main() {
  BlocOverrides.runZoned(() => runApp(const App()),
      blocObserver: SimpleBlocObserver());
}
