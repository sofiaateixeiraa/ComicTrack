import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/auth/presentation/screens/auth_screen.dart';
import '../features/auth/presentation/screens/change_email_screen.dart';
import '../features/auth/presentation/screens/change_password_screen.dart';
import '../features/auth/presentation/screens/edit_profile_screen.dart';
import '../features/auth/presentation/screens/profile_screen.dart';
import '../features/auth/presentation/screens/verify_email_screen.dart';
import '../features/catalog/presentation/screens/issue_detail_screen.dart';
import '../features/catalog/presentation/screens/publisher_series_screen.dart';
import '../features/catalog/presentation/screens/series_detail_screen.dart';
import '../features/catalog/presentation/screens/search_screen.dart';
import '../features/collection/presentation/screens/full_list_screen.dart';
import '../features/collection/presentation/screens/home_screen.dart';
part 'router.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/auth',
    redirect: (context, state) {
      final user = authState.asData?.value;
      final isLoggedIn = user != null;
      final onAuth = state.matchedLocation == '/auth';
      final onVerifyEmail = state.matchedLocation == '/verify-email';
      // só contas com password precisam de confirmar o email.
      final needsVerification =
          isLoggedIn && user.hasPasswordProvider && !user.emailVerified;

      if (!isLoggedIn && !onAuth) return '/auth';
      if (isLoggedIn && onAuth) return needsVerification ? '/verify-email' : '/home';
      if (needsVerification && !onVerifyEmail) return '/verify-email';
      if (!needsVerification && onVerifyEmail) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/auth', builder: (_, _) => const AuthScreen()),
      GoRoute(
        path: '/verify-email',
        builder: (_, _) => const VerifyEmailScreen(),
      ),
      GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
      GoRoute(path: '/search', builder: (_, _) => const SearchScreen()),
      GoRoute(
        path: '/publisher/:id',
        builder: (_, state) => PublisherSeriesScreen(
          publisherId: state.pathParameters['id']!,
          publisherName: state.uri.queryParameters['name'] ?? '',
        ),
      ),
      GoRoute(
        // lista de issues da serie.
        path: '/series/:id',
        builder: (_, state) =>
            SeriesDetailScreen(seriesId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/issue/:id',
        builder: (_, state) =>
            IssueDetailScreen(issueId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
      GoRoute(
        path: '/profile/edit',
        builder: (_, _) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/change-email',
        builder: (_, _) => const ChangeEmailScreen(),
      ),
      GoRoute(
        path: '/profile/change-password',
        builder: (_, _) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: '/list/:type',
        builder: (_, state) =>
            FullListScreen(type: state.pathParameters['type']!),
      ),
    ],
  );
}
