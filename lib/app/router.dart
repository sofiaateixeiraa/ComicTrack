import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/auth/presentation/screens/auth_screen.dart';
import '../features/auth/presentation/screens/profile_screen.dart';
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
      final isLoggedIn = authState.asData?.value != null;
      final onAuth = state.matchedLocation == '/auth';

      if (!isLoggedIn && !onAuth) return '/auth';
      if (isLoggedIn && onAuth) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/auth', builder: (_, _) => const AuthScreen()),
      GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
      GoRoute(path: '/search', builder: (_, _) => const SearchScreen()),
      GoRoute(
        path: '/publisher/:id',
        builder: (_, state) => PublisherSeriesScreen(
          publisherId: state.pathParameters['id']!,
          publisherName: state.uri.queryParameters['name'] ?? '',
        ),
      ),
      GoRoute(   // mostra a lista de issues da série
        path: '/series/:id',
        builder: (_, state) => SeriesDetailScreen(seriesId: state.pathParameters['id']!),
      ),
      GoRoute(   // é aqui que se faz o tracking (posse / leitura / favorito)
        path: '/issue/:id',
        builder: (_, state) => IssueDetailScreen(issueId: state.pathParameters['id']!),
      ),
      GoRoute(path: '/profile', builder: (_, _) => const ProfileScreen()),
      GoRoute(
        path: '/list/:type',
        builder: (_, state) => FullListScreen(type: state.pathParameters['type']!),
      ),
    ],
  );
}