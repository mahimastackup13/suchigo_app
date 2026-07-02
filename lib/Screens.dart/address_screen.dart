import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:provider/provider.dart';
import 'package:suchigo_app/provider/home_provider.dart';
import 'package:suchigo_app/provider/profile_provider.dart';
import 'package:suchigo_app/provider/bill_provider.dart';
import 'package:suchigo_app/Screens.dart/bill_screen.dart';
import 'package:suchigo_app/Screens.dart/booking_confirmation_screen.dart';
import 'package:suchigo_app/services/address_api_service.dart';
import 'package:suchigo_app/services/pickup_api_service.dart';
import 'package:suchigo_app/services/notification_service.dart';
import 'home_screen.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _pickupDateController = TextEditingController();
  final _contactController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController(); // street / house info
  final _secondaryController = TextEditingController();
  final _landmarkController = TextEditingController();
  final _cityController = TextEditingController();
  final _zipController = TextEditingController();
  final _bagsController = TextEditingController(text: '1');

  String? _selectedDistrict;
  String? _selectedState;
  String? _selectedLocalBody;
  String? _selectedWard;
  String? _selectedTimeSlot;
  DateTime? _selectedDate;

  bool _isSubmitting = false;
  String? _submitError;
  final ScrollController _scrollController = ScrollController();

  static const Color _darkGreen = Color(0xFF1E713D);
  static const Color _headerGreen = Color(0xFF4CAF50);

  final List<String> _districts = ['Ernakulam', 'Thrissur'];
  final List<String> _state = ['Kerala', 'Tamilnadu'];

  final List<String> _localBodies = [
    'Kochi Corporation',
    'Thrissur Corporation',
  ];

  final List<String> _wards = List.generate(20, (i) => 'Ward ${i + 1}');

  final List<Map<String, dynamic>> _timeSlots = const [
    {'label': '9:00 AM – 12:00 PM', 'hour': 9},
    {'label': '12:00 PM – 3:00 PM', 'hour': 12},
    {'label': '3:00 PM – 6:00 PM', 'hour': 15},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
        if (profileProvider.displayName.isNotEmpty) {
          _nameController.text = profileProvider.displayName;
        } else if (profileProvider.username.isNotEmpty && profileProvider.username != 'User') {
          _nameController.text = profileProvider.username;
        }
        if (profileProvider.phoneNumber.isNotEmpty) {
          _contactController.text = profileProvider.phoneNumber;
        }
        if (profileProvider.email.isNotEmpty) {
          _emailController.text = profileProvider.email;
        }
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pickupDateController.dispose();
    _contactController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _secondaryController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _bagsController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _buildScheduledDateIso() {
    final date = _selectedDate!;
    final hour =
        _timeSlots.firstWhere(
              (slot) => slot['label'] == _selectedTimeSlot,
            )['hour']
            as int;

    final utcDateTime = DateTime.utc(
      date.year,
      date.month,
      date.day,
      hour,
      0,
      0,
    );
    return utcDateTime.toIso8601String().replaceFirst('.000Z', 'Z');
  }

  Future<void> _selectPickupDate() async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
        _pickupDateController.text =
            '${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}';
      });
    }
  }

  List<String> _missingFieldLabels() {
    final missing = <String>[];
    if (_nameController.text.trim().isEmpty) missing.add('Full Name');
    if (_contactController.text.trim().isEmpty) missing.add('Contact Number');
    if (_emailController.text.trim().isEmpty) missing.add('Email Address');
    if (_addressController.text.trim().isEmpty) missing.add('Pickup Address');
    if (_cityController.text.trim().isEmpty) missing.add('City');
    if (_zipController.text.trim().isEmpty) missing.add('Zip / Postal Code');
    if (_pickupDateController.text.trim().isEmpty || _selectedDate == null) {
      missing.add('Pickup Date');
    }
    if (_selectedTimeSlot == null) missing.add('Pickup Time Slot');
    if (_selectedState == null) missing.add('State');
    if (_selectedDistrict == null) missing.add('District');
    if (_selectedLocalBody == null) missing.add('Local Body');
    if (_selectedWard == null) missing.add('Ward Name & Number');
    if (_bagsController.text.trim().isEmpty) missing.add('Number of Bags');
    return missing;
  }

  Future<void> _submitForm() async {
    final formIsValid = _formKey.currentState?.validate() ?? false;
    final missing = _missingFieldLabels();

    if (!formIsValid || missing.isNotEmpty) {
      setState(() {
        _submitError = missing.isNotEmpty
            ? 'Please fill in: ${missing.join(', ')}'
            : 'Please fix the highlighted fields above.';
      });
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    try {
      final dateStr = _selectedDate != null
          ? "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}"
          : "";

      final billProvider = Provider.of<BillProvider>(context, listen: false);
      final wasteTypeVal = billProvider.selectedWasteTypes.isNotEmpty
          ? billProvider.selectedWasteTypes.join(', ')
          : 'Mixed Household Waste';

      final pickupResponse = await PickupApiService.createPickup(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        contactNumber: _contactController.text.trim(),
        street: _addressController.text.trim(),
        city: _cityController.text.trim(),
        zipCode: _zipController.text.trim(),
        state: _selectedState ?? '',
        district: _selectedDistrict ?? '',
        localBody: _selectedLocalBody ?? '',
        wardName: _selectedWard ?? '',
        pickupDate: dateStr,
        pickupTimeSlot: _selectedTimeSlot ?? '',
        itemsDescription: _secondaryController.text.trim().isNotEmpty
            ? _secondaryController.text.trim()
            : 'General household waste',
        wasteType: wasteTypeVal,
        landmark: _landmarkController.text.trim().isNotEmpty
            ? _landmarkController.text.trim()
            : null,
      );

      final addressResponse = <String, dynamic>{
        'street': _addressController.text.trim(),
        'city': _cityController.text.trim(),
        'zip_code': _zipController.text.trim(),
        'number_of_bags': int.tryParse(_bagsController.text.trim()) ?? 1,
      };

      final pickupId = int.tryParse(pickupResponse['id']?.toString() ?? '') ?? 0;
      if (_selectedDate != null && pickupId > 0) {
        try {
          await NotificationService.instance.schedulePickupReminders(
            pickupId: pickupId,
            pickupDate: _selectedDate!,
          );
        } catch (e) {
          debugPrint('[AddressScreen] Failed to schedule notification reminders: $e');
        }
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pickup scheduled successfully!'),
          backgroundColor: _darkGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BookingConfirmationScreen(
            bookingDetails: BookingDetails.fromApiResponses(
              pickupJson: pickupResponse,
              addressJson: addressResponse,
              selectedTimeSlotLabel: _selectedTimeSlot!,
              fallbackContactName: _nameController.text.trim(),
              fallbackContactPhone: _contactController.text.trim(),
            ),
          ),
        ),
      );
    } on PickupSubmissionException catch (e) {
      setState(() => _submitError = 'Pickup error — ${e.message}');
    } catch (e) {
      setState(() => _submitError = 'Unexpected error: $e');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _previewConfirmationScreenWithMockData() {
    final mockAddressResponse = <String, dynamic>{
      'id': 1,
      'street': _addressController.text.trim().isNotEmpty
          ? _addressController.text.trim()
          : '456 Main Road',
      'city': _cityController.text.trim().isNotEmpty
          ? _cityController.text.trim()
          : 'Kochi',
      'state': (_selectedState ?? 'kerala').toLowerCase(),
      'district': (_selectedDistrict ?? 'ernakulam').toLowerCase(),
      'zip_code': _zipController.text.trim().isNotEmpty
          ? _zipController.text.trim()
          : '682020',
      'ward': (_selectedWard ?? 'WARD1').toUpperCase().replaceAll(' ', ''),
      'local_body': _selectedLocalBody ?? 'Kochi Corporation',
      'number_of_bags': int.tryParse(_bagsController.text.trim()) ?? 2,
      'is_default': true,
      'user': 1,
    };

    final mockPickupResponse = <String, dynamic>{
      'id': 8741,
      'name': _nameController.text.trim().isNotEmpty
          ? _nameController.text.trim()
          : 'Preview Customer',
      'email': _emailController.text.trim().isNotEmpty
          ? _emailController.text.trim()
          : 'preview@example.com',
      'contact_number': _contactController.text.trim().isNotEmpty
          ? _contactController.text.trim()
          : '+919876543210',
      'landmark': _landmarkController.text.trim().isNotEmpty
          ? _landmarkController.text.trim()
          : 'Near the school',
      'scheduled_date': _selectedDate != null
          ? _buildScheduledDateIso()
          : '2026-10-25T10:00:00Z',
      'items_description': _secondaryController.text.trim().isNotEmpty
          ? _secondaryController.text.trim()
          : 'Electronics and documents',
      'pickup_address': _addressController.text.trim().isNotEmpty
          ? _addressController.text.trim()
          : '456 Main Road',
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingConfirmationScreen(
          bookingDetails: BookingDetails.fromApiResponses(
            pickupJson: mockPickupResponse,
            addressJson: mockAddressResponse,
            selectedTimeSlotLabel: _selectedTimeSlot ?? '9:00 AM – 12:00 PM',
            fallbackContactName: _nameController.text.trim().isNotEmpty
                ? _nameController.text.trim()
                : 'Preview Customer',
            fallbackContactPhone: _contactController.text.trim().isNotEmpty
                ? _contactController.text.trim()
                : '+919876543210',
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool required = true,
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
    List<TextInputFormatter>? formatters,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? customValidator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (required) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboard,
            inputFormatters: formatters,
            readOnly: readOnly,
            onTap: onTap,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              filled: true,
              fillColor: const Color(0xFFF9FBF9),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _headerGreen, width: 1.8),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.2),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red, width: 1.8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 16,
              ),
              errorStyle: const TextStyle(fontSize: 11, height: 1.0),
            ),
            validator:
                customValidator ??
                (required
                    ? (v) => (v == null || v.trim().isEmpty) ? 'Required' : null
                    : null),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String hint,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
    bool required = true,
  }) {
    return FormField<String>(
      initialValue: value,
      validator: required
          ? (v) => (v == null || v.isEmpty) ? 'Please select an option' : null
          : null,
      builder: (state) {
        final hasError = state.hasError;
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  if (required) ...[
                    const SizedBox(width: 4),
                    const Text(
                      '*',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _showSelectionBottomSheet(
                  title: label,
                  items: items,
                  selectedValue: value,
                  onSelected: (val) {
                    onChanged(val);
                    state.didChange(val);
                  },
                ),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FBF9),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: hasError
                          ? Colors.red
                          : (value != null ? _headerGreen.withOpacity(0.5) : Colors.grey.shade200),
                      width: hasError ? 1.2 : 1.5,
                    ),
                    boxShadow: [
                      if (value != null && !hasError)
                        BoxShadow(
                          color: _headerGreen.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          value ?? hint,
                          style: TextStyle(
                            fontSize: 14,
                            color: value != null ? Colors.black87 : Colors.grey.shade400,
                            fontWeight: value != null ? FontWeight.w500 : FontWeight.normal,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: hasError
                            ? Colors.red
                            : (value != null ? _headerGreen : Colors.grey.shade600),
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
              if (hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 16),
                  child: Text(
                    state.errorText ?? '',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 11,
                      height: 1.0,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showSelectionBottomSheet({
    required String title,
    required List<String> items,
    required String? selectedValue,
    required ValueChanged<String?> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        String searchQuery = "";
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredItems = items
                .where((item) => item.toLowerCase().contains(searchQuery.toLowerCase()))
                .toList();

            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.65,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Select $title',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close_rounded, size: 20, color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search_rounded, color: Colors.grey.shade500, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                onChanged: (val) => setModalState(() => searchQuery = val),
                                style: const TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                  hintText: 'Search $title...',
                                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            if (searchQuery.isNotEmpty)
                              GestureDetector(
                                onTap: () => setModalState(() => searchQuery = ""),
                                child: Icon(Icons.clear_rounded, color: Colors.grey.shade500, size: 18),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: filteredItems.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off_rounded, size: 48, color: Colors.grey.shade300),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No results found',
                                    style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];
                                final isSelected = item == selectedValue;

                                Widget leadingWidget;
                                if (title.toLowerCase().contains("ward")) {
                                  final numberOnly = item.replaceAll(RegExp(r'[^0-9]'), '');
                                  leadingWidget = Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: isSelected ? _darkGreen : Colors.green.shade50,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        numberOnly.isNotEmpty ? numberOnly : '#',
                                        style: TextStyle(
                                          color: isSelected ? Colors.white : _darkGreen,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  leadingWidget = Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: isSelected ? _darkGreen.withOpacity(0.1) : Colors.grey.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.location_city_rounded,
                                      color: isSelected ? _darkGreen : Colors.grey.shade600,
                                      size: 16,
                                    ),
                                  );
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: InkWell(
                                    onTap: () {
                                      onSelected(item);
                                      Navigator.pop(context);
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? _darkGreen.withOpacity(0.05)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: isSelected
                                              ? _darkGreen.withOpacity(0.3)
                                              : Colors.grey.shade100,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          leadingWidget,
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              item,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                                color: isSelected ? _darkGreen : Colors.black87,
                                              ),
                                            ),
                                          ),
                                          if (isSelected)
                                            const Icon(
                                              Icons.check_circle_rounded,
                                              color: _darkGreen,
                                              size: 20,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
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

  Widget _buildFormSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: _headerGreen, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(color: Color(0xFFF1F5F2), thickness: 1),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Provider.of<HomeProvider>(context, listen: false).setSelectedIndex(1);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (_submitError != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red.shade700,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _submitError!,
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Section 1: Contact Info Card
                      _buildFormSection(
                        title: "Contact Information",
                        icon: Icons.person_rounded,
                        children: [
                          _buildField(
                            controller: _nameController,
                            label: 'Full Name',
                            hint: 'Enter your full name',
                          ),
                          _buildField(
                            controller: _contactController,
                            label: 'Contact Number',
                            hint: 'Enter your contact number',
                            keyboard: TextInputType.phone,
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            customValidator: (v) {
                              if (v == null || v.trim().isEmpty)
                                return 'Required';
                              if (v.trim().length < 7)
                                return 'Enter a valid phone number';
                              return null;
                            },
                          ),
                          _buildField(
                            controller: _emailController,
                            label: 'Email Address',
                            hint: 'Enter your email address',
                            keyboard: TextInputType.emailAddress,
                            customValidator: (v) {
                              if (v == null || v.trim().isEmpty)
                                return 'Required';
                              final emailRegex = RegExp(
                                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                              );
                              if (!emailRegex.hasMatch(v.trim()))
                                return 'Enter a valid email';
                              return null;
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Section 2: Address Details Card
                      _buildFormSection(
                        title: "Pickup Location",
                        icon: Icons.location_on_rounded,
                        children: [
                          _buildField(
                            controller: _addressController,
                            label: 'Pickup Address',
                            hint: 'Enter your complete address',
                            maxLines: 3,
                          ),
                          _buildField(
                            controller: _cityController,
                            label: 'City',
                            hint: 'Enter your city name',
                          ),
                          _buildDropdown(
                            label: 'State',
                            hint: 'Select state',
                            items: _state,
                            value: _selectedState,
                            onChanged: (v) =>
                                setState(() => _selectedState = v),
                          ),
                          _buildDropdown(
                            label: 'District',
                            hint: 'Select district',
                            items: _districts,
                            value: _selectedDistrict,
                            onChanged: (v) => setState(() {
                              _selectedDistrict = v;
                              _selectedLocalBody = null;
                            }),
                          ),
                          _buildDropdown(
                            label: 'Local Body',
                            hint: 'Select local body',
                            items: _localBodies,
                            value: _selectedLocalBody,
                            onChanged: (v) =>
                                setState(() => _selectedLocalBody = v),
                          ),
                          _buildDropdown(
                            label: 'Ward Name & Number',
                            hint: 'Select ward (optional)',
                            items: _wards,
                            value: _selectedWard,
                            onChanged: (v) => setState(() => _selectedWard = v),
                            required: false,
                          ),
                          _buildField(
                            controller: _zipController,
                            label: 'Zip / Postal Code',
                            hint: 'Enter zip code',
                            keyboard: TextInputType.number,
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Section 3: Pickup Schedule Card
                      _buildFormSection(
                        title: "Pickup Schedule",
                        icon: Icons.calendar_month_rounded,
                        children: [
                          _buildField(
                            controller: _pickupDateController,
                            label: 'Pickup Date',
                            hint: 'Tap to select pickup date',
                            readOnly: true,
                            onTap: _selectPickupDate,
                          ),
                          _buildDropdown(
                            label: 'Pickup Time Slot',
                            hint: 'Select time slot',
                            items: _timeSlots
                                .map((e) => e['label'] as String)
                                .toList(),
                            value: _selectedTimeSlot,
                            onChanged: (v) =>
                                setState(() => _selectedTimeSlot = v),
                          ),
                          _buildField(
                            controller: _bagsController,
                            label: 'Number of Bags',
                            hint: 'Enter number of bags',
                            keyboard: TextInputType.number,
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Section 4: Extra Details Card
                      _buildFormSection(
                        title: "Additional Details",
                        icon: Icons.info_rounded,
                        children: [
                          _buildField(
                            controller: _secondaryController,
                            label: 'Secondary Number',
                            hint: 'Enter alternative contact number',
                            keyboard: TextInputType.phone,
                            formatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            required: false,
                          ),
                          _buildField(
                            controller: _landmarkController,
                            label: 'Location / Landmark',
                            hint: 'Enter nearby landmark',
                            required: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // Submit Button Container with Gradient
                      Container(
                        width: double.infinity,
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4CAF50), Color(0xFF00BCD4)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF4CAF50).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'SUBMIT',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                        ),
                      ),
                      if (kDebugMode) ...[const SizedBox(height: 16)],
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF4CAF50), Color(0xFF00BCD4), Color(0xFF2ECC71)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _headerIconBtn(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () {
                      Provider.of<HomeProvider>(
                        context,
                        listen: false,
                      ).setSelectedIndex(1);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
                  ),
                  const Text(
                    'Schedule Pickup',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  _headerIconBtn(
                    icon: Icons.home_rounded,
                    onTap: () {
                      Provider.of<HomeProvider>(
                        context,
                        listen: false,
                      ).setSelectedIndex(0);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Welcome card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Welcome back, ${Provider.of<ProfileProvider>(context).username}! 👋',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Manage your waste collection and track your\nenvironmental impact',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerIconBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}
