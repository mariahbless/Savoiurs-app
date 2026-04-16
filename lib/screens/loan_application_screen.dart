import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';
//import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';

class LoanApplicationScreen extends StatefulWidget {
  const LoanApplicationScreen({super.key});

  @override
  State<LoanApplicationScreen> createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _otherContactController = TextEditingController();
  final TextEditingController _nextOfKinNameController = TextEditingController();
  final TextEditingController _nextOfKinContactController = TextEditingController();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _monthlyIncomeController = TextEditingController();
  final TextEditingController _currentAddressController = TextEditingController();

  String? _selectedLoanType;
  String? _selectedGender;
  String? _selectedCollateral;  // ← collateral dropdown value
  bool _isLoading = false;

 
  File? _idFrontImage;
  Uint8List? _idFrontImageBytes;
  String? _idFrontImageBase64;

 
  File? _idBackImage;
  Uint8List? _idBackImageBytes;
  String? _idBackImageBase64;

  final List<String> _loanTypes = [
    'School Fees Loan',
    'Business Loan',
    'Personal Loan',
    'Land Title Loan',
  ];

  final List<String> _genders = ['Male', 'Female', 'Other'];

  // ← Collateral restricted to three types
  final List<String> _collateralTypes = [
    'Land',
    'Vehicle Logbook',
    'Business Assets',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _locationController.dispose();
    _otherContactController.dispose();
    _nextOfKinNameController.dispose();
    _nextOfKinContactController.dispose();
    _occupationController.dispose();
    _monthlyIncomeController.dispose();
    _currentAddressController.dispose();
    super.dispose();
  }

  
  Future<void> _pickIdImage({required bool isFront}) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        if (isFront) {
          _idFrontImage = kIsWeb ? null : File(picked.path);
          _idFrontImageBytes = bytes;
          _idFrontImageBase64 = base64Encode(bytes);
        } else {
          _idBackImage = kIsWeb ? null : File(picked.path);
          _idBackImageBytes = bytes;
          _idBackImageBase64 = base64Encode(bytes);
        }
      });
    }
  }

  Future<void> _submitLoan() async {
    if (_formKey.currentState!.validate()) {
      // Require both front and back ID photos
      if (_idFrontImageBase64 == null || _idBackImageBase64 == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _idFrontImageBase64 == null
                  ? 'Please upload the FRONT of your National ID'
                  : 'Please upload the BACK of your National ID',
            ),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() => _isLoading = true);

      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        final userId = prefs.getInt('user_id');

        if (token == null || userId == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Session expired. Please login again.'),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isLoading = false);
          return;
        }

        final response = await http.post(
          Uri.parse('http://127.0.0.1:8000/api/loans'),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'user_id': userId,
            'amount': double.parse(_amountController.text.trim()),
            'description': _selectedLoanType,
            'status': 'pending',
            'name': _nameController.text.trim(),
            'email': _emailController.text.trim(),
            'contact': _contactController.text.trim(),
            'location': _locationController.text.trim(),
            'other_contact': _otherContactController.text.trim(),
            'gender': _selectedGender,
            'next_of_kin_name': _nextOfKinNameController.text.trim(),
            'next_of_kin_contact': _nextOfKinContactController.text.trim(),
            'occupation': _occupationController.text.trim(),
            'monthly_income': double.parse(_monthlyIncomeController.text.trim()),
            'collateral': _selectedCollateral,
            'current_address': _currentAddressController.text.trim(),
            'id_image_front': _idFrontImageBase64,
            'id_image_back': _idBackImageBase64,
          }),
        );

        final data = jsonDecode(response.body);

        if (response.statusCode == 201 && data['success'] == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoanSuccessScreen(
                amount: _amountController.text.trim(),
                loanType: _selectedLoanType!,
                name: _nameController.text.trim(),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? 'Failed to apply for loan'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connection error. Check your internet or server.'),
            backgroundColor: Colors.red,
          ),
        );
      }

      setState(() => _isLoading = false);
    }
  }

  // ─── Reusable text field builder ───────────────────────────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    Color? fillColor,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blueAccent),
        filled: true,
        fillColor: fillColor ?? Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: validator ??
          (value) {
            if (value == null || value.isEmpty) return 'Please enter $label';
            return null;
          },
    );
  }

  // ─── Section header ─────────────────────────────────────────────────────────
  Widget _sectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(child: Divider(color: Colors.blueAccent)),
        ],
      ),
    );
  }

  /// Builds a single ID upload box (front or back).
  Widget _buildIdUploadBox({
    required String label,
    required bool isFront,
    required Uint8List? imageBytes,
  }) {
    final bool hasImage = imageBytes != null;

    return Expanded(
      child: GestureDetector(
        onTap: () => _pickIdImage(isFront: isFront),
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: hasImage ? Colors.green : Colors.blueAccent,
              width: 1.5,
            ),
          ),
          child: hasImage
              ? Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.memory(
                        imageBytes,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    // Green tick badge
                    Positioned(
                      top: 6,
                      left: 6,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.green.shade600,
                        child: const Icon(Icons.check, size: 14, color: Colors.white),
                      ),
                    ),
                    // Remove button
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () => setState(() {
                          if (isFront) {
                            _idFrontImage = null;
                            _idFrontImageBytes = null;
                            _idFrontImageBase64 = null;
                          } else {
                            _idBackImage = null;
                            _idBackImageBytes = null;
                            _idBackImageBase64 = null;
                          }
                        }),
                        child: const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close, size: 14, color: Colors.white),
                        ),
                      ),
                    ),
                    // Label at bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade600.withOpacity(0.85),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(9),
                            bottomRight: Radius.circular(9),
                          ),
                        ),
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isFront ? Icons.credit_card : Icons.flip_camera_android,
                      size: 30,
                      color: Colors.blueAccent,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tap to upload',
                      style: TextStyle(color: Colors.grey, fontSize: 11),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text('Apply for a Loan'),
        backgroundColor: Colors.blueAccent.shade100,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            color: Colors.blue.shade50,
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // ── Header ────────────────────────────────────────────────
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blueAccent,
                      child: Icon(Icons.account_balance_wallet, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Loan Application",
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      "Fill in the details below to apply",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 25),

                    // ── Personal Information ──────────────────────────────────
                    _sectionHeader('Personal Information', Icons.person),

                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      icon: Icons.person_outline,
                    ),
                    const SizedBox(height: 12),

                    _buildTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter email';
                        if (!value.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    _buildTextField(
                      controller: _contactController,
                      label: 'Contact Number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),

                    _buildTextField(
                      controller: _otherContactController,
                      label: 'Other Contact',
                      icon: Icons.phone_callback_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) => null,
                    ),
                    const SizedBox(height: 12),

                    // Gender Dropdown
                    DropdownButtonFormField<String>(
                      initialValue: _selectedGender,
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        prefixIcon: const Icon(Icons.wc, color: Colors.blueAccent),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      items: _genders
                          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedGender = value),
                      validator: (value) => value == null ? 'Please select gender' : null,
                    ),
                    const SizedBox(height: 12),

                    _buildTextField(
                      controller: _locationController,
                      label: 'Location',
                      icon: Icons.location_on_outlined,
                    ),
                    const SizedBox(height: 12),

                    _buildTextField(
                      controller: _currentAddressController,
                      label: 'Current Address',
                      icon: Icons.home_outlined,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),

                    _buildTextField(
                      controller: _occupationController,
                      label: 'Occupation',
                      icon: Icons.work_outline,
                    ),
                    const SizedBox(height: 12),

                    _buildTextField(
                      controller: _monthlyIncomeController,
                      label: 'Monthly Income (UGX)',
                      icon: Icons.payments_outlined,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter monthly income';
                        if (double.tryParse(value) == null) return 'Enter a valid amount';
                        return null;
                      },
                    ),

                    // ── Next of Kin ───────────────────────────────────────────
                    _sectionHeader('Next of Kin', Icons.people_outline),

                    _buildTextField(
                      controller: _nextOfKinNameController,
                      label: 'Next of Kin Name',
                      icon: Icons.person_add_outlined,
                    ),
                    const SizedBox(height: 12),

                    _buildTextField(
                      controller: _nextOfKinContactController,
                      label: 'Next of Kin Contact',
                      icon: Icons.contact_phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),

                    // ── Loan Details ──────────────────────────────────────────
                    _sectionHeader('Loan Details', Icons.account_balance_outlined),

                    _buildTextField(
                      controller: _amountController,
                      label: 'Loan Amount (UGX)',
                      icon: Icons.attach_money,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter loan amount';
                        if (double.tryParse(value) == null) return 'Please enter a valid amount';
                        if (double.parse(value) <= 0) return 'Amount must be greater than 0';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Loan Type Dropdown
                    DropdownButtonFormField<String>(
                      initialValue: _selectedLoanType,
                      decoration: InputDecoration(
                        labelText: 'Loan Type',
                        prefixIcon: const Icon(Icons.category, color: Colors.blueAccent),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      items: _loanTypes
                          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedLoanType = value),
                      validator: (value) => value == null ? 'Please select a loan type' : null,
                    ),
                    const SizedBox(height: 12),

                    // ← Collateral Dropdown (restricted to 3 types)
                    DropdownButtonFormField<String>(
                      initialValue: _selectedCollateral,
                      decoration: InputDecoration(
                        labelText: 'Collateral',
                        prefixIcon: const Icon(Icons.security_outlined, color: Colors.blueAccent),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      items: _collateralTypes
                          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedCollateral = value),
                      validator: (value) => value == null ? 'Please select a collateral type' : null,
                    ),

                    // ── ID Upload ─────────────────────────────────────────────
                    _sectionHeader('Identity Verification', Icons.badge_outlined),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Upload both sides of your National ID',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Front & Back side by side
                    Row(
                      children: [
                        _buildIdUploadBox(
                          label: 'Front Side',
                          isFront: true,
                          imageBytes: _idFrontImageBytes,
                        ),
                        const SizedBox(width: 12),
                        _buildIdUploadBox(
                          label: 'Back Side',
                          isFront: false,
                          imageBytes: _idBackImageBytes,
                        ),
                      ],
                    ),

                    // Upload status indicators
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          _idFrontImageBytes != null ? Icons.check_circle : Icons.radio_button_unchecked,
                          size: 16,
                          color: _idFrontImageBytes != null ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Front uploaded',
                          style: TextStyle(
                            fontSize: 12,
                            color: _idFrontImageBytes != null ? Colors.green : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Icon(
                          _idBackImageBytes != null ? Icons.check_circle : Icons.radio_button_unchecked,
                          size: 16,
                          color: _idBackImageBytes != null ? Colors.green : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Back uploaded',
                          style: TextStyle(
                            fontSize: 12,
                            color: _idBackImageBytes != null ? Colors.green : Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // ── Submit Button ─────────────────────────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: _submitLoan,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Submit Application',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


// =====================
// LOAN SUCCESS SCREEN
// =====================
class LoanSuccessScreen extends StatelessWidget {
  final String amount;
  final String loanType;
  final String name;

  const LoanSuccessScreen({
    super.key,
    required this.amount,
    required this.loanType,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Card(
            color: Colors.blue.shade50,
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.check, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Application Submitted!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Your loan application has been received and is under review.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 25),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blueAccent.shade100),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow('Applicant', name),
                        const Divider(),
                        _buildSummaryRow('Loan Type', loanType),
                        const Divider(),
                        _buildSummaryRow('Amount', 'UGX $amount'),
                        const Divider(),
                        _buildSummaryRow('Status', 'Pending Review'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Back to Home', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.blueAccent)),
        ],
      ),
    );
  }
}