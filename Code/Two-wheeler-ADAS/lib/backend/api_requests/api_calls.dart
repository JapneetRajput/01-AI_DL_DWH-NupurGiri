import 'dart:convert';
import 'dart:typed_data';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class GetTemperatureCall {
  static Future<ApiCallResponse> call({
    String? lat = '19.175547',
    String? lon = '72.972099',
    String? openweathermapApiKey = '684801857014478630501eb36e38614c',
    String? iconImage = 'http://openweathermap.org/img/w/[WeatherIcon].png',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'Get Temperature',
      apiUrl:
          'https://api.openweathermap.org/data/2.5/weather?lat=${lat}&lon=${lon}&appid=${openweathermapApiKey}&units=metric',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'Lat': lat,
        'Lon': lon,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
    );
  }

  static dynamic currentTemp(dynamic response) => getJsonField(
        response,
        r'''$.main.temp''',
      );
  static dynamic weatherIcon(dynamic response) => getJsonField(
        response,
        r'''$.weather[:].icon''',
      );
  static dynamic weatherConditionName(dynamic response) => getJsonField(
        response,
        r'''$.weather[:].main''',
      );
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list);
  } catch (_) {
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar);
  } catch (_) {
    return isList ? '[]' : '{}';
  }
}
