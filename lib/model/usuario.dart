class Usuario {
  final int id, idCliente, idCadastrante;
  final String nome, email;
  final DateTime dataCadastro;


  Usuario(this.id, this.idCliente, this.nome, this.email, this.dataCadastro, this.idCadastrante);

  factory Usuario.fromJson(Map<String, dynamic> json) {

    return Usuario(
      int.parse(json['id']),
      int.parse(json['id_cliente']),
      json['nome'],
      json['email'],
      DateTime.parse(json['dt_cadastro']),
      int.parse(json['id_cadastrante']),
    );
  }

}