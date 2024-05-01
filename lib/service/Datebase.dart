class Member {
  String name;
  String email;
  String pw;

  Member({
    required this.name,
    required this.email,
    required this.pw,
  });

  // Factory method to create Member instance from Firebase snapshot
  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      pw: map['pw'] ?? '',
    );
  }

  // Convert Member object to a map for storing in Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'pw': pw,
    };
  }
}
