class LogInWithEmailAndPasswordFailure {
  final String message;
  const LogInWithEmailAndPasswordFailure([this.message = "An Unknown error occurred."]);

  factory LogInWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure('Email is not valid or badly formatted.');
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure('This user has been disabled. Please contact support for help.');
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure('No user found with this email.');
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure('Wrong password.');
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }
}
