import 'package:bandnames_app/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bandnames_app/pages/pages.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SocketService(),
           )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BandNames App',
        initialRoute: 'home',
        routes: {
          'home' : (_) => const HomePage(),
          'status' : (_) => const StatusPage(),
        },
      ),
    );
  }
}