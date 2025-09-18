import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../../auth/adapters/auth_adapter.dart';
import '../api_adapter/api_adapter.dart';
import '../web_adapter/web_adapter.dart';

part 'service_adapter.g.dart';

class ServiceAdapter {
  //@Route.get("/")
  //Response _home(Request request) {
  //  var html = File('public/index.html').readAsStringSync();
  //  return Response.ok(html, headers: {'Content-Type': 'text/html'});
  //}
  //
  //@Route.get("/manifest.json")
  //Response _getManifest(Request request) {
  //  var html = File('public/manifest.json').readAsStringSync();
  //  return Response.ok(html);
  //}
  //
  //@Route.get("/flutter_bootstrap.js")
  //Response _getFile(Request request) {
  //  var html = File('public/flutter_bootstrap.js').readAsStringSync();
  //  return Response.ok(html, headers: {'Content-Type': 'text/javascript'});
  //}
  //
  //@Route.get("/flutter_service_worker.js")
  //Response _getFlutterServiceFile(Request request) {
  //  var html = File('public/flutter_service_worker.js').readAsStringSync();
  //  return Response.ok(html, headers: {'Content-Type': 'text/javascript'});
  //}
  //
  //@Route.get("/main.dart.js")
  //Response _getMainDartFile(Request request) {
  //  var html = File('public/main.dart.js').readAsStringSync();
  //  return Response.ok(html, headers: {'Content-Type': 'text/javascript'});
  //}
  //
  //@Route.get("/manifest.json")
  //Response _getManifestFile(Request request) {
  //  var html = File('public/manifest.json').readAsStringSync();
  //  return Response.ok(html);
  //}
  //
  //@Route.get("/version.json")
  //Response _getVersionFile(Request request) {
  //  var html = File('public/version.json').readAsStringSync();
  //  return Response.ok(html);
  //}
  //
  //@Route.get("/favicon.png")
  //Response _getFavIconFile(Request request) {
  //  var html = File('public/favicon.png').readAsBytesSync();
  //  return Response.ok(html, headers: {'Content-Type': 'image'});
  //}
  //
  //@Route.get("/index.html")
  //Response _getIndexHtmlFile(Request request) {
  //  var html = File('public/index.html').readAsStringSync();
  //  return Response.ok(html);
  //}

  @Route.mount("/web")
  Router get webAdapter => WebAdapter().router;

  @Route.mount("/auth")
  Router get authAdapter => AuthAdapter().router;

  @Route.mount("/api")
  Router get apiAdapter => ApiAdapter().router;

  Router get router {
    var r = _$ServiceAdapterRouter(this);
    //r.get("/assets/fonts/<file>", createStaticHandler("public"));
    //r.get("/assets/packages/cupertino_icons/assets/<file>", createStaticHandler("public"));
    //r.get("/assets/packages/view/assets/images/<file>", createStaticHandler("public"));
    //r.get("/assets/packages/<file>", createStaticHandler("public"));
    //r.get("/assets/shaders/<file>", createStaticHandler("public"));
    //r.get("/assets/<file>", createStaticHandler("public"));
    //r.get("/canvaskit/chromium/<file>", createStaticHandler("public"));
    //r.get("/canvaskit/<file>", createStaticHandler("public"));
    //r.get("/icons/<file>", createStaticHandler("public"));
    return r;
  }

  Handler get handler => router.call;
}
