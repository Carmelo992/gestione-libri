import 'dart:convert';

import 'package:shelf/shelf.dart';

class CustomResponse extends Response {
  CustomResponse.ok(Object? body, {Map<String, Object>? headers, super.encoding, super.context})
    : super.ok(encodeBody(body), headers: defaultHeader(headers));

  CustomResponse.movedPermanently(
    super.location, {
    Object? body,
    Map<String, Object>? headers,
    super.encoding,
    super.context,
  }) : super.movedPermanently(body: encodeBody(body), headers: defaultHeader(headers));

  CustomResponse.found(super.location, {Object? body, Map<String, Object>? headers, super.encoding, super.context})
    : super.found(body: encodeBody(body), headers: defaultHeader(headers));

  CustomResponse.seeOther(super.location, {Object? body, Map<String, Object>? headers, super.encoding, super.context})
    : super.seeOther(body: encodeBody(body), headers: defaultHeader(headers));

  CustomResponse.notModified({Map<String, Object>? headers, super.context})
    : super.notModified(headers: defaultHeader(headers));

  CustomResponse.badRequest({Object? body, Map<String, Object>? headers, super.encoding, super.context})
    : super.badRequest(body: encodeBody(body), headers: defaultHeader(headers));

  CustomResponse.unauthorized({Object? body, Map<String, Object>? headers, super.encoding, super.context})
    : super.unauthorized(encodeBody(body), headers: defaultHeader(headers));

  CustomResponse.forbidden({Object? body, Map<String, Object>? headers, super.encoding, super.context})
    : super.forbidden(encodeBody(body), headers: defaultHeader(headers));

  CustomResponse.notFound({Object? body, Map<String, Object>? headers, super.encoding, super.context})
    : super.notFound(encodeBody(body), headers: defaultHeader(headers));

  CustomResponse.internalServerError({Object? body, Map<String, Object>? headers, super.encoding, super.context})
    : super.internalServerError(body: encodeBody(body), headers: defaultHeader(headers));

  CustomResponse(super.statusCode, {Object? body, Map<String, Object>? headers, super.encoding, super.context})
    : super(body: encodeBody(body), headers: defaultHeader(headers));

  static String? encodeBody(Object? body) => body != null ? jsonEncode(body) : null;

  static Map<String, Object> defaultHeader(Map<String, Object>? headers) => {
    ...?headers,
    "Content-Type": "application/json",
  };
}
