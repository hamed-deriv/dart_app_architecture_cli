import 'package:flutter_app_architecture/structure/data/base_model.dart';

/// Show user information model.
class ShowUserInformationModel implements BaseModel {
  /// Initializes [ShowUserInformationModel].
  ShowUserInformationModel({
    required this.name,
    this.birthdate,
  });

  /// Creates an instance from JSON.
  factory ShowUserInformationModel.fromJson(Map<String, dynamic> json) =>
      ShowUserInformationModel(
        name: json['name'],
        birthdate: json['birthdate'],
      );

  /// Name.
  final String name;

  /// Birthdate.
  final String? birthdate;

  //// Converts an instance to JSON.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    json['name'] = name;
    json['birthdate'] = birthdate;

    return json;
  }
}
