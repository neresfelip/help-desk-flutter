import 'package:flutter/material.dart';
import 'package:helpdesk/components/mdialog.dart';
import 'package:helpdesk/configs/constantes.dart';
import 'package:helpdesk/projeto_detalhes.dart';
import 'package:helpdesk/rede/requisicao.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';
import 'model/usuario.dart';
import 'model/projeto.dart';
import 'sobre_nos.dart';

Usuario? usuario;

class ListaProjetos extends StatefulWidget {
  ListaProjetos(Usuario user, {Key? key}) : super(key: key) {
    usuario = user;
  }

  @override
  _ListaProjetosState createState() => _ListaProjetosState();
}

class _ListaProjetosState extends State<ListaProjetos> {
  List<Projeto> projetos = [];

  @override
  void initState() {
    super.initState();
    _loadProjetos();
  }

  _loadProjetos() async {
    List<dynamic> list = await Requisicao(
            url: 'http://35.198.47.229:8075/api/get_projetos',
            tipo: Tipo.get,
            context: context)
        .execute('Carregando...');

    for (dynamic jsonProjeto in list) {
      projetos.add(Projeto.fromJson(jsonProjeto));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Projetos',
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SobreNos(),
                  ),
                );
              },
              icon: const Icon(Icons.info_outline)),
          IconButton(
            icon: const Icon(
              Icons.logout,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text('Deseja sair deste usuário?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Não')),
                        TextButton(
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.remove(kLoginUsuario);

                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()));
                            },
                            child: const Text('Sim')),
                      ],
                    );
                  });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('images/bg_abstract_blue.png'),
            fit: BoxFit.fitHeight,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), BlendMode.dstATop),
          ),
        ),
        child: projetos.isEmpty
            ? Center(
                child: OutlinedButton(
                  onPressed: () {
                    _loadProjetos();
                  },
                  child: const Text('Tentar novamente'),
                ),
              )
            : OrientationBuilder(
                builder: (BuildContext context, Orientation orientation) {
                  return GridView.builder(
                      padding: const EdgeInsets.all(10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            orientation == Orientation.portrait ? 2 : 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: projetos.length,
                      itemBuilder: (context, index) {
                        Projeto projeto = projetos[index];

                        return OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shadowColor: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProjetoDetalhes(projeto)));
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                projeto.nome,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                projeto.cliente,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                },
              ),
      ),
    );
  }
}
