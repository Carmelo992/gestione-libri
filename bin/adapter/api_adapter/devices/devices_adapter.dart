import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../../request_models/response_model.dart';

part 'devices_adapter.g.dart';

class DevicesAdapter {
  DevicesAdapter();

  @Route.get("/")
  Response _emptyApi(Request request) => CustomResponse.ok(null);

  Router get router => _$DevicesAdapterRouter(this);
}
