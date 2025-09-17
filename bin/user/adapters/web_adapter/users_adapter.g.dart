// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'users_adapter.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$UserAdapterRouter(UserAdapter service) {
  final router = Router();
  router.add('GET', r'/', service._getAllUsers);
  router.add('PUT', r'/', service._insertUser);
  router.add('GET', r'/<userId|[0-9]+>', service._getUser);
  router.add('PUT', r'/<userId|[0-9]+>', service._editUser);
  router.add('DELETE', r'/<userId|[0-9]+>', service._deleteUser);
  router.add('PUT', r'/register', service._registerUser);
  router.all(r'/<ignored|.*>', service.notFound);
  return router;
}
