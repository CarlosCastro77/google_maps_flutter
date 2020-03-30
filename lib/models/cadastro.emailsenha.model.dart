class CadastroEmailSenhaModel {
  String email;
  String senha;

  CadastroEmailSenhaModel({this.email, this.senha});

  Map<String, dynamic> toJson() => {
        'Email': email,
        'Senha': senha,
      };
}
