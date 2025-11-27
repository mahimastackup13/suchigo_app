import 'package:flutter/material.dart';
import 'package:suchigo_app/Screens.dart/collector_screen.dart';
import 'package:suchigo_app/Screens.dart/waste_screen.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({super.key});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  // 0 = Accept Order, 1 = Start Travelling, 2 = Reached Location
  int buttonState = 0;

  String getButtonText() {
    if (buttonState == 0) return "Accept Order";
    if (buttonState == 1) return "Start Travelling";
    return "Reached Location";
  }

  Color getButtonColor() {
    if (buttonState == 2) return Colors.green;
    if (buttonState == 1) return Colors.deepOrangeAccent;
    return Colors.blue;
  }
void handleButtonTap() {
    setState(() {
      if (buttonState == 0) {
        buttonState = 1; // Accept → Start travelling
      } else if (buttonState == 1) {
        buttonState = 2; // Start travelling → Reached location
      } else if (buttonState == 2) {
        // *************** NAVIGATION LOGIC ADDED ***************
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const WasteScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Update Status",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white,
        size: 32),
        
      ),

      body: SingleChildScrollView(
        
        child: Padding(
          padding: const EdgeInsets.all(16),
          
          child: Column(
            children: [
              // ************** TOP ORDER CARD **************
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order ID + Status Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Order ID",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              "250916BIOEKM015",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              "Status",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              buttonState == 0
                                  ? "Pending"
                                  : buttonState == 1
                                      ? "Accepted"
                                      : "Reached location",
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ************ CUSTOMER NAME ************
                    const Text(
                      "Customer Name",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Bobin Abraham",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 16),

                    // ************ ADDRESS ************
                    const Text(
                      "Delivery Address",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Home\nTRAK 50, Thejas Nagar, Salis road",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),

                    const SizedBox(height: 16),

                    // ************ LANDMARK ************
                    const Text(
                      "Landmark",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Cordoba men’s hostel",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),

                    const SizedBox(height: 16),

                    // ************ IN PROGRESS ************
                    const Text(
                      "In Progress By",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Ashraf Bio",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),

                    const SizedBox(height: 16),

                    // ************ PHONE NUMBERS ************
                    const Text(
                      "Phone Number",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Text(
                          "+919496322103",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "copy",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Alternate Number",
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: const [
                        Text(
                          "8590216091",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          "copy",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ************ NAVIGATE BUTTON ************
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.location_on_outlined),
                        label: const Text(
                          "Navigate",
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ************** BUTTONS BELOW **************
              Column(
                children: [
                  // CALL BUTTON ABOVE
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () {
                        print("Call clicked");
                      },
                      child: Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          color: Colors.lightGreenAccent.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.call, color: Colors.black),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // ****** MAIN LOGIC BUTTON (Accept → Start → Reached) ******
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: handleButtonTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: getButtonColor(),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(getButtonText(), style: TextStyle(fontSize: 17)
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Drop Order
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const CollectorScreen()),
  );
},

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text("Drop Order",
                      style: TextStyle(fontSize: 17),),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Request Cancel
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => const CollectorScreen()),
  );
},

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text("Request Cancel",
                       style: TextStyle(fontSize: 17)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
