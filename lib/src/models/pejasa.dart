class Pejasa {
  final String pejasaId;
  final String userName;
  final String email;
  final String phoneNumber;
  final String userImage;

  Pejasa(
      {this.userName,
      this.email,
      this.phoneNumber,
      this.pejasaId,
      this.userImage});

  Map<String, dynamic> toMap() {
    return {
      'pejasaId': pejasaId,
      'userName': userName,
      'email': email,
      'numberPhone': phoneNumber,
      'userImage': userImage
    };
  }

  Pejasa.fromFirestore(Map<String, dynamic> firestore)
      : pejasaId = firestore['pejasaId'],
        userName = firestore['userName'],
        email = firestore['email'],
        phoneNumber = firestore['phoneNumber'],
        userImage = firestore['userImage'];
}
