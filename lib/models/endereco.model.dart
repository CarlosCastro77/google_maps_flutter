class EnderecoModel {
  String rua;
  String cep;
  String pais;
  String bairro;
  String numero;
  String cidade;
  String estado;

  EnderecoModel(
      {this.rua,
      this.cep,
      this.pais,
      this.bairro,
      this.numero,
      this.cidade,
      this.estado});

  Map<String, dynamic> toJson() => {
        'Rua': rua,
        'Cep': cep,
        'Pais': pais,
        'Bairro': bairro,
        'Numero': numero,
        'Cidade': cidade,
        'Estado': estado
      };
}
