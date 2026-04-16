
import 'package:flutter/material.dart';
import 'loan_service.dart';

class LoanEditScreen extends StatefulWidget {
  final Map<String, dynamic> loan;

  const LoanEditScreen({super.key, required this.loan});

  @override
  State<LoanEditScreen> createState() => _LoanEditScreenState();
}

class _LoanEditScreenState extends State<LoanEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _amountController;
  late TextEditingController _collateralController;
  String? _selectedDescription;
  bool _saving = false;

  final List<String> _loanTypes = [
    'School Fees Loan',
    'Business Loan',
    'Personal Loan',
    'Land Title Loan',
  ];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
        text: widget.loan['amount']?.toString() ?? '');
    _collateralController = TextEditingController(
        text: widget.loan['collateral']?.toString() ?? '');
    _selectedDescription = widget.loan['description']?.toString();

    // If saved description doesn't match list, reset to null
    if (_selectedDescription != null &&
        !_loanTypes.contains(_selectedDescription)) {
      _selectedDescription = null;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _collateralController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDescription == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a loan type.'),
            backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _saving = true);

    final result = await LoanService.updateLoan(widget.loan['id'], {
      'amount': double.tryParse(_amountController.text.trim()) ?? 0,
      'description': _selectedDescription,
      'collateral': _collateralController.text.trim(),
    });

    setState(() => _saving = false);

    if (result['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Loan updated successfully!"),
            backgroundColor: Colors.green),
      );
      Navigator.pop(context, result['loan']);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(result['message'] ?? 'Update failed.'),
            backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final status =
        (widget.loan['status'] ?? '').toString().toLowerCase();

    // Guard: not pending — show locked screen
    if (status != 'pending') {
      return Scaffold(
        appBar: AppBar(title: const Text("Edit Loan"), centerTitle: true),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 80, color: Colors.grey),
                const SizedBox(height: 20),
                const Text(
                  "Editing Not Allowed",
                  style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "This loan is currently \"${status.toUpperCase()}\" and can no longer be edited. Only pending loans can be modified.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Edit Loan Application"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notice banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.orange),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        "You can only edit this loan while its status is PENDING.",
                        style: TextStyle(
                            color: Colors.orange, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Amount
              _buildField(
                controller: _amountController,
                label: "Loan Amount (UGX)",
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Amount is required';
                  if (double.tryParse(v) == null) {
                    return 'Enter a valid amount';
                  }
                  if (double.parse(v) <= 0) {
                    return 'Amount must be greater than 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Loan Type Dropdown
              const Text("Loan Type",
                  style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 13)),
              const SizedBox(height: 6),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedDescription,
                    isExpanded: true,
                    hint: const Text("Select loan type"),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: _loanTypes
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (val) {
                      setState(() => _selectedDescription = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Collateral
              _buildField(
                controller: _collateralController,
                label: "Collateral (optional)",
                icon: Icons.home_work_outlined,
                maxLines: 2,
                validator: (_) => null, // optional
              ),
              const SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text("Save Changes",
                          style: TextStyle(
                              fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Colors.blue, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red)),
      ),
    );
  }
}