// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022
/// This class represents a node in [Graph].
class Node {
  Node({required this.id});

  /// The [Node]-ID.
  final String id;

  @override
  String toString() {
    return '{id: $id}';
  }
}
