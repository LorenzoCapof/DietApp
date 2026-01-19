import 'package:dietapp/core/models/nutrition.dart';

class User {
  final String id;
  final String name;
  final int dailyCalorieGoal;
  final MacroGoals macroGoals;

  User({
    required this.id,
    required this.name,
    required this.dailyCalorieGoal,
    required this.macroGoals,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'dailyCalorieGoal': dailyCalorieGoal,
    'macroGoals': macroGoals.toJson(),
  };

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'],
    name: json['name'],
    dailyCalorieGoal: json['dailyCalorieGoal'],
    macroGoals: MacroGoals.fromJson(json['macroGoals']),
  );
}