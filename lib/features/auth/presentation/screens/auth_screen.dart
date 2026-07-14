import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../providers/auth_providers.dart';
import '../providers/user_profile_providers.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _loading = false;
  bool _isRegister = false;
  bool _obscurePassword = true;
  String? _error;

  void _toggleMode() {
    setState(() {
      _isRegister = !_isRegister;
      _error = null;
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final isRegister = _isRegister;
    if (isRegister && _passCtrl.text != _confirmPassCtrl.text) {
      setState(() => _error = 'As palavra-passes não coincidem.');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    final signInUseCase = ref.read(signInProvider);
    final registerUseCase = ref.read(registerProvider);
    final createProfile = ref.read(createUserProfileProvider);
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    final name = _nameCtrl.text.trim();

    final result = isRegister
        ? await registerUseCase.call(
            email: email,
            password: pass,
            name: name.isEmpty ? null : name,
          )
        : await signInUseCase.call(email: email, password: pass);

    result.fold(
      (failure) {
        if (!mounted) return;
        setState(() {
          _error = switch (failure) {
            AuthFailure(:final message) => message,
            NetworkFailure(:final message) => message,
            _ => 'Ocorreu um erro. Tente de novo.',
          };
          _loading = false;
        });
      },
      (appUser) async {
        // router redireciona automaticamente para /home ou /verify-email via authState.
        if (isRegister) {
          await createProfile.call(
            uid: appUser.uid,
            email: appUser.email,
            name: name.isEmpty ? appUser.email : name,
          );
        }
      },
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final signInWithGoogleUseCase = ref.read(signInWithGoogleProvider);
    final ensureProfile = ref.read(ensureUserProfileProvider);
    final result = await signInWithGoogleUseCase.call();

    result.fold(
      (failure) {
        if (!mounted) return;
        setState(() {
          _error = switch (failure) {
            AuthFailure(:final message) => message,
            NetworkFailure(:final message) => message,
            _ => 'Ocorreu um erro. Tente de novo.',
          };
          _loading = false;
        });
      },
      (appUser) async {
        // router redireciona automaticamente para /home via authState.
        await ensureProfile.call(
          uid: appUser.uid,
          email: appUser.email,
          name: appUser.displayName?.isNotEmpty == true
              ? appUser.displayName!
              : appUser.email,
        );
      },
    );
  }

  Future<void> _forgotPassword() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Insira o seu email primeiro.');
      return;
    }
    final result = await ref.read(resetPasswordProvider).call(email: email);
    result.fold(
      (f) => setState(() => _error = 'Erro ao enviar email.'),
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email de recuperação enviado!')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              // Logo
              Center(child: Image.asset('assets/brand/logo.png', height: 100)),
              const SizedBox(height: 4),
              const Center(
                child: Text(
                  'A tua coleção, sempre contigo.',
                  style: TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ),
              const SizedBox(height: 32),

              Text(
                _isRegister ? 'Criar Conta' : 'Iniciar Sessão',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // nome completo, apenas no registo.
              if (_isRegister) ...[
                const Text(
                  'Nome Completo',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(hintText: 'O teu nome'),
                ),
                const SizedBox(height: 20),
              ],

              // email.
              const Text(
                'Email',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'exemplo@email.com',
                ),
              ),
              const SizedBox(height: 20),

              // palavra-passe.
              const Text(
                'Palavra-passe',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passCtrl,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white38,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // confirmar palavra-passe, apenas no registo.
              if (_isRegister) ...[
                const Text(
                  'Confirmar palavra-passe',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _confirmPassCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: '••••••••'),
                ),
                const SizedBox(height: 12),
              ],

              // esqueci-me da palavra-passe.
              if (!_isRegister)
                GestureDetector(
                  onTap: _forgotPassword,
                  child: const Text(
                    'Esqueci-me da palavra-passe',
                    style: TextStyle(
                      color: Color(0xFFE53935),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(
                  _error!,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                ),
              ],

              const SizedBox(height: 24),

              // botão submit.
              ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(_isRegister ? 'Criar Conta' : 'Entrar'),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  const Expanded(child: Divider(color: Colors.white24)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'OU',
                      style: const TextStyle(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider(color: Colors.white24)),
                ],
              ),

              const SizedBox(height: 20),

              // continuar com google.
              OutlinedButton(
                onPressed: _loading ? null : _signInWithGoogle,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(3),
                      child: CustomPaint(
                        size: const Size(14, 14),
                        painter: _GoogleLogoPainter(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Continuar com Google',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // alternar entre iniciar sessão e criar conta.
              Center(
                child: GestureDetector(
                  onTap: _loading ? null : _toggleMode,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: _isRegister
                              ? 'Já tens conta? '
                              : 'Ainda não tens conta? ',
                        ),
                        TextSpan(
                          text: _isRegister ? 'Iniciar Sessão' : 'Regista-te',
                          style: const TextStyle(
                            color: Color(0xFFE53935),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 18, size.height / 18);

    final blue = Paint()..color = const Color(0xFF4285F4);
    final blueMoveTo = Path()
      ..moveTo(17.64, 9.2045)
      ..cubicTo(17.64, 8.5664, 17.5827, 7.9527, 17.4764, 7.3636)
      ..lineTo(9, 7.3636)
      ..lineTo(9, 10.8454)
      ..lineTo(13.8436, 10.8454)
      ..cubicTo(13.635, 11.9704, 13.0009, 12.9236, 12.0477, 13.5618)
      ..lineTo(12.0477, 15.8199)
      ..lineTo(14.9564, 15.8199)
      ..cubicTo(16.6582, 14.2531, 17.64, 11.9458, 17.64, 9.2045)
      ..close();
    canvas.drawPath(blueMoveTo, blue);

    final green = Paint()..color = const Color(0xFF34A853);
    final greenPath = Path()
      ..moveTo(9, 18)
      ..cubicTo(11.43, 18, 13.4673, 17.1936, 14.9564, 15.8182)
      ..lineTo(12.0477, 13.5601)
      ..cubicTo(11.2413, 14.1001, 10.2109, 14.4192, 9.0, 14.4192)
      ..cubicTo(6.6564, 14.4192, 4.6718, 12.8365, 3.9641, 10.7088)
      ..lineTo(0.9573, 10.7088)
      ..lineTo(0.9573, 13.0406)
      ..cubicTo(2.4382, 15.9832, 5.4818, 18, 9, 18)
      ..close();
    canvas.drawPath(greenPath, green);

    final yellow = Paint()..color = const Color(0xFFFBBC05);
    final yellowPath = Path()
      ..moveTo(3.9641, 10.71)
      ..cubicTo(3.7841, 10.17, 3.6818, 9.5932, 3.6818, 9.0)
      ..cubicTo(3.6818, 8.4068, 3.7841, 7.83, 3.9641, 7.29)
      ..lineTo(3.9641, 4.9582)
      ..lineTo(0.9573, 4.9582)
      ..cubicTo(0.3477, 6.1732, 0, 7.5477, 0, 9)
      ..cubicTo(0, 10.4523, 0.3477, 11.8268, 0.9573, 13.0418)
      ..lineTo(3.9641, 10.71)
      ..close();
    canvas.drawPath(yellowPath, yellow);

    final red = Paint()..color = const Color(0xFFEA4335);
    final redPath = Path()
      ..moveTo(9, 3.5795)
      ..cubicTo(10.3214, 3.5795, 11.5077, 4.0336, 12.4405, 4.9255)
      ..lineTo(15.0218, 2.3441)
      ..cubicTo(13.4632, 0.8918, 11.4259, 0, 9, 0)
      ..cubicTo(5.4818, 0, 2.4382, 2.0168, 0.9573, 4.9582)
      ..lineTo(3.9641, 7.29)
      ..cubicTo(4.6718, 5.1618, 6.6564, 3.5795, 9, 3.5795)
      ..close();
    canvas.drawPath(redPath, red);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
