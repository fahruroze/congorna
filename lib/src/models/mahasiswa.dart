class Mahasiswa {
  final String mahasiswaId;
  final String userName;
  final String email;
  final String phoneNumber;
  final String userImage;

  Mahasiswa(
      {this.userName,
      this.email,
      this.phoneNumber,
      this.mahasiswaId,
      this.userImage});

  Map<String, dynamic> toMap() {
    return {
      'mahasiswaId': mahasiswaId,
      'userName': userName,
      'email': email,
      'numberPhone': phoneNumber,
      'userImage': userImage
    };
  }

  Mahasiswa.fromFirestore(Map<String, dynamic> firestore)
      : mahasiswaId = firestore['mahasiswaId'],
        userName = firestore['userName'],
        email = firestore['email'],
        phoneNumber = firestore['phoneNumber'],
        userImage = firestore['userImage'];
}
