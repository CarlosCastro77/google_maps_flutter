class CadastroEmpresaModel {
  String razaoSocial;
  String cnpj;
  String nomeFantasia;

  CadastroEmpresaModel({this.razaoSocial, this.cnpj, this.nomeFantasia});

  Map<String, dynamic> toJson() => {
        'RazaoSocial': razaoSocial,
        'Cnpj': cnpj,
        'NomeFantasia': nomeFantasia,
      };
}
