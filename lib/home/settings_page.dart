import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color brandGreen = Color(0xFF43A047);
    const Color backgroundColor = Color(0xFF151717);

    bool notificationsEnabled = true;
    bool darkModeEnabled = true;
    bool locationEnabled = true;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Settings
            _buildSectionTitle("Account"),
            _buildSettingTile(
              icon: Icons.person,
              title: "Edit Profile",
              subtitle: "Update your personal information",
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.security,
              title: "Privacy & Security",
              subtitle: "Manage your privacy settings",
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.notifications_active,
              title: "Notification Preferences",
              trailing: Switch(
                value: notificationsEnabled,
                activeThumbColor: brandGreen,
                onChanged: (value) {},
              ),
            ),

            const SizedBox(height: 24),

            // App Settings
            _buildSectionTitle("App Settings"),
            _buildSettingTile(
              icon: Icons.dark_mode,
              title: "Dark Mode",
              trailing: Switch(
                value: darkModeEnabled,
                activeThumbColor: brandGreen,
                onChanged: (value) {},
              ),
            ),
            _buildSettingTile(
              icon: Icons.location_on,
              title: "Location Services",
              trailing: Switch(
                value: locationEnabled,
                activeThumbColor: brandGreen,
                onChanged: (value) {},
              ),
            ),
            _buildSettingTile(
              icon: Icons.language,
              title: "Language",
              subtitle: "English",
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.area_chart,
              title: "Units",
              subtitle: "Metric",
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {},
            ),

            const SizedBox(height: 24),

            // Sustainability Settings
            _buildSectionTitle("Sustainability"),
            _buildSettingTile(
              icon: Icons.eco,
              title: "Carbon Tracking",
              subtitle: "Enable automatic CO₂ calculation",
              trailing: Switch(
                value: true,
                activeThumbColor: brandGreen,
                onChanged: (value) {},
              ),
            ),
            _buildSettingTile(
              icon: Icons.recommend,
              title: "Eco Recommendations",
              subtitle: "Get sustainable travel suggestions",
              trailing: Switch(
                value: true,
                activeThumbColor: brandGreen,
                onChanged: (value) {},
              ),
            ),
            _buildSettingTile(
              icon: Icons.analytics,
              title: "Data Sharing",
              subtitle: "Share anonymous travel data",
              trailing: Switch(
                value: false,
                activeThumbColor: brandGreen,
                onChanged: (value) {},
              ),
            ),

            const SizedBox(height: 24),

            // Support
            _buildSectionTitle("Support"),
            _buildSettingTile(
              icon: Icons.help,
              title: "Help Center",
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.description,
              title: "Terms & Conditions",
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.privacy_tip,
              title: "Privacy Policy",
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.feedback,
              title: "Send Feedback",
              onTap: () {},
            ),

            const SizedBox(height: 32),

            // App Version
            Center(
              child: Text(
                "Way2Sustain v1.0.0",
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[400],
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.grey[900]!.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey[300]),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              )
            : null,
        trailing:
            trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
