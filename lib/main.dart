import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpdesk/lista_projetos.dart';
import 'package:helpdesk/model/usuario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'configs/constantes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  final StatefulWidget home;

  if (prefs.containsKey(kLoginUsuario)) {
    Usuario usuario =
        Usuario.fromJson(jsonDecode(prefs.getString(kLoginUsuario)!));
    home = ListaProjetos(usuario);
  } else {
    home = const Login();
  }

  runApp(MyApp(home));
}

class MyApp extends StatelessWidget {
  MyApp(this.homeWidget, {Key? key}) : super(key: key);

  Widget homeWidget;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Help Desk',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(bodyText2: TextStyle(color: Colors.blue,),),
      ),
      home: homeWidget,
    );
  }
}
