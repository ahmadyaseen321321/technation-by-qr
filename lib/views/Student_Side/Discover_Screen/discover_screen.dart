import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technation_hub/controllers/discover_controller.dart';
import 'package:technation_hub/data/response/status.dart';
import '../../../res/Colors/colors.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final controller = Get.put(DiscoverController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: AppColor.blackColor),
        title: const Text(
          'Discover',
          style: TextStyle(color: AppColor.blackColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => controller.fetchDiscoverData(),
            icon: const Icon(Icons.refresh, color: AppColor.blackColor),
          ),
          const Icon(Icons.search, color: AppColor.blackColor),
          const SizedBox(width: 16),
        ],
      ),
      body: Obx(() {
        switch (controller.rxDiscoverData.value.status) {
          case Status.LOADING:
            return const Center(child: CircularProgressIndicator());
          case Status.ERROR:
            return Center(child: Text(controller.rxDiscoverData.value.message.toString()));
          case Status.COMPLETED:
            final data = controller.rxDiscoverData.value.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search channels, members, jobs...',
                        prefixIcon: const Icon(Icons.search, color: AppColor.greyColor),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColor.lightGreyColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(color: AppColor.lightGreyColor),
                        ),
                      ),
                    ),
                  ),
                  
                  // Tabs
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildTab('All', isActive: true),
                        _buildTab('Channels'),
                        _buildTab('Members'),
                        _buildTab('Jobs'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Trending Channels
                  _buildSectionHeader('Trending Channels 🔥'),
                  Container(
                    height: 180,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: data.channels?.length ?? 0,
                      itemBuilder: (context, index) {
                        final channel = data.channels![index];
                        return _buildChannelCard(
                          channel.name ?? '', 
                          '${channel.description?.substring(0, 20)}...', 
                          Icons.code_rounded
                        );
                      },
                    ),
                  ),
                  
                  // New Members
                  _buildSectionHeader('New Members 👋'),
                  Container(
                    height: 150,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: data.members?.length ?? 0,
                      itemBuilder: (context, index) {
                        final member = data.members![index];
                        return _buildMemberItem(member.fullName ?? 'User', member.role?.toUpperCase() ?? 'MEMBER');
                      },
                    ),
                  ),
                  
                  // Study Groups
                  if (data.groups != null && data.groups!.isNotEmpty) ...[
                    _buildSectionHeader('Study Groups 📚'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: data.groups!.map((g) => _buildStudyGroupCard(
                          g['name'], 
                          '${g['max_members']} max', 
                          g['topic'] ?? 'General'
                        )).toList(),
                      ),
                    ),
                  ],
                  
                  // Latest Jobs
                  if (data.jobs != null && data.jobs!.isNotEmpty) ...[
                    _buildSectionHeader('Latest Jobs 💼', showViewAll: true),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: data.jobs!.map((j) => _buildJobCard(
                          j['title'], 
                          '${j['company']} • ${j['location']}', 
                          j['type'].toString().toUpperCase(), 
                          List<String>.from(j['skills_required'] ?? [])
                        )).toList(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            );
        }
      }),
    );
  }

  Widget _buildTab(String text, {bool isActive = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: isActive ? AppColor.primaryColor : AppColor.greyColor,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 2,
              width: 20,
              color: AppColor.primaryColor,
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showViewAll = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            showViewAll ? 'View all' : 'See all',
            style: const TextStyle(color: AppColor.primaryColor, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildChannelCard(String name, String members, IconData icon) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.lightGreyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColor.primaryColor, size: 30),
          const Spacer(),
          Text(
            name, 
            style: const TextStyle(fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            members, 
            style: TextStyle(color: AppColor.greyColor, fontSize: 11),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
              const SizedBox(width: 4),
              const Text('Active', style: TextStyle(color: Colors.green, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMemberItem(String name, String role) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=$name'),
          ),
          const SizedBox(height: 8),
          Text(
            name, 
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColor.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(role, style: const TextStyle(color: AppColor.primaryColor, fontSize: 8, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyGroupCard(String title, String members, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.lightGreyColor),
      ),
      child: Row(
        children: [
          Container(width: 4, height: 40, decoration: BoxDecoration(color: AppColor.primaryColor, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(Icons.people_outline, size: 14, color: AppColor.greyColor),
                    const SizedBox(width: 4),
                    Text(members, style: TextStyle(color: AppColor.greyColor, fontSize: 12)),
                    const SizedBox(width: 12),
                    Icon(Icons.access_time, size: 14, color: AppColor.greyColor),
                    const SizedBox(width: 4),
                    Text(time, style: TextStyle(color: AppColor.greyColor, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24),
            ),
            child: const Text('Join', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard(String title, String company, String type, List<String> tags) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColor.lightGreyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: type == 'REMOTE' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(type == 'REMOTE' ? Icons.laptop : Icons.business, size: 12, color: type == 'REMOTE' ? Colors.green : Colors.orange),
                    const SizedBox(width: 4),
                    Text(type, style: TextStyle(color: type == 'REMOTE' ? Colors.green : Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          Text(company, style: TextStyle(color: AppColor.greyColor, fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            children: tags.map((tag) => Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColor.lightGreyColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(tag, style: const TextStyle(color: AppColor.blackColor, fontSize: 11)),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
