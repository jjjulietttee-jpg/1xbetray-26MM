import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'features/splash/presentation/cubit/splash_cubit.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/home/presentation/screens/simple_home_screen.dart';
import 'features/game/presentation/screens/game_screen.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/usecases/get_profile_usecase.dart';
import 'features/profile/domain/usecases/save_player_name_usecase.dart';
import 'features/profile/presentation/cubit/profile_cubit.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/mystery_cards/presentation/screens/working_mystery_cards_screen.dart';
import 'features/game_modes/presentation/screens/game_modes_screen.dart';
import 'features/settings/presentation/screens/settings_screen.dart';
import 'features/achievements/data/repositories/achievements_repository_impl.dart';
import 'features/achievements/domain/usecases/get_achievements_with_progress_usecase.dart';
import 'features/achievements/presentation/cubit/achievements_cubit.dart';
import 'features/achievements/presentation/screens/achievements_screen.dart';
import 'features/statistics/presentation/screens/statistics_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  debugLogDiagnostics: false,
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => BlocProvider(
        create: (_) => SplashCubit(),
        child: const SplashScreen(),
      ),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      builder: (context, state) => BlocProvider(
        create: (_) => OnboardingCubit(),
        child: const OnboardingScreen(),
      ),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) {
        return const SimpleHomeScreen();
      },
    ),
    GoRoute(
      path: '/game',
      name: 'game',
      builder: (context, state) {
        return const GameScreen();
      },
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) {
        final repo = ProfileRepositoryImpl();
        return BlocProvider(
          create: (_) => ProfileCubit(
            GetProfileUseCase(repo),
            SavePlayerNameUseCase(repo),
          ),
          child: const ProfileScreen(),
        );
      },
    ),
    GoRoute(
      path: '/mystery-cards',
      name: 'mystery-cards',
      builder: (context, state) {
        return const WorkingMysteryCardsScreen();
      },
    ),
    GoRoute(
      path: '/game-modes',
      name: 'game-modes',
      builder: (context, state) {
        return const GameModesScreen();
      },
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) {
        return const SettingsScreen();
      },
    ),
    GoRoute(
      path: '/achievements',
      name: 'achievements',
      builder: (context, state) {
        final repo = AchievementsRepositoryImpl();
        return BlocProvider(
          create: (_) => AchievementsCubit(
            GetAchievementsWithProgressUseCase(repo),
          ),
          child: const AchievementsScreen(),
        );
      },
    ),
    GoRoute(
      path: '/statistics',
      name: 'statistics',
      builder: (context, state) {
        return const StatisticsScreen();
      },
    ),
  ],
);
