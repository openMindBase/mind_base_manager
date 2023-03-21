// @author Matthias Weigt 21.03.23
// All rights reserved ©2023

class Exercise{
  Exercise({required this.question, required this.answer});

  final String question;
  final String answer;

  @override
  String toString() => "q:$question a:$answer";

  String get title => "-$question";
}