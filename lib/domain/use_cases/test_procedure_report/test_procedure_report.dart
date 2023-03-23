// @author Matthias Weigt 27.07.2022
// All rights reserved ©2022


/// This is a abstract class of a [TestProcedure] report.
abstract class TestProcedureReport {
  TestProcedureReport({this.name = ""});

  final String name;

  /// Gets the String representing a report of a [TestProcedure].
  String get();
}
