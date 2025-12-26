class LoginResponseModel {
  static const _idDaoKey = "id";
  static const _createdAtDaoKey = "created_at";
  static const _updatedAtDaoKey = "updated_at";
  static const _firstNameDaoKey = "first_name";
  static const _lastNameDaoKey = "last_name";
  static const _emailDaoKey = "email";
  static const _isAdminDaoKey = "is_admin";
  static const _tokenDaoKey = "token";
  static const _refreshTokenDaoKey = "refreshToken";

  static const _idKey = "id";
  static const _createdAtKey = "createdAt";
  static const _updatedAtKey = "updatedAt";
  static const _firstNameKey = "firstName";
  static const _lastNameKey = "lastName";
  static const _emailKey = "email";
  static const _isAdminKey = "isAdmin";
  static const _tokenKey = "token";
  static const _refreshTokenKey = "refreshToken";

  final int id;
  final String createdAt;
  final String updatedAt;
  final String firstName;
  final String lastName;
  final String email;
  final bool isAdmin;
  final String token;
  final String refreshToken;

  LoginResponseModel.fromDao(Map<String, dynamic> dao)
    : id = dao[_idDaoKey],
      createdAt = dao[_createdAtDaoKey],
      updatedAt = dao[_updatedAtDaoKey],
      firstName = dao[_firstNameDaoKey],
      lastName = dao[_lastNameDaoKey],
      email = dao[_emailDaoKey],
      isAdmin = dao[_isAdminDaoKey] == 1,
      token = dao[_tokenDaoKey],
      refreshToken = dao[_refreshTokenDaoKey];

  Map<String, dynamic> toMap() => {
    _idKey: id,
    _createdAtKey: createdAt,
    _updatedAtKey: updatedAt,
    _firstNameKey: firstName,
    _lastNameKey: lastName,
    _emailKey: email,
    _isAdminKey: isAdmin,
    _tokenKey: token,
    _refreshTokenKey: refreshToken,
  };
}
