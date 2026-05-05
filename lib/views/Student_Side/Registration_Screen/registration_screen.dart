import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/Colors/colors.dart';
import '../../../res/routes/routes_names.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final List<String> _interests = [
    'Python', 'Web Dev', 'Networking', 'Cybersecurity', 'DevOps', 'Databases', 'Mobile Dev', 'AI/ML'
  ];
  final List<String> _selectedInterests = ['Python', 'Cybersecurity', 'AI/ML'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColor.backgroundDark,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text('Register yourself', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          const Icon(Icons.info_outline, color: Colors.white),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Create Your Account',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColor.blackColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Join the community of elite IT professionals and students.',
              style: TextStyle(color: AppColor.greyColor),
            ),
            const SizedBox(height: 32),
            
            // Fields
            _buildTextField(Icons.person_outline, 'Full Name'),
            const SizedBox(height: 16),
            _buildTextField(Icons.email_outlined, 'Email Address'),
            const SizedBox(height: 16),
            _buildTextField(Icons.alternate_email, '@handle'),
            const SizedBox(height: 16),
            _buildTextField(Icons.lock_outline, 'Password', isPassword: true),
            const SizedBox(height: 32),
            
            // Interests
            const Text('Select your interests', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _interests.map((interest) {
                final isSelected = _selectedInterests.contains(interest);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedInterests.remove(interest);
                      } else {
                        _selectedInterests.add(interest);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColor.primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? AppColor.primaryColor : AppColor.lightGreyColor),
                    ),
                    child: Text(
                      interest,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColor.greyColor,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            
            // Join Button
            ElevatedButton(
              onPressed: () => Get.offAllNamed(RouteName.homeScreen),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.primaryColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Join Free >', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 32),
            
            // Social Logins
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.g_mobiledata, color: AppColor.googleRed, size: 30),
                    label: const Text('Google', style: TextStyle(color: Colors.black87)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: AppColor.lightGreyColor),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.code, color: AppColor.githubBlack),
                    label: const Text('GitHub', style: TextStyle(color: Colors.black87)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: AppColor.lightGreyColor),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Footer
            Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(color: AppColor.greyColor, fontSize: 12),
                  children: const [
                    TextSpan(text: 'By joining you agree to our '),
                    TextSpan(text: 'Terms', style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold)),
                    TextSpan(text: ' & '),
                    TextSpan(text: 'Privacy Policy', style: TextStyle(color: AppColor.primaryColor, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Banner
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Mock circuit pattern
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.1,
                        child: CustomPaint(painter: CircuitPainter()),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'TECHNATION ELITE',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Connect with 50k+ Developers Worldwide',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColor.lightGreyColor),
      ),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: AppColor.greyColor),
          suffixIcon: isPassword ? const Icon(Icons.visibility_outlined, color: AppColor.greyColor) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        ),
      ),
    );
  }
}

class CircuitPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    // Basic circuit lines
    for (var i = 0; i < 5; i++) {
      canvas.drawLine(Offset(0, 30.0 * i), Offset(size.width, 30.0 * i + 20), paint);
      canvas.drawCircle(Offset(size.width / 2, 30.0 * i), 4, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
