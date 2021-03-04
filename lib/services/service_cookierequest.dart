import 'dart:convert';
import 'package:http/http.dart'as http;

class ServiceCookieRequest{

  static final JsonDecoder _decoder = new JsonDecoder();
  static final JsonEncoder _encoder = new JsonEncoder();

  static Map<String, String> headers = {"content-type": "text/json"};
  static Map<String, String> cookies = {};

  static void _updateCookie(http.Response response) {
    String allSetCookie = response.headers['set-cookie'];

    if (allSetCookie != null) {

      var setCookies = allSetCookie.split(',');

      for (var setCookie in setCookies) {
        var cookies = setCookie.split(';');

        for (var cookie in cookies) {
          _setCookie(cookie);
        }
      }

      headers['cookie'] = _generateCookieHeader();
    }
  }

  static void _setCookie(String rawCookie) {
    if (rawCookie.length > 0) {
      var keyValue = rawCookie.split('=');
      if (keyValue.length == 2) {
        var key = keyValue[0].trim();
        var value = keyValue[1];

        // ignore keys that aren't cookies
        if (key == 'path' || key == 'expires')
          return;

        cookies[key] = value;
      }
    }
  }

  static String _generateCookieHeader() {
    String cookie = "";

    for (var key in cookies.keys) {
      if (cookie.length > 0)
        cookie += ";";
      cookie += key + "=" + cookies[key];
    }

    return cookie;
  }

  static Future<dynamic> get(String url) {
    return http.get(url, headers: headers).then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      _updateCookie(response);

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data : ${statusCode}");
      }


      print('ServiceCookieRequest : '+response.statusCode.toString());
      print('ServiceCookieRequest : '+res);

      return res;

    });


  }

  static Future<dynamic> post(String url, {body, encoding}) {
    return http
        .post(url, body: _encoder.convert(body), headers: headers, encoding: encoding)
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;

      _updateCookie(response);

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return _decoder.convert(res);
    });
  }


  static Future loginGroupWare() async {
    await ServiceCookieRequest.get(
        'http://gw.hakjisa.co.kr/LoginOK?CorpID=xxxxxxxxxx&UserID=kakao%40hakjisa.co.kr&UserPass=gkrwltk741%21%40&UserOTP=');
  }
}