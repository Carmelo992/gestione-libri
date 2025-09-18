import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../city/adapters/api_adapter/api_city_adapter.dart';

part 'api_adapter.g.dart';

class ApiAdapter {
  @Route.mount("/empty")
  Router get cityAdapter => ApiCityAdapter().router;

  Router get router => _$ApiAdapterRouter(this);

  Handler get handler => _$ApiAdapterRouter(this).call;
}
