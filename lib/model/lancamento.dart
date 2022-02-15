import 'package:flutter/material.dart';

class Lancamento {
  int id, idProjeto;
  DateTime dataInicio, dataFim;
  String diffHoras, diffMinutos;
  String descricao, atividade, colaborador;
  int ticket;

  Lancamento(
      {required this.id,
      required this.idProjeto,
      required this.dataInicio,
      required this.dataFim,
      required this.diffHoras,
      required this.diffMinutos,
      required this.descricao,
      required this.atividade,
      required this.colaborador,
      required this.ticket});

  factory Lancamento.fromJson(Map<String, dynamic> json) {
    return Lancamento(
        id: int.parse(json['id']),
        idProjeto: int.parse(json['id_projeto']),
        dataInicio: DateTime.parse(json['dt_inicio']),
        dataFim: DateTime.parse(json['dt_fim']),
        diffHoras: json['diff_horas'],
        diffMinutos: json['diff_minutos'],
        descricao: json['descricao'],
        atividade: json['atividade'],
        colaborador: json['colaborador'],
        ticket: int.parse(json['ticket']));
  }
}
