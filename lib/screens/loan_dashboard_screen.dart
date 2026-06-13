import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'loan_service.dart';
import 'loan_detail_screen.dart';


class _C {
  static const navy        = Color(0xFF0A1628);
  static const blue        = Color(0xFF1565C0);
  static const blueBright  = Color(0xFF2979FF);
  static const surface     = Color(0xFFFFFFFF);
  static const surfaceDim  = Color(0xFFF0F4FF);
  static const border      = Color(0xFFBBD0F8);
  static const textPri     = Color(0xFF0A1628);
  static const textSec     = Color(0xFF5C7099);
  static const success     = Color(0xFF00C853);
  static const error       = Color(0xFFE53935);
}

class LoanDashboardScreen extends StatefulWidget {
  const LoanDashboardScreen({super.key});

  @override
  State<LoanDashboardScreen> createState() => _LoanDashboardScreenState();
}

class _LoanDashboardScreenState extends State<LoanDashboardScreen> {
  List<dynamic> _loans = [];
  bool _loading = true;
  String? _error;

  final _formKey = GlobalKey<FormState>();
  bool _formExpanded = false;
  bool _submitting = false;

  
  final _amountCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _contactCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _otherContactCtrl = TextEditingController();
  final _kinNameCtrl = TextEditingController();
  final _kinContactCtrl = TextEditingController();
  final _occupationCtrl = TextEditingController();
  final _incomeCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();

  String? _loanType;
  String? _gender;
  String? _collateral;

  Uint8List? _frontBytes;
  String? _frontBase64;
  Uint8List? _backBytes;
  String? _backBase64;

  final _loanTypes = ['School Fees Loan', 'Business Loan', 'Personal Loan', 'Land Title Loan'];
  final _genders = ['Male', 'Female', 'Other'];
  final _collaterals = ['Land', 'Vehicle Logbook', 'Business Assets'];

  @override
  void initState() {
    super.initState();
    _fetchLoans();
  }

  @override
  void dispose() {
    for (final c in [
      _amountCtrl,
      _nameCtrl,
      _emailCtrl,
      _contactCtrl,
      _locationCtrl,
      _otherContactCtrl,
      _kinNameCtrl,
      _kinContactCtrl,
      _occupationCtrl,
      _incomeCtrl,
      _addressCtrl
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchLoans() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final loans = await LoanService.getLoans();
      setState(() {
        _loans = loans;
        _loading = false;
        if (loans.isEmpty) {
          _formExpanded = true;
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load loans. Please try again.';
        _loading = false;
      });
    }
  }

  Future<void> _pickImage({required bool isFront}) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() {
      if (isFront) {
        _frontBytes = bytes;
        _frontBase64 = base64Encode(bytes);
      } else {
        _backBytes = bytes;
        _backBase64 = base64Encode(bytes);
      }
    });
  }

  void _clearForm() {
    _amountCtrl.clear();
    _nameCtrl.clear();
    _emailCtrl.clear();
    _contactCtrl.clear();
    _locationCtrl.clear();
    _otherContactCtrl.clear();
    _kinNameCtrl.clear();
    _kinContactCtrl.clear();
    _occupationCtrl.clear();
    _incomeCtrl.clear();
    _addressCtrl.clear();
    setState(() {
      _loanType = null;
      _gender = null;
      _collateral = null;
      _frontBytes = null;
      _frontBase64 = null;
      _backBytes = null;
      _backBase64 = null;
    });
  }

