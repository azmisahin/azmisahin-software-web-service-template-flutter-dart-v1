import 'package:flutter/material.dart';
import 'socket_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SocketService socketService = SocketService();
  int durationTime = 5;
  final ScrollController _menuScrollController = ScrollController();
  final ScrollController _bodyScrollController = ScrollController();

  void decreaseDuration() {
    setState(() {
      durationTime = durationTime > 1 ? durationTime - 1 : 1;
    });
    socketService.decreaseDuration();
  }

  void increaseDuration() {
    setState(() {
      durationTime += 1;
    });
    socketService.increaseDuration();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service'),
        actions: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: decreaseDuration,
          ),
          Text(
            '$durationTime', 
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: increaseDuration,
          ),
        ],
      ),
      drawer: Drawer(
        child: StreamBuilder<List<String>>(
          stream: socketService.logsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                // Scroll
                _menuScrollController.animateTo(
                  _menuScrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              });
              return ListView.builder(
                controller: _menuScrollController,
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: index % 2 == 0 ? Colors.grey[200] : Colors.white,
                    child: ListTile(
                      title: Text(
                        snapshot.data![index],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      body: StreamBuilder<List<String>>(
        stream: socketService.logsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final lastLog = snapshot.data!.last;
            return Center(
              child: Text(
                lastLog,
                style: TextStyle(fontSize: 20),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    socketService.initSocket();
  }

  @override
  void dispose() {
    socketService.dispose();
    _menuScrollController.dispose();
    _bodyScrollController.dispose();
    super.dispose();
  }
}
