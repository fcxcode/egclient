import 'dart:io';
import 'dart:convert';

import 'package:egclient/client/zone.dart';
import 'package:egclient/client/arena.dart';
import 'package:egclient/client/chat.dart';
import 'package:egclient/client/shell.dart';

export 'package:egclient/client/arena.dart';
export 'package:egclient/client/chat.dart';
export 'package:egclient/client/shell.dart';

class EGClient {
  EGClientConfig _config;

  final String host;
  final int port;
  final String username;
  final String password;
  final Zone _zone;

  Arena _arena;
  Arena get arena => _arena;
  Chat _chat;
  Chat get chat => _chat;
  Shell _shell;
  Shell get shell => _shell;

  EGClient(this.host, this.port, this.username, this.password)
      : _zone = Zone() {
    _zone.host = host;
    _zone.port = port;
    _zone.username = username;
    _zone.password = password;

    _arena = Arena(_zone);
    _chat = Chat(_zone);
    _shell = Shell(_zone);

    _zone.onConnected.listen((event) {
      _arena.enter();
    });
    _zone.onDisconnected.listen((event) {});
  }

  void run() async {
    _zone.run();
  }

  void stop() {
    _zone.stop();
  }
}

class EGClientConfig {
  final String serverHost;

  EGClientConfig(this.serverHost);

  EGClientConfig.fromJson(Map<String, dynamic> json)
      : serverHost = json['serverHost'];

  Map<String, dynamic> toJson() {
    return {'serverHost': serverHost};
  }
}