  Future<void> _submitLoan() async {
    if (!_formKey.currentState!.validate()) return;
    if (_frontBase64 == null || _backBase64 == null) {
      _showSnackbar(
        _frontBase64 == null
            ? 'Please upload the FRONT of your National ID'
            : 'Please upload the BACK of your National ID',
        isError: true,
      );
      return;
    }
    setState(() => _submitting = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getInt('user_id');
      if (token == null || userId == null) {
        _showSnackbar('Session expired. Please login again.', isError: true);
        setState(() => _submitting = false);
        return;
      }
      final response = await http.post(
        Uri.parse(LoanService.createLoanUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': userId,
          'amount': double.parse(_amountCtrl.text.trim()),
          'description': _loanType,
          'status': 'pending',
          'name': _nameCtrl.text.trim(),
          'email': _emailCtrl.text.trim(),
          'contact': _contactCtrl.text.trim(),
          'location': _locationCtrl.text.trim(),
          'other_contact': _otherContactCtrl.text.trim(),
          'gender': _gender,
          'next_of_kin_name': _kinNameCtrl.text.trim(),
          'next_of_kin_contact': _kinContactCtrl.text.trim(),
          'occupation': _occupationCtrl.text.trim(),
          'monthly_income': double.parse(_incomeCtrl.text.trim()),
          'collateral': _collateral,
          'current_address': _addressCtrl.text.trim(),
          'id_image_front': _frontBase64,
          'id_image_back': _backBase64,
        }),
      );
      final data = jsonDecode(response.body);
      if (!mounted) return;
      if ((response.statusCode == 200 || response.statusCode == 201) && data['success'] == true) {
        _showSuccessDialog();
        _clearForm();
        _formExpanded = false;
        _fetchLoans(); 
      } else {
        _showSnackbar(data['message'] ?? 'Failed to apply for loan', isError: true);
      }
    } catch (_) {
      if (mounted) {
        _showSnackbar('Connection error. Check your internet or server.', isError: true);
      }
    }
    if (mounted) {
      setState(() => _submitting = false);
    }
  }

  void _showSnackbar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: isError ? _C.error : _C.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: _C.success, size: 28),
            SizedBox(width: 10),
            Text("Application Sent"),
          ],
        ),
        content: const Text("Your loan application has been submitted successfully and is under review!"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK", style: TextStyle(fontWeight: FontWeight.bold, color: _C.blue)),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'disbursed':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      case 'completed':
        return Colors.teal;
      case 'defaulted':
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'approved':
        return Icons.check_circle_outline;
      case 'disbursed':
        return Icons.account_balance;
      case 'rejected':
        return Icons.cancel_outlined;
      case 'completed':
        return Icons.task_alt;
      case 'defaulted':
        return Icons.warning_amber;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("My Loan Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchLoans,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchLoans,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              _buildApplyLoanCard(),
              const SizedBox(height: 24),
              
    
              const Text(
                "My Loan Applications",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D1B40),
                ),
              ),
              const SizedBox(height: 12),
              
  
              if (_loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_error != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 60),
                        const SizedBox(height: 12),
                        Text(_error!, style: const TextStyle(color: Colors.red)),
                        const SizedBox(height: 16),
                        ElevatedButton(onPressed: _fetchLoans, child: const Text("Retry")),
                      ],
                    ),
                  ),
                )
              else if (_loans.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined, size: 60, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          "No loan applications yet.",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _loans.length,
                  itemBuilder: (context, index) {
                    final loan = _loans[index];
                    final status = (loan['status'] ?? 'pending').toString();
                    final amount = loan['amount']?.toString() ?? '0';
                    final purpose = loan['description'] ?? 'Loan Application';
                    final date = loan['created_at'] != null ? loan['created_at'].toString().substring(0, 10) : '';

                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoanDetailScreen(loan: loan),
                            ),
                          );
                          _fetchLoans(); 
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                            
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: _statusColor(status).withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _statusIcon(status),
                                  color: _statusColor(status),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 14),
                        
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      purpose,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0D1B40)),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "UGX ${_formatAmount(amount)}",
                                      style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w700, fontSize: 13),
                                    ),
                                    if (loan['name'] != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text(
                                          "Applicant: ${loan['name']}",
                                          style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    if (loan['collateral'] != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          "Collateral: ${loan['collateral']}",
                                          style: TextStyle(color: Colors.grey[700], fontSize: 12),
                                        ),
                                      ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Applied: $date",
                                      style: const TextStyle(color: Colors.grey, fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                          
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _statusColor(status).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: _statusColor(status), width: 1),
                                ),
                                child: Text(
                                  status.toUpperCase(),
                                  style: TextStyle(
                                    color: _statusColor(status),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildApplyLoanCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _C.border.withOpacity(0.5), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              InkWell(
                onTap: () {
                  setState(() {
                    _formExpanded = !_formExpanded;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_C.blue, _C.blueBright],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "Apply for a New Loan",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Get approved in under 24 hours",
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _formExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  ),
                ),
              ),

          
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader("Personal Information", Icons.person_rounded),
                        const SizedBox(height: 12),
                        _buildField(controller: _nameCtrl, label: 'Full Name', icon: Icons.badge_outlined),
                        _buildField(
                          controller: _emailCtrl,
                          label: 'Email Address',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Please enter email';
                            if (!v.contains('@')) return 'Enter a valid email';
                            return null;
                          },
                        ),
                        _buildField(
                          controller: _contactCtrl,
                          label: 'Contact Number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          showDialCode: true,
                        ),
                        _buildField(
                          controller: _otherContactCtrl,
                          label: 'Other Contact',
                          icon: Icons.phone_callback_outlined,
                          keyboardType: TextInputType.phone,
                          showDialCode: true,
                          validator: (_) => null,
                        ),
                        _buildDropdown<String>(
                          label: 'Gender',
                          icon: Icons.wc_rounded,
                          value: _gender,
                          items: _genders,
                          onChanged: (v) => setState(() => _gender = v),
                        ),
                        _buildField(controller: _locationCtrl, label: 'Location', icon: Icons.location_on_outlined),
                        _buildField(controller: _addressCtrl, label: 'Current Address', icon: Icons.home_outlined, maxLines: 2),
                        _buildField(controller: _occupationCtrl, label: 'Occupation', icon: Icons.work_outline_rounded),
                        _buildField(
                          controller: _incomeCtrl,
                          label: 'Monthly Income (UGX)',
                          icon: Icons.payments_outlined,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Please enter monthly income';
                            if (double.tryParse(v) == null) return 'Enter a valid amount';
                            return null;
                          },
                        ),
                        
                        const Divider(height: 24),
                        _buildSectionHeader("Next of Kin", Icons.people_alt_rounded),
                        const SizedBox(height: 12),
                        _buildField(controller: _kinNameCtrl, label: 'Next of Kin Name', icon: Icons.person_add_outlined),
                        _buildField(
                          controller: _kinContactCtrl,
                          label: 'Next of Kin Contact',
                          icon: Icons.contact_phone_outlined,
                          keyboardType: TextInputType.phone,
                          showDialCode: true,
                        ),

                        const Divider(height: 24),
                        _buildSectionHeader("Loan Details", Icons.account_balance_rounded),
                        const SizedBox(height: 12),
                        _buildField(
                          controller: _amountCtrl,
                          label: 'Loan Amount (UGX)',
                          icon: Icons.attach_money_rounded,
                          keyboardType: TextInputType.number,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Please enter loan amount';
                            if (double.tryParse(v) == null) return 'Please enter a valid amount';
                            if (double.parse(v) <= 0) return 'Amount must be greater than 0';
                            return null;
                          },
                        ),
                        _buildDropdown<String>(
                          label: 'Loan Type',
                          icon: Icons.category_rounded,
                          value: _loanType,
                          items: _loanTypes,
                          onChanged: (v) => setState(() => _loanType = v),
                        ),
                        _buildDropdown<String>(
                          label: 'Collateral',
                          icon: Icons.security_rounded,
                          value: _collateral,
                          items: _collaterals,
                          onChanged: (v) => setState(() => _collateral = v),
                        ),

                        const Divider(height: 24),
                        _buildSectionHeader("Identity Verification", Icons.verified_user_rounded),
                        const SizedBox(height: 8),
                        const Text('Upload both sides of your National ID', style: TextStyle(color: _C.textSec, fontSize: 13)),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            _buildIdBox(label: 'Front Side', isFront: true, bytes: _frontBytes),
                            const SizedBox(width: 12),
                            _buildIdBox(label: 'Back Side', isFront: false, bytes: _backBytes),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: _C.surfaceDim,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _C.border),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildStatusChip('Front uploaded', _frontBytes != null),
                              Container(width: 1, height: 20, color: _C.border),
                              _buildStatusChip('Back uploaded', _backBytes != null),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: _submitting
                              ? Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [_C.blue, _C.blueBright]),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                  ),
                                )
                              : DecoratedBox(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [_C.blue, _C.blueBright],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(color: _C.blue.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
                                    ],
                                  ),
                                  child: ElevatedButton.icon(
                                    onPressed: _submitLoan,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    ),
                                    icon: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                                    label: const Text(
                                      'Submit Application',
                                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                crossFadeState: _formExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: _C.blue, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: _C.navy,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool showDialCode = false,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(color: _C.textPri, fontSize: 14, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: _C.textSec, fontSize: 13),
          floatingLabelStyle: const TextStyle(color: _C.blueBright, fontWeight: FontWeight.w600, fontSize: 12),
          prefixIcon: Icon(icon, color: _C.blue, size: 18),
          prefix: showDialCode ? _dialBadge() : null,
          filled: true,
          fillColor: _C.surfaceDim,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _C.border, width: 1.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _C.border, width: 1.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _C.blueBright, width: 1.8),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _C.error, width: 1.2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _C.error, width: 1.8),
          ),
          errorStyle: const TextStyle(color: _C.error, fontSize: 11),
        ),
        validator: validator ?? (v) => (v == null || v.isEmpty) ? 'Please enter $label' : null,
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
    String? Function(T?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        dropdownColor: _C.surface,
        style: const TextStyle(color: _C.textPri, fontSize: 14, fontWeight: FontWeight.w500),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _C.blue),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: _C.textSec, fontSize: 13),
          floatingLabelStyle: const TextStyle(color: _C.blueBright, fontWeight: FontWeight.w600, fontSize: 12),
          prefixIcon: Icon(icon, color: _C.blue, size: 18),
          filled: true,
          fillColor: _C.surfaceDim,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _C.border, width: 1.0)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _C.border, width: 1.0)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _C.blueBright, width: 1.8)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _C.error, width: 1.2)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _C.error, width: 1.8)),
          errorStyle: const TextStyle(color: _C.error, fontSize: 11),
        ),
        items: items.map((i) => DropdownMenuItem(value: i, child: Text(i.toString()))).toList(),
        onChanged: onChanged,
        validator: validator ?? (v) => v == null ? 'Please select $label' : null,
      ),
    );
  }

  Widget _dialBadge() {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [_C.blue, _C.blueBright]),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        '+256',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildIdBox({required String label, required bool isFront, required Uint8List? bytes}) {
    final has = bytes != null;
    return Expanded(
      child: GestureDetector(
        onTap: () => _pickImage(isFront: isFront),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 140,
          decoration: BoxDecoration(
            color: has ? Colors.transparent : _C.surfaceDim,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: has ? _C.success : _C.border,
              width: has ? 2 : 1.2,
            ),
            boxShadow: has ? [BoxShadow(color: _C.success.withOpacity(0.15), blurRadius: 10)] : [],
          ),
          child: has
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Image.memory(bytes, fit: BoxFit.cover),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(13),
                            bottomRight: Radius.circular(13),
                          ),
                        ),
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(color: _C.success, shape: BoxShape.circle),
                        child: const Icon(Icons.check, color: Colors.white, size: 11),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => setState(() {
                          if (isFront) {
                            _frontBytes = null;
                            _frontBase64 = null;
                          } else {
                            _backBytes = null;
                            _backBase64 = null;
                          }
                        }),
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(color: _C.error, shape: BoxShape.circle),
                          child: const Icon(Icons.close, color: Colors.white, size: 11),
                        ),
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _C.blue.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFront ? Icons.credit_card_rounded : Icons.flip_to_back_rounded,
                        color: _C.blue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(label, style: const TextStyle(color: _C.blue, fontSize: 12, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    const Text('Tap to upload', style: TextStyle(color: _C.textSec, fontSize: 10)),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, bool done) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: done ? _C.success : Colors.transparent,
            border: Border.all(color: done ? _C.success : _C.border, width: 1.5),
            shape: BoxShape.circle,
          ),
          child: done ? const Icon(Icons.check, color: Colors.white, size: 10) : null,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: done ? _C.success : _C.textSec,
          ),
        ),
      ],
    );
  }

  String _formatAmount(String amount) {
    try {
      final num = double.parse(amount);
      return num.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
    } catch (_) {
      return amount;
    }
  }
}