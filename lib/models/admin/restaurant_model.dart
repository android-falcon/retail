// To parse this JSON data, do
//
//     final restaurantModel = restaurantModelFromJson(jsonString);

import 'dart:convert';

RestaurantModel restaurantModelFromJson(String str) => RestaurantModel.fromJson(json.decode(str));

String restaurantModelToJson(RestaurantModel data) => json.encode(data.toJson());

class RestaurantModel {
  RestaurantModel({
    required this.totalCount,
    required this.restaurants,
  });

  int totalCount;
  List<Restaurant> restaurants;

  factory RestaurantModel.fromJson(Map<String, dynamic> json) => RestaurantModel(
        totalCount: json["totalCount"] ?? 0,
        restaurants: json["restaurants"] == null ? [] : List<Restaurant>.from(json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalCount": totalCount,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}

class Restaurant {
  Restaurant({
    required this.id,
    required this.name,
    required this.username,
    required this.description,
    required this.phoneNumber,
    required this.email,
    required this.website,
    required this.facebook,
    required this.whatsapp,
    required this.instagram,
    required this.tikTok,
    required this.youTube,
    required this.snapchat,
    required this.twitter,
    required this.foodPrepTime,
    required this.colorPrimary,
    required this.colorSecondary,
    required this.colorTertiary,
    required this.designType,
    required this.onlinePayment,
    required this.otpWhatsapp,
    required this.delivery,
    required this.pickup,
    required this.dineIn,
    required this.image,
    required this.imageCover,
    required this.costPerKm,
    required this.minCost,
    required this.restaurantBranches,
    required this.menus,
  });

  String id;
  String name;
  String username;
  String description;
  String phoneNumber;
  String email;
  String website;
  String facebook;
  String whatsapp;
  String instagram;
  String tikTok;
  String youTube;
  String snapchat;
  String twitter;
  String foodPrepTime;
  String colorPrimary;
  String colorSecondary;
  String colorTertiary;
  int designType;
  bool onlinePayment;
  bool otpWhatsapp;
  bool delivery;
  bool pickup;
  bool dineIn;
  String image;
  String imageCover;
  double costPerKm;
  double minCost;
  List<dynamic> restaurantBranches;
  List<dynamic> menus;

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"] ?? "",
        name: json["name"] ?? "",
        username: json["username"] ?? "",
        description: json["description"] ?? "",
        phoneNumber: json["phoneNumber"] ?? "",
        email: json["email"] ?? "",
        website: json["website"] ?? "",
        facebook: json["facebook"] ?? "",
        whatsapp: json["whatsapp"] ?? "",
        instagram: json["instagram"] ?? "",
        tikTok: json["tikTok"] ?? "",
        youTube: json["youTube"] ?? "",
        snapchat: json["snapchat"] ?? "",
        twitter: json["twitter"] ?? "",
        foodPrepTime: json["foodPrepTime"] ?? "",
        colorPrimary: json["colorPrimary"] ?? "",
        colorSecondary: json["colorSecondary"] ?? "",
        colorTertiary: json["colorTertiary"] ?? "",
        designType: json["designType"] ?? 0,
        onlinePayment: json["onlinePayment"] ?? false,
        otpWhatsapp: json["otpWhatsapp"] ?? false,
        delivery: json["delivery"] ?? false,
        pickup: json["pickup"] ?? false,
        dineIn: json["dineIn"] ?? false,
        image: json["image"] ?? "",
        imageCover: json["imageCover"] ?? "",
        costPerKm: json["costPerKm"]?.toDouble() ?? 0,
        minCost: json["minCost"]?.toDouble() ?? 0,
        restaurantBranches: json["restaurantBranches"] == null ? [] : List<dynamic>.from(json["restaurantBranches"].map((x) => x)),
        menus: json["menus"] == null ? [] : List<dynamic>.from(json["menus"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "description": description,
        "phoneNumber": phoneNumber,
        "email": email,
        "website": website,
        "facebook": facebook,
        "whatsapp": whatsapp,
        "instagram": instagram,
        "tikTok": tikTok,
        "youTube": youTube,
        "snapchat": snapchat,
        "twitter": twitter,
        "foodPrepTime": foodPrepTime,
        "colorPrimary": colorPrimary,
        "colorSecondary": colorSecondary,
        "colorTertiary": colorTertiary,
        "designType": designType,
        "onlinePayment": onlinePayment,
        "otpWhatsapp": otpWhatsapp,
        "delivery": delivery,
        "pickup": pickup,
        "dineIn": dineIn,
        "image": image,
        "imageCover": imageCover,
        "costPerKm": costPerKm,
        "minCost": minCost,
        "restaurantBranches": List<dynamic>.from(restaurantBranches.map((x) => x)),
        "menus": List<dynamic>.from(menus.map((x) => x)),
      };
}
