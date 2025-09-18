// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'web_adapter.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$WebAdapterRouter(WebAdapter service) {
  final router = Router();
  router.mount(r'/users', service.usersAdapter.call);
  router.mount(r'/city', service.citiesAdapter.call);
  return router;
}
