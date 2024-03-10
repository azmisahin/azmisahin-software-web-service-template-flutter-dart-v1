import 'package:flutter/material.dart';
import 'socket_service.dart';

class SocketView extends StatefulWidget {
  final SocketService socketService;

  const SocketView(this.socketService, {super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SocketViewState createState() => _SocketViewState();
}

class _SocketViewState extends State<SocketView> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.socketService.logs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(widget.socketService.logs[index]),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.socketService.status),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    widget.socketService.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    widget.socketService.dispose();
    super.dispose();
  }
}
