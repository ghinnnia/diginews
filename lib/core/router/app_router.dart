import 'package:go_router/go_router.dart';
import 'package:diginews_offline_first/core/router/route_names.dart';
import 'package:diginews_offline_first/features/news/domain/entities/news_entity.dart';
import 'package:diginews_offline_first/features/news/presentation/pages/detail_page.dart';
import 'package:diginews_offline_first/features/news/presentation/pages/home_page.dart';
import 'package:diginews_offline_first/features/profile/presentation/pages/profile_page.dart';
import 'package:diginews_offline_first/features/splash/presentation/pages/splash_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        name: RouteNames.splash,
        path: RoutePaths.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        name: RouteNames.home,
        path: RoutePaths.home,
        builder: (context, state) => const HomePage(),
        routes: [
          GoRoute(
            name: RouteNames.detail,
            path: 'detail',
            builder: (context, state) {
              final news = state.extra as NewsEntity?;
              if (news == null) {
                // Fallback jika halaman diakses tanpa data (mis. deep-link
                // langsung tanpa melalui Home) -> kembali ke Home.
                return const HomePage();
              }
              return DetailPage(news: news);
            },
          ),
          GoRoute(
            name: RouteNames.profile,
            path: 'profile',
            builder: (context, state) => const ProfilePage(),
          ),
        ],
      ),
    ],
  );
}
