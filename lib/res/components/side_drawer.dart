import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Colors/colors.dart';
import '../routes/routes_names.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.only(top: 60, left: 24, bottom: 32, right: 24),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColor.backgroundDark,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=ahmad'),
                  // In a real app, this would be the user's profile image
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ahmad Raza',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Senior Flutter Developer',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              children: [
                _buildMenuItem(
                  icon: Icons.dashboard_customize_outlined,
                  title: 'Channels',
                  isSelected: true,
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.groups_outlined,
                  title: 'Study Groups',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.work_outline,
                  title: 'Job Board',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.notifications_none_outlined,
                  title: 'Notifications',
                  badge: '3',
                  onTap: () {},
                ),
                _buildMenuItem(
                  icon: Icons.bookmark_border,
                  title: 'Bookmarks',
                  onTap: () {},
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Divider(color: AppColor.lightGreyColor),
                ),
                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {},
                ),
              ],
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColor.lightGreyColor, width: 0.5)),
            ),
            child: Column(
              children: [
                _buildMenuItem(
                  icon: Icons.logout,
                  title: 'Log Out',
                  titleColor: Colors.orange[800]!,
                  iconColor: Colors.orange[800]!,
                  onTap: () => Get.offAllNamed(RouteName.loginScreen),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFooterLink('Terms & Conditions'),
                    const SizedBox(width: 12),
                    _buildFooterLink('Privacy Policy'),
                  ],
                ),
                const SizedBox(height: 8),
                _buildFooterLink('Policy of Use'),
                const SizedBox(height: 24),
                const Text(
                  'v2.4.0',
                  style: TextStyle(color: AppColor.greyColor, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    bool isSelected = false,
    String? badge,
    Color? titleColor,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColor.primaryColor.withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          icon,
          color: iconColor ?? (isSelected ? AppColor.primaryColor : AppColor.backgroundDark.withOpacity(0.7)),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: titleColor ?? (isSelected ? AppColor.primaryColor : AppColor.backgroundDark),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 16,
          ),
        ),
        trailing: badge != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColor.primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildFooterLink(String text) {
    return Text(
      text,
      style: const TextStyle(color: AppColor.greyColor, fontSize: 12),
    );
  }
}
