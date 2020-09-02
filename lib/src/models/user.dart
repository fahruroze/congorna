class User {
  final String userId;
  final String userName;
  final String email;
  final String phoneNumber;
  final String userImage;

  User(
      {this.userName,
      this.email,
      this.phoneNumber,
      this.userId,
      this.userImage});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'numberPhone': phoneNumber,
      'userImage': userImage
    };
  }

  User.fromFirestore(Map<String, dynamic> firestore)
      : userId = firestore['userId'],
        userName = firestore['userName'],
        email = firestore['email'],
        phoneNumber = firestore['phoneNumber'],
        userImage = firestore['userImage'];
}
