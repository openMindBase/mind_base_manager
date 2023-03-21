// @author Matthias Weigt 21.03.23

/// For printing stats into the console.
class StatsPrinter{
  static const _defaultUnderscores = 10;
  static const bool _alwaysWriteStats = true;
  StatsPrinter({required String title, required this.stats,this.doPrint=false}):title="$title ${DateTime.now().toString()}"{
    printStats();
  }

  final String title;
  final List<String> stats;
  final bool doPrint;

  void printStats() {
    if(!doPrint && !_alwaysWriteStats) {
      return;
    }

    print("${_underScore(_defaultUnderscores)} $title ${_underScore(_defaultUnderscores)}");
    for(var v in stats) {
        print("| $v ${_spaceAndPipe(_defaultUnderscores*2+title.length+2-(v.length+3))}");
    }
    print(_underScore(_defaultUnderscores*2+title.length+2));

  }

  String _underScore(int length) {
    String s = "";
    for(int i = 0;i<length;i++) {
      s+= "-";
    }
    return s;
  }
  String _spaceAndPipe(int length) {
    String s = "";
    for(int i = 0;i<length-1;i++) {
      s+= " ";
    }
    s+="|";
    return s;
  }


}