// @author Matthias Weigt 13.02.23
// All rights reserved ©2023

/// The metadata to display at the StudentSelectionScreen
class StudentMetadata {
  const StudentMetadata(this.id, {this.name});

  static const StudentMetadata example = StudentMetadata("testStudent12345",name: "Mira Bellenbaum");

  static StudentMetadata fromJson(Map<String,dynamic> data) {
    return StudentMetadata(data["id"],name: data["name"],);
  }


  final String id;
  final String? name;

  String toFullString() {
    return 'StudentMetadata{id: $id, name: $name}';
  }

  @override
  String toString() {
    return "${name ?? id}}";
  }





}
