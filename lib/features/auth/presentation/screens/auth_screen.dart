import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_providers.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> with SingleTickerProviderStateMixin {
  late final TabController _tab;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _tab.addListener(() => setState(() => _error = null));
  }

  @override
  void dispose() {
    _tab.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() { _loading = true; _error = null; });
    final repo = ref.read(authRepositoryProvider);
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;

    final result = _tab.index == 0
        ? await repo.signIn(email: email, password: pass)
        : await repo.register(email: email, password: pass);

    result.fold(
      (failure) => setState(() {
        _error = switch (failure) {
          AuthFailure(:final message) => message,
          NetworkFailure(:final message) => message,
          _ => 'Ocorreu um erro. Tenta de novo.',
        };
        _loading = false;
      }),
      (_) { /* router redireciona automaticamente via authState */ },
    );
  }

  Future<void> _forgotPassword() async {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty) {
      setState(() => _error = 'Insere o teu email primeiro.');
      return;
    }
    final result = await ref.read(authRepositoryProvider).resetPassword(email: email);
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              // Logo
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'COMIC',
                      style: GoogleFonts.bangers(fontSize: 42, color: Colors.white),
                    ),
                    TextSpan(
                      text: 'TRACK',
                      style: GoogleFonts.bangers(fontSize: 42, color: const Color(0xFFE53935)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              const Text('A tua coleção, sempre contigo.',
                  style: TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 40),

              // Tabs Entrar / Registar
              TabBar(
                controller: _tab,
                indicatorColor: const Color(0xFFE53935),
                labelColor: const Color(0xFFE53935),
                unselectedLabelColor: Colors.white54,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                tabs: const [Tab(text: 'Entrar'), Tab(text: 'Registar')],
              ),
              const SizedBox(height: 32),

              // Email
              const Text('Email', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 8),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'teu@email.com'),
              ),
              const SizedBox(height: 20),

              // Password
              const Text('Password', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 8),
              TextField(
                controller: _passCtrl,
                obscureText: true,
                decoration: const InputDecoration(hintText: '••••••••'),
              ),
              const SizedBox(height: 12),

              // Esqueci-me (apenas no tab Login)
              if (_tab.index == 0)
                GestureDetector(
                  onTap: _forgotPassword,
                  child: const Text(
                    'Esqueci-me da password',
                    style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.bold),
                  ),
                ),

              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
              ],

              const SizedBox(height: 24),

              // Botão submit
              AnimatedBuilder(
                animation: _tab,
                builder: (_, __) => ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(_tab.index == 0 ? 'Entrar' : 'Criar conta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}