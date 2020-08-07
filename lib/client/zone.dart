import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:egclient/client/packets/packets.dart';

class Zone {
  String host;
  int port;
  String username;
  String password;

  Socket _socket;
  bool autoReconnect = true;

  bool _isRunning = false;
  bool _isStopping = false;
  int _lastConnect = 0;
  bool _isConnected = false;
  bool get isConnected => _isConnected;

  int _lastSyncRequest;
  int _lastSyncResponse;

  int _tick;
  int get tick => _tick;

  final Stopwatch _stopwatch = Stopwatch();
  int get elapsed => _stopwatch.elapsedMilliseconds;

  final StreamController<int> _onTick = StreamController<int>.broadcast();
  Stream<int> get onTick => _onTick.stream;

  final StreamController<void> _onConnected =
      StreamController<void>.broadcast();
  Stream<void> get onConnected => _onConnected.stream;

  final StreamController<void> _onDisconnected =
      StreamController<void>.broadcast();
  Stream<void> get onDisconnected => _onDisconnected.stream;

  final StreamController<Packet> _onPacket =
      StreamController<Packet>.broadcast();
  Stream<Packet> get onPacket => _onPacket.stream;

  Zone();

  void run() {
    if (!_isRunning) {
      _isRunning = true;
      _isStopping = false;
      _lastConnect = 0;
      _isConnected = false;

      _tick = 0;
      _stopwatch.reset();
      _stopwatch.start();
      Timer.periodic(Duration(milliseconds: 10), (timer) {
        _tick++;
        if (_isStopping) {
          timer.cancel();
          _disconnect();
          _isRunning = false;
        } else {
          if (_isConnected) {
            if (_lastSyncRequest == 0 || tick - _lastSyncRequest >= 1000) {
              _lastSyncRequest = tick;
              var syncRequest = SyncRequest(tick);
              send(syncRequest.toPacket());
            } else if (_lastSyncResponse != 0 &&
                tick - _lastSyncResponse >= 1000 * 3) {
              _disconnect();
            }
          } else {
            if (_lastConnect == 0 || tick - _lastConnect >= 2000) {
              if (_lastConnect == 0 || autoReconnect) {
                print('Connecting...');
                _connect();
              } else {
                stop();
              }
              _lastConnect = tick;
            }
          }
          _onTick.add(tick);
        }
      });
    }
  }

  void stop() async {
    if (!_isStopping) {
      _isStopping = true;
      while (_isRunning) {
        await Future.delayed(Duration(milliseconds: 10));
      }
      _stopwatch.stop();
    }
  }

  void _connect() async {
    if (_socket == null) {
      _isConnected = false;
      _lastSyncRequest = 0;
      _lastSyncResponse = 0;

      try {
        _socket = await Socket.connect('egclient.jyuw.xyz', 7905);
      } catch (ex) {
        print('Connect error: ${ex}');
        return;
      }

      _socket.listen((data) {
        var values = String.fromCharCodes(data);
        for (var value in values.split('\n')) {
          if (value.isNotEmpty) {
            var packet = Packet.fromJson(json.decode(value));
            _handleReceived(packet);
          }
        }
      }, onDone: () {
        print('Connection closed');
        _disconnect();
      }, onError: (error) {
        print('Connection error: $error');
        _disconnect();
      });
      var initRequest = InitRequest(host, port, username, password);
      send(initRequest.toPacket());
    }
  }

  void _disconnect() {
    if (_socket != null) {
      _socket.close();
      _socket.destroy();
      _socket = null;
      _isConnected = false;
      _onDisconnected.add(null);
    }
  }

  void _handleReceived(Packet packet) async {
    print('HandleReceived: ${packet.type}');
    if (!_isConnected) {
      if (packet.type == PacketType.initResponse) {
        var initResponse = InitResponse.fromPacket(packet);
        if (initResponse.isSuccess) {
          _isConnected = true;
          _onConnected.add(null);
        } else {
          print('Connection failed: ${initResponse.information}');
          _disconnect();
          await stop();
        }
      }
    } else {
      if (packet.type == PacketType.syncResponse) {
        //var syncResponse = SyncResponse.fromPacket(packet);
        _lastSyncResponse = tick;
      } else if (packet.type == PacketType.disconnect) {
        print('PacketType.disconnect');
        //var disconnect = Disconnect.fromPacket(packet);
        _disconnect();
      }

      _onPacket.add(packet);
    }
  }

  void send(Packet packet) {
    if (_socket != null) {
      var value = json.encode(packet.toJson());
      _socket.writeln(value);
    }
  }
}
