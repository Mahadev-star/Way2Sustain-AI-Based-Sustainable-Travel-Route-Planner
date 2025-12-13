import 'package:flutter/material.dart';

class SelectLocationPage extends StatefulWidget {
  const SelectLocationPage({super.key});

  @override
  State<SelectLocationPage> createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  String selectedVehicle = "";
  DateTime? selectedDateTime;

  @override
  void initState() {
    super.initState();
    // Simulate getting current location
    _simulateCurrentLocation();
  }

  Future<void> _simulateCurrentLocation() async {
    // Simulated location for demo purposes
    // In a real app, you would use geolocator here
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        fromController.text = "Current Location";
      });
    }
  }

  Future<void> pickDateTime() async {
    DateTime? date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF43A047),
              surface: Color(0xFF151717),
            ),
            // ignore: deprecated_member_use
            dialogBackgroundColor: const Color(0xFF151717),
          ),
          child: child!,
        );
      },
    );

    if (date == null) return;

    TimeOfDay? time = await showTimePicker(
      // ignore: use_build_context_synchronously
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF43A047),
              surface: Color(0xFF151717),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: const Color(0xFF151717),
            ),
          ),
          child: child!,
        );
      },
    );

    if (time == null) return;

    if (mounted) {
      setState(() {
        selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );
      });
    }
  }

  Widget vehicleIcon(String name, IconData icon, String emoji) {
    bool selected = selectedVehicle == name;
    const Color selectedColor = Color(0xFF43A047);
    final Color unselectedColor = Colors.grey[700]!;

    return GestureDetector(
      onTap: () {
        setState(() => selectedVehicle = name);
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: selected ? selectedColor : unselectedColor,
              border: Border.all(
                color: selected ? selectedColor : Colors.transparent,
                width: 2,
              ),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: selectedColor.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 28)),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? selectedColor : Colors.grey[400],
            ),
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
          // Background gradient - same as home page
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

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white70),
                  ),

                  const SizedBox(height: 10),

                  // Title
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Plan Your Journey",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Choose locations and vehicle for sustainable travel",
                      style: TextStyle(fontSize: 16, color: Colors.grey[400]),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Main card container
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      border: Border.all(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        // From field
                        TextField(
                          controller: fromController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: "From",
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: brandGreen,
                            ),
                            filled: true,
                            fillColor: Colors.grey[900],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: brandGreen,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 16,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // To field
                        TextField(
                          controller: toController,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          decoration: InputDecoration(
                            hintText: "To",
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            prefixIcon: Icon(
                              Icons.location_on,
                              color: brandGreen,
                            ),
                            filled: true,
                            fillColor: Colors.grey[900],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: brandGreen,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 18,
                              horizontal: 16,
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Vehicle selection title
                        const Text(
                          "Select Vehicle Type",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Choose the most sustainable option",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Vehicle icons row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            vehicleIcon("EV", Icons.ev_station, "🚗"),
                            vehicleIcon("Petrol", Icons.local_gas_station, "⛽"),
                            vehicleIcon("Bike", Icons.directions_bike, "🚲"),
                            vehicleIcon("Walk", Icons.directions_walk, "🚶"),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Date & Time picker
                        GestureDetector(
                          onTap: pickDateTime,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey[800]!,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  color: brandGreen,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    selectedDateTime == null
                                        ? "Select Date & Time"
                                        : "${selectedDateTime!.toLocal()}"
                                              .split('.')[0],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: selectedDateTime == null
                                          ? Colors.grey[500]
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.grey[500],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Find Sustainable Route Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              _findSustainableRoute(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: brandGreen,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(16),
                              elevation: 4,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.eco, size: 24),
                                SizedBox(width: 12),
                                Text(
                                  "Find Sustainable Route",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Sustainability tips
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: brandGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          // ignore: deprecated_member_use
                          color: brandGreen.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: Color(0xFF43A047),
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Sustainability Tips",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "• Electric vehicles produce 50% less CO₂\n"
                            "• Biking reduces traffic and improves health\n"
                            "• Walking is 100% carbon-free\n"
                            "• Carpooling saves fuel and money",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[300],
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _findSustainableRoute(BuildContext context) {
    // Validate inputs
    if (fromController.text.isEmpty || toController.text.isEmpty) {
      _showSnackBar(context, 'Please enter both From and To locations');
      return;
    }

    if (selectedVehicle.isEmpty) {
      _showSnackBar(context, 'Please select a vehicle type');
      return;
    }

    // Calculate eco points based on vehicle selection
    int ecoPoints = 0;
    String vehicleName = "";

    switch (selectedVehicle) {
      case "EV":
        ecoPoints = 50;
        vehicleName = "Electric Vehicle";
        break;
      case "Bike":
        ecoPoints = 80;
        vehicleName = "Bicycle";
        break;
      case "Walk":
        ecoPoints = 100;
        vehicleName = "Walking";
        break;
      case "Petrol":
        ecoPoints = 20;
        vehicleName = "Petrol Vehicle";
        break;
    }

    // Show success message with eco points
    _showSnackBar(
      context,
      '🎉 Route found! Using $vehicleName earns you $ecoPoints EcoPoints',
    );

    // In a real app, you would navigate to results page
    // Navigator.pushNamed(context, '/route-results', arguments: {
    //   'from': fromController.text,
    //   'to': toController.text,
    //   'vehicle': selectedVehicle,
    //   'dateTime': selectedDateTime,
    //   'ecoPoints': ecoPoints,
    // });
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF43A047),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
