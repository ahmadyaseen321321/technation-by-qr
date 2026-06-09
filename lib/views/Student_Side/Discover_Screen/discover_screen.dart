import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:technation_hub/Models/channel_model.dart';
import 'package:technation_hub/Models/user_model.dart';
import 'package:technation_hub/controllers/discover_controller.dart';
import 'package:technation_hub/data/response/status.dart';
import 'package:technation_hub/res/Colors/colors.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final DiscoverController controller = Get.put(DiscoverController());
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundDark,
        elevation: 0,
        title: const Text(
          'Discover',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: controller.fetchDiscoverData,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // ── Search Bar ─────────────────────────────────────────────────────
          _SearchBar(
            controller: _searchController,
            focusNode: _searchFocus,
            onChanged: controller.onSearchChanged,
            onClear: () {
              _searchController.clear();
              controller.clearSearch();
              _searchFocus.unfocus();
            },
          ),

          // ── Tab Bar (hidden during search) ─────────────────────────────────
          Obx(() => controller.isSearching.value
              ? const SizedBox.shrink()
              : _TabBar(controller: controller)),

          // ── Body ───────────────────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              // ── Search mode ──────────────────────────────────────────
              if (controller.isSearching.value) {
                if (controller.isSearchLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppColor.primaryColor),
                  );
                }
                final results = controller.rxSearchResults.value;
                if (results == null || results.isEmpty) {
                  return _EmptyState(
                    icon: Icons.search_off_rounded,
                    message: 'No results found.\nTry a different keyword.',
                  );
                }
                return _SearchResultsView(results: results);
              }

              // ── Discover mode ────────────────────────────────────────
              switch (controller.rxDiscoverData.value.status) {
                case Status.LOADING:
                  return const Center(
                    child: CircularProgressIndicator(
                        color: AppColor.primaryColor),
                  );
                case Status.ERROR:
                  return _ErrorState(
                    message: controller.rxDiscoverData.value.message ??
                        'Something went wrong',
                    onRetry: controller.fetchDiscoverData,
                  );
                case Status.COMPLETED:
                  return _DiscoverBody(
                    controller: controller,
                    data: controller.rxDiscoverData.value.data!,
                  );
              }
            }),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Search Bar
// ════════════════════════════════════════════════════════════════════════════
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.backgroundDark,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onChanged: onChanged,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search channels, people, jobs…',
          hintStyle:
              const TextStyle(color: Colors.white54, fontSize: 14),
          prefixIcon:
              const Icon(Icons.search, color: Colors.white54),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Colors.white54),
                  onPressed: onClear,
                )
              : null,
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.10),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Tab Bar
// ════════════════════════════════════════════════════════════════════════════
class _TabBar extends StatelessWidget {
  final DiscoverController controller;
  const _TabBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    const tabs = ['All', 'Channels', 'Members', 'Jobs', 'Groups'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Obx(() => Row(
              children: tabs
                  .map((t) => _TabChip(
                        label: t,
                        isActive:
                            controller.selectedTab.value == t,
                        onTap: () => controller.updateTab(t),
                      ))
                  .toList(),
            )),
      ),
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabChip(
      {required this.label,
      required this.isActive,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColor.primaryColor : AppColor.backgroundLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isActive ? AppColor.primaryColor : AppColor.lightGreyColor,
          ),
        ),
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
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Discover Body (the scrollable content when not searching)
// ════════════════════════════════════════════════════════════════════════════
class _DiscoverBody extends StatelessWidget {
  final DiscoverController controller;
  final DiscoverData data;

  const _DiscoverBody({required this.controller, required this.data});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tab = controller.selectedTab.value;
      return RefreshIndicator(
        color: AppColor.primaryColor,
        onRefresh: () async => controller.fetchDiscoverData(),
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            // ── Channels ────────────────────────────────────────────
            if ((tab == 'All' || tab == 'Channels') &&
                (data.channels?.isNotEmpty ?? false)) ...[
              _SectionHeader(
                title: 'Trending Channels 🔥',
                onSeeAll: () => controller.updateTab('Channels'),
              ),
              SizedBox(
                height: 190,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: data.channels!.length,
                  itemBuilder: (_, i) =>
                      _ChannelCard(channel: data.channels![i]),
                ),
              ),
            ],

