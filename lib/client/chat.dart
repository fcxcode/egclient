import 'dart:async';

import 'package:egclient/client/packets/packets.dart';
import 'package:egclient/client/zone.dart';
import 'package:egclient/client/arena.dart';

part 'chat_data.dart';

class Chat {
  final Zone _zone;

  final StreamController<Message> _onMessage =
      StreamController<Message>.broadcast();
  Stream<Message> get onMessage => _onMessage.stream;

  Chat(this._zone) {
    _zone.onPacket.listen((packet) {
      if (packet.type == PacketType.chatMessageIn) {
        var chatMessageIn = ChatMessageIn.fromPacket(packet);
        _onMessage.add(chatMessageIn.message);
      }
    });
  }

  void reply(Message message, String text,
      [SoundType soundType = SoundType.none]) {
    if (message.playerId != 0xFFFF) {
      send('/$text', playerId: message.playerId, soundType: soundType);
    } else {
      send(':${message.author}:${text}',
          playerId: 0xFFFF, soundType: soundType);
    }
  }

  void replyMany(Message message, List<String> lines,
          [SoundType soundType = SoundType.none]) =>
      lines.forEach((text) {
        reply(message, text, soundType);
      });

  void send(String text,
      {int playerId = 0xFFFF, SoundType soundType = SoundType.none}) {
    var chatMessageOut = ChatMessageOut(soundType.index, playerId, text);
    _zone.send(chatMessageOut.toPacket());
  }

  void sendMany(List<String> lines,
          {int playerId = 0xFFFF, SoundType soundType = SoundType.none}) =>
      lines.forEach((text) {
        send(text, playerId: playerId, soundType: soundType);
      });
}
