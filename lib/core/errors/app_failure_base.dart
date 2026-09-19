abstract class AppFailure {
  const AppFailure(this.code, {this.message = ''});

  final String code;
  final String message;
}
