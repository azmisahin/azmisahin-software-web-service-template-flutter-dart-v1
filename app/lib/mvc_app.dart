import 'package:flutter/material.dart';
import 'socket_service.dart';
import 'socket_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = SocketService();

    // SocketView'ı SocketService ile başlat
    final socketView = SocketView(socketService);

    return MaterialApp(
      title: 'Client',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Client'),
        ),
        body: socketView,
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}
