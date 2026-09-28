import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/session_controller.dart';
import 'core/story_api.dart';
import 'l10n/generated/app_localizations.dart';
import 'screens/auth_screen.dart';
import 'screens/story_screens.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StoryApp());
}

class StoryApp extends StatefulWidget {
  const StoryApp({super.key});

  @override
  State<StoryApp> createState() => _StoryAppState();
}

class _StoryAppState extends State<StoryApp> {
  late final SessionController _session;
  late final StoryApi _api;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _session = SessionController();
    _api = StoryApi();
    _router = GoRouter(
      initialLocation: '/',
      refreshListenable: _session,
      redirect: (context, state) {
        final location = state.matchedLocation;
        if (!_session.isReady) return location == '/' ? null : '/';
        if (location == '/') {
          return _session.token == null ? '/login' : '/stories';
        }
        final isAuthRoute = location == '/login' || location == '/register';
        if (_session.token == null && !isAuthRoute) return '/login';
        if (_session.token != null && isAuthRoute) return '/stories';
        return null;
      },
      routes: [
        GoRoute(path: '/', builder: (context, state) => const LoadingScreen()),
        GoRoute(
          path: '/login',
          builder: (context, state) =>
              LoginScreen(api: _api, session: _session),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) =>
              RegisterScreen(api: _api, session: _session),
        ),
        GoRoute(
          path: '/stories',
          builder: (context, state) =>
              StoriesScreen(api: _api, session: _session),
        ),
        GoRoute(
          path: '/stories/:id',
          builder: (context, state) => StoryDetailScreen(
            api: _api,
            session: _session,
            storyId: state.pathParameters['id']!,
          ),
        ),
        GoRoute(
          path: '/add',
          builder: (context, state) =>
              AddStoryScreen(api: _api, session: _session),
        ),
      ],
    );
    _session.restore();
  }

  @override
  void dispose() {
    _router.dispose();
    _session.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _session,
      builder: (context, child) => MaterialApp.router(
        onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
        debugShowCheckedModeBanner: false,
        locale: Locale(_session.languageCode),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFB9513C),
            surface: const Color(0xFFF6F2E9),
          ),
          scaffoldBackgroundColor: const Color(0xFFF6F2E9),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFF6F2E9),
            foregroundColor: Color(0xFF242A24),
            elevation: 0,
            centerTitle: false,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE3DED3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE3DED3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFFB9513C),
                width: 1.5,
              ),
            ),
          ),
        ),
        routerConfig: _router,
      ),
    );
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
