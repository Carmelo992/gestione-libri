// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_adapter.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$ServiceAdapterRouter(ServiceAdapter service) {
  final router = Router();
  router.mount(r'/web', service.webAdapter.call);
  router.mount(r'/auth', service.authAdapter.call);
  router.mount(r'/api', service.apiAdapter.call);
  return router;
}
