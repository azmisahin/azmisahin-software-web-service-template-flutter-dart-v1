import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService extends ChangeNotifier {
  late IO.Socket socket;
  List<String> logs = [];

  String status = "Connecting...";

  SocketService() {
    initSocket();
  }

  void initSocket() {
    const serverAddress = 'http://127.0.0.1:8080';
    socket = IO.io(serverAddress, <String, dynamic>{
      'transports': ['websocket']
    });

    socket.onConnect((_) {
      status = "Client connected!";
      Timer.periodic(const Duration(seconds: 5), (timer) {
        var endpoint = '/api/v1/time';
        socket.emit('get', endpoint);
      });
    });

    socket.on('/api/v1/time', (data) {
      String currentTime = data["current_time"];
      logs.add(currentTime);
      notifyListeners();
    });

    socket.on('message', (data) {
      notifyListeners();
    });

    socket.onDisconnect((_) {
      notifyListeners();
    });

    socket.onError((error) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    super.dispose();
    socket.dispose();
  }
}
