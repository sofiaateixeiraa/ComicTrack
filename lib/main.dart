import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/router.dart';
import 'app/theme.dart';
import 'core/config/env.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'features/auth/presentation/providers/user_profile_providers.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.load();
  Env.validate();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // ativa persistência offline do firestore.
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  runApp(const ProviderScope(child: ComicTrackApp()));
}

class ComicTrackApp extends ConsumerWidget {
  const ComicTrackApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    ref.listen(currentUserProvider, (previous, next) {
      if (next == null) return;
      ref
          .read(ensureUserProfileProvider)
          .call(
            uid: next.uid,
            email: next.email,
            name: next.displayName?.isNotEmpty == true
                ? next.displayName!
                : next.email,
          );
    });
    return MaterialApp.router(
      title: 'ComicTrack',
      theme: AppTheme.dark,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
