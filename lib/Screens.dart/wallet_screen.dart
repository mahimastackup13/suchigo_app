import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:suchigo_app/services/pickup_api_service.dart';
import 'package:suchigo_app/services/secure_storage_service.dart';
import 'package:intl/intl.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  static const Color _primaryGreen = Color(0xFF1E713D);
  static const Color _backgroundGrey = Color(0xFFF5F5F5);

  double _balance = 0.0;
  final TextEditingController _amountController = TextEditingController();

  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadWalletData();
  }

  Future<void> _loadWalletData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final pickups = await PickupApiService.fetchPickups();
      
      // Load custom refill transactions from secure storage
      final refillsJson = await SecureStorageService.getRefills();
      List<Map<String, dynamic>> customRefills = [];
      if (refillsJson != null) {
        final decoded = jsonDecode(refillsJson);
        if (decoded is List) {
          customRefills = List<Map<String, dynamic>>.from(decoded);
        }
      }

      // Generate dynamic transactions based on pickups
      final List<Map<String, dynamic>> generatedTransactions = [];
      double computedBalance = 0.0;

      // First add refills to computedBalance and generated list
      for (var refill in customRefills) {
        computedBalance += (double.tryParse(refill['amount'].toString()) ?? 0.0);
        generatedTransactions.add({
          'title': refill['title'] ?? 'Added via Wallet Refill',
          'type': 'credit',
          'amount': double.tryParse(refill['amount'].toString()) ?? 0.0,
          'date': refill['date'] ?? 'Just now',
          'category': refill['category'] ?? 'Load',
          'timestamp': DateTime.tryParse(refill['timestamp']?.toString() ?? '') ?? DateTime.now(),
        });
      }

      // Now add pickups incentives and fees
      for (var item in pickups) {
        final id = item['id']?.toString() ?? '';
        final wasteType = item['waste_type']?.toString() ?? 'Mixed Waste';
        final dateStr = item['pickup_date']?.toString() ?? item['scheduled_date']?.toString() ?? '';
        final status = item['status']?.toString() ?? 'Pending';
        
        double weight = 5.0; 
        if (item['estimated_weight'] != null) {
          weight = double.tryParse(item['estimated_weight'].toString()) ?? 5.0;
        } else if (item['number_of_bags'] != null) {
          weight = (double.tryParse(item['number_of_bags'].toString()) ?? 2) * 2.5;
        }
        
        final dt = DateTime.tryParse(dateStr) ?? DateTime.now();

        if (status.toLowerCase() == 'completed' || status.toLowerCase() == 'confirmed' || status.toLowerCase() == 'success') {
          final incentive = weight * 15.0;
          final fee = 40.0;

          generatedTransactions.add({
            'title': '$wasteType Recycling Incentive',
            'type': 'credit',
            'amount': incentive,
            'date': _formatDateLabel(dt),
            'category': 'Incentive',
            'timestamp': dt,
          });

          generatedTransactions.add({
            'title': 'Collection Service Fee #$id',
            'type': 'debit',
            'amount': fee,
            'date': _formatDateLabel(dt),
            'category': 'Payment',
            'timestamp': dt,
          });

          computedBalance += (incentive - fee);
        } else {
          generatedTransactions.add({
            'title': 'Pending Collection Ref #$id',
            'type': 'pending',
            'amount': 0.0,
            'date': _formatDateLabel(dt),
            'category': 'Hold',
            'timestamp': dt,
          });
        }
      }

      // If they have no completed pickups or refills, give them a welcome balance
      if (computedBalance <= 0 && customRefills.isEmpty) {
        computedBalance = 200.0;
        generatedTransactions.add({
          'title': 'Welcome Gift Incentive',
          'type': 'credit',
          'amount': 200.0,
          'date': 'Account Opening',
          'category': 'Bonus',
          'timestamp': DateTime.now().subtract(const Duration(days: 5)),
        });
      }

      // Sort all transactions by timestamp descending
      generatedTransactions.sort((a, b) {
        final tA = a['timestamp'] as DateTime;
        final tB = b['timestamp'] as DateTime;
        return tB.compareTo(tA);
      });

      if (mounted) {
        setState(() {
          _balance = computedBalance;
          _transactions = generatedTransactions;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  String _formatDateLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final checkDate = DateTime(dt.year, dt.month, dt.day);

    if (checkDate == today) {
      return 'Today, ${DateFormat('hh:mm a').format(dt)}';
    } else if (checkDate == yesterday) {
      return 'Yesterday, ${DateFormat('hh:mm a').format(dt)}';
    } else {
      return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _addMoney(double amount) async {
    if (amount <= 0) return;
    
    // Save to Secure Storage
    final refillsJson = await SecureStorageService.getRefills();
    List<Map<String, dynamic>> customRefills = [];
    if (refillsJson != null) {
      final decoded = jsonDecode(refillsJson);
      if (decoded is List) {
        customRefills = List<Map<String, dynamic>>.from(decoded);
      }
    }

    final newRefill = {
      'title': 'Added via Wallet Refill',
      'type': 'credit',
      'amount': amount,
      'date': 'Just now',
      'category': 'Load',
      'timestamp': DateTime.now().toIso8601String(),
    };
    customRefills.add(newRefill);

    await SecureStorageService.saveRefills(jsonEncode(customRefills));

    // Reload the wallet data dynamically
    _loadWalletData();
  }

  void _showAddMoneyBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Add Money to Wallet",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    prefixText: "₹ ",
                    prefixStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _primaryGreen,
                    ),
                    hintText: "Enter amount",
                    hintStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(
                        color: _primaryGreen,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [100.0, 200.0, 500.0].map((amt) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: OutlinedButton(
                          onPressed: () {
                            _amountController.text = amt.toStringAsFixed(0);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: _primaryGreen),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "+ ₹${amt.toStringAsFixed(0)}",
                            style: const TextStyle(
                              color: _primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      final double? amt = double.tryParse(
                        _amountController.text,
                      );
                      if (amt != null && amt > 0) {
                        _addMoney(amt);
                        _amountController.clear();
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "PROCEED TO PAY",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundGrey,
      appBar: AppBar(
        title: const Text(
          "SuchiGo Wallet",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: _primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: _primaryGreen))
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadWalletData,
                          style: ElevatedButton.styleFrom(backgroundColor: _primaryGreen),
                          child: const Text('Retry', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: [
                    // Elegant balance presentation container
                    _buildBalanceBanner(),

                    const Padding(
                      padding: EdgeInsets.fromLTRB(16, 24, 16, 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Transaction History",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: _loadWalletData,
                        color: _primaryGreen,
                        child: _transactions.isEmpty
                            ? const SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(40.0),
                                    child: Text(
                                      "No transactions yet.",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              )
                            : ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: _transactions.length,
                                itemBuilder: (context, index) {
                                  final tx = _transactions[index];
                                  return _buildTransactionCard(tx);
                                },
                              ),
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildBalanceBanner() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _primaryGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Available Balance",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "ACTIVE",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "₹ ${_balance.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _showAddMoneyBottomSheet,
                        icon: const Icon(Icons.add_rounded, size: 20),
                        label: const Text("ADD MONEY"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _primaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> tx) {
    final bool isCredit = tx['type'] == 'credit';
    final Color amountColor = isCredit
        ? const Color(0xFF2E7D32)
        : Colors.black87;
    final String amountSign = isCredit ? "+" : "-";

    IconData catIcon = Icons.swap_horiz_rounded;
    Color iconBg = Colors.grey.shade100;
    Color iconColor = Colors.grey.shade600;

    switch (tx['category']) {
      case 'Bonus':
        catIcon = Icons.eco_rounded;
        iconBg = const Color(0xFFE8F5E9);
        iconColor = const Color(0xFF2E7D32);
        break;
      case 'Incentive':
        catIcon = Icons.card_giftcard_rounded;
        iconBg = const Color(0xFFFFF3E0);
        iconColor = Colors.orange;
        break;
      case 'Payment':
        catIcon = Icons.receipt_long_rounded;
        iconBg = const Color(0xFFE3F2FD);
        iconColor = Colors.blue;
        break;
      case 'Load':
        catIcon = Icons.account_balance_wallet_rounded;
        iconBg = const Color(0xFFEDE7F6);
        iconColor = Colors.purple;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(catIcon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx['title']!,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tx['date']!,
                  style: TextStyle(fontSize: 11.5, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Text(
            "$amountSign ₹${tx['amount'].toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
