import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technation_hub/Models/study_group_model.dart';
import 'package:technation_hub/controllers/study_group_controller.dart';
import 'package:technation_hub/data/response/status.dart';
import 'package:technation_hub/res/Colors/colors.dart';

class StudyGroupsScreen extends StatefulWidget {
  const StudyGroupsScreen({super.key});

  @override
  State<StudyGroupsScreen> createState() => _StudyGroupsScreenState();
}

class _StudyGroupsScreenState extends State<StudyGroupsScreen> {
  final StudyGroupController controller = Get.put(StudyGroupController());
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
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
          'Study Groups',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: controller.refreshAll,
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Refresh',
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'study_groups_fab',
        backgroundColor: AppColor.primaryColor,
        onPressed: () => _showCreateGroupSheet(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          // ── Tab Toggle ───────────────────────────────────────────────────
          _TabToggle(controller: controller),

          // ── Search Bar (discover tab only) ───────────────────────────────
          Obx(() => controller.selectedTab.value == 'discover'
              ? _SearchBar(
                  textController: _searchCtrl,
                  onChanged: controller.onSearch,
                )
              : const SizedBox.shrink()),

          // ── Body ─────────────────────────────────────────────────────────
          Expanded(
            child: Obx(() {
              if (controller.selectedTab.value == 'my') {
                return _MyGroupsBody(controller: controller);
              }
              return _DiscoverBody(controller: controller);
            }),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Tab Toggle
// ════════════════════════════════════════════════════════════════════════════
class _TabToggle extends StatelessWidget {
  final StudyGroupController controller;
  const _TabToggle({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.backgroundDark,
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
      child: Obx(() {
        final isDiscover = controller.selectedTab.value == 'discover';
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              _Tab(
                label: 'My Groups',
                isActive: !isDiscover,
                onTap: () => controller.switchTab('my'),
              ),
              _Tab(
                label: 'Discover',
                isActive: isDiscover,
                onTap: () => controller.switchTab('discover'),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _Tab(
      {required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? AppColor.primaryColor : Colors.white70,
                fontWeight:
                    isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Search Bar
// ════════════════════════════════════════════════════════════════════════════
class _SearchBar extends StatelessWidget {
  final TextEditingController textController;
  final ValueChanged<String> onChanged;
  const _SearchBar(
      {required this.textController, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: TextField(
        controller: textController,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Search by name, topic…',
          prefixIcon:
              const Icon(Icons.search, color: AppColor.greyColor),
          suffixIcon: textController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: AppColor.greyColor),
                  onPressed: () {
                    textController.clear();
                    onChanged('');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColor.lightGreyColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColor.lightGreyColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(
                color: AppColor.primaryColor, width: 1.5),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// My Groups Body
// ════════════════════════════════════════════════════════════════════════════
class _MyGroupsBody extends StatelessWidget {
  final StudyGroupController controller;
  const _MyGroupsBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = controller.rxMyGroups.value.status;
      if (status == Status.LOADING) {
        return const Center(
            child: CircularProgressIndicator(
                color: AppColor.primaryColor));
      }
      if (status == Status.ERROR) {
        return _ErrorState(
            message: controller.rxMyGroups.value.message ?? '',
            onRetry: controller.fetchMyGroups);
      }
      final groups = controller.rxMyGroups.value.data ?? [];
      if (groups.isEmpty) {
        return _EmptyState(
          icon: Icons.group_outlined,
          title: 'No groups yet',
          subtitle:
              'Join or create a study group\nto get started.',
          action: 'Discover Groups',
          onAction: () => controller.switchTab('discover'),
        );
      }
      return RefreshIndicator(
        color: AppColor.primaryColor,
        onRefresh: () async => controller.fetchMyGroups(),
        child: ListView.builder(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: groups.length,
          itemBuilder: (_, i) => _MyGroupCard(
            group: groups[i],
            isLeaving:
                controller.actionId.value == groups[i].id,
            onLeave: () =>
                controller.leaveGroup(groups[i].id ?? ''),
            onChat: () =>
                _openGroupChat(context, groups[i]),
          ),
        ),
      );
    });
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Discover Body
// ════════════════════════════════════════════════════════════════════════════
class _DiscoverBody extends StatelessWidget {
  final StudyGroupController controller;
  const _DiscoverBody({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = controller.rxAllGroups.value.status;
      if (status == Status.LOADING) {
        return const Center(
            child: CircularProgressIndicator(
                color: AppColor.primaryColor));
      }
      if (status == Status.ERROR) {
        return _ErrorState(
            message: controller.rxAllGroups.value.message ?? '',
            onRetry: controller.fetchStudyGroups);
      }
      final groups = controller.filteredGroups;
      if (groups.isEmpty) {
        return _EmptyState(
          icon: Icons.search_off_rounded,
          title: 'No groups found',
          subtitle: 'Try a different search term\nor create a new group.',
        );
      }
      return RefreshIndicator(
        color: AppColor.primaryColor,
        onRefresh: () async => controller.fetchStudyGroups(),
        child: ListView.builder(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: groups.length,
          itemBuilder: (_, i) {
            final g = groups[i];
            return Obx(() => _DiscoverGroupCard(
                  group: g,
                  isActing:
                      controller.actionId.value == g.id,
                  onJoin: () =>
                      controller.joinGroup(g.id ?? ''),
                  onLeave: () =>
                      controller.leaveGroup(g.id ?? ''),
                  onTap: () =>
                      _showGroupDetailSheet(context, g, controller),
                ));
          },
        ),
      );
    });
  }
}

// ════════════════════════════════════════════════════════════════════════════
// My Group Card (joined groups — with chat button)
// ════════════════════════════════════════════════════════════════════════════
class _MyGroupCard extends StatelessWidget {
  final StudyGroupModel group;
  final bool isLeaving;
  final VoidCallback onLeave;
  final VoidCallback onChat;

  const _MyGroupCard({
    required this.group,
    required this.isLeaving,
    required this.onLeave,
    required this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
        children: [
          // ── Header ─────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.primaryColor.withValues(alpha: 0.08),
                  AppColor.primaryColor.withValues(alpha: 0.02),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                _GroupAvatar(name: group.name ?? ''),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        group.topic ?? 'General',
                        style: const TextStyle(
                          color: AppColor.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColor.successColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'MEMBER',
                    style: TextStyle(
                      color: AppColor.successColor,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Meta row ───────────────────────────────────────────────
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _MetaChip(
                  icon: Icons.people_outline,
                  label:
                      '${group.memberCount ?? 0}/${group.maxMembers ?? 20}',
                ),
                const SizedBox(width: 12),
                if ((group.schedule ?? '').isNotEmpty)
                  Flexible(
                    child: _MetaChip(
                      icon: Icons.schedule_outlined,
                      label: group.schedule!,
                    ),
                  ),
              ],
            ),
          ),

          if ((group.description ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Text(
                group.description!,
                style: const TextStyle(
                    color: AppColor.greyColor,
                    fontSize: 12,
                    height: 1.4),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          const Divider(height: 1),

          // ── Actions ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isLeaving
                        ? null
                        : () => _confirmLeave(context),
                    icon: isLeaving
                        ? const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColor.errorColor))
                        : const Icon(Icons.exit_to_app,
                            size: 16, color: AppColor.errorColor),
                    label: const Text('Leave',
                        style: TextStyle(color: AppColor.errorColor)),
                    style: OutlinedButton.styleFrom(
                      side:
                          const BorderSide(color: AppColor.errorColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding:
                          const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: onChat,
                    icon: const Icon(Icons.chat_bubble_outline,
                        size: 16, color: Colors.white),
                    label: const Text('Open Chat',
                        style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primaryColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding:
                          const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLeave(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Leave Group?',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text(
            'Are you sure you want to leave "${group.name}"?'),
        actions: [
          TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              onLeave();
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.errorColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Discover Group Card
// ════════════════════════════════════════════════════════════════════════════
class _DiscoverGroupCard extends StatelessWidget {
  final StudyGroupModel group;
  final bool isActing;
  final VoidCallback onJoin;
  final VoidCallback onLeave;
  final VoidCallback onTap;

  const _DiscoverGroupCard({
    required this.group,
    required this.isActing,
    required this.onJoin,
    required this.onLeave,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMember = group.isMember ?? false;
    final memberCount = group.memberCount ?? 0;
    final maxMembers = group.maxMembers ?? 20;
    final fillRatio = maxMembers > 0 ? memberCount / maxMembers : 0.0;
    final isFull = memberCount >= maxMembers;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isMember
                ? AppColor.primaryColor.withValues(alpha: 0.4)
                : AppColor.lightGreyColor,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Title row ──────────────────────────────────────
              Row(
                children: [
                  _GroupAvatar(name: group.name ?? '', size: 42),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                group.name ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isMember) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColor.primaryColor
                                      .withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('JOINED',
                                    style: TextStyle(
                                        color: AppColor.primaryColor,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                            if (isFull && !isMember) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColor.errorColor
                                      .withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('FULL',
                                    style: TextStyle(
                                        color: AppColor.errorColor,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          group.topic ?? 'General',
                          style: const TextStyle(
                              color: AppColor.primaryColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              if ((group.description ?? '').isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  group.description!,
                  style: const TextStyle(
                      color: AppColor.greyColor,
                      fontSize: 13,
                      height: 1.4),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),

              // ── Meta ───────────────────────────────────────────
              Row(
                children: [
                  _MetaChip(
                    icon: Icons.people_outline,
                    label: '$memberCount/$maxMembers members',
                  ),
                  const SizedBox(width: 10),
                  if ((group.schedule ?? '').isNotEmpty)
                    Flexible(
                      child: _MetaChip(
                        icon: Icons.schedule_outlined,
                        label: group.schedule!,
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 10),

              // ── Member fill progress bar ────────────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: fillRatio.clamp(0.0, 1.0),
                  minHeight: 4,
                  backgroundColor: AppColor.lightGreyColor,
                  color: isFull
                      ? AppColor.errorColor
                      : AppColor.primaryColor,
                ),
              ),

              const SizedBox(height: 14),

              // ── Action button ──────────────────────────────────
              SizedBox(
                width: double.infinity,
                child: isMember
                    ? OutlinedButton.icon(
                        onPressed: isActing ? null : onLeave,
                        icon: isActing
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColor.errorColor))
                            : const Icon(Icons.exit_to_app,
                                size: 16, color: AppColor.errorColor),
                        label: const Text('Leave Group',
                            style:
                                TextStyle(color: AppColor.errorColor)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: AppColor.errorColor),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed:
                            (isActing || isFull) ? null : onJoin,
                        icon: isActing
                            ? const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white))
                            : const Icon(Icons.group_add,
                                size: 16, color: Colors.white),
                        label: Text(
                            isFull ? 'Group Full' : 'Join Group',
                            style:
                                const TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isFull
                              ? AppColor.greyColor
                              : AppColor.primaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          padding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Group Detail Bottom Sheet
// ════════════════════════════════════════════════════════════════════════════
void _showGroupDetailSheet(
    BuildContext context,
    StudyGroupModel group,
    StudyGroupController controller) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) =>
        _GroupDetailSheet(group: group, controller: controller),
  );
}

class _GroupDetailSheet extends StatefulWidget {
  final StudyGroupModel group;
  final StudyGroupController controller;

  const _GroupDetailSheet(
      {required this.group, required this.controller});

  @override
  State<_GroupDetailSheet> createState() => _GroupDetailSheetState();
}

class _GroupDetailSheetState extends State<_GroupDetailSheet> {
  List<Map<String, dynamic>> _members = [];
  bool _loadingMembers = true;

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    try {
      final members =
          await widget.controller.fetchGroupMembers(widget.group.id ?? '');
      if (mounted) {
        setState(() {
          _members = members;
          _loadingMembers = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingMembers = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.group;
    final memberCount = group.memberCount ?? 0;
    final maxMembers = group.maxMembers ?? 20;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      builder: (_, sc) => ListView(
        controller: sc,
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
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
          const SizedBox(height: 20),

          // Group header
          Row(
            children: [
              _GroupAvatar(name: group.name ?? '', size: 56),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group.name ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                    const SizedBox(height: 3),
                    Text(group.topic ?? 'General',
                        style: const TextStyle(
                            color: AppColor.primaryColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 13)),
                    const SizedBox(height: 3),
                    Text('$memberCount / $maxMembers members',
                        style: const TextStyle(
                            color: AppColor.greyColor, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),

          if ((group.description ?? '').isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(group.description!,
                style: const TextStyle(
                    fontSize: 14, height: 1.55, color: AppColor.blackColor)),
          ],

          const SizedBox(height: 16),

          // Meta chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              if ((group.schedule ?? '').isNotEmpty)
                _DetailChip(
                    icon: Icons.schedule_outlined,
                    label: group.schedule!),
              _DetailChip(
                  icon: Icons.people_outline,
                  label: '$memberCount/$maxMembers members'),
              _DetailChip(
                  icon: group.isOpen == true
                      ? Icons.lock_open_outlined
                      : Icons.lock_outline,
                  label:
                      group.isOpen == true ? 'Open' : 'Private'),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Members
          Row(
            children: [
              const Text('Members',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              const Spacer(),
              if (_loadingMembers)
                const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColor.primaryColor)),
            ],
          ),
          const SizedBox(height: 12),

          if (!_loadingMembers && _members.isEmpty)
            const Text('No members yet.',
                style: TextStyle(color: AppColor.greyColor))
          else
            ..._members.map((m) => _MemberRow(member: m)),

          const SizedBox(height: 24),

          // Action button
          Obx(() {
            final isMember = group.isMember ?? false;
            final isActing =
                widget.controller.actionId.value == group.id;
            final isFull = memberCount >= maxMembers;

            return isMember
                ? OutlinedButton.icon(
                    onPressed: isActing
                        ? null
                        : () {
                            Get.back();
                            widget.controller
                                .leaveGroup(group.id ?? '');
                          },
                    icon: const Icon(Icons.exit_to_app,
                        size: 16, color: AppColor.errorColor),
                    label: const Text('Leave Group',
                        style: TextStyle(color: AppColor.errorColor)),
                    style: OutlinedButton.styleFrom(
                      side:
                          const BorderSide(color: AppColor.errorColor),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  )
                : ElevatedButton.icon(
                    onPressed: (isActing || isFull)
                        ? null
                        : () {
                            Get.back();
                            widget.controller
                                .joinGroup(group.id ?? '');
                          },
                    icon: isActing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.group_add,
                            size: 16, color: Colors.white),
                    label: Text(
                        isFull ? 'Group Full' : 'Join Group',
                        style: const TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFull
                          ? AppColor.greyColor
                          : AppColor.primaryColor,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                  );
          }),
        ],
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  final Map<String, dynamic> member;
  const _MemberRow({required this.member});

  @override
  Widget build(BuildContext context) {
    final name = (member['full_name'] as String?)?.isNotEmpty == true
        ? member['full_name']! as String
        : member['username']?.toString() ?? 'User';
    final avatarUrl = (member['avatar_url'] as String?)?.trim() ?? '';
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColor.primaryColor.withValues(alpha: 0.12),
            backgroundImage:
                avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
            child: avatarUrl.isEmpty
                ? Text(initials.isEmpty ? 'U' : initials,
                    style: const TextStyle(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12))
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 13)),
                Text('@${member['username'] ?? ''}',
                    style: const TextStyle(
                        color: AppColor.greyColor, fontSize: 11)),
              ],
            ),
          ),
          if (member['role'] != null)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color:
                    AppColor.primaryColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                (member['role'] as String).toUpperCase(),
                style: const TextStyle(
                    color: AppColor.primaryColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Create Group Sheet
// ════════════════════════════════════════════════════════════════════════════
void _showCreateGroupSheet(BuildContext context) {
  final controller = Get.find<StudyGroupController>();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => _CreateGroupSheet(controller: controller),
  );
}

class _CreateGroupSheet extends StatefulWidget {
  final StudyGroupController controller;
  const _CreateGroupSheet({required this.controller});

  @override
  State<_CreateGroupSheet> createState() => _CreateGroupSheetState();
}

class _CreateGroupSheetState extends State<_CreateGroupSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _topicCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _scheduleCtrl = TextEditingController();
  int _maxMembers = 20;
  bool _submitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _topicCtrl.dispose();
    _descCtrl.dispose();
    _scheduleCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    widget.controller.createGroup(
      name: _nameCtrl.text.trim(),
      topic: _topicCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      schedule: _scheduleCtrl.text.trim(),
      maxMembers: _maxMembers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.75,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, sc) => Form(
          key: _formKey,
          child: ListView(
            controller: sc,
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
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
              const Text('Create a Study Group',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 20),

              _FormField(
                controller: _nameCtrl,
                label: 'Group Name',
                icon: Icons.group_outlined,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Name is required'
                    : null,
              ),
              const SizedBox(height: 14),
              _FormField(
                controller: _topicCtrl,
                label: 'Topic (e.g. Flutter, Data Science)',
                icon: Icons.topic_outlined,
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Topic is required'
                    : null,
              ),
              const SizedBox(height: 14),
              _FormField(
                controller: _descCtrl,
                label: 'Description',
                icon: Icons.notes_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 14),
              _FormField(
                controller: _scheduleCtrl,
                label: 'Schedule (e.g. Mon & Wed 7PM)',
                icon: Icons.schedule_outlined,
              ),
              const SizedBox(height: 20),

              // Max members slider
              Row(
                children: [
                  const Icon(Icons.people_outline,
                      color: AppColor.primaryColor, size: 20),
                  const SizedBox(width: 8),
                  const Text('Max Members:',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text('$_maxMembers',
                      style: const TextStyle(
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ],
              ),
              Slider(
                value: _maxMembers.toDouble(),
                min: 2,
                max: 50,
                divisions: 48,
                activeColor: AppColor.primaryColor,
                onChanged: (v) =>
                    setState(() => _maxMembers = v.round()),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _submitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: _submitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Create Group',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Group Chat  (navigated from My Groups → Open Chat)
// ════════════════════════════════════════════════════════════════════════════
void _openGroupChat(BuildContext context, StudyGroupModel group) {
  Get.to(() => _GroupChatScreen(group: group),
      transition: Transition.rightToLeft);
}

class _GroupChatScreen extends StatefulWidget {
  final StudyGroupModel group;
  const _GroupChatScreen({required this.group});

  @override
  State<_GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<_GroupChatScreen> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  // Local message list (chat is not yet backed by real-time API — placeholder)
  final List<_ChatMsg> _messages = [];

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _send() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMsg(body: text, isMe: true,
          time: _now(), senderName: 'You'));
    });
    _msgCtrl.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _now() {
    final t = DateTime.now();
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final memberCount = widget.group.memberCount ?? 0;
    return Scaffold(
      backgroundColor: AppColor.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.group.name ?? '',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            Text('$memberCount member${memberCount == 1 ? '' : 's'}',
                style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 11)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.white),
            onPressed: () => _showGroupDetailSheet(
                context, widget.group,
                Get.find<StudyGroupController>()),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          // ── Messages ─────────────────────────────────────────────
          Expanded(
            child: _messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _GroupAvatar(
                            name: widget.group.name ?? '',
                            size: 64),
                        const SizedBox(height: 16),
                        Text(
                          widget.group.name ?? '',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'This is the beginning of the group chat.',
                          style: TextStyle(
                              color: AppColor.greyColor),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Say hello! 👋',
                          style: TextStyle(
                              color: AppColor.greyColor,
                              fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length,
                    itemBuilder: (_, i) =>
                        _messages[i].isMe
                            ? _MyBubble(msg: _messages[i])
                            : _OtherBubble(msg: _messages[i]),
                  ),
          ),

          // ── Input ─────────────────────────────────────────────────
          Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(color: AppColor.lightGreyColor)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    maxLines: 4,
                    minLines: 1,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Message ${widget.group.name}…',
                      filled: true,
                      fillColor: AppColor.backgroundLight,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppColor.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMsg {
  final String body;
  final bool isMe;
  final String time;
  final String senderName;
  const _ChatMsg(
      {required this.body,
      required this.isMe,
      required this.time,
      required this.senderName});
}

class _MyBubble extends StatelessWidget {
  final _ChatMsg msg;
  const _MyBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: Get.width * 0.72),
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: AppColor.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
            ),
            child: Text(msg.body,
                style: const TextStyle(
                    color: Colors.white, fontSize: 14)),
          ),
          const SizedBox(height: 4),
          Text(msg.time,
              style: const TextStyle(
                  color: AppColor.greyColor, fontSize: 10)),
        ],
      ),
    );
  }
}

class _OtherBubble extends StatelessWidget {
  final _ChatMsg msg;
  const _OtherBubble({required this.msg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor:
                AppColor.primaryColor.withValues(alpha: 0.12),
            child: Text(msg.senderName[0].toUpperCase(),
                style: const TextStyle(
                    color: AppColor.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(msg.senderName,
                  style: const TextStyle(
                      color: AppColor.greyColor, fontSize: 11)),
              const SizedBox(height: 4),
              Container(
                constraints: BoxConstraints(maxWidth: Get.width * 0.68),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                  border:
                      Border.all(color: AppColor.lightGreyColor),
                ),
                child: Text(msg.body,
                    style: const TextStyle(fontSize: 14)),
              ),
              const SizedBox(height: 4),
              Text(msg.time,
                  style: const TextStyle(
                      color: AppColor.greyColor, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Shared small widgets
// ════════════════════════════════════════════════════════════════════════════
class _GroupAvatar extends StatelessWidget {
  final String name;
  final double size;
  const _GroupAvatar({required this.name, this.size = 48});

  @override
  Widget build(BuildContext context) {
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .take(2)
        .map((p) => p[0].toUpperCase())
        .join();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColor.primaryColor, Color(0xFF6B63E0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(size * 0.28),
      ),
      child: Center(
        child: Text(
          initials.isEmpty ? 'G' : initials,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size * 0.36,
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: AppColor.greyColor),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                color: AppColor.greyColor, fontSize: 12)),
      ],
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _DetailChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColor.backgroundLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColor.lightGreyColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColor.primaryColor),
          const SizedBox(width: 5),
          Text(label,
              style: const TextStyle(
                  fontSize: 12, color: AppColor.blackColor)),
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final String? Function(String?)? validator;

  const _FormField({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColor.primaryColor),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColor.lightGreyColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColor.lightGreyColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
              color: AppColor.primaryColor, width: 1.5),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? action;
  final VoidCallback? onAction;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColor.lightGreyColor),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                    color: AppColor.blackColor)),
            const SizedBox(height: 8),
            Text(subtitle,
                style: const TextStyle(
                    color: AppColor.greyColor, height: 1.4),
                textAlign: TextAlign.center),
            if (action != null && onAction != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 12),
                ),
                child: Text(action!),
              ),
            ],
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.wifi_off_rounded,
              size: 52, color: AppColor.greyColor),
          const SizedBox(height: 12),
          Text(message,
              style: const TextStyle(color: AppColor.greyColor),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
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
    );
  }
}
