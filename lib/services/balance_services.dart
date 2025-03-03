import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class BalanceServices {
  String url = "http://192.168.1.143:3000/balance";

  Future<bool> hasPin({required String userId}) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$url/has-pin"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            "userId": userId,
          },
        ),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body)["hasPin"];
      }

      return false;
    } on http.ClientException catch (e) {
      throw http.ClientException(
        e.message,
      );
    } on SocketException catch (e) {
      throw SocketException(
        e.message,
      );
    } on Exception catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<double> createPin({
    required String userId,
    required String pin,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$url/create-pin"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "userId": userId,
          "newPin": pin,
        }),
      );

      if (response.statusCode == 200) {
        return (json.decode(response.body)["balance"] as int).toDouble();
      } else {
        throw CreatePinException("Ocorreu ao criar seu PIN, por favor tente novamente...");
      }
    } on CreatePinException catch (e) {
      throw CreatePinException(
        e.message,
      );
    } on http.ClientException catch (e) {
      throw http.ClientException(
        e.message,
      );
    } on SocketException catch (e) {
      throw SocketException(
        e.message,
      );
    } on Exception catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  Future<double> getBalance({
    required String userId,
    required String pin,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$url/user-balance"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "userId": userId,
          "pin": pin,
        }),
      );

      if (response.statusCode == 200) {
        return (json.decode(response.body)["balance"] as int).toDouble();
      } else {
        throw AuthenticationException("PIN inválido, verifique-o e tente novamente...");
      }
    } on AuthenticationException catch (e) {
      throw AuthenticationException(
        e.message,
      );
    } on http.ClientException catch (e) {
      throw http.ClientException(
        e.message,
      );
    } on SocketException catch (e) {
      throw SocketException(
        e.message,
      );
    } on Exception catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}

class AuthenticationException extends http.ClientException {
  AuthenticationException(super.message);
}

class CreatePinException extends http.ClientException {
  CreatePinException(super.message);
}
