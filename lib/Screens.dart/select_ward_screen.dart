import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:suchigo_app/Screens.dart/collector_screen.dart';
import 'package:suchigo_app/Screens.dart/Orders_Screen.dart';

class SelectWardScreen extends StatefulWidget {
  const SelectWardScreen({super.key});

  @override
  State<SelectWardScreen> createState() => _SelectWardScreenState();
}

class _SelectWardScreenState extends State<SelectWardScreen> {
  TextEditingController searchController = TextEditingController();
  String userLocation = "Fetching location...";

  List<Map<String, dynamic>> wards = [
    {"name": "RAJAGIRI", "red": 1, "black": 0},
    {"name": "NORTH KALAMASSERY", "red": 0, "black": 1},
    {"name": "H M T JUNCTION", "red": 1, "black": 0},
    {"name": "ROCKWELL", "red": 0, "black": 1},
    {"name": "VIDAKKUZHA", "red": 0, "black": 1},
    {"name": "PIPELINE", "red": 0, "black": 1},
    {"name": "THEVAKKAL", "red": 0, "black": 1},
    {"name": "PULIYAMPURAM", "red": 0, "black": 3},
  ];

  List<Map<String, dynamic>> filteredWards = [];

  @override
  void initState() {
    super.initState();
    filteredWards = wards;
    getLocation();

    searchController.addListener(() {
      filterWards();
    });
  }

  void filterWards() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredWards = wards
          .where((w) => w["name"].toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => userLocation = "Enable GPS");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() => userLocation = "Location permission denied");
      return;
    }

    Position pos = await Geolocator.getCurrentPosition();
    setState(() {
      userLocation = "${pos.latitude}, ${pos.longitude}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 15),

          
             Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
              color: Colors.black,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Select Ward",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Column(
                  children: [
                    // SEARCH + ACCEPTED BUTTON
                    Row(
                      children: [
                        /// Search Box
                        Expanded(
                          child: Container(
                            height: 48,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F3F3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search...",
                                  suffixIcon: Icon(
                                    Icons.location_on,
                                    color: Colors.green[700],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        /// ACCEPTED BUTTON (Clickable)
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Accepted clicked"),
                              ),
                            );
                          },
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 22),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC8D97D),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text(
                                "Accepted",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    /// GO TO ORDERS BUTTON (Clickable)
                    GestureDetector(
                       onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OrdersScreen()),
    );
  },
                      child: Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          color: const Color(0xFFC8D97D),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Text(
                            "Go to orders",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// WARD LIST
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredWards.length,
                        itemBuilder: (context, i) {
                          var w = filteredWards[i];
                          return wardTile(index: i + 1, data: w);
                        },
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

  /// WARD TILE (Clickable)
  Widget wardTile({required int index, required Map data}) {
    return InkWell(
      onTap: () {
        // TODO: Navigate to specific ward details
        Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OrdersScreen()),
    );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Clicked ${data['name']}")),
        );
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: [
            Text(
              "$index.  ${data['name']}",
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Spacer(),

            /// Red count
            bubble(data["red"], Colors.red),

            const SizedBox(width: 12),

            /// Black count
            bubble(data["black"], Colors.black),
          ],
        ),
      ),
    );
  }

  /// BUBBLE COUNTER UI
  Widget bubble(int count, Color color) {
    return Container(
      width: 38,
      height: 38,
      decoration:
          BoxDecoration(color: color, shape: BoxShape.circle),
      child: Center(
        child: Text(
          "$count",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
