class UserModel {
  final String? image,
      name,
      department,
      email,
      phoneNo,
      community,
      cardImage,
      fcmToken,
      rollno,
      id;
      
  bool? student;

  UserModel({
    this.id,
    this.email,
    this.phoneNo,
    this.fcmToken,
    this.community,
    this.cardImage,
    this.image,
    this.name,
    this.department,
    this.student,
    this.rollno,
  });
}