            // ── Members ─────────────────────────────────────────────
            if ((tab == 'All' || tab == 'Members') &&
                (data.members?.isNotEmpty ?? false)) ...[
              _SectionHeader(
                title: 'New Members 👋',
                onSeeAll: () => controller.updateTab('Members'),
              ),
              SizedBox(
                height: 140,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: data.members!.length,
                  itemBuilder: (_, i) =>
                      _MemberChip(user: data.members![i]),
                ),
              ),
            ],

            // ── Study Groups ─────────────────────────────────────────
            if ((tab == 'All' || tab == 'Groups') &&
                (data.groups?.isNotEmpty ?? false)) ...[
              _SectionHeader(
                title: 'Study Groups 📚',
                onSeeAll: () => controller.updateTab('Groups'),
              ),
              ...data.groups!.map((g) => _StudyGroupCard(
                    group: g,
                    isJoining:
                        controller.joiningGroupId.value == g['id'],
                    onJoin: () =>
                        controller.joinGroup(g['id'].toString()),
                  )),
            ],

            // ── Jobs ─────────────────────────────────────────────────
            if ((tab == 'All' || tab == 'Jobs') &&
                (data.jobs?.isNotEmpty ?? false)) ...[
              _SectionHeader(
                title: 'Latest Jobs 💼',
                onSeeAll: () => controller.updateTab('Jobs'),
              ),
              ...data.jobs!.map((j) => _JobCard(job: j)),
            ],

            // ── Empty state for single tab ────────────────────────────
            if (tab == 'Channels' && (data.channels?.isEmpty ?? true))
              _EmptyState(
                  icon: Icons.tag,
                  message: 'No channels available yet.'),
            if (tab == 'Members' && (data.members?.isEmpty ?? true))
              _EmptyState(
                  icon: Icons.people_outline,
                  message: 'No members found.'),
            if (tab == 'Jobs' && (data.jobs?.isEmpty ?? true))
              _EmptyState(
                  icon: Icons.work_outline,
                  message: 'No jobs posted yet.'),
            if (tab == 'Groups' && (data.groups?.isEmpty ?? true))
              _EmptyState(
                  icon: Icons.groups_outlined,
                  message: 'No study groups yet.'),
          ],
        ),
      );
    });
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Search Results
// ════════════════════════════════════════════════════════════════════════════
class _SearchResultsView extends StatelessWidget {
  final SearchResults results;
  const _SearchResultsView({required this.results});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        if (results.users.isNotEmpty) ...[
          _SearchSectionLabel('People'),
          ...results.users.map((u) => _UserSearchTile(user: u)),
        ],
        if (results.channels.isNotEmpty) ...[
          _SearchSectionLabel('Channels'),
          ...results.channels
              .map((c) => _ChannelSearchTile(channel: c)),
        ],
        if (results.posts.isNotEmpty) ...[
          _SearchSectionLabel('Posts'),
          ...results.posts.map((p) => _PostSearchTile(post: p)),
        ],
        if (results.jobs.isNotEmpty) ...[
          _SearchSectionLabel('Jobs'),
          ...results.jobs.map((j) => _JobSearchTile(job: j)),
        ],
      ],
    );
  }
}

class _SearchSectionLabel extends StatelessWidget {
  final String label;
  const _SearchSectionLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppColor.greyColor,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _UserSearchTile extends StatelessWidget {
  final User user;
  const _UserSearchTile({required this.user});

  @override
  Widget build(BuildContext context) {
    final name = user.fullName?.isNotEmpty == true
        ? user.fullName!
        : user.username ?? 'User';
    final avatarUrl = user.avatarUrl?.trim() ?? '';
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();

    return ListTile(
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: AppColor.primaryColor.withValues(alpha: 0.12),
        backgroundImage:
            avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
        child: avatarUrl.isEmpty
            ? Text(initials.isEmpty ? 'U' : initials,
                style: const TextStyle(
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.bold))
            : null,
      ),
      title: Text(name,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text('@${user.username ?? ''}',
          style:
              const TextStyle(color: AppColor.greyColor, fontSize: 12)),
      trailing: _RoleBadge(role: user.role ?? 'MEMBER'),
      onTap: () => _showMemberSheet(context, user),
    );
  }
}

class _ChannelSearchTile extends StatelessWidget {
  final ChannelModel channel;
  const _ChannelSearchTile({required this.channel});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColor.primaryColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.tag, color: AppColor.primaryColor),
      ),
      title: Text('#${channel.name ?? ''}',
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(channel.description ?? '',
          maxLines: 1, overflow: TextOverflow.ellipsis,
          style:
              const TextStyle(color: AppColor.greyColor, fontSize: 12)),
      onTap: () => _showChannelSheet(context, channel),
    );
  }
}

