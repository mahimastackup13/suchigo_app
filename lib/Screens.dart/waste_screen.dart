import 'package:flutter/material.dart';
import 'package:suchigo_app/Screens.dart/collector_screen.dart';
import 'package:suchigo_app/Screens.dart/login_screen.dart';


class WasteScreen extends StatefulWidget {
  const WasteScreen({super.key});

  @override
  State<WasteScreen> createState() => _WasteScreenState();
}

class _WasteScreenState extends State<WasteScreen> {
  String selectedBag = "Select Bag";
  Map<String, int> bagCounts = {
    "SMALL": 0,
    "MEDIUM": 0,
    "X SMALL": 0,
    "NO BAG": 0,
    "TVM BAG": 0,
  };

  String wasteType = "";
  bool isResidential = true;
  String qty = "";

  bool isCash = true;
  TextEditingController partialCash = TextEditingController();

  final List<String> wasteButtons = [
    "SANITARY PAD",
    "MEDICAL WASTE",
    "ADULT DIAPER",
    "KIDS DIAPER",
    "HAIR",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Waste Type",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // BAG DROPDOWN
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: GestureDetector(
                onTap: () => openBagPopup(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(selectedBag, style: const TextStyle(fontSize: 16)),
                    const Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // BAG DETAILS
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey.shade100,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Bag size",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "QTY",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "PRICE",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (bagCounts[selectedBag] != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(selectedBag),
                        Text(bagCounts[selectedBag].toString()),
                        const Text("7.00"),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // RESIDENTIAL / COMMERCIAL
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey.shade100,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: true,
                        groupValue: isResidential,
                        onChanged: (v) => setState(() => isResidential = true),
                      ),
                      const Text("Residential"),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: false,
                        groupValue: isResidential,
                        onChanged: (v) => setState(() => isResidential = false),
                      ),
                      const Text("Commercial"),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // WASTE TYPE
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey.shade100,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Select Waste Type",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 14),

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: wasteButtons.map((w) {
                      return GestureDetector(
                        onTap: () => setState(() => wasteType = w),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: wasteType == w
                                ? const Color.fromARGB(255, 106, 139, 49)
                                : const Color(0xFFC8E69A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            w,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // QUANTITY
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey.shade100,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Enter QTY",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (v) => qty = v,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      if (qty.isNotEmpty) openPaymentPopup(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 18,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "UPDATE",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // BAG POPUP
  void openBagPopup(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      context: context,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              bagTile("SMALL", 7.00),
              bagTile("MEDIUM", 10.00),
              bagTile("X SMALL", 5.00),
              bagTile("NO BAG", 0.00),
              bagTile("TVM BAG", 7.00),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                  child: Text("Back", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // BAG TILE
  Widget bagTile(String name, double price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(price.toStringAsFixed(2)),
          ElevatedButton(
            onPressed: () {
              setState(() {
                bagCounts[name] = bagCounts[name]! + 1;
                selectedBag = name;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text("ADD", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // PAYMENT POPUP
  void openPaymentPopup(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStatePopup) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Payment Mode",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Radio(
                          value: true,
                          groupValue: isCash,
                          onChanged: (v) => setStatePopup(() => isCash = true),
                        ),
                        const Text("Cash"),
                        const SizedBox(width: 30),
                        Radio(
                          value: false,
                          groupValue: isCash,
                          onChanged: (v) => setStatePopup(() => isCash = false),
                        ),
                        const Text("Online"),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // QR CODE WHEN ONLINE
                    if (!isCash)
                      Center(
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/images/Qrcodes.png",
                              height: 220,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "SCAN & PAY USING ANY UPI APP",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            //
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pop(); // close bottom sheet properly
                            Future.delayed(
                              const Duration(milliseconds: 80),
                              () {
                                showSuccessPopup(context);
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            "Complete",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Payment Successful"),
        content: const Text("The transaction has been completed successfully."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(
                dialogContext,
                rootNavigator: true,
              ).pop(); // close popup

              Future.delayed(const Duration(milliseconds: 50), () {
                Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (_) => const CollectorScreen()),
                );
              });
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
