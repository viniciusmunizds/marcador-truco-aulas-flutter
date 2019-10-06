import 'package:flutter/material.dart';
import 'package:marcador_truco/models/player.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _playerOne = Player(name: "Nós", score: 0, victories: 0);
  var _playerTwo = Player(name: "Eles", score: 0, victories: 0);
  TextEditingController _renameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _resetPlayers();
  }

  void _resetPlayer({Player player, bool resetVictories = true}) {
    setState(() {
      player.score = 0;
      if (resetVictories) player.victories = 0;
    });
  }

  void _resetPlayers({bool resetVictories = true}) {
    _resetPlayer(player: _playerOne, resetVictories: resetVictories);
    _resetPlayer(player: _playerTwo, resetVictories: resetVictories);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text("Marcador Pontos (Truco!)"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _showDialog2(
                  title: 'Zerar pontuação',
                  message:
                      'Tem certeza que deseja zerar a pontuação?',
                  confirm: () {
                    _showDialog3(
                      title: 'Zerar',
                      message: 'Deseja zerar tudo ou apenas a partida atual?',
                      confirm: () {
                        _resetPlayers(resetVictories: true);
                      },
                      cancel: () {
                        _resetPlayers(resetVictories: false);
                      },
                    );
                  });
            },
            icon: Icon(Icons.refresh),
          )
        ],
      ),
      body: Container(padding: EdgeInsets.all(20.0), child: _showPlayers()),
    );
  }

  Widget _showPlayerBoard(Player player) {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _showPlayerName(player),
          _showPlayerScore(player.score),
          _showPlayerVictories(player.victories),
          _showScoreButtons(player),
        ],
      ),
    );
  }

  Widget _showPlayers() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _showPlayerBoard(_playerOne),
        _showPlayerBoard(_playerTwo),
      ],
    );
  }

  Widget _showPlayerName(Player player) {
    return GestureDetector(
      onTap: () {
        return showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text('Nome do Jogador'),
                content: TextField(
                  controller: _renameController,
                  decoration: InputDecoration(hintText: "Escreva o nome aqui"),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: new Text('CANCEL'),
                    onPressed: () {
                      _renameController.clear();
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      setState(() {
                        if (_renameController.text != "") {
                          player.name = _renameController.text;
                          _renameController.clear();
                        }
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            });
      },
      child: Text(
        player.name.toUpperCase(),
        style: TextStyle(
            fontSize: 22.0, fontWeight: FontWeight.w500, color: Colors.cyan),
      ),
    );
  }

  Widget _showPlayerVictories(int victories) {
    return Text(
      "vitórias ( $victories )",
      style: TextStyle(fontWeight: FontWeight.w300),
    );
  }

  Widget _showPlayerScore(int score) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 52.0),
      child: Text(
        "$score",
        style: TextStyle(fontSize: 120.0),
      ),
    );
  }

  Widget _buildRoundedButton(
      {String text, double size = 52.0, Color color, Function onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: Container(
          color: color,
          height: size,
          width: size,
          child: Center(
              child: Text(
            text,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

  Widget _showScoreButtons(Player player) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _buildRoundedButton(
          text: '-1',
          color: Colors.black.withOpacity(0.1),
          onTap: () {
            setState(() {
              if (player.score > 0) player.score--;
            });
          },
        ),
        _buildRoundedButton(
          text: '+1',
          color: Colors.cyan,
          onTap: () {
            setState(() {
              if (player.score < 12) player.score++;
              if (_playerOne.score == 11 && _playerTwo.score == 11) {
                _showDialog1(
                  title: 'Mão de ferro',
                  message:
                      'Quando as duas duplas conseguem chegar a 11 pontos na partida. Todos os jogadores recebem as cartas “cobertas”, isto é, viradas para baixo, e deverão jogar assim. Quem vencer a mão, vence a partida.',
                );
              }
            });

            if (player.score == 12) {
              _showDialog2(
                  title: 'Fim do jogo',
                  message: '${player.name} ganhou!',
                  confirm: () {
                    setState(() {
                      player.victories++;
                    });
                    _resetPlayers(resetVictories: false);
                  },
                  cancel: () {
                    setState(() {
                      player.score--;
                    });
                  });
            }
          },
        ),
      ],
    );
  }

  void _showDialog1(
      {String title, String message, Function confirm, Function cancel}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                if (confirm != null) confirm();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog2(
      {String title, String message, Function confirm, Function cancel}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop();
                if (cancel != null) cancel();
              },
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                if (confirm != null) confirm();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialog3(
      {String title, String message, Function confirm, Function cancel}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text("PARTIDA ATUAL"),
              onPressed: () {
                Navigator.of(context).pop();
                if (cancel != null) cancel();
              },
            ),
            FlatButton(
              child: Text("TUDO"),
              onPressed: () {
                Navigator.of(context).pop();
                if (confirm != null) confirm();
              },
            ),
          ],
        );
      },
    );
  }
}
