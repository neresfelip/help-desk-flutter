import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:helpdesk/configs/constantes.dart';
import 'package:helpdesk/model/projeto.dart';
import 'package:helpdesk/rede/requisicao.dart';
import 'model/lancamento.dart';
import 'package:intl/intl.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ProjetoDetalhes extends StatefulWidget {
  Projeto projeto;

  ProjetoDetalhes(this.projeto, {Key? key}) : super(key: key);

  @override
  _ProjetoDetalhesState createState() => _ProjetoDetalhesState();
}

class _ProjetoDetalhesState extends State<ProjetoDetalhes> {
  List<Lancamento> lancamentos = [];

  @override
  void initState() {
    super.initState();
    _loadLancamentos();
  }

  _loadLancamentos() async {
    Map<String, String> parametros = {
      'id_projeto': widget.projeto.id.toString(),
    };

    List<dynamic> list = await Requisicao(
            url: 'http://35.198.47.229:8075/api/lancamentos_projeto',
            tipo: Tipo.get,
            context: context,
            parametros: parametros)
        .execute('Carregando...');

    for (dynamic jsonLancamento in list) {
      lancamentos.add(Lancamento.fromJson(jsonLancamento));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        //decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('images/bg_abstract_blue.jpg'), fit: BoxFit.fitHeight)),
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    expandedHeight: orientation == Orientation.portrait ? 270 : 200,
                    floating: true,
                    pinned: false,
                    snap: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: Container(
                        color: Colors.blue,
                        padding: orientation == Orientation.portrait ?
                        const EdgeInsets.only(top: 60, right: 20, left: 20) :
                        const EdgeInsets.only(top: 32, right: 20, left: 20),
                        child: Column(
                          //verticalDirection: VerticalDirection.up,
                            children: [
                              TextButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Descrição'),
                                          content: Text(widget.projeto.descricao),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Ok"),
                                            )
                                          ],
                                        );
                                      });
                                },
                                child: Text(
                                  widget.projeto.descricao,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: orientation == Orientation.portrait ? 5 : 3,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Linha(
                                  campo: 'Responsável',
                                  valor: widget.projeto.responsavel),
                              Linha(
                                  campo: 'Comercial',
                                  valor: widget.projeto.comercial),
                              Linha(
                                  campo: 'Executante',
                                  valor: widget.projeto.executante),
                              Linha(
                                  campo: 'Total de horas',
                                  valor: widget.projeto.totalHoras.toString()),
                              Linha(
                                  campo: 'Previsão de término',
                                  valor: DateFormat("dd-MM-yyyy")
                                      .format(widget.projeto.prevTermino!)),
                            ]),
                      ),
                    ),
                    title: Text(
                      widget.projeto.nome,
                      style: const TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ];
              },
              body: lancamentos.isEmpty
                  ? Column( mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(MaterialIcons.clear, color: Colors.blue, size: 80,),
                  Text('Sem lançamentos até o momento'),
                ],
              )
                  : ListView.builder(
                padding: kPaddingMedio,
                itemCount: lancamentos.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const Text(
                      'Lançamentos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }

                  Lancamento lancamento = lancamentos[index - 1];

                  return Container(
                    decoration: BoxDecoration(
                        border:
                        Border.all(width: 1, color: Colors.blue.shade100),
                        color: Colors.white),
                    margin: kPaddingPequeno,
                    padding: kPaddingMedio,
                    child: Column(
                      children: [
                        Linha2(icon: MaterialIcons.access_time, valor: DateFormat("yyyy-MM-dd HH:mm").format(lancamento.dataInicio)),
                        Linha2(icon: MaterialIcons.description, valor: lancamento.descricao),
                        Linha2(icon: MaterialIcons.person, valor: lancamento.colaborador),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class Linha extends StatelessWidget {
  Linha({required this.campo, required this.valor});

  String campo;
  String? valor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          campo + ':',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(valor ?? '-', style: const TextStyle(
          color: Colors.white,
        ),),
      ],
    );
  }
}

class Linha2 extends StatelessWidget {
  Linha2({required this.icon, required this.valor});

  IconData icon;
  String valor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue,),
        const SizedBox(
          width: 10,
        ),
        Flexible(child: Text(valor, style: const TextStyle(color: Colors.black54),)),
      ],
    );
  }
}


