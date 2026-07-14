import 'package:flutter_dotenv/flutter_dotenv.dart';

/// lê credenciais de --dart-define e, se ausentes, do ficheiro .env local.
class Env {
  static const String _metronUsernameFromDefine = String.fromEnvironment(
    'METRON_USERNAME',
  );
  static const String _metronPasswordFromDefine = String.fromEnvironment(
    'METRON_PASSWORD',
  );

  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {}
  }

  static String get metronUsername {
    if (_metronUsernameFromDefine.isNotEmpty) {
      return _metronUsernameFromDefine;
    }
    return dotenv.maybeGet('METRON_USERNAME') ?? '';
  }

  static String get metronPassword {
    if (_metronPasswordFromDefine.isNotEmpty) {
      return _metronPasswordFromDefine;
    }
    return dotenv.maybeGet('METRON_PASSWORD') ?? '';
  }

  static void validate() {
    assert(
      metronUsername.isNotEmpty,
      'METRON_USERNAME não definida. Define em .env (local) ou usa '
      '--dart-define=METRON_USERNAME=... / --dart-define-from-file=... ',
    );
    assert(
      metronPassword.isNotEmpty,
      'METRON_PASSWORD não definida. Define em .env (local) ou usa '
      '--dart-define=METRON_PASSWORD=... / --dart-define-from-file=... ',
    );
  }
}
