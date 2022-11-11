class Slot {
  bool isMine;
  var isRevealed = false;
  var mineCount = 0;

  Slot(this.isMine);

  reveal() {
    isRevealed = true;
  }

  isBlank() {
    return !isMine && mineCount == 0;
  }

  description() {
    if (!isRevealed) {
      return "■";
    } else if (isMine) {
      return "X";
    } else if (mineCount == 0) {
      return " ";
    } else {
      return mineCount.toString();
    }
  }
}
