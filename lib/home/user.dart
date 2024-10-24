class User {
  final String name;
  final String email;
  final String phone;
  final String picture;
  final String country;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.picture,
    required this.country,
  });

  // Constructor que convierte JSON a un objeto de tipo User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: '${json['name']['first']} ${json['name']['last']}',
      email: json['email'],
      phone: json['phone'],
      country: json['location']['country'],
      picture: json['picture']['large'],
    );
  }
}
