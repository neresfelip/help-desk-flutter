import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:helpdesk/components/mdialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

enum Tipo { get, post }

class Requisicao {
  Requisicao({
    required this.url,
    required this.tipo,
    required this.context,
    this.parametros,
  });

  String url;
  Tipo tipo;
  BuildContext context;
  Map<String, String>? parametros;

  Future<List<dynamic>> execute(String message) async {

    await Future.delayed(const Duration(milliseconds: 1));

    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.mobile && connectivityResult != ConnectivityResult.wifi) {
      _exibeSnackBar('Verifique sua conexão com a internet');
      throw Exception('Erro de conexão');
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return MDialog(message);
        });

    final http.Response response;

    switch (tipo) {
      case Tipo.get:

        if (parametros != null) {
          url += '?';
          for (String key in parametros!.keys) {
            url += key + "=" + parametros![key]! + "&";
          }
          url = url.substring(0, url.length - 1);
        }

        response = await http.get(
          Uri.parse(url),
        );
        break;

      case Tipo.post:
        response = await http.post(
          Uri.parse(url),
          body: parametros,
        );
        break;
    }

    if (response.statusCode != 200) {
      _exibeSnackBar('Erro ${response.statusCode}');
      Navigator.pop(context);
      throw Exception('status code: ${response.statusCode}');
    }

    Map<String, dynamic> json = jsonDecode(response.body);

    if (json['status'] != 1) {
      _exibeSnackBar(json['message']);
      Navigator.pop(context);
      throw Exception(json['message']);
    }

    Navigator.pop(context);
    return json['data'];

  }

  _exibeSnackBar(String msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Ok',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
