import 'dart:async' as async;
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

import 'package:lms_backend/core/exceptions/app_exception.dart';
class HttpClient {
  final http.Client _client;
  final Duration timeout;
  final Logger _logger = Logger('HttpClient');

  HttpClient({
    http.Client? client,
    this.timeout = const Duration(seconds: 30),
  }) : _client = client ?? http.Client();

  Future<dynamic> get(
    Uri uri, {
    Map<String, String>? headers,
  }) {
    return _send(
      method: 'GET',
      uri: uri,
      headers: headers,
    );
  }

  Future<dynamic> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return _send(
      method: 'POST',
      uri: uri,
      headers: headers,
      body: body,
    );
  }

  Future<dynamic> put(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return _send(
      method: 'PUT',
      uri: uri,
      headers: headers,
      body: body,
    );
  }

  Future<dynamic> patch(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return _send(
      method: 'PATCH',
      uri: uri,
      headers: headers,
      body: body,
    );
  }

  Future<dynamic> delete(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) {
    return _send(
      method: 'DELETE',
      uri: uri,
      headers: headers,
      body: body,
    );
  }

  Future<dynamic> _send({
    required String method,
    required Uri uri,
    Map<String, String>? headers,
    Object? body,
  }) async {
    try {
      _logger.fine('$method request: $uri');

      final requestHeaders = _buildHeaders(headers);
      final encodedBody = body == null ? null : jsonEncode(body);

      final response = await _executeRequest(
        method: method,
        uri: uri,
        headers: requestHeaders,
        body: encodedBody,
      ).timeout(timeout);

      _logger.fine(
        '$method response: ${response.statusCode} $uri',
      );

      return _handleResponse(response);
    } on async.TimeoutException catch (error, stackTrace) {
      _logger.warning(
        '$method request timed out: $uri',
      );

      throw TimeoutException(
        message: 'Request timed out',
        details: error.toString(),
        stackTrace: stackTrace,
      );
    } on SocketException catch (error, stackTrace) {
      _logger.warning(
        '$method network error: ${error.message}',
      );

      throw NetworkException(
        message: 'Unable to connect to the server',
        details: error.message,
        stackTrace: stackTrace,
      );
    } on http.ClientException catch (error, stackTrace) {
      _logger.warning(
        '$method HTTP client error: ${error.message}',
      );

      throw NetworkException(
        message: 'Unable to complete the network request',
        details: error.message,
        stackTrace: stackTrace,
      );
    } on AppException {
      rethrow;
    } on FormatException catch (error, stackTrace) {
      _logger.warning(
        '$method response parsing failed: ${error.message}',
      );

      throw ServerException(
        message: 'Invalid response received from server',
        details: error.message,
        stackTrace: stackTrace,
      );
    } catch (error, stackTrace) {
      _logger.severe(
        '$method unexpected HTTP error: $error',
        error,
        stackTrace,
      );

      throw NetworkException(
        message: 'An unexpected network error occurred',
        details: error.toString(),
        stackTrace: stackTrace,
      );
    }
  }

  Future<http.Response> _executeRequest({
    required String method,
    required Uri uri,
    required Map<String, String> headers,
    String? body,
  }) {
    switch (method) {
      case 'GET':
        return _client.get(
          uri,
          headers: headers,
        );

      case 'POST':
        return _client.post(
          uri,
          headers: headers,
          body: body,
        );

      case 'PUT':
        return _client.put(
          uri,
          headers: headers,
          body: body,
        );

      case 'PATCH':
        return _client.patch(
          uri,
          headers: headers,
          body: body,
        );

      case 'DELETE':
        return _client.delete(
          uri,
          headers: headers,
          body: body,
        );

      default:
        throw ArgumentError(
          'Unsupported HTTP method: $method',
        );
    }
  }

  Map<String, String> _buildHeaders(
    Map<String, String>? headers,
  ) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      ...?headers,
    };
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      return _decodeBody(response);
    }

    final errorDetails = _extractErrorDetails(response);

    switch (statusCode) {
      case 400:
        throw ValidationException(
          message: errorDetails.message,
          details: errorDetails.details,
        );

      case 401:
        throw AuthException(
          message: errorDetails.message,
          details: errorDetails.details,
        );

      case 403:
        throw AuthorizationException(
          message: errorDetails.message,
          details: errorDetails.details,
        );

      case 404:
        throw NotFoundException(
          message: errorDetails.message,
          details: errorDetails.details,
        );

      case 409:
        throw ConflictException(
          message: errorDetails.message,
          details: errorDetails.details,
        );

      default:
        throw ServerException(
          message: errorDetails.message,
          code: statusCode,
          details: errorDetails.details,
        );
    }
  }

  dynamic _decodeBody(http.Response response) {
    if (response.body.trim().isEmpty) {
      return null;
    }

    return jsonDecode(response.body);
  }

  _ErrorDetails _extractErrorDetails(
    http.Response response,
  ) {
    if (response.body.trim().isEmpty) {
      return _ErrorDetails(
        message: _defaultMessage(response.statusCode),
      );
    }

    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        final message = decoded['message']?.toString();

        return _ErrorDetails(
          message: message?.isNotEmpty == true
              ? message!
              : _defaultMessage(response.statusCode),
          details: response.body,
        );
      }

      return _ErrorDetails(
        message: decoded.toString(),
        details: response.body,
      );
    } on FormatException {
      return _ErrorDetails(
        message: response.body,
        details: response.body,
      );
    }
  }

  String _defaultMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request';

      case 401:
        return 'Authentication failed';

      case 403:
        return 'You are not authorized to perform this action';

      case 404:
        return 'Requested resource was not found';

      case 409:
        return 'The requested operation conflicts with existing data';

      default:
        if (statusCode >= 500) {
          return 'Server error occurred';
        }

        return 'HTTP request failed';
    }
  }

  void close() {
    _client.close();
  }
}

class _ErrorDetails {
  final String message;
  final String? details;

  const _ErrorDetails({
    required this.message,
    this.details,
  });
}