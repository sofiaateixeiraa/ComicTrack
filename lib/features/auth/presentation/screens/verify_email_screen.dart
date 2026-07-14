import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/error/failures.dart';
import '../providers/auth_providers.dart';

const _red = Color(0xFFE53935);
const _resendCooldownSeconds = 60;

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  bool _checking = false;
  bool _resending = false;
  String? _message;
  int _cooldown = 0;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() => _cooldown = _resendCooldownSeconds);
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() => _cooldown--);
      if (_cooldown <= 0) timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.mark_email_unread_outlined,
                color: _red,
                size: 56,
              ),
              const SizedBox(height: 24),
              const Text(
                'Confirme o seu email',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Enviámos um link de confirmação para ${user?.email ?? 'o seu email'}. Abre-o para continuar a usar a app.',
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
              if (_message != null) ...[
                const SizedBox(height: 16),
                Text(
                  _message!,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _checking ? null : _checkVerified,
                child: _checking
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Já confirmei'),
              ),
              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: (_resending || _cooldown > 0) ? null : _resend,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(color: Colors.white24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _resending
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white70,
                        ),
                      )
                    : Text(
                        _cooldown > 0
                            ? 'Reenviar email (${_cooldown}s)'
                            : 'Reenviar email',
                        style: const TextStyle(color: Colors.white70),
                      ),
              ),
              const SizedBox(height: 16),

              Center(
                child: GestureDetector(
                  onTap: () => ref.read(signOutProvider).call(),
                  child: const Text(
                    'Terminar sessão',
                    style: TextStyle(color: Colors.white38, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkVerified() async {
    setState(() {
      _checking = true;
      _message = null;
    });
    final result = await ref.read(reloadCurrentUserProvider).call();
    if (!mounted) return;
    setState(() => _checking = false);
    result.fold(
      (_) => setState(
        () => _message = 'Não foi possível verificar agora. Tente de novo.',
      ),
      (_) => setState(
        () => _message =
            'Ainda não confirmámos o seu email. Verifique a caixa de entrada.',
      ),
    );
  }

  Future<void> _resend() async {
    setState(() {
      _resending = true;
      _message = null;
    });
    final result = await ref.read(sendEmailVerificationProvider).call();
    if (!mounted) return;
    setState(() => _resending = false);
    result.fold(
      (failure) => setState(() {
        _message = switch (failure) {
          AuthFailure(:final message) => message,
          _ => 'Não foi possível enviar o email. Tente novamente mais tarde.',
        };
      }),
      (_) {
        setState(
          () => _message = 'Email reenviado! Verifique também a pasta de spam.',
        );
        _startCooldown();
      },
    );
  }
}
