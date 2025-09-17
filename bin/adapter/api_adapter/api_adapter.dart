import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import './devices/devices_adapter.dart';

part 'api_adapter.g.dart';

class ApiAdapter {
  @Route.mount("/empty")
  Router get emptyAdapter => DevicesAdapter().router;

  Router get router => _$ApiAdapterRouter(this);

  Handler get handler => _$ApiAdapterRouter(this).call;
}
