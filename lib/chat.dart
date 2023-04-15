// ignore_for_file: must_be_immutable, non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';

class Chat extends StatefulWidget {
  Device connected_device;
  NearbyService nearbyService;
  var chat_state;

  Chat({Key? key, required this.connected_device, required this.nearbyService})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _Chat();
}

class _Chat extends State<Chat> {
  late StreamSubscription subscription;
  late StreamSubscription receivedDataSubscription;
  List<ChatMessage> messages = [];
  final myController = TextEditingController();
  void addMessgeToList(ChatMessage obj) {
    setState(() {
      messages.insert(0, obj);
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    receivedDataSubscription.cancel();
  }

  void init() {
    receivedDataSubscription =
        widget.nearbyService.dataReceivedSubscription(callback: (data) {
      var obj =
          ChatMessage(messageContent: data["message"], messageType: "receiver");
      addMessgeToList(obj);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0021F3),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              widget.connected_device.deviceName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            const Text(
              "connected",
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: Stack(
          children: <Widget>[
            ListView.builder(
              itemCount: messages.length,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 14,
                    top: 10,
                    bottom: 10,
                  ),
                  child: Align(
                    alignment: (messages[index].messageType == "receiver"
                        ? Alignment.topLeft
                        : Alignment.topRight),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (messages[index].messageType == "receiver"
                            ? Colors.grey.shade200
                            : Colors.blue.shade100),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        messages[index].messageContent,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1.0,
                    ),
                  ),
                ),
                height: 60,
                width: double.infinity,
                child: Row(
                  textDirection: TextDirection.rtl,
                  children: <Widget>[
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextField(
                        // textDirection: TextDirection.rtl,
                        decoration: const InputDecoration(
                          // hintTextDirection: TextDirection.rtl,
                          hintText: "Type your message here ...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none,
                        ),
                        controller: myController,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        if (widget.connected_device.state ==
                            SessionState.notConnected) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("disconnected"),
                            backgroundColor: Colors.red,
                          ));
                          return;
                        }

                        widget.nearbyService.sendMessage(
                            widget.connected_device.deviceId,
                            myController.text);
                        var obj = ChatMessage(
                            messageContent: myController.text,
                            messageType: "sender");

                        addMessgeToList(obj);
                        myController.text = "";
                      },
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                      backgroundColor: const Color(0xFF0021F3),
                      elevation: 0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}
