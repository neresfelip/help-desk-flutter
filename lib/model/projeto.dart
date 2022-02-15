class Projeto {
  final int id;
  final int totalHoras;
  final DateTime? prevTermino;
  final String nome, descricao;
  final String cliente, responsavel, comercial;
  final String? executante;

  Projeto(
      {required this.id,
      required this.totalHoras,
      required this.prevTermino,
      required this.nome,
      required this.descricao,
      required this.cliente,
      required this.responsavel,
      required this.comercial,
      required this.executante});

  factory Projeto.fromJson(Map<String, dynamic> json) {
    return Projeto(
      id: int.parse(json['id']),
      totalHoras: int.parse(json['total_horas']),
      prevTermino: json['prev_termino'] != null ? DateTime.parse(json['prev_termino']) : null,
      descricao: json['descricao'],
      cliente: json['cliente'],
      responsavel: json['responsavel'],
      comercial: json['comercial'],
      executante: json['executante'],
      nome: json['nome'],
    );
  }
}
