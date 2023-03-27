// Author = Matthias Weigt
// Date = 06.04.2022


import 'package:mind_base_manager/domain/entities/math/relation.dart';
import 'package:mind_base_manager/domain/entities/math/tuple.dart';

/// This class searches for transitivity in a [Relation] and removes all transitive elements of the relation.
class TransitivityCleaner<T> {
  /// The relation input.
  final Relation<T> _relationInput;
  /// The transitive tuples to delete.
  final Set<Tuple<T>> _transitives = {};

  /// Input [Relation] [_relationInput] to clean for transitivity.
  TransitivityCleaner(this._relationInput);

  /// Returns the cleaned [Relation].
  Relation<T> get() {
    for(Tuple<T> t in _relationInput.tuples) {
      if(_checkTupleForTransitivity(t)) {
        break;
      }
    }
    if(_transitives.isEmpty) {
      return _relationInput;
    }
    Set<Tuple<T>> output = {};
    for(Tuple<T> t in _relationInput.tuples) {
      for(Tuple<T> badTuple in _transitives) {
        if(t.x1 != badTuple.x1 || t.x2 != badTuple.x2) {
          output.add(t);
        }
      }
    }
    return TransitivityCleaner<T>(Relation<T>(output)).get();
  }

  /// Checks if the tuple is transitive.
  bool _checkTupleForTransitivity(Tuple<T> tuple) {
    Set<T> directSuccessors = _relationInput.get(tuple.x1);
    directSuccessors.removeWhere((element) => element == tuple.x2);
    
    try{
      generatePaths(directSuccessors,tuple.x2);
    } catch (e) {
      _transitives.add(tuple);
      return true;
    }
    
    return false;
  }
  
  void generatePaths(Set<T> startingPoints,T start) {
    if(startingPoints.isEmpty) {
      return;
    }
    for(T t in startingPoints) {
      if(t == start) {
        // Transitive candidate.
        throw Error();
      }
      generatePaths(_relationInput.get(t), start);
    }
  }

}