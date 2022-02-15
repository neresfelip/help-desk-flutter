import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:helpdesk/rede/requisicao.dart';
import 'configs/constantes.dart';
import 'components/campo_de_texto.dart';
import 'lista_projetos.dart';

import 'model/usuario.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

String email = '', senha = '';

class _LoginState extends State<Login> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return Container(
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('images/bg_help_desk.jpg'),
                  fit: orientation == Orientation.portrait
                      ? BoxFit.fitHeight
                      : BoxFit.fitWidth,
                  alignment: Alignment.bottomRight,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.1), BlendMode.dstATop),
                ),
              ),
              child: orientation == Orientation.portrait
                  ? Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const ContainerLogo(),
                          ContainerCentral(),
                          const Rodape(),
                        ],
                      ),
                    ),
                  )
                  : Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                ContainerLogo(),
                                Rodape(),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(child: ContainerCentral()),
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}

class ContainerLogo extends StatelessWidget {
  const ContainerLogo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "images/logo.png",
      height: 200,
    );
  }
}

class ContainerCentral extends StatefulWidget {


  ContainerCentral({Key? key}) : super(key: key);

  @override
  State<ContainerCentral> createState() => _ContainerCentralState();
}

class _ContainerCentralState extends State<ContainerCentral> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: kPaddingPadrao,
      padding: kPaddingPadrao,
      alignment: AlignmentDirectional.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EntradaTexto(
            hint: 'E-mail',
            inputType: TextInputType.emailAddress,
            onChanged: (value) {
              email = value;
            },
          ),
          const SizedBox(
            height: 20,
          ),
          EntradaTexto(
            hint: 'Senha',
            inputType: TextInputType.visiblePassword,
            onChanged: (value) {
              senha = value;
            },
            obscure: true,
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            child: const Text('ENTRAR'),
            onPressed: () {
              _login(context, email, senha);
            },
          ),
          /*TextButton(
            child: const Text('Esqueci a senha'),
            onPressed: () {},
          ),*/
        ],
      ),
    );
  }
}

class Rodape extends StatelessWidget {
  const Rodape({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          'Desenvolvido por:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 20,
        ),
        Image(
          image: AssetImage('images/logo_ri.png'),
          height: 60,
        ),
      ],
    );
  }
}

_login(dynamic context, String email, String senha) async {
  Map<String, String> parametros = {
    'email': email,
    'senha': senha,
  };

  List<dynamic> list = await Requisicao(
          url: 'http://35.198.47.229:8075/api/login',
          tipo: Tipo.post,
          context: context,
          parametros: parametros)
      .execute('Entrando...');

  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setString(kLoginUsuario, jsonEncode(list[0]));

  Usuario usuario = Usuario.fromJson(list[0]);
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => ListaProjetos(usuario)));
}
