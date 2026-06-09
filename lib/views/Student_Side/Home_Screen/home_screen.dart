import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:technation_hub/Models/post_model.dart';
import 'package:technation_hub/controllers/home_controller.dart';
import 'package:technation_hub/data/response/status.dart';
import 'package:technation_hub/res/Colors/colors.dart';
import 'package:technation_hub/views/Student_Side/Home_Screen/comment_screen.dart';
import '../../../res/components/side_drawer.dart';
import '../../../res/routes/routes_names.dart';
import 'create_post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());

  // ── Helpers ─────────────────────────────────────────────────────────────────
  String _timeAgo(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final diff = DateTime.now().difference(dt);
      if (diff.inSeconds < 60) return 'just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      if (diff.inDays < 7) return '${diff.inDays}d ago';
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundLight,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColor.backgroundDark,
        elevation: 0,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: const Text(
          'TechNation Hub',
          style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => controller.fetchHomeData(),
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh',
          ),
          IconButton(
            onPressed: () => Get.toNamed(RouteName.discoverScreen),
            icon: const Icon(Icons.search, color: Colors.white),
            tooltip: 'Search',
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'home_fab',
        backgroundColor: AppColor.primaryColor,
        onPressed: () => Get.to(() => const CreatePostScreen()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // ── Channel Filter Chips ─────────────────────────────────────────
          _buildChannelBar(),

          // ── Feed ─────────────────────────────────────────────────────────
          Expanded(child: _buildFeed()),
        ],
      ),
    );
  }

  // ── Channel Bar ──────────────────────────────────────────────────────────────
  Widget _buildChannelBar() {
    return Obx(() {
      final status = controller.rxChannelList.value.status;
      if (status == Status.LOADING) {
        return const SizedBox(
          height: 60,
          child: Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColor.primaryColor,
              ),
            ),
          ),
        );
      }
      if (status == Status.ERROR) {
        return SizedBox(
          height: 44,
          child: Center(
            child: Text(
              controller.rxChannelList.value.message ?? 'Error loading channels',
              style: const TextStyle(color: AppColor.errorColor, fontSize: 12),
            ),
          ),
        );
      }
      final channels = controller.rxChannelList.value.data!;
      return Container(
        height: 60,
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: channels.length + 1,
          itemBuilder: (context, index) {
            return Obx(() {
              if (index == 0) {
                return _categoryChip(
                  'All',
                  isActive: controller.selectedChannelId.value.isEmpty,
                  onTap: () => controller.filterByChannel(''),
                );
              }
              final ch = channels[index - 1];
              return _categoryChip(
                ch.name ?? '',
                isActive: controller.selectedChannelId.value == ch.id,
                onTap: () => controller.filterByChannel(ch.id ?? ''),
              );
            });
          },
        ),
      );
    });
  }

  Widget _categoryChip(String label,
      {bool isActive = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isActive ? AppColor.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isActive ? AppColor.primaryColor : AppColor.lightGreyColor),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : AppColor.blackColor,
              fontWeight:
                  isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  // ── Feed ─────────────────────────────────────────────────────────────────────
  Widget _buildFeed() {
    return Obx(() {
      final status = controller.rxPostList.value.status;
      if (status == Status.LOADING) {
        return const Center(
            child: CircularProgressIndicator(color: AppColor.primaryColor));
      }
      if (status == Status.ERROR) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded,
                  size: 48, color: AppColor.greyColor),
              const SizedBox(height: 12),
              Text(
                controller.rxPostList.value.message ?? 'Something went wrong',
                style: const TextStyle(color: AppColor.greyColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: controller.fetchFeed,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    foregroundColor: Colors.white),
              ),
            ],
          ),
        );
      }
      final posts = controller.filteredPosts;
      if (posts.isEmpty) {
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.dynamic_feed_outlined,
                  size: 52, color: AppColor.greyColor),
              SizedBox(height: 12),
              Text('No posts yet. Be the first to share!',
                  style: TextStyle(color: AppColor.greyColor)),
            ],
          ),
        );
      }
      return RefreshIndicator(
        color: AppColor.primaryColor,
        onRefresh: () async => controller.fetchFeed(),
        child: ListView.builder(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: posts.length,
          itemBuilder: (context, index) =>
              _PostCard(post: posts[index], timeAgo: _timeAgo),
        ),
      );
    });
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// Post Card  (self-contained stateful widget for like animation)
// ════════════════════════════════════════════════════════════════════════════════
class _PostCard extends StatefulWidget {
  final PostModel post;
  final String Function(String?) timeAgo;

  const _PostCard({required this.post, required this.timeAgo});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeAnimCtrl;
  late Animation<double> _likeScale;

