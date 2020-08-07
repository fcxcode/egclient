part of 'chat.dart';

class Message {
  final MessageType messageType;
  final SoundType soundType;
  final int playerId;
  final String author;
  final String text;

  Message(
      this.messageType, this.soundType, this.playerId, this.author, this.text);
  Message.fromJson(Map<String, dynamic> json)
      : messageType = MessageType.values[json['messageType']],
        soundType = SoundType.values[json['soundType']],
        playerId = json['playerId'],
        author = json['author'],
        text = json['text'];

  Map<String, dynamic> toJson() {
    return {
      'messageType': messageType.index,
      'soundType': soundType.index,
      'playerId': playerId,
      'author': author,
      'text': text
    };
  }
}

enum MessageType {
  broadcast,
  publicMacro,
  public,
  team,
  teamRemote,
  private,
  server,
  privateRemote,
  warning,
  channel
}

enum SoundType {
  none, // 0  = Silence
  bassBeep, // 1  = BEEP!
  trebleBeep, // 2  = BEEP!
  att, // 3  = You're not dealing with AT&T
  aiscretion, // 4  = Due to some violent content, parental discretion is advised
  hallellula, // 5  = Hallellula
  reagan, // 6  = Ronald Reagan
  inconceivable, // 7  = Inconceivable
  churchill, // 8  = Winston Churchill
  snotLicker, // 9  = Listen to me, you pebble farting snot licker
  crying, // 10 = Crying
  burp, // 11 = Burp
  girl, // 12 = Girl
  scream, // 13 = Scream
  fart, // 14 = Fart1
  fart2, // 15 = Fart2
  phone, // 16 = Phone ring
  worldUnderAttack, // 17 = The world is under attack at this very moment
  gibberish, // 18 = Gibberish
  ooooo, // 19 = Ooooo
  geeee, // 20 = Geeee
  ohhhh, // 21 = Ohhhh
  ahhhh, // 22 = Awwww
  thisGameSucks, // 23 = This game sucks
  sheep, // 24 = Sheep
  cantLogIn, // 25 = I can't log in!
  messageAlarm, // 26 = Beep
  startMusic, // 100= Start music playing
  stopMusic, // 101= Stop music
  playOnce, // 102= Play music for 1 iteration then stop
  victoryBell, // 103= Victory bell
  goal, // 104= Goal!
}
