import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../city/adapters/web_adapter/web_city_adapter.dart';
import '../../user/adapters/web_adapter/users_adapter.dart';

part 'web_adapter.g.dart';

class WebAdapter {
  @Route.mount("/users")
  Router get usersAdapter => UserAdapter().router;

  @Route.mount("/city")
  Router get citiesAdapter => WebCityAdapter().router;

  Router get router => _$WebAdapterRouter(this);

  Handler get handler => _$WebAdapterRouter(this).call;
}
