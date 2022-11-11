import 'dart:io';
import 'dart:math';

import 'package:minedarter/slot.dart';

class Game {
  final int width;
  final int height;
  final int mine_count;
  late final List<List<Slot>> slots;
  bool isWon = false;
  bool isLost = false;
  late final DateTime start;

  Game(this.width, this.height, this.mine_count) {
    slots = List.generate(
      height,
      (y) => List.generate(
        width,
        (x) => Slot(false),
      ),
    );

    var minesPlaced = 0;
    while (minesPlaced < mine_count) {
      var x = Random().nextInt(width);
      var y = Random().nextInt(height);
      if (!slots[y][x].isMine) {
        slots[y][x].isMine = true;
        minesPlaced++;
      }
    }

    // Set mine counts
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        var slot = slots[y][x];
        if (slot.isMine) {
          continue;
        }
        var mineCount = 0;
        for (var y2 = max(0, y-1); y2 <= min(height - 1, y + 1); y2++) {
          for (var x2 = max(0, x-1); x2 <= min(width - 1, x + 1); x2++) {
            if (slots[y2][x2].isMine) {
              mineCount++;
            }
          }
        }
        slot.mineCount = mineCount;
      }
    }

    start = DateTime.now();
  }

  void checkWin() {
    var count = 0;
    for (var y = 0; y < height; y++) {
      for (var x = 0; x < width; x++) {
        var slot = slots[y][x];
        if (slot.isRevealed) {
          count++;
        }
      }
    }
    if (count == width * height - mine_count) {
      isWon = true;
      for (var y = 0; y < height; y++) {
        for (var x = 0; x < width; x++) {
          var slot = slots[y][x];
          if (slot.isMine) {
            slot.reveal();
          }
        }
      }
    }
  }

  void reveal(int x, int y) {
    if (isWon || isLost) {
      return;
    }
    if (x < 0 || x >= width || y < 0 || y >= height) {
      return;
    }
    if (slots[y][x].isRevealed) {
      return;
    }
    slots[y][x].reveal();
    if (slots[y][x].isMine) {
      isLost = true;
      for (var y = 0; y < height; y++) {
        for (var x = 0; x < width; x++) {
          var slot = slots[y][x];
          if (slot.isMine) {
            slot.reveal();
          }
        }
      }
    } else if (slots[y][x].isBlank()) {
      for (var y2 = max(0, y-1); y2 <= min(height - 1, y + 1); y2++) {
        for (var x2 = max(0, x-1); x2 <= min(width - 1, x + 1); x2++) {
          reveal(x2, y2);
        }
      }
    }
  }

  void printBoard() {
    stdout.write("  ");
    for (var x = 0; x < width; x++) {
      stdout.write("$x ");
      if (x < 10 && width >= 10) {
        stdout.write(" ");
      }
    }
    print("");
    for (var y = 0; y < height; y++) {
      stdout.write("$y ");
      if (y < 10 && height >= 10) {
        stdout.write(" ");
      }
      for (var x = 0; x < width; x++) {
        stdout.write(slots[y][x].description());
        stdout.write(" ");
        if (width >= 10) {
          stdout.write(" ");
        }
      }
      print("");
    }
  }
}