class _PostSearchTile extends StatelessWidget {
  final Map<String, dynamic> post;
  const _PostSearchTile({required this.post});

  @override
  Widget build(BuildContext context) {
    final body = post['body']?.toString() ?? '';
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColor.greyColor.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.article_outlined,
            color: AppColor.greyColor),
      ),
      title: Text(
        body.length > 80 ? '${body.substring(0, 80)}…' : body,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 13),
      ),
    );
  }
}

class _JobSearchTile extends StatelessWidget {
  final Map<String, dynamic> job;
  const _JobSearchTile({required this.job});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.orange.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.work_outline, color: Colors.orange),
      ),
      title: Text(job['title']?.toString() ?? '',
          style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(job['company']?.toString() ?? '',
          style:
              const TextStyle(color: AppColor.greyColor, fontSize: 12)),
      onTap: () => _showJobSheet(context, job),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Section Header
// ════════════════════════════════════════════════════════════════════════════
class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold)),
          if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              child: const Text('See all',
                  style: TextStyle(
                      color: AppColor.primaryColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600)),
            ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Channel Card
// ════════════════════════════════════════════════════════════════════════════
class _ChannelCard extends StatelessWidget {
  final ChannelModel channel;
  const _ChannelCard({required this.channel});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showChannelSheet(context, channel),
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12, bottom: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColor.lightGreyColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.tag, color: AppColor.primaryColor),
            ),
            const Spacer(),
            Text(
              '#${channel.name ?? ''}',
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              '${channel.memberCount ?? 0} posts',
              style: const TextStyle(
                  color: AppColor.greyColor, fontSize: 11),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                const Text('Active',
                    style:
                        TextStyle(color: Colors.green, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Member Chip (horizontal scroll)
// ════════════════════════════════════════════════════════════════════════════
class _MemberChip extends StatelessWidget {
  final User user;
  const _MemberChip({required this.user});

  @override
  Widget build(BuildContext context) {
    final name = user.fullName?.isNotEmpty == true
        ? user.fullName!
        : user.username ?? 'User';
    final avatarUrl = user.avatarUrl?.trim() ?? '';
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();
    final firstName = name.split(' ').first;

    return GestureDetector(
      onTap: () => _showMemberSheet(context, user),
      child: Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor:
                  AppColor.primaryColor.withValues(alpha: 0.12),
              backgroundImage:
                  avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
              child: avatarUrl.isEmpty
                  ? Text(initials.isEmpty ? 'U' : initials,
                      style: const TextStyle(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16))
                  : null,
            ),
            const SizedBox(height: 6),
            Text(firstName,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            _RoleBadge(role: user.role ?? 'MEMBER', small: true),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Study Group Card
// ════════════════════════════════════════════════════════════════════════════
class _StudyGroupCard extends StatelessWidget {
  final Map<String, dynamic> group;
  final bool isJoining;
  final VoidCallback onJoin;

  const _StudyGroupCard({
    required this.group,
    required this.isJoining,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    final name = group['name']?.toString() ?? 'Group';
    final topic = group['topic']?.toString() ?? 'General';
    final maxMembers = group['max_members']?.toString() ?? '20';
    final schedule = group['schedule']?.toString() ?? '';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColor.lightGreyColor),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 52,
            decoration: BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.topic_outlined,
                        size: 13, color: AppColor.greyColor),
                    const SizedBox(width: 4),
                    Text(topic,
                        style: const TextStyle(
                            color: AppColor.greyColor, fontSize: 12)),
                    const SizedBox(width: 12),
                    const Icon(Icons.people_outline,
                        size: 13, color: AppColor.greyColor),
                    const SizedBox(width: 4),
                    Text('Max $maxMembers',
                        style: const TextStyle(
                            color: AppColor.greyColor, fontSize: 12)),
                  ],
                ),
                if (schedule.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.schedule,
                          size: 13, color: AppColor.greyColor),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(schedule,
                            style: const TextStyle(
                                color: AppColor.greyColor,
                                fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 72,
            child: ElevatedButton(
              onPressed: isJoining ? null : onJoin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: isJoining
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Join',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 13)),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Job Card
// ════════════════════════════════════════════════════════════════════════════
class _JobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  const _JobCard({required this.job});

  @override
  Widget build(BuildContext context) {
    final title = job['title']?.toString() ?? '';
    final company = job['company']?.toString() ?? '';
    final location = job['location']?.toString() ?? '';
    final type = (job['type']?.toString() ?? '').toUpperCase();
    final List<String> skills = job['skills_required'] != null
        ? List<String>.from(job['skills_required'])
        : [];

    final isRemote = type == 'REMOTE';
    final typeColor = isRemote ? Colors.green : Colors.orange;

    return GestureDetector(
      onTap: () => _showJobSheet(context, job),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColor.lightGreyColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      Icon(Icons.business_center, color: typeColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      Text('$company · $location',
                          style: const TextStyle(
                              color: AppColor.greyColor, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: typeColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    type,
                    style: TextStyle(
                        color: typeColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            if (skills.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: skills
                    .take(4)
                    .map((s) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColor.backgroundLight,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                                color: AppColor.lightGreyColor),
                          ),
                          child: Text(s,
                              style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColor.blackColor)),
                        ))
                    .toList(),
              ),
            ],
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _showJobSheet(context, job),
                icon: const Icon(Icons.open_in_new, size: 14),
                label: const Text('View & Apply'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColor.primaryColor,
                  side: const BorderSide(color: AppColor.primaryColor),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Role Badge
// ════════════════════════════════════════════════════════════════════════════
class _RoleBadge extends StatelessWidget {
  final String role;
  final bool small;
  const _RoleBadge({required this.role, this.small = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: small ? 5 : 7, vertical: small ? 1 : 2),
      decoration: BoxDecoration(
        color: AppColor.primaryColor.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(
          color: AppColor.primaryColor,
          fontSize: small ? 8 : 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Empty / Error states
// ════════════════════════════════════════════════════════════════════════════
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  const _EmptyState({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: AppColor.lightGreyColor),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColor.greyColor, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 52, color: AppColor.greyColor),
            const SizedBox(height: 12),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColor.greyColor)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Bottom Sheets (Channel / Member / Job)
// ════════════════════════════════════════════════════════════════════════════
void _showChannelSheet(BuildContext context, ChannelModel channel) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => _ChannelSheet(channel: channel),
  );
}

void _showMemberSheet(BuildContext context, User user) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => _MemberSheet(user: user),
  );
}

void _showJobSheet(BuildContext context, Map<String, dynamic> job) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.white,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => _JobSheet(job: job),
  );
}

// ── Channel Sheet ─────────────────────────────────────────────────────────
class _ChannelSheet extends StatelessWidget {
  final ChannelModel channel;
  const _ChannelSheet({required this.channel});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.45,
      minChildSize: 0.3,
      maxChildSize: 0.7,
      builder: (_, sc) => ListView(
        controller: sc,
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        children: [
          _SheetHandle(),
          const SizedBox(height: 16),
          Row(children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppColor.primaryColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.tag,
                  color: AppColor.primaryColor, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('#${channel.name ?? ''}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    Text('${channel.memberCount ?? 0} posts',
                        style: const TextStyle(
                            color: AppColor.greyColor, fontSize: 13)),
                  ]),
            ),
          ]),
          const SizedBox(height: 16),
          if ((channel.description ?? '').isNotEmpty) ...[
            Text(channel.description!,
                style: const TextStyle(fontSize: 14, height: 1.5)),
            const SizedBox(height: 20),
          ],
          ElevatedButton.icon(
            onPressed: () {
              Get.back();
              Get.snackbar('Joined', 'You joined #${channel.name}',
                  snackPosition: SnackPosition.BOTTOM);
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Join Channel',
                style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Member Sheet ──────────────────────────────────────────────────────────
class _MemberSheet extends StatelessWidget {
  final User user;
  const _MemberSheet({required this.user});

  @override
  Widget build(BuildContext context) {
    final name = user.fullName?.isNotEmpty == true
        ? user.fullName!
        : user.username ?? 'User';
    final avatarUrl = user.avatarUrl?.trim() ?? '';
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.50,
      minChildSize: 0.35,
      maxChildSize: 0.75,
      builder: (_, sc) => ListView(
        controller: sc,
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        children: [
          _SheetHandle(),
          const SizedBox(height: 20),
          Center(
            child: CircleAvatar(
              radius: 44,
              backgroundColor:
                  AppColor.primaryColor.withValues(alpha: 0.12),
              backgroundImage:
                  avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
              child: avatarUrl.isEmpty
                  ? Text(initials.isEmpty ? 'U' : initials,
                      style: const TextStyle(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 26))
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Column(children: [
              Text(name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 2),
              Text('@${user.username ?? ''}',
                  style: const TextStyle(
                      color: AppColor.primaryColor,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              _RoleBadge(role: user.role ?? 'MEMBER'),
            ]),
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _ProfileAction(
              icon: Icons.message_outlined,
              label: 'Message',
              onTap: () {
                Get.back();
                Get.snackbar('Info', 'Direct messaging coming soon',
                    snackPosition: SnackPosition.BOTTOM);
              },
            ),
            _ProfileAction(
              icon: Icons.person_add_outlined,
              label: 'Follow',
              onTap: () {
                Get.back();
                Get.snackbar('Followed', 'You followed $name',
                    snackPosition: SnackPosition.BOTTOM);
              },
            ),
            _ProfileAction(
              icon: Icons.share_outlined,
              label: 'Share',
              onTap: () {
                Clipboard.setData(
                    ClipboardData(text: 'Check out $name on TechNation Hub!'));
                Get.back();
                Get.snackbar('Copied', 'Profile link copied',
                    snackPosition: SnackPosition.BOTTOM);
              },
            ),
          ]),
        ],
      ),
    );
  }
}

class _ProfileAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ProfileAction(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColor.primaryColor, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppColor.greyColor)),
        ],
      ),
    );
  }
}

// ── Job Sheet ──────────────────────────────────────────────────────────────
class _JobSheet extends StatelessWidget {
  final Map<String, dynamic> job;
  const _JobSheet({required this.job});

  @override
  Widget build(BuildContext context) {
    final title = job['title']?.toString() ?? '';
    final company = job['company']?.toString() ?? '';
    final location = job['location']?.toString() ?? '';
    final type = (job['type']?.toString() ?? '').toUpperCase();
    final description = job['description']?.toString() ?? '';
    final applyUrl = job['apply_url']?.toString() ?? '';
    final List<String> skills = job['skills_required'] != null
        ? List<String>.from(job['skills_required'])
        : [];
    final isRemote = type == 'REMOTE';
    final typeColor = isRemote ? Colors.green : Colors.orange;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.60,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, sc) => ListView(
        controller: sc,
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        children: [
          _SheetHandle(),
          const SizedBox(height: 20),
          Row(children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.business_center,
                  color: typeColor, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    Text('$company · $location',
                        style: const TextStyle(
                            color: AppColor.greyColor, fontSize: 13)),
                  ]),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(type,
                  style: TextStyle(
                      color: typeColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
            ),
          ]),
          const SizedBox(height: 20),
          if (skills.isNotEmpty) ...[
            const Text('Required Skills',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: skills
                  .map((s) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColor.backgroundLight,
                          borderRadius: BorderRadius.circular(8),
                          border:
                              Border.all(color: AppColor.lightGreyColor),
                        ),
                        child: Text(s,
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColor.blackColor)),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
          ],
          if (description.isNotEmpty) ...[
            const Text('About this role',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            Text(description,
                style:
                    const TextStyle(fontSize: 14, height: 1.55)),
            const SizedBox(height: 24),
          ],
          ElevatedButton.icon(
            onPressed: () {
              if (applyUrl.isNotEmpty) {
                Clipboard.setData(ClipboardData(text: applyUrl));
                Get.back();
                Get.snackbar(
                    'Apply Link Copied',
                    'Open your browser and paste the link to apply',
                    snackPosition: SnackPosition.BOTTOM);
              } else {
                Get.back();
                Get.snackbar('Info', 'No application link provided',
                    snackPosition: SnackPosition.BOTTOM);
              }
            },
            icon: const Icon(Icons.send, color: Colors.white, size: 18),
            label: const Text('Apply Now',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Sheet Handle ─────────────────────────────────────────────────────────────
class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        decoration: BoxDecoration(
          color: AppColor.lightGreyColor,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}
