import 'dart:async';
import 'dart:collection';

import 'package:egclient/client/packets/packets.dart';
import 'package:egclient/client/zone.dart';
import 'package:egclient/client/chat.dart';

part 'shell_data.dart';

class Shell {
  final Zone _zone;

  final Queue<ShellModule> _modules = Queue<ShellModule>();

  Shell(this._zone) {
    _zone.onConnected.listen(_handleOnConnected);
    _zone.onPacket.listen(_handleOnPacket);
  }

  void _handleOnConnected(_) {
    while (_modules.isNotEmpty) {
      var module = _modules.removeFirst();
      var shellRegister = ShellRegister(module);
      _zone.send(shellRegister.toPacket());
    }
  }

  void _handleOnPacket(Packet packet) {
    if (packet.type == PacketType.shellOnEvent) {
      var shellOnEvent = ShellOnEvent.fromPacket(packet);
      _eventsMap[shellOnEvent.commandId].add(shellOnEvent.event);
    }
  }

  void register(ShellModule module) {
    if (_zone.isConnected) {
      var shellRegister = ShellRegister(module);
      _zone.send(shellRegister.toPacket());
    } else {
      _modules.add(module);
    }
  }
}
