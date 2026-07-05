/// lê credenciais injetadas via --dart-define no build.
class Env {
  static const String metronUsername = String.fromEnvironment(
    'METRON_USERNAME',
  );
  static const String metronPassword = String.fromEnvironment(
    'METRON_PASSWORD',
  );

  static void validate() {
    assert(
      metronUsername.isNotEmpty,
      'METRON_USERNAME não definida. Usa --dart-define=METRON_USERNAME=...',
    );
    assert(
      metronPassword.isNotEmpty,
      'METRON_PASSWORD não definida. Usa --dart-define=METRON_PASSWORD=...',
    );
  }
}
