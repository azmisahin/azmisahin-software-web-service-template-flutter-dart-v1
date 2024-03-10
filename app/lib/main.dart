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
  final ScrollController _scrollController = ScrollController();

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
            '$durationTime', // Duration göster
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: increaseDuration,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: StreamBuilder<List<String>>(
                stream: socketService.logsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    WidgetsBinding.instance?.addPostFrameCallback((_) {
                      // Scrool
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    });
                    return ListView.builder(
                      reverse: true,
                      controller: _scrollController,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            snapshot.data![index],
                            style: TextStyle(fontSize: 16),
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
          ),
        ],
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
    super.dispose();
  }
}
