class CadastroClienteModel {
  String nome;
  String cpf;
  String dataNascimento;

  CadastroClienteModel({
    this.nome,
    this.cpf,
    this.dataNascimento,
  });

  Map<String, dynamic> toJson() => {
        'Nome': nome,
        'Cpf': cpf,
        'DataNascimento': dataNascimento,
      };
}
