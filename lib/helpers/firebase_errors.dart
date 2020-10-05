String getErrorString(String code){
  switch (code) {
    case 'weak-password':
      return 'Sua senha é muito fraca.';
    case 'invalid-email':
      return 'Seu e-mail é inválido.';
    case 'account-exists-with-different-credential':
      return 'E-mail já está sendo utilizado em outra conta.';
    case 'invalid-credential':
      return 'Seu e-mail é inválido.';
    case 'wrong-password':
      return 'Sua senha está incorreta.';
    case 'user-not-found':
      return 'Não há usuário com este e-mail.';
    case 'user-disabled':
      return 'Este usuário foi desabilitado.';
    case 'too-many-requests':
      return 'Muitas solicitações. Tente novamente mais tarde.';
    case 'operation-not-allowed':
      return 'Operação não permitida.';
    case 'firebase_auth':
      return 'Operação não permitida.';

    default:
      return 'Um erro indefinido ocorreu.';
  }
} 