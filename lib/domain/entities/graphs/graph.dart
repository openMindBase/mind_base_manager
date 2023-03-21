// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022


import 'edge.dart';
import 'node.dart';

/// This class represents a Graph with [Node]s and [Edge]s.
/// A direct successor of a [Node] is a [Node] that is connected to the first [Node] by [Edge] and is the ending point of this connection.
/// A predecessor of a [Node] is a [Node] that is connected to the first [Node] by [Edge] and is the starting point of this connection.
class Graph<T extends Node> {

  /// This constructor validates the input with [_validate] and throws if input is not valid.
  Graph({required this.nodes, required this.edges}) {
    nodesMap = _setToMap(nodes);
    ids = _idSet(nodes);
    _validate();
  }

  /// Here are all [Node]s in [Graph] stored.
  final Set<T> nodes;

  /// Easy access to all [Node.id]s of [nodes].
  late Set<String> ids;

  /// With [nodesMap] you can access a [Node] of [nodes] by [Node.id].
  late Map<String, T> nodesMap;

  /// Here are all [Edge]s in [Graph] stored.
  final Set<Edge> edges;

  /// Tells if [Graph] contains [Node] represented by input [id].
  bool contains(String id) {
    return ids.contains(id);
  }

  /// This methode can be used to clone a set of [Node]s onto another set.
  Set<T> cloneNodes() => Set.from(nodes);

  /// This methode can be used to clone a set of [Edge]s onto another set.
  Set<Edge> cloneEdges() => Set.from(edges);

  /// Access to [Node] by [id].
  /// Throws if [Node] represented by [id] is not part of [Graph].
  T getNodeById(String id) {
    _validateNode(id);
    return nodesMap[id]!;
  }

  /// Get the direct successors of the input [Node].
  Set<T> getDirectSuccessors(T node) {
    Set<T> output = {};
    for (var edge in edges) {
      if (edge.x1 == node.id) {
        output.add(getNodeById(edge.x2));
      }
    }
    return output;
  }

  /// Get the direct predecessor of the input [Node].
  Set<T> getDirectPredecessors(T node) {
    Set<T> output = {};
    for (var edge in edges) {
      if (edge.x2 == node.id) {
        output.add(getNodeById(edge.x1));
      }
    }
    return output;
  }

  /// Returns a subgraph of [Graph] that starts at the [Node] represented by the input [id] and takes all successors from the starting [Node] into the [Graph].
  Graph<T> getSubGraphBySuccessors(String id) {
    return _getSubGraph(id, (node) => getDirectSuccessors(node as T),
        bySuccessor: true);
  }

  /// Returns a subgraph of [Graph] that ends at the [Node] represented by the input [id] and takes all predecessors from the ending [Node] into the [Graph].
  Graph<T> getSubGraphByPredecessors(String id) {
    return _getSubGraph(id, (node) => getDirectPredecessors(node as T),
        bySuccessor: false);
  }

  /// Easy access to all successors of the [Node] represented by the input [id].
  Set<T> getAllSuccessors(String id) {
    return getSubGraphBySuccessors(id).nodes
      ..removeWhere((element) => element.id == id);
  }

  /// Easy access to all predecessors of the [Node] represented by the input [id].
  Set<T> getAllPredecessor(String id) {
    return getSubGraphByPredecessors(id).nodes
      ..removeWhere((element) => element.id == id);
  }

  @override
  String toString() {
    return 'Graph{nodes: $nodes, edges: $edges}';
  }

  /// The number of [Node]s in [Graph].
  int get length => nodes.length;

  /// Throws if [Node] represented by [id] is not part of [Graph].
  void _validateNode(String id) {
    if (!nodesMap.containsKey(id)) {
      throw ArgumentError("Node not part of graph.");
    }
  }

  /// Returns a subgraph of [Graph].
  /// Depending on the [dependencyGetter] the subgraph either consist of all successors or predecessors of [Node] represented by the input [id].
  Graph<T> _getSubGraph(String id, _NodeDependencyGetter dependencyGetter,
      {required bool bySuccessor}) {
    _validateNode(id);
    Set<T> outputNodes = {};
    Set<Edge> outputEdges = {};
    List<T> que = [getNodeById(id)];
    while (true) {
      if (que.isEmpty) {
        break;
      }
      T temp = que.removeAt(0);
      outputNodes.add(temp);
      Set<T> tempTs = dependencyGetter(temp) as Set<T>;
      que.addAll(tempTs);
      for (T t in tempTs) {
        outputEdges.add(Edge(
            x1: bySuccessor ? temp.id : t.id,
            x2: bySuccessor ? t.id : temp.id));
      }
    }
    return Graph<T>(nodes: outputNodes, edges: outputEdges);
  }

  /// Throws if one [Edge] in [edges] contains a [Node] that is not part of [Graph].
  void _validate() {
    for (var edge in edges) {
      _validateEdge(edge);
    }
  }

  /// Throws if the [Node.id] of one of the [Node]s connected by [edge] is not contained in [ids].
  void _validateEdge(Edge edge) {
    if (!contains(edge.x1) || !contains(edge.x2)) {
      throw ArgumentError("Graph does not contain all nodes of inputted edge");
    }
  }

  /// Key: [id].
  /// Value: [Node] with [Node.id].
  Map<String, T> _setToMap(Set<T> set) {
    Map<String, T> output = {};
    for (var v in set) {
      output[v.id] = v;
    }
    return output;
  }

  /// Takes a [set] of [Node]s and returns a Set of [id]s of [Node]s.
  Set<String> _idSet(Set<T> set) {
    Set<String> output = {};
    for (var v in set) {
      output.add(v.id);
    }
    return output;
  }
}

/// This is a type definition for a function that takes a [node] returns a set of [Node]s.
/// This type definition is used for [_getSubGraph] to determine the sub-[Graph] creation direction.
typedef _NodeDependencyGetter = Set<Node> Function(Node node);
