import 'dart:async';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Socket.io Client',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();

    // Server adresi ve portu burada belirtin
    const serverAddress = 'http://192.168.1.57:8080';

    // Socket.io bağlantısını başlat
    socket = IO.io(serverAddress, <String, dynamic>{
      'transports': ['websocket'],
    });

    // Bağlantı başarıyla gerçekleştiğinde
    socket.onConnect((_) {
      print('Connected with Socket.io');

      // Belirli bir aralıkta veri gönderme
      Timer.periodic(Duration(seconds: 5), (timer) {
        var endpoint = '/api/v1/time';
        print('Sending... $endpoint');
        socket.emit('get', endpoint);
      });
    });

    // Belirli bir endpoint üzerinden gelen veri
    socket.on('/api/v1/time', (data) {
      print('Received Data: $data');
    });

    // Genel mesaj alma
    socket.on('message', (data) {
      print('Received Message: $data');
    });

    // Bağlantı kopunca
    socket.onDisconnect((_) => print('Disconnected'));

    // Hata durumunda
    socket.onError((error) => print('Error: $error'));
  }

  @override
  void dispose() {
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socket.io Client'),
      ),
      body: Center(
        child: Text('Socket.io Client is running...'),
      ),
    );
  }
}
