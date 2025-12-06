class CertificateModel {
  final String id;
  final String name;
  final String issuer;
  final String issueDate;
  final String? expiryDate;
  final String? credentialId;
  final String? credentialUrl;
  final String? description;

  CertificateModel({
    required this.id,
    required this.name,
    required this.issuer,
    required this.issueDate,
    this.expiryDate,
    this.credentialId,
    this.credentialUrl,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'issuer': issuer,
      'issue_date': issueDate,
      'expiry_date': expiryDate,
      'credential_id': credentialId,
      'credential_url': credentialUrl,
      'description': description,
    };
  }

  factory CertificateModel.fromMap(Map<String, dynamic> map) {
    return CertificateModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      issuer: map['issuer'] ?? '',
      issueDate: map['issue_date'] ?? '',
      expiryDate: map['expiry_date'],
      credentialId: map['credential_id'],
      credentialUrl: map['credential_url'],
      description: map['description'],
    );
  }

  CertificateModel copyWith({
    String? id,
    String? name,
    String? issuer,
    String? issueDate,
    String? expiryDate,
    String? credentialId,
    String? credentialUrl,
    String? description,
  }) {
    return CertificateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      issuer: issuer ?? this.issuer,
      issueDate: issueDate ?? this.issueDate,
      expiryDate: expiryDate ?? this.expiryDate,
      credentialId: credentialId ?? this.credentialId,
      credentialUrl: credentialUrl ?? this.credentialUrl,
      description: description ?? this.description,
    );
  }
}
