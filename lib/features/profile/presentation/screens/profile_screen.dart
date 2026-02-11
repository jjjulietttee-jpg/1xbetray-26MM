import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/shared/widgets/custom_elevated_button.dart';
import '../../../../core/shared/widgets/custom_text.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/entities/profile_entity.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/nickname_edit_popup.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_rank_section.dart';
import '../widgets/profile_stat_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const _ProfileView();
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  bool _hasShownNamePrompt = false;
  ProfileEntity? _lastProfile;

  void _openNicknamePopup(bool isFirstTime) {
    final s = context.read<ProfileCubit>().state;
    final raw = s is ProfileLoaded ? s.profile.playerName : 'Player';
    final initial = (raw.isEmpty || raw == 'Player') ? '' : raw;
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.transparent,
        pageBuilder: (_, __, ___) => NicknameEditPopup(
          initialName: initial,
          onSave: (n) => context.read<ProfileCubit>().savePlayerName(n),
          onSkip: isFirstTime ? () {} : null,
          title: isFirstTime ? 'Welcome to 1Xylophone!' : 'Change nickname',
          subtitle: isFirstTime ? 'Choose your player name' : 'Enter your player name',
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProfileCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded) _lastProfile = state.profile;
        if (state is ProfileLoaded &&
            state.profile.playerName == 'Player' &&
            !_hasShownNamePrompt) {
          _hasShownNamePrompt = true;
          _openNicknamePopup(true);
        }
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.primaryDark.withValues(alpha: 0.7),
            ),
            child: SafeArea(
              child: BlocBuilder<ProfileCubit, ProfileState>(
                buildWhen: (p, c) =>
                    c is ProfileLoaded || c is ProfileLoading || c is ProfileSaving,
                builder: (context, state) {
                  final profile = state is ProfileLoaded
                      ? state.profile
                      : _lastProfile;
                  final saving = state is ProfileSaving;
                  if (state is ProfileLoading && profile == null) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppTheme.neonCyan),
                    );
                  }
                  if (profile == null && state is! ProfileLoading) {
                    return const Center(
                      child: CustomText.body('Failed to load profile'),
                    );
                  }
                  if (profile == null) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppTheme.neonCyan),
                    );
                  }
                  return Stack(
                    children: [
                      Column(
                        children: [
                          _buildAppBar(context),
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  ProfileHeader(
                                    profile: profile,
                                    onEditTap: () => _openNicknamePopup(false),
                                  ),
                                  const SizedBox(height: 20),
                                  _buildStatsGrid(profile),
                                  const SizedBox(height: 20),
                                  ProfileRankSection(profile: profile),
                                  const SizedBox(height: 24),
                                  _buildActions(context),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (saving)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: SafeArea(
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: AppTheme.neonPurple.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Saving...',
                                  style: TextStyle(
                                    color: AppTheme.textWhite,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppTheme.textWhite),
            onPressed: () => context.go('/home'),
          ),
          const Expanded(
            child: Center(
              child: CustomText.title(
                'Profile',
                glowColor: AppTheme.neonPurple,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: AppTheme.textWhite),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(ProfileEntity p) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        ProfileStatCard(
          title: 'Games played',
          value: '${p.gamesPlayed}',
          icon: Icons.gamepad,
          color: AppTheme.neonBlue,
        ),
        ProfileStatCard(
          title: 'Wins',
          value: '${p.wins}',
          icon: Icons.emoji_events,
          color: AppTheme.neonCyan,
        ),
        ProfileStatCard(
          title: 'Win rate',
          value: '${(p.winRate * 100).toStringAsFixed(1)}%',
          icon: Icons.trending_up,
          color: AppTheme.neonPurple,
        ),
        ProfileStatCard(
          title: 'Best score',
          value: '${p.bestScore}',
          icon: Icons.star,
          color: AppTheme.neonCyan,
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Column(
      children: [
        CustomElevatedButton(
          text: 'Statistics',
          backgroundColor: AppTheme.neonBlue,
          onPressed: () => context.go('/statistics'),
        ),
        const SizedBox(height: 16),
        CustomElevatedButton(
          text: 'Achievements',
          backgroundColor: AppTheme.neonCyan,
          onPressed: () => context.go('/achievements'),
        ),
        const SizedBox(height: 16),
        CustomElevatedButton(
          text: 'Settings',
          backgroundColor: AppTheme.neonPurple,
          onPressed: () => context.go('/settings'),
        ),
        const SizedBox(height: 16),
        CustomElevatedButton(
          text: 'Back to Home',
          backgroundColor: AppTheme.textGray,
          onPressed: () => context.go('/home'),
        ),
      ],
    );
  }
}
