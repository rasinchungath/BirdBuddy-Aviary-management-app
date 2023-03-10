class UserModel {
  String name;
  String email;
  String bio;
  String phoneNumber;
  String profilePic;
  String createdAt;
  String uid;

  UserModel(
      {required this.name,
      required this.email,
      required this.bio,
      required this.profilePic,
      required this.phoneNumber,
      required this.createdAt,
      required this.uid});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      profilePic: map['profilePic'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      createdAt: map['createdAt'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'bio': bio,
      'profilePic': profilePic,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
      'uid': uid,
    };
  }
}
