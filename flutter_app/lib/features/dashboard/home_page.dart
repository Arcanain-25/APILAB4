import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/learning_content.dart';
import '../../widgets/remote_svg_icon.dart';
import '../catalog/course_catalog_page.dart';
import 'learning_content_cubit.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LearningContentCubit, LearningContentState>(
      builder: (context, state) {
        if (state is LearningContentLoading) {
          return const Scaffold(
            body: Center(
                child: CircularProgressIndicator(color: Color(0xFF315B8F))),
          );
        }
        if (state is LearningContentError) {
          return Scaffold(body: _DashboardError(message: state.message));
        }
        return _Dashboard(data: (state as LearningContentLoaded).content.home);
      },
    );
  }
}

class _Dashboard extends StatelessWidget {
  const _Dashboard({required this.data});

  final HomePageData data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F5F7),
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _HomeHeader(data: data.header)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: _LearnedTodayCard(data: data.learnedToday),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 8),
                child: _SectionHeading(
                  title: data.myCoursesTitle,
                  action: data.myCoursesActionLabel,
                  onPressed: () => _openCatalog(context),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _LearningPrompt(
                  data: data.learningPrompt,
                  onPressed: () => _openCatalog(context),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 10),
                child: Text(data.learningPlanTitle,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList.separated(
                itemCount: data.learningPlanItems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) => _LearningPlanCard(
                  item: data.learningPlanItems[index],
                  onTap: () => _openCatalog(context),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
                child: _MeetupBanner(data: data.meetup),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _openCatalog(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute<void>(builder: (_) => const CourseCatalogPage()),
  );
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.data});

  final HomeHeaderData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF315B8F),
      padding: const EdgeInsets.fromLTRB(22, 14, 18, 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.greeting,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 27,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(data.subtitle,
                    style:
                        TextStyle(color: Colors.white.withValues(alpha: 0.78))),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You are all caught up.')),
            ),
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                RemoteSvgIcon(
                  url: data.notificationIconUrl,
                  fallback: Icons.notifications_none,
                  color: Colors.white,
                  size: 25,
                ),
                if (data.hasUnread)
                  Positioned(
                    right: -2,
                    top: -1,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                          color: Color(0xFFFF8B4A), shape: BoxShape.circle),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          ClipOval(
            child: Image.network(
              data.avatarUrl,
              width: 46,
              height: 46,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const CircleAvatar(
                radius: 23,
                backgroundColor: Color(0xFF7895B8),
                child: Icon(Icons.person, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LearnedTodayCard extends StatelessWidget {
  const _LearnedTodayCard({required this.data});

  final LearnedTodayData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(data.title,
                      style: const TextStyle(color: Color(0xFF687581)))),
              Text(data.formatted,
                  style: const TextStyle(
                      color: Color(0xFF315B8F), fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 13),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: data.progress,
              minHeight: 8,
              color: const Color(0xFFFF8B4A),
              backgroundColor: const Color(0xFFE9EDF1),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading(
      {required this.title, required this.action, required this.onPressed});

  final String title;
  final String action;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
              child:
                  Text(title, style: Theme.of(context).textTheme.titleLarge)),
          TextButton(onPressed: onPressed, child: Text(action)),
        ],
      );
}

class _LearningPrompt extends StatelessWidget {
  const _LearningPrompt({required this.data, required this.onPressed});

  final LearningPromptData data;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 166,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              data.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: const Color(0xFFDCE6EE)),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.97),
                    Colors.white.withValues(alpha: 0.74),
                    Colors.transparent
                  ],
                  stops: const [0, 0.55, 1],
                ),
              ),
            ),
            Positioned(
              left: 16,
              top: 16,
              bottom: 14,
              width: 190,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      data.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Color(0xFF193A36),
                          fontSize: 17,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  FilledButton(
                    onPressed: onPressed,
                    style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFFFF8B4A)),
                    child: Text(data.actionLabel),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LearningPlanCard extends StatelessWidget {
  const _LearningPlanCard({required this.item, required this.onTap});

  final LearningPlanItemData item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              RemoteSvgIcon(
                url: item.progressIconUrl,
                fallback: Icons.timelapse,
                color: const Color(0xFF687581),
                size: 25,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 7),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: item.progress,
                        minHeight: 5,
                        color: const Color(0xFF5A9B79),
                        backgroundColor: const Color(0xFFE9EDF1),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text('${item.completed}/${item.total}',
                  style:
                      const TextStyle(color: Color(0xFF687581), fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}

class _MeetupBanner extends StatelessWidget {
  const _MeetupBanner({required this.data});

  final MeetupData data;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: 150,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              data.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
                  Container(color: const Color(0xFF315B8F)),
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.black.withValues(alpha: 0.74),
                    Colors.transparent
                  ],
                ),
              ),
            ),
            Positioned(
              left: 17,
              right: 100,
              top: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(data.subtitle,
                      style:
                          const TextStyle(color: Colors.white, height: 1.35)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardError extends StatelessWidget {
  const _DashboardError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_outlined, size: 38),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: context.read<LearningContentCubit>().load,
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
}
