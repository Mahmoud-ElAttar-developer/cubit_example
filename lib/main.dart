import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

List<dynamic> names = ['Foo', 'Bar', 'Baz'];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);
  void pickRandomName() => emit(names.getRandomElement());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NamesCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = NamesCubit();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Home Page')),
      body: StreamBuilder<String?>(
        stream: cubit.stream,
        builder: (context, snapshot) {
          final button = TextButton(
            onPressed: () => cubit.pickRandomName(),
            child: const Text('Pick a random name', style: TextStyle(color: Colors.blue)),
          );
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return button;
            case ConnectionState.waiting:
              return button;
            case ConnectionState.active:
            return Column(
              children: [
                button,
                const Divider(),
                Text(snapshot.data ?? 'No name picked yet'),
              ],
            );
            case ConnectionState.done:
            return SizedBox(
              width: double.infinity,
              child: Center(
                child: Text(snapshot.data ?? 'No name picked yet'),
              ),
            );
          }
        },
      ), // StreamBuilder
    );
  }
}
