part of packets;

enum PacketType {
  none,
  disconnect,
  initRequest,
  initResponse,
  syncRequest,
  syncResponse,
  chatMessageIn,
  chatMessageOut,
  shellRegister,
  shellOnEvent,
  arenaEnter,
  arenaEntering,
  arenaEntered,
  playerEnter,
  playerLeave,
  playerTarget,
}

class Packet {
  static final String version = '1.0';
  final PacketType type;
  Map<String, dynamic> _json;

  Packet(this.type) {
    _json = <String, dynamic>{};
  }

  Packet.fromJson(Map<String, dynamic> json)
      : type = PacketType.values[json['type']] {
    _json = json;
  }

  Map<String, dynamic> toJson() {
    _json['type'] = type.index;
    return _json;
  }
}

class Disconnect {
  Disconnect();
  Disconnect.fromPacket(Packet packet);

  Packet toPacket() {
    var packet = Packet(PacketType.disconnect);
    return packet;
  }
}

class InitRequest {
  final String host;
  final int port;
  final String username;
  final String password;
  final String version;

  InitRequest(this.host, this.port, this.username, this.password)
      : version = Packet.version;

  InitRequest.fromPacket(Packet packet)
      : host = packet._json['host'],
        port = packet._json['port'],
        username = packet._json['username'],
        password = packet._json['password'],
        version = packet._json['version'];

  Packet toPacket() {
    var packet = Packet(PacketType.initRequest);
    packet._json.addAll({
      'host': host,
      'port': port,
      'username': username,
      'password': password,
      'version': version
    });
    return packet;
  }
}

class InitResponse {
  final bool isSuccess;
  final String information;

  InitResponse(this.isSuccess, [this.information]);
  InitResponse.fromPacket(Packet packet)
      : isSuccess = packet._json['isSuccess'],
        information = packet._json['information'];

  Packet toPacket() {
    var packet = Packet(PacketType.initResponse);
    packet._json.addAll({'isSuccess': isSuccess, 'information': information});
    return packet;
  }
}

class SyncRequest {
  final int timestamp;

  SyncRequest(this.timestamp);
  SyncRequest.fromPacket(Packet packet) : timestamp = packet._json['timestamp'];

  Packet toPacket() {
    var packet = Packet(PacketType.syncRequest);
    packet._json.addAll({'timestamp': timestamp});
    return packet;
  }
}

class SyncResponse {
  final int timestamp;

  SyncResponse(this.timestamp);
  SyncResponse.fromPacket(Packet packet)
      : timestamp = packet._json['timestamp'];

  Packet toPacket() {
    var packet = Packet(PacketType.syncResponse);
    packet._json.addAll({'timestamp': timestamp});
    return packet;
  }
}

class ArenaEnter {
  final String name;

  ArenaEnter(this.name);
  ArenaEnter.fromPacket(Packet packet) : name = packet._json['name'];

  Packet toPacket() {
    var packet = Packet(PacketType.arenaEnter);
    packet._json.addAll({'name': name});
    return packet;
  }
}

class ArenaEntering {
  final int playerId;

  ArenaEntering(this.playerId);
  ArenaEntering.fromPacket(Packet packet) : playerId = packet._json['playerId'];

  Packet toPacket() {
    var packet = Packet(PacketType.arenaEntering);
    packet._json.addAll({'playerId': playerId});
    return packet;
  }
}

class ArenaEntered {
  ArenaEntered();
  ArenaEntered.fromPacket(Packet packet);

  Packet toPacket() {
    var packet = Packet(PacketType.arenaEntered);
    return packet;
  }
}

class ChatMessageIn {
  final Message message;

  ChatMessageIn(this.message);
  ChatMessageIn.fromPacket(Packet packet)
      : message = Message.fromJson(packet._json['message']);

  Packet toPacket() {
    var packet = Packet(PacketType.chatMessageIn);
    packet._json.addAll({'message': message.toJson()});
    return packet;
  }
}

class ChatMessageOut {
  final int soundTypeId;
  final int playerId;
  final String text;

  ChatMessageOut(this.soundTypeId, this.playerId, this.text);
  ChatMessageOut.fromPacket(Packet packet)
      : soundTypeId = packet._json['soundTypeId'],
        playerId = packet._json['playerId'],
        text = packet._json['text'];

  Packet toPacket() {
    var packet = Packet(PacketType.chatMessageOut);
    packet._json.addAll(
        {'soundTypeId': soundTypeId, 'playerId': playerId, 'text': text});
    return packet;
  }
}

class ShellRegister {
  final ShellModule module;

  ShellRegister(this.module);
  ShellRegister.fromPacket(Packet packet)
      : module = ShellModule.fromJson(packet._json['module']);

  Packet toPacket() {
    var packet = Packet(PacketType.shellRegister);
    packet._json.addAll({'module': module.toJson()});
    return packet;
  }
}

class ShellOnEvent {
  final String commandId;
  final ShellEvent event;

  ShellOnEvent(this.commandId, this.event);
  ShellOnEvent.fromPacket(Packet packet)
      : commandId = packet._json['commandId'],
        event = ShellEvent.fromJson(packet._json['event']);

  Packet toPacket() {
    var packet = Packet(PacketType.shellOnEvent);
    packet._json.addAll({
      'commandId': commandId,
      'event': event.toJson(),
    });
    return packet;
  }
}

class PlayerEnter {
  final int playerId;
  final int teamId;
  final String name;
  final String squad;

  PlayerEnter(this.playerId, this.teamId, this.name, this.squad);
  PlayerEnter.fromPacket(Packet packet)
      : playerId = packet._json['playerId'],
        teamId = packet._json['teamId'],
        name = packet._json['name'],
        squad = packet._json['squad'];

  Packet toPacket() {
    var packet = Packet(PacketType.playerEnter);
    packet._json.addAll(
        {'playerId': playerId, 'teamId': teamId, 'name': name, 'squad': squad});
    return packet;
  }
}

class PlayerLeave {
  final int playerId;

  PlayerLeave(this.playerId);
  PlayerLeave.fromPacket(Packet packet) : playerId = packet._json['playerId'];

  Packet toPacket() {
    var packet = Packet(PacketType.playerLeave);
    packet._json.addAll({'playerId': playerId});
    return packet;
  }
}

class PlayerTarget {
  final int playerId;

  PlayerTarget(this.playerId);
  PlayerTarget.fromPacket(Packet packet) : playerId = packet._json['playerId'];

  Packet toPacket() {
    var packet = Packet(PacketType.playerTarget);
    packet._json.addAll({'playerId': playerId});
    return packet;
  }
}