  HomeController get _controller => Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    _likeAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _likeScale = TweenSequence<double>([
      TweenSequenceItem(
          tween: Tween(begin: 1.0, end: 1.35)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50),
      TweenSequenceItem(
          tween: Tween(begin: 1.35, end: 1.0)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50),
    ]).animate(_likeAnimCtrl);
  }

  @override
  void dispose() {
    _likeAnimCtrl.dispose();
    super.dispose();
  }

  void _handleLike() {
    HapticFeedback.lightImpact();
    _likeAnimCtrl.forward(from: 0);
    _controller.toggleLike(widget.post.id ?? '');
  }

  void _handleComment() {
    Get.to(
      () => CommentScreen(post: widget.post),
      transition: Transition.downToUp,
    );
  }

  void _handleShare(BuildContext context) {
    final content = widget.post.body ?? '';
    final author = widget.post.fullName ?? widget.post.username ?? 'Unknown';
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ShareSheet(author: author, content: content),
    );
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    final avatarUrl = post.avatarUrl?.trim() ?? '';
    final name =
        post.fullName?.isNotEmpty == true ? post.fullName! : 'Unknown';
    final handle = '@${post.username ?? ''}';
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();

    final totalLikes = post.reactionCounts?.values
            .fold<int>(0, (prev, v) => prev + (v as int)) ??
        0;
    final isLiked = post.isLiked ?? false;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: AppColor.lightGreyColor),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Author Row ──────────────────────────────────────────────
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor:
                      AppColor.primaryColor.withValues(alpha: 0.12),
                  backgroundImage:
                      avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl.isEmpty
                      ? Text(
                          initials.isEmpty ? 'U' : initials,
                          style: const TextStyle(
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          if ((post.userRole ?? '').isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColor.primaryColor
                                    .withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                post.userRole!,
                                style: const TextStyle(
                                  color: AppColor.primaryColor,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 1),
                      Row(
                        children: [
                          Text(handle,
                              style: const TextStyle(
                                  color: AppColor.greyColor, fontSize: 12)),
                          if ((post.channelName ?? '').isNotEmpty) ...[
                            const Text(' · ',
                                style: TextStyle(
                                    color: AppColor.greyColor, fontSize: 12)),
                            Text(
                              '#${post.channelName}',
                              style: const TextStyle(
                                  color: AppColor.primaryColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  widget.timeAgo(post.createdAt),
                  style: const TextStyle(
                      color: AppColor.greyColor, fontSize: 11),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ── Body ────────────────────────────────────────────────────
            Text(post.body ?? '',
                style:
                    const TextStyle(fontSize: 14, height: 1.5)),

            // ── Code Snippet ────────────────────────────────────────────
            if (post.hasCode == true) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '// Code snippet attached — open thread to view',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'monospace',
                    fontSize: 12,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 14),

            // ── Stats row (likes / comments count) ──────────────────────
            if (totalLikes > 0 || (post.replyCount ?? 0) > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    if (totalLikes > 0) ...[
                      const Icon(Icons.thumb_up,
                          size: 13, color: AppColor.primaryColor),
                      const SizedBox(width: 4),
                      Text('$totalLikes',
                          style: const TextStyle(
                              color: AppColor.greyColor, fontSize: 12)),
                    ],
                    const Spacer(),
                    if ((post.replyCount ?? 0) > 0)
                      GestureDetector(
                        onTap: _handleComment,
                        child: Text(
                          '${post.replyCount} comment${(post.replyCount ?? 0) > 1 ? 's' : ''}',
                          style: const TextStyle(
                            color: AppColor.greyColor,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            const Divider(height: 1),
            const SizedBox(height: 6),

            // ── Action Buttons ──────────────────────────────────────────
            Row(
              children: [
                // Like
                Expanded(
                  child: _ActionButton(
                    icon: AnimatedBuilder(
                      animation: _likeScale,
                      builder: (_, child) => Transform.scale(
                        scale: _likeScale.value,
                        child: Icon(
                          isLiked
                              ? Icons.thumb_up
                              : Icons.thumb_up_outlined,
                          color: isLiked
                              ? AppColor.primaryColor
                              : AppColor.greyColor,
                          size: 20,
                        ),
                      ),
                    ),
                    label: isLiked ? 'Liked' : 'Like',
                    labelColor: isLiked
                        ? AppColor.primaryColor
                        : AppColor.greyColor,
                    onTap: _handleLike,
                  ),
                ),

                // Comment
                Expanded(
                  child: _ActionButton(
                    icon: const Icon(Icons.chat_bubble_outline,
                        color: AppColor.greyColor, size: 20),
                    label: 'Comment',
                    onTap: _handleComment,
                  ),
                ),

                // Share
                Expanded(
                  child: Builder(
                    builder: (ctx) => _ActionButton(
                      icon: const Icon(Icons.share_outlined,
                          color: AppColor.greyColor, size: 20),
                      label: 'Share',
                      onTap: () => _handleShare(ctx),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Reusable action button (Like / Comment / Share)
// ────────────────────────────────────────────────────────────────────────────
class _ActionButton extends StatelessWidget {
  final Widget icon;
  final String label;
  final Color labelColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.labelColor = AppColor.greyColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: labelColor,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Share Bottom Sheet
// ────────────────────────────────────────────────────────────────────────────
class _ShareSheet extends StatelessWidget {
  final String author;
  final String content;

  const _ShareSheet({required this.author, required this.content});

  @override
  Widget build(BuildContext context) {
    final snippet =
        content.length > 120 ? '${content.substring(0, 120)}…' : content;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColor.lightGreyColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Share Post',
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 6),
          Text(
            '"$snippet"',
            style: const TextStyle(
                color: AppColor.greyColor,
                fontSize: 12,
                fontStyle: FontStyle.italic),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _shareOption(
                icon: Icons.copy_rounded,
                label: 'Copy link',
                color: AppColor.primaryColor,
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(
                        text: 'TechNation Hub • $author: $snippet'),
                  );
                  Get.back();
                  Get.snackbar('Copied', 'Post link copied to clipboard',
                      snackPosition: SnackPosition.BOTTOM);
                },
              ),
              _shareOption(
                icon: Icons.message_outlined,
                label: 'Message',
                color: Colors.green,
                onTap: () {
                  Get.back();
                  Get.snackbar('Info', 'Direct messaging coming soon',
                      snackPosition: SnackPosition.BOTTOM);
                },
              ),
              _shareOption(
                icon: Icons.share_outlined,
                label: 'More',
                color: AppColor.greyColor,
                onTap: () {
                  Get.back();
                  Get.snackbar('Info', 'More sharing options coming soon',
                      snackPosition: SnackPosition.BOTTOM);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shareOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppColor.greyColor)),
        ],
      ),
    );
  }
}
