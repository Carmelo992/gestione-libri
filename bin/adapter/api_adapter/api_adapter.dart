import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../city/city.dart';
import '../../school/school.dart';
import '../../year/year.dart';

part 'api_adapter.g.dart';

class ApiAdapter {
  @Route.mount("/city")
  Router get cityAdapter => ApiCityAdapter().router;

  @Route.mount("/school")
  Router get schoolAdapter => ApiSchoolAdapter().router;

  @Route.mount("/years")
  Router get yearAdapter => ApiYearAdapter().router;

  Router get router => _$ApiAdapterRouter(this);

  Handler get handler => _$ApiAdapterRouter(this).call;
}
