import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'select_location_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Mock logout function - replace with actual authentication logic
  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Logged out successfully"),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color brandGreen = Color(0xFF43A047);
    const Color darkGreen = Color(0xFF0A3D0A);
    const Color backgroundColor = Color(0xFF151717);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Stack(
        children: [
          // Background gradient - same as login page
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.topRight,
                  radius: 1.5,
                  colors: [darkGreen, backgroundColor],
                  stops: [0.0, 0.7],
                ),
              ),
            ),
          ),

          Column(
            children: [
              // ---------------------- APP BAR ----------------------
              AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                centerTitle: false,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Way2Sustain",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          "EcoPoints: ",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[300],
                          ),
                        ),
                        const Text(
                          "0", // Changed from 82 to 0
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color:
                                Colors.orange, // Changed to orange for 0 points
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: PopupMenuButton<String>(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: (value) {
                        if (value == "profile") {
                          _showComingSoonSnackbar(context, "Profile");
                        } else if (value == "settings") {
                          _showComingSoonSnackbar(context, "Settings");
                        } else if (value == "trips") {
                          _showComingSoonSnackbar(context, "My Trips");
                        } else if (value == "logout") {
                          _logout(context);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: "profile",
                          child: ListTile(
                            leading: Icon(Icons.person),
                            title: Text("Profile"),
                          ),
                        ),
                        const PopupMenuItem(
                          value: "settings",
                          child: ListTile(
                            leading: Icon(Icons.settings),
                            title: Text("Settings"),
                          ),
                        ),
                        const PopupMenuItem(
                          value: "trips",
                          child: ListTile(
                            leading: Icon(Icons.map),
                            title: Text("My Trips"),
                          ),
                        ),
                        const PopupMenuItem(
                          value: "logout",
                          child: ListTile(
                            leading: Icon(Icons.logout, color: Colors.red),
                            title: Text(
                              "Logout",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                      ],
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundColor: brandGreen,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              // ---------------------- BODY WITH OPENSTREETMAP ----------------------
              Expanded(
                child: Column(
                  children: [
                    // Map Section
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(
                                51.509364,
                                -0.128928,
                              ), // London coordinates
                              initialZoom: 13.0,
                            ),
                            children: [
                              // OpenStreetMap Tile Layer
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName:
                                    'com.example.sustainable_travel_app',
                              ),

                              // Marker for current location
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: LatLng(
                                      51.509364,
                                      -0.128928,
                                    ), // London
                                    width: 50.0,
                                    height: 50.0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        // ignore: deprecated_member_use
                                        color: brandGreen.withOpacity(0.3),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: brandGreen,
                                          width: 2,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.location_on,
                                        color: brandGreen,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Content Section
                    Expanded(
                      flex: 3,
                      child: Container(
                        margin: const EdgeInsets.all(16.0),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          // ignore: deprecated_member_use
                          border: Border.all(
                            // ignore: deprecated_member_use
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              const Icon(
                                Icons.eco,
                                size: 60,
                                color: brandGreen,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "Welcome to Way2Sustain!",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Plan your sustainable travel journey",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[400],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),

                              // Main action button
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const SelectLocationPage(),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.route),
                                  label: const Text("Plan New Journey"),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: brandGreen,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 30,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Feature cards - updated as requested
                              GridView.count(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                childAspectRatio: 1.5,
                                children: [
                                  _buildFeatureCard(
                                    icon: Icons.leaderboard,
                                    title: "Leaderboard",
                                    color: Colors.amber,
                                    subtitle: "Rank #--",
                                  ),
                                  _buildFeatureCard(
                                    icon: Icons.air,
                                    title: "Air Quality",
                                    color: Colors.blue,
                                    subtitle: "Good",
                                  ),
                                  _buildFeatureCard(
                                    icon: Icons.co2,
                                    title: "Carbon Track",
                                    color: Colors.green,
                                    subtitle: "0 kg",
                                  ),
                                  _buildFeatureCard(
                                    icon: Icons.cloud,
                                    title: "Weather",
                                    color: Colors.lightBlue,
                                    subtitle: "24°C",
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),

                              // Additional info
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  // ignore: deprecated_member_use
                                  color: Colors.grey[900]!.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[800]!),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildStatItem(
                                      icon: Icons.directions_car,
                                      value: "0",
                                      label: "Trips",
                                    ),
                                    _buildStatItem(
                                      icon: Icons.forest,
                                      value: "0",
                                      label: "CO₂ Saved",
                                    ),
                                    _buildStatItem(
                                      icon: Icons.local_fire_department,
                                      value: "0",
                                      label: "Points",
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required Color color,
    required String subtitle,
  }) {
    final opacityColor = Color.fromRGBO(
      // ignore: deprecated_member_use
      color.red,
      // ignore: deprecated_member_use
      color.green,
      // ignore: deprecated_member_use
      color.blue,
      0.2,
    );

    final opacityBorderColor = Color.fromRGBO(
      // ignore: deprecated_member_use
      color.red,
      // ignore: deprecated_member_use
      color.green,
      // ignore: deprecated_member_use
      color.blue,
      0.3,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: opacityColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: opacityBorderColor, width: 1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[300],
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.grey[400], size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 10)),
      ],
    );
  }

  // Helper function to show coming soon snackbar
  void _showComingSoonSnackbar(BuildContext context, String featureName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$featureName - Coming Soon!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: const Color(0xFF43A047),
      ),
    );
  }
}
