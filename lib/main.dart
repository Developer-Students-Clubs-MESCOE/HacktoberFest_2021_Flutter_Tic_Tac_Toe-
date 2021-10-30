/*
 * TODO:
 * 1. Create a board.   = DONE
 * 2. Fill the fields on the board. = DONE
 * 3. Changing players.  = DONE
 * 4. Checking winner.  = DONE
 * 5. Checking draw game. = DONE
 * 6. Keep track of player. score. = DONE
 * */

/* 
* Material library is for design purpose.*/

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false, // To remove debug tag.
    home: GameBoard(), // This is constructor.
  ));
}

class Players {
  String? X; //static is used not to change values.
  String? O;
  static String noPlayer = '';

    Players(this.X, this.O);
}

class Utils {
  //converting 2D array to 1D array of widgets
  // Convert List<M> to List<Widget> where M is any type.
  static List<Widget> modelBuilder<M>(
      List<M> models, Widget Function(int index, M model) builder) {
    return models
        .asMap()
        .map<int, Widget>(
            (index, model) => MapEntry(index, builder(index, model)))
        .values
        .toList();
  }
}

class GameBoard extends StatefulWidget {
  @override
  _GameBoardState createState() =>
      _GameBoardState(); //a developer would usualy use _classname_State
}

class _GameBoardState extends State<GameBoard> {
  late List<List<String>> matrix;
  final int matrixSize = 3;
  late String lastMove = Players.noPlayer;
  int playerXScore = 0;
  int playerOScore = 0;
  late Players p;

  @override
  void initState() {
    super.initState();
    p = Players('🍳', '🥚');
    setEmptyFields();
  }

  void setEmptyFields() {
    matrix = List.generate(
        matrixSize,
        (_) => List.generate(
            matrixSize,
            (_) => Players
                .noPlayer)); //passing a funtion in  will tell to fill the class
  }

  @override
  Widget build(BuildContext context) {
    String? nextPlayer = lastMove == p.X ? p.O : p.X;
    return Scaffold(
      backgroundColor: getPlayerColor(nextPlayer!).withAlpha(150),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.9),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: const Offset(0,2)
                        )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children:[
                        Text(
                          "Player ${p.X}",
                          style: TextStyle(color: Colors.black, fontSize: 22),
                        ),
                        Text(
                          " $playerXScore",
                          style: TextStyle(color: Colors.black, fontSize: 22),
                        ),
                      ]
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.9),
                          spreadRadius: 4,
                          blurRadius: 7,
                          offset: const Offset(0,2)
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                        children:[
                          Text(
                            "Player ${p.O}",
                            style: TextStyle(color: Colors.black, fontSize: 22),
                          ),
                          Text(
                            " $playerOScore",
                            style: TextStyle(color: Colors.black, fontSize: 22),
                          ),
                        ]
                    ),
                  ),
                ),
              ],
            )
          ]),
          Column(
            //actually board
            mainAxisAlignment: MainAxisAlignment.center,
            children: Utils.modelBuilder(
              matrix,
              (x, value) => buildRow(x),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: Colors.white
                  )
                ),
                onPressed: (){},
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Text(
                    "Player ${lastMove == p.X ? p.O : p.X}'s Turn",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildRow(int x) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: Utils.modelBuilder(
        matrix[x],
        (y, value) => buildField(x, y),
      ),
    );
  }

  Color getPlayerColor(String player) {
    if (player == p.X)
      return Color(0xfffee440);
    else if (player == p.O)
      return Color(0xffcaf0f8);
    else
      return Colors.white;
  }

  Widget buildField(int x, int y) {
    return Container(
      margin: EdgeInsets.all(5),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size(92, 92),
            primary: getPlayerColor(matrix[x][y]),
          ),
          onPressed: () {
            setField(matrix[x][y], x, y);
          },
          child: Text(
            matrix[x][y],
            style: TextStyle(fontSize: 42),
          )),
    );
  }

  void setField(String value, int x, int y) {
    if (value == Players.noPlayer) {
      final nextPlayer = lastMove == p.X ? p.O : p.X;
      setState(() {
        //Stateful widget will only update if there is setState()
        matrix[x][y] = nextPlayer!;
        lastMove = nextPlayer;
      });
    }
    if (isWinner(x, y)) {
      print("Player $lastMove has won");
      setState(() {
        if (lastMove == p.X)
          playerXScore++;
        else
          playerOScore++;
      });
      showEndDialog("Player $lastMove has won");
    } else if (isDraw()) {
      print("Draw!");
      showEndDialog("Draw!");
    }
  }

  showEndDialog(String message) {
    setEmptyFields();
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
          title: Text(message),
          content: Text("Would you like to play again or reset the score?"),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  playerXScore = 0;
                  playerOScore = 0;
                });

                Navigator.of(context).pop();
              },
              child: Text("Play Again"),
            ),
          ]),
    );
  }

  bool isDraw() {
    return matrix
        .every((row) => row.every((element) => element != Players.noPlayer));
  }

  bool isWinner(int x, int y) {
    final int n = matrixSize;
    final String player = matrix[x][y];

    int row = 0, col = 0, diag = 0, antiDiag = 0;

    for (int i = 0; i < n; i++) {
      if (matrix[x][i] == player) row++;
      if (matrix[i][y] == player) col++;
      if (matrix[i][i] == player) diag++;
      if (matrix[i][n - i - 1] == player) antiDiag++;
    }
    return row == n || col == n || diag == n || antiDiag == n;
  }
}
