import 'dart:async';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import '../core/core.dart';

class JwtManager {
  static final _secret = SecretKey('1YQ#(b5n4RlGmk@B5V|u}1}~S');
  static const _issuer = "Emile";
  static const _userIdKey = "userId";
  static const isAdminKey = "isAdmin";
  static const _isResetPasswordTokenKey = "isResetPasswordToken";
  static const refreshTokenKey = "refreshToken";
  static const tokenKey = "token";
  static const authorizationKey = "Authorization";

  static String? getJwtFromHeader(Map<String, dynamic> headers) {
    var bearer = headers[authorizationKey];
    if (bearer == null) {
      return null;
    }
    var tokenParts = bearer.split(" ");
    if (tokenParts.first == "Bearer") {
      return tokenParts.last;
    } else {
      return null;
    }
  }

  static int? getUserIdFromHeader(Map<String, dynamic> headers) {
    String? jwt = getJwtFromHeader(headers);
    if (jwt == null) return null;
    try {
      Map<String, dynamic> jwtMap = validateJwt(jwt);
      return jwtMap[_userIdKey];
    } catch (e) {
      print(e);
      return null;
    }
  }

  static bool? getIsAdminFromHeader(Map<String, dynamic> headers) {
    String? jwt = getJwtFromHeader(headers);
    if (jwt == null) return null;
    try {
      Map<String, dynamic> jwtMap = validateJwt(jwt);
      return jwtMap[isAdminKey];
    } catch (e) {
      print(e);
      return null;
    }
  }

  static String createAccessToken(int userId, bool isAdmin) {
    return JWT({_userIdKey: userId, isAdminKey: isAdmin}, issuer: _issuer).sign(_secret, expiresIn: Duration(days: 1));
  }

  static String createRefreshToken(int userId, bool isAdmin) {
    return JWT({
      _userIdKey: userId,
      refreshTokenKey: true,
      isAdminKey: isAdmin,
    }, issuer: _issuer).sign(_secret, expiresIn: Duration(days: 2));
  }

  static String createResetPasswordToken(int userId, bool isAdmin) {
    return JWT({
      _userIdKey: userId,
      isAdminKey: isAdmin,
      _isResetPasswordTokenKey: true,
    }, issuer: _issuer).sign(_secret, expiresIn: Duration(days: 1));
  }

  static Map<String, dynamic> validateJwt(String token) {
    try {
      final jwt = JWT.verify(token, _secret, issuer: _issuer);
      return jwt.payload;
    } on JWTExpiredException {
      Logger.info("jwt expired");
      rethrow;
    } on JWTException catch (ex) {
      Logger.info(ex.message);
      rethrow;
    }
  }

  static bool validateAccessToken(String token, bool mustBeAdmin, {bool ignoreCheckUserRole = false}) {
    if (_jwtBlackList.contains(token)) return false;
    try {
      final payload = validateJwt(token);

      bool isAdmin = payload[isAdminKey];
      if (ignoreCheckUserRole || isAdmin == mustBeAdmin) {
        return !payload.containsKey(refreshTokenKey);
      }
      return false;
    } catch (ex) {
      return false;
    }
  }

  static bool validateRefreshToken(String token) {
    try {
      final payload = validateJwt(token);
      return payload[refreshTokenKey] ?? false;
    } catch (ex) {
      return false;
    }
  }

  static bool validateResetPasswordToken(String token) {
    try {
      final payload = validateJwt(token);
      return payload[_isResetPasswordTokenKey] ?? false;
    } catch (ex) {
      return false;
    }
  }

  static final Set<String> _jwtBlackList = {};

  static void invalidateJwt(String jwt) => _jwtBlackList.add(jwt);

  static void startCleanJob() {
    Timer.periodic(Duration(hours: 12), (_) {
      List<String> jwtToRemove = [];
      for (String jwt in _jwtBlackList) {
        try {
          validateJwt(jwt);
        } catch (e) {
          jwtToRemove.add(jwt);
        }
      }
      _jwtBlackList.removeAll(jwtToRemove);
    });
  }

  static String? renewToken(Map<String, dynamic> headers, bool isJwt) {
    String? jwt = getJwtFromHeader(headers);
    if (jwt == null) return null;
    try {
      Map<String, dynamic> jwtMap = validateJwt(jwt);
      var userId = jwtMap[_userIdKey];
      var isAdmin = jwtMap[isAdminKey];
      if (userId != null && isAdmin != null) {
        if (isJwt) {
          return JwtManager.createAccessToken(userId, isAdmin);
        } else {
          return JwtManager.createRefreshToken(userId, isAdmin);
        }
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
