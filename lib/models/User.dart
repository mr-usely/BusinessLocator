class User {
  String? id, firstName, lastName, email, birthDay, address;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.birthDay,
      this.email,
      this.address});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["_id"] as String,
        firstName: json["firstName"] as String,
        lastName: json["lastName"] as String,
        email: json["email"] as String,
        birthDay: json["birthDay"] as String);
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "birthDay": birthDay
      };
}
