import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../user/adapters/web_adapter/users_adapter.dart';

part 'web_adapter.g.dart';

class WebAdapter {
  @Route.mount("/users")
  Router get usersAdapter => UserAdapter().router;

  Router get router => _$WebAdapterRouter(this);

  Handler get handler => _$WebAdapterRouter(this).call;
}
