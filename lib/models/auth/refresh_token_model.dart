// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

RefreshTokenModel refreshTokenModelFromJson(String str) => RefreshTokenModel.fromJson(json.decode(str));

String refreshTokenModelToJson(RefreshTokenModel data) => json.encode(data.toJson());

class RefreshTokenModel {
  RefreshTokenModel({
    required this.accessToken,
  });

  String accessToken;

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) => RefreshTokenModel(
        accessToken: json["accessToken"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
      };
}
