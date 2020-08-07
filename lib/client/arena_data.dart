part of 'arena.dart';

class Player {
  final int playerId;

  final String name;
  final String nameLowerCase;
  final String squad;

  Team _team;
  Team get team => _team;

  Team _teamOld;
  Team get teamOld => _teamOld;

  bool get isInArena => _team != null;

  Player(this.playerId, this.name, this.squad)
      : nameLowerCase = name.toLowerCase();
}

class Team {
  final int teamId;
  final List<Player> _players = <Player>[];
  List<Player> get players => List.unmodifiable(_players);

  Team(this.teamId);
}
