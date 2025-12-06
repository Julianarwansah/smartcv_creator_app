class PersonalInfoModel {
  final String name;
  final String email;
  final String phone;
  final String address;
  final String? city;
  final String? country;
  final String? postalCode;
  final String? website;
  final String? linkedin;
  final String? github;
  final String? profilePhoto;

  PersonalInfoModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.city,
    this.country,
    this.postalCode,
    this.website,
    this.linkedin,
    this.github,
    this.profilePhoto,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'country': country,
      'postal_code': postalCode,
      'website': website,
      'linkedin': linkedin,
      'github': github,
      'profile_photo': profilePhoto,
    };
  }

  factory PersonalInfoModel.fromMap(Map<String, dynamic> map) {
    return PersonalInfoModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      city: map['city'],
      country: map['country'],
      postalCode: map['postal_code'],
      website: map['website'],
      linkedin: map['linkedin'],
      github: map['github'],
      profilePhoto: map['profile_photo'],
    );
  }

  PersonalInfoModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? country,
    String? postalCode,
    String? website,
    String? linkedin,
    String? github,
    String? profilePhoto,
  }) {
    return PersonalInfoModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      website: website ?? this.website,
      linkedin: linkedin ?? this.linkedin,
      github: github ?? this.github,
      profilePhoto: profilePhoto ?? this.profilePhoto,
    );
  }
}
