// Author = Matthias Weigt
// Date = 02.06.2022

import 'dart:math';

class RandomList<T> {
  List<T> random(List<T> list) {
    List<T> output = [];
    while (true) {
      if (list.isEmpty) {
        return output;
      }
      T element = list
          .removeAt(list.length > 1 ? Random().nextInt(list.length - 1) : 0);
      output.add(element);
    }
  }
}
