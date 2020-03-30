class LoginBloc {
  static String errosLogin(String errorCode) {
    switch (errorCode) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        return "Este endereço de email já está em uso.";

      case 'ERROR_USER_NOT_FOUND':
        return "Usuário não existe, favor criar uma conta.";

      case 'ERROR_INVALID_EMAIL':
        return "O email informado é inválido";

      case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
        return "Senha incorreta.";

      case 'ERROR_WRONG_PASSWORD':
        return "Senha incorreta.";

      case 'ERROR_USER_DISABLED':
        return "Conta não existe, você pode criar uma conta";

      default:
        return "An error has occurred";
    }
  }
}
