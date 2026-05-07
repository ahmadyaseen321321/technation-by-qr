import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:technation_hub/Models/channel_model.dart';
import 'package:technation_hub/Models/post_model.dart';
import 'package:technation_hub/controllers/home_controller.dart';
import 'package:technation_hub/data/response/status.dart';
import '../../../res/Colors/colors.dart';
import '../../../res/components/side_drawer.dart';
import 'python_channel_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundLight,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: AppColor.backgroundDark,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'TechNation Hub',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => controller.fetchHomeData(),
            icon: const Icon(Icons.refresh, color: Colors.white),
          ),
          const Icon(Icons.search, color: Colors.white),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Categories (Channels)
          Obx(() {
            switch (controller.rxChannelList.value.status) {
              case Status.LOADING:
                return const SizedBox(height: 60, child: Center(child: CircularProgressIndicator()));
              case Status.ERROR:
                return SizedBox(height: 60, child: Center(child: Text(controller.rxChannelList.value.message.toString())));
              case Status.COMPLETED:
                return Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: (controller.rxChannelList.value.data?.length ?? 0) + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return _buildCategory('All', isActive: true, onTap: () {});
                      }
                      final channel = controller.rxChannelList.value.data![index - 1];
                      return _buildCategory(channel.name ?? '', onTap: () {
                        if (channel.name == 'Python') {
                          Get.to(() => const PythonChannelScreen());
                        }
                      });
                    },
                  ),
                );
            }
          }),
          
          // Feed (Posts)
          Expanded(
            child: Obx(() {
              switch (controller.rxPostList.value.status) {
                case Status.LOADING:
                  return const Center(child: CircularProgressIndicator());
                case Status.ERROR:
                  return Center(child: Text(controller.rxPostList.value.message.toString()));
                case Status.COMPLETED:
                  return RefreshIndicator(
                    onRefresh: () async => controller.fetchFeed(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: controller.rxPostList.value.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        final post = controller.rxPostList.value.data![index];
                        return _buildPostCard(
                          userName: post.fullName ?? 'Unknown',
                          userHandle: '@${post.username}',
                          role: post.userRole ?? 'MEMBER',
                          time: 'Just now',
                          content: post.body ?? '',
                          hasCode: post.hasCode ?? false,
                          codeContent: post.hasCode == true ? 'Source code available in thread...' : null,
                          likes: (post.reactionCounts?.length ?? 0).toString(),
                          comments: '0',
                        );
                      },
                    ),
                  );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(String text, {bool isActive = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: isActive ? AppColor.primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isActive ? AppColor.primaryColor : AppColor.lightGreyColor),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? Colors.white : AppColor.blackColor,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildPostCard({
    required String userName,
    required String userHandle,
    required String role,
    required String time,
    required String content,
    bool hasCode = false,
    String? codeContent,
    bool hasImage = false,
    int imageCount = 0,
    required String likes,
    required String comments,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppColor.lightGreyColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=$userName'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(userName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(role, style: const TextStyle(color: AppColor.primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      Text(userHandle, style: TextStyle(color: AppColor.greyColor, fontSize: 12)),
                    ],
                  ),
                ),
                Text(time, style: TextStyle(color: AppColor.greyColor, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 16),
            
            // Post Content
            Text(content, style: const TextStyle(fontSize: 14, height: 1.4)),
            const SizedBox(height: 16),
            
            // Code Snippet
            if (hasCode)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  codeContent!,
                  style: const TextStyle(color: Colors.greenAccent, fontFamily: 'monospace', fontSize: 12),
                ),
              ),
            
            // Images
            if (hasImage)
              Row(
                children: List.generate(imageCount, (index) => Expanded(
                  child: Container(
                    height: 150,
                    margin: EdgeInsets.only(right: index < imageCount - 1 ? 8 : 0),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: NetworkImage('https://picsum.photos/400/300'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )),
              ),
              
            const SizedBox(height: 16),
            
            // Interaction Row
            Row(
              children: [
                _buildInteractionItem(Icons.thumb_up_outlined, likes),
                const SizedBox(width: 16),
                _buildInteractionItem(Icons.chat_bubble_outline, comments),
                const SizedBox(width: 16),
                const Icon(Icons.share_outlined, color: AppColor.greyColor, size: 20),
                const Spacer(),
                const Icon(Icons.bookmark_border, color: AppColor.greyColor, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractionItem(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, color: AppColor.greyColor, size: 20),
        const SizedBox(width: 4),
        Text(count, style: TextStyle(color: AppColor.greyColor, fontSize: 12)),
      ],
    );
  }
}
