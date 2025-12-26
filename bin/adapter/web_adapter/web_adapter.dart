import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../city/city.dart';
import '../../school/school.dart';
import '../../user/user.dart';
import '../../year/year.dart';

part 'web_adapter.g.dart';

class WebAdapter {
  @Route.mount("/users")
  Router get usersAdapter => UserAdapter().router;

  @Route.mount("/cities")
  Router get citiesAdapter => WebCityAdapter().router;

  @Route.mount("/schools")
  Router get schoolAdapter => WebSchoolAdapter().router;

  @Route.mount("/years")
  Router get yearAdapter => WebYearAdapter().router;

  Router get router => _$WebAdapterRouter(this);

  Handler get handler => _$WebAdapterRouter(this).call;
}
