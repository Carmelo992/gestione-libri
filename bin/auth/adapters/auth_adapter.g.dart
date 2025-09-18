// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_adapter.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$AuthAdapterRouter(AuthAdapter service) {
  final router = Router();
  router.add('GET', r'/', service._getProfile);
  router.add('PUT', r'/', service._editProfile);
  router.add('POST', r'/login', service._login);
  router.add('POST', r'/logout', service._logout);
  router.add('POST', r'/renewToken', service._renewToken);
  router.add('POST', r'/resetCode', service._resetCode);
  router.add('POST', r'/resetPassword', service._resetPassword);
  router.add('POST', r'/changePassword', service._changePassword);
  router.all(r'/<ignored|.*>', service.notFound);
  return router;
}
