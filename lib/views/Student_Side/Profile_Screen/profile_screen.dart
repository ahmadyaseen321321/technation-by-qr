import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technation_hub/controllers/profile_controller.dart';
import 'package:technation_hub/data/response/status.dart';
import 'package:technation_hub/res/routes/routes_names.dart';
import 'package:technation_hub/views/Student_Side/Profile_Screen/edit_profile_screen.dart';
import '../../../res/Colors/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use find if already registered (MainScreen registers it), else put it
    final controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColor.backgroundLight,
      appBar: _buildAppBar(controller),
      body: Obx(() {
        final userState = controller.rxUser.value;

        if (userState.status == Status.LOADING) {
          return const Center(child: CircularProgressIndicator());
        }

        if (userState.status == Status.ERROR) {
          return _ErrorView(
            message: userState.message ?? 'Something went wrong',
            onRetry: controller.refresh,
          );
        }

        final user = userState.data!;
        return RefreshIndicator(
          onRefresh: () async => controller.refresh(),
          color: AppColor.primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header Card ──────────────────────────────────────────
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tappable avatar
                          GestureDetector(
                            onTap: () => Get.to(
                              () => EditProfileScreen(user: user),
                              transition: Transition.rightToLeft,
                            ),
                            child: Stack(
                              children: [
                                _Avatar(
                                  name: user.fullName ?? user.username ?? 'User',
                                  avatarUrl: user.avatarUrl,
                                  radius: 46,
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                      color: AppColor.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.camera_alt,
                                        color: Colors.white, size: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // Edit Profile button
                          OutlinedButton(
                            onPressed: () => Get.to(
                              () => EditProfileScreen(user: user),
                              transition: Transition.rightToLeft,
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              side: const BorderSide(
                                  color: AppColor.primaryColor),
                            ),
                            child: const Text(
                              'Edit Profile',
                              style: TextStyle(
                                  color: AppColor.primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Name + username
                      Text(
                        user.fullName ?? 'User',
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColor.blackColor),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '@${user.username ?? 'username'}',
                            style: const TextStyle(
                                color: AppColor.primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 13),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              (user.role ?? 'member').toUpperCase(),
                              style: const TextStyle(
                                  color: AppColor.primaryColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Bio
                      Text(
                        user.bio?.isNotEmpty == true
                            ? user.bio!
                            : 'No bio added yet. Tap Edit Profile to add one.',
                        style: TextStyle(
                          color: user.bio?.isNotEmpty == true
                              ? const Color(0xFF444466)
                              : AppColor.greyColor,
                          height: 1.5,
                          fontSize: 14,
                          fontStyle: user.bio?.isNotEmpty == true
                              ? FontStyle.normal
                              : FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Skills
                      if (user.skills != null && user.skills!.isNotEmpty) ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: user.skills!
                              .map((s) => _SkillChip(label: s))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Stats
                      Obx(() => _StatsRow(stats: controller.stats.value)),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),

                // ── OpenClaw CTA ──────────────────────────────────────────
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: InkWell(
                    onTap: () => Get.toNamed(RouteName.aiScreen),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColor.primaryColor.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: AppColor.primaryColor.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF6B63E0),
                                  AppColor.primaryColor
                                ],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.smart_toy_rounded,
                                color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Ask OpenClaw',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColor.primaryColor,
                                        fontSize: 14)),
                                Text('Your AI mentor at TechNation Hub',
                                    style: TextStyle(
                                        color: AppColor.greyColor,
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right,
                              color: AppColor.primaryColor),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Tabs ──────────────────────────────────────────────────
                Container(
                  color: Colors.white,
                  child: Obx(() => Row(
                        children: [
                          _TabItem(
                            label: 'Posts',
                            icon: Icons.article_outlined,
                            isActive: controller.selectedTab.value == 0,
                            onTap: () => controller.selectTab(0),
                          ),
                          _TabItem(
                            label: 'Projects',
                            icon: Icons.folder_outlined,
                            isActive: controller.selectedTab.value == 1,
                            onTap: () => controller.selectTab(1),
                          ),
                          _TabItem(
                            label: 'Achievements',
                            icon: Icons.emoji_events_outlined,
                            isActive: controller.selectedTab.value == 2,
                            onTap: () => controller.selectTab(2),
                          ),
                        ],
                      )),
                ),

                // ── Tab Content ───────────────────────────────────────────
                Obx(() {
                  switch (controller.selectedTab.value) {
                    case 0:
                      return _PostsTab(controller: controller);
                    case 1:
                      return _PlaceholderTab(
                        icon: Icons.folder_outlined,
                        title: 'No projects yet',
                        subtitle:
                            'Projects you share will appear here.',
                      );
                    case 2:
                      return _PlaceholderTab(
                        icon: Icons.emoji_events_outlined,
                        title: 'No achievements yet',
                        subtitle:
                            'Earn badges by participating in the community.',
                      );
                    default:
                      return const SizedBox.shrink();
                  }
                }),
              ],
            ),
          ),
        );
      }),
    );
  }

  AppBar _buildAppBar(ProfileController controller) {
    return AppBar(
      backgroundColor: AppColor.backgroundDark,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: const Text(
        'Profile',
        style:
            TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          tooltip: 'Refresh',
          onPressed: controller.refresh,
        ),
        Obx(() => controller.isLoggingOut.value
            ? const Padding(
                padding: EdgeInsets.all(14),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                ),
              )
            : IconButton(
                icon: const Icon(Icons.logout, color: Colors.white70),
                tooltip: 'Logout',
                onPressed: () => _confirmLogout(controller),
              )),
        const SizedBox(width: 4),
      ],
    );
  }

  void _confirmLogout(ProfileController controller) {
    Get.dialog(
      AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Log out?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content:
            const Text('You will need to sign in again to access your account.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.errorColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Posts Tab
// ════════════════════════════════════════════════════════════════════════════
class _PostsTab extends StatelessWidget {
  final ProfileController controller;
  const _PostsTab({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final state = controller.rxPosts.value;

      if (state.status == Status.LOADING) {
        return const Padding(
          padding: EdgeInsets.all(40),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (state.status == Status.ERROR) {
        return Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Column(
              children: [
                const Icon(Icons.wifi_off, color: AppColor.greyColor, size: 40),
                const SizedBox(height: 12),
                Text(state.message ?? 'Failed to load posts',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColor.greyColor)),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: controller.fetchPosts,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        );
      }

      final posts = state.data ?? [];
      if (posts.isEmpty) {
        return const _PlaceholderTab(
          icon: Icons.article_outlined,
          title: 'No posts yet',
          subtitle: 'Your posts will appear here once you start contributing to channels.',
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: posts.length,
        itemBuilder: (_, i) => _PostCard(post: posts[i]),
      );
    });
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Post Card
// ════════════════════════════════════════════════════════════════════════════
class _PostCard extends StatelessWidget {
  final UserPost post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.lightGreyColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Channel badge + time
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColor.primaryColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '#${post.channelName}',
                    style: const TextStyle(
                        color: AppColor.primaryColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Text(
                  _timeAgo(post.createdAt),
                  style: const TextStyle(
                      color: AppColor.greyColor, fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Body
            Text(
              post.body,
              style: const TextStyle(fontSize: 14, height: 1.5),
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),

            // Code badge
            if (post.hasCode) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.code,
                      size: 14, color: AppColor.greyColor),
                  const SizedBox(width: 4),
                  const Text('Contains code',
                      style: TextStyle(
                          color: AppColor.greyColor, fontSize: 11)),
                ],
              ),
            ],

            const SizedBox(height: 12),

            // Reactions row
            Row(
              children: [
                const Icon(Icons.thumb_up_outlined,
                    size: 16, color: AppColor.greyColor),
                const SizedBox(width: 4),
                Text('${post.likeCount}',
                    style: const TextStyle(
                        color: AppColor.greyColor, fontSize: 12)),
                const SizedBox(width: 16),
                const Icon(Icons.chat_bubble_outline,
                    size: 16, color: AppColor.greyColor),
                const SizedBox(width: 4),
                Text('${post.replyCount}',
                    style: const TextStyle(
                        color: AppColor.greyColor, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Reusable Widgets
// ════════════════════════════════════════════════════════════════════════════
class _Avatar extends StatelessWidget {
  final String name;
  final String? avatarUrl;
  final double radius;

  const _Avatar(
      {required this.name, required this.avatarUrl, required this.radius});

  @override
  Widget build(BuildContext context) {
    final trimmed = avatarUrl?.trim() ?? '';
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColor.primaryColor.withOpacity(0.12),
      backgroundImage: trimmed.isNotEmpty ? NetworkImage(trimmed) : null,
      child: trimmed.isEmpty
          ? Text(
              initials.isEmpty ? 'U' : initials,
              style: TextStyle(
                  color: AppColor.primaryColor,
                  fontSize: radius * 0.46,
                  fontWeight: FontWeight.bold),
            )
          : null,
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  const _SkillChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColor.primaryColor.withOpacity(0.09),
        borderRadius: BorderRadius.circular(8),
        border:
            Border.all(color: AppColor.primaryColor.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(
            color: AppColor.primaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final ProfileStats stats;
  const _StatsRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: AppColor.backgroundLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatItem(count: '${stats.posts}', label: 'POSTS'),
          _vDivider(),
          _StatItem(count: '${stats.replies}', label: 'REPLIES'),
          _vDivider(),
          const _StatItem(count: '–', label: 'FOLLOWING'),
          _vDivider(),
          const _StatItem(count: '–', label: 'FOLLOWERS'),
        ],
      ),
    );
  }

  Widget _vDivider() =>
      Container(height: 28, width: 1, color: AppColor.lightGreyColor);
}

class _StatItem extends StatelessWidget {
  final String count;
  final String label;
  const _StatItem({required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(
                color: AppColor.greyColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4)),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon,
                      size: 16,
                      color: isActive
                          ? AppColor.primaryColor
                          : AppColor.greyColor),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      color: isActive
                          ? AppColor.primaryColor
                          : AppColor.greyColor,
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 2.5,
              color: isActive
                  ? AppColor.primaryColor
                  : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderTab extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _PlaceholderTab({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 32),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 48, color: AppColor.lightGreyColor),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColor.greyColor)),
            const SizedBox(height: 8),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColor.greyColor, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off,
                size: 56, color: AppColor.greyColor),
            const SizedBox(height: 16),
            const Text('Could not load profile',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColor.greyColor)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
