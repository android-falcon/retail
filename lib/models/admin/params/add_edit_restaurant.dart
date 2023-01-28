
class AddEditRestaurantParams {
  AddEditRestaurantParams({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
    required this.phoneNumber,
    required this.email,
    required this.website,
  });

  int id;
  String name;
  String username;
  String? password;
  String phoneNumber;
  String email;
  String website;
}
