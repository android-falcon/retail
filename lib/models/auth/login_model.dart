// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.name,
    required this.phoneNumber,
    required this.website,
    required this.userRole,
    required this.accessToken,
    required this.applicationId,
  });

  String name;
  String phoneNumber;
  String website;
  int userRole;
  String accessToken;
  String applicationId;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        name: json["name"] ?? "",
        phoneNumber: json["phoneNumber"] ?? "",
        website: json["website"] ?? "",
        userRole: json["userRole"] ?? 0,
        accessToken: json["accessToken"] ?? "",
        applicationId: json["applicationId"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "phoneNumber": phoneNumber,
        "website": website,
        "userRole": userRole,
        "accessToken": accessToken,
        "applicationId": applicationId,
      };
}
