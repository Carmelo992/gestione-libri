import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../city/city.dart';
import '../../school/school.dart';
import '../../user/user.dart';

part 'web_adapter.g.dart';

class WebAdapter {
  @Route.mount("/users")
  Router get usersAdapter => UserAdapter().router;

  @Route.mount("/city")
  Router get citiesAdapter => WebCityAdapter().router;

  @Route.mount("/school")
  Router get schoolAdapter => WebSchoolAdapter().router;

  Router get router => _$WebAdapterRouter(this);

  Handler get handler => _$WebAdapterRouter(this).call;
}
