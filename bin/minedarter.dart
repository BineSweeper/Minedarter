import 'dart:io';

import 'package:minedarter/game.dart';

void main(List<String> arguments) {
  while (true) {
    print("\u{001B}[2J");
    print("Welcome to Mineswifter!");
    print("If you want to exit, type 'exit' at any point of time.");
    print("Please enter the level (default is easy): (easy, medium, hard, custom)");
    print("  Easy   - 9x9 board with 10 mines");
    print("  Medium - 16x16 board with 40 mines");
    print("  Hard   - 30x16 board with 99 mines");
    print("  Custom - You specify the board size and mine count");
    var level = stdin.readLineSync()?.toLowerCase();
    var width = 9;
    var height = 9;
    var mineCount = 10;
    if (level == "exit") {
      return;
    } else if (level == "medium") {
      width = 16;
      height = 16;
      mineCount = 40;
    } else if (level == "hard") {
      width = 30;
      height = 16;
      mineCount = 99;
    } else if (level == "custom") {
      print("Enter the width of the board: ");
      var widthStr = stdin.readLineSync();
      if (widthStr != null && widthStr != "") {
        width = int.parse(widthStr);
      }
      print("Enter the height of the board: ");
      var heightStr = stdin.readLineSync();
      if (heightStr != null && heightStr != "") {
        height = int.parse(heightStr);
      }
      print("Enter the number of mines: ");
      var mineCountStr = stdin.readLineSync();
      if (mineCountStr != null && mineCountStr != "") {
        mineCount = int.parse(mineCountStr);
      }
    }

    var game = Game(width, height, mineCount);

    while (!game.isLost && !game.isWon) {
      print("\u{001B}[2J");
      print("Minedarter");
      game.printBoard();
      print("Enter the coordinates of the slot you want to reveal: ");
      var input = stdin.readLineSync();
      if (input == null || input == "") {
        continue;
      }
      if (input == "exit") {
        return;
      }
      var parts = input.split(" ");
      if (parts.length != 2) {
        continue;
      }
      var y = int.parse(parts[0]);
      var x = int.parse(parts[1]);
      game.reveal(x, y);
      game.checkWin();

      if (game.isWon || game.isLost) {
        print("\u{001B}[2J");
        print("Minedarter");
        game.printBoard();
        print("Time elapsed: ${-game.start.difference(DateTime.now()).inSeconds} seconds");
        if (game.isWon) {
          print("You won!");
        } else {
          print("You lost!");
        }
        print("Press enter to continue...");
        stdin.readLineSync();
      }
    }
  }
}
