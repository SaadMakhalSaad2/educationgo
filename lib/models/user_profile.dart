class UserProfile {
  String? id;
  String? name;
  String? email;
  String? imageUrl;
  String? dateJoined;

  UserProfile(this.id, this.email, this.name, this.imageUrl, this.dateJoined);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'imageUrl': imageUrl,
        'dateJoined': dateJoined
      };

  UserProfile.fromJson(Map<Object?, Object?> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    email = json['email'].toString();
    imageUrl = json['imageUrl'].toString();
    dateJoined = json['dateJoined'].toString();
  }

}
