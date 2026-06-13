import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'loan_service.dart';


class _C {
  static const navy        = Color(0xFF0A1628);
  static const navyMid     = Color(0xFF0F2044);
  static const blue        = Color(0xFF1565C0);
  static const blueBright  = Color(0xFF2979FF);
  static const accent      = Color(0xFF4FC3F7); 
  static const gold        = Color(0xFFFFD54F);
  static const surface     = Color(0xFFFFFFFF);
  static const surfaceDim  = Color(0xFFF0F4FF);
  static const border      = Color(0xFFBBD0F8);
  static const textPri     = Color(0xFF0A1628);
  static const textSec     = Color(0xFF5C7099);
  static const success     = Color(0xFF00C853);
  static const error       = Color(0xFFE53935);
}


class LoanApplicationScreen extends StatefulWidget {
  const LoanApplicationScreen({super.key});

  @override
  State<LoanApplicationScreen> createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends State<LoanApplicationScreen>
    with SingleTickerProviderStateMixin {

  final _formKey = GlobalKey<FormState>();
  late final AnimationController _heroAnim;
  late final Animation<double> _heroFade;

  final _amountCtrl         = TextEditingController();
  final _nameCtrl           = TextEditingController();
  final _emailCtrl          = TextEditingController();
  final _contactCtrl        = TextEditingController();
  final _locationCtrl       = TextEditingController();
  final _otherContactCtrl   = TextEditingController();
  final _kinNameCtrl        = TextEditingController();
  final _kinContactCtrl     = TextEditingController();
  final _occupationCtrl     = TextEditingController();
  final _incomeCtrl         = TextEditingController();
  final _addressCtrl        = TextEditingController();

  String? _loanType;
  String? _gender;
  String? _collateral;
  bool    _isLoading = false;

  Uint8List? _frontBytes;
  String?    _frontBase64;
  Uint8List? _backBytes;
  String?    _backBase64;

  final _loanTypes = ['School Fees Loan','Business Loan','Personal Loan','Land Title Loan'];
  final _genders   = ['Male','Female','Other'];
  final _collaterals = ['Land','Vehicle Logbook','Business Assets'];

  @override
  void initState() {
    super.initState();
    _heroAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _heroFade = CurvedAnimation(parent: _heroAnim, curve: Curves.easeOut);
    _heroAnim.forward();
  }

  @override
  void dispose() {
    _heroAnim.dispose();
    for (final c in [_amountCtrl,_nameCtrl,_emailCtrl,_contactCtrl,_locationCtrl,
                     _otherContactCtrl,_kinNameCtrl,_kinContactCtrl,_occupationCtrl,
                     _incomeCtrl,_addressCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickImage({required bool isFront}) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() {
      if (isFront) { _frontBytes = bytes; _frontBase64 = base64Encode(bytes); }
      else          { _backBytes  = bytes; _backBase64  = base64Encode(bytes); }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_frontBase64 == null || _backBase64 == null) {
      _snack(_frontBase64 == null
          ? 'Please upload the FRONT of your National ID'
          : 'Please upload the BACK of your National ID',
          isError: true);
      return;
    }
    setState(() => _isLoading = true);
    try {
      final prefs  = await SharedPreferences.getInstance();
      final token  = prefs.getString('token');
      final userId = prefs.getInt('user_id');
      if (token == null || userId == null) {
        _snack('Session expired. Please login again.', isError: true);
        setState(() => _isLoading = false);
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
      if (response.statusCode == 201 && data['success'] == true) {
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (_) => LoanSuccessScreen(
            amount: _amountCtrl.text.trim(),
            loanType: _loanType!,
            name: _nameCtrl.text.trim(),
          ),
        ));
      } else {
        _snack(data['message'] ?? 'Failed to apply for loan', isError: true);
      }
    } catch (_) {
      _snack('Connection error. Check your internet or server.', isError: true);
    }
    setState(() => _isLoading = false);
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: isError ? _C.error : _C.success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
    ));
  }


  Widget _card({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: _C.blue.withOpacity(0.08), blurRadius: 24, offset: const Offset(0, 8)),
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_C.blue, _C.blueBright],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                Text(title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: 0.4,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool showDialCode = false,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(color: _C.textPri, fontSize: 15, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: _C.textSec, fontSize: 14),
          floatingLabelStyle: TextStyle(color: _C.blueBright, fontWeight: FontWeight.w600, fontSize: 13),
          prefixIcon: Icon(icon, color: _C.blue, size: 20),
          prefix: showDialCode ? _dialBadge() : null,
          filled: true,
          fillColor: _C.surfaceDim,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _C.border, width: 1.2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _C.border, width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _C.blueBright, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _C.error, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _C.error, width: 2),
          ),
          errorStyle: const TextStyle(color: _C.error, fontSize: 12),
        ),
        validator: validator ?? (v) => (v == null || v.isEmpty) ? 'Please enter $label' : null,
      ),
    );
  }


  Widget _dropdown<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<T> items,
    required void Function(T?) onChanged,
    String? Function(T?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        dropdownColor: _C.surface,
        style: const TextStyle(color: _C.textPri, fontSize: 15, fontWeight: FontWeight.w500),
        icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _C.blue),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: _C.textSec, fontSize: 14),
          floatingLabelStyle: TextStyle(color: _C.blueBright, fontWeight: FontWeight.w600, fontSize: 13),
          prefixIcon: Icon(icon, color: _C.blue, size: 20),
          filled: true,
          fillColor: _C.surfaceDim,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _C.border, width: 1.2)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _C.border, width: 1.2)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _C.blueBright, width: 2)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _C.error, width: 1.5)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: _C.error, width: 2)),
          errorStyle: const TextStyle(color: _C.error, fontSize: 12),
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [_C.blue, _C.blueBright]),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text('+256',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12, letterSpacing: 0.5),
      ),
    );
  }

  
  Widget _idBox({required String label, required bool isFront, required Uint8List? bytes}) {
    final has = bytes != null;
    return Expanded(
      child: GestureDetector(
        onTap: () => _pickImage(isFront: isFront),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 155,
          decoration: BoxDecoration(
            color: has ? Colors.transparent : _C.surfaceDim,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: has ? _C.success : _C.border,
              width: has ? 2 : 1.5,
            ),
            boxShadow: has ? [BoxShadow(color: _C.success.withOpacity(0.15), blurRadius: 12)] : [],
          ),
          child: has
            ? Stack(fit: StackFit.expand, children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.memory(bytes, fit: BoxFit.cover),
                ),
                
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15),
                      ),
                    ),
                    child: Text(label, textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                  ),
                ),
              
                Positioned(top: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(color: _C.success, borderRadius: BorderRadius.circular(20)),
                    child: const Icon(Icons.check, color: Colors.white, size: 13),
                  ),
                ),
        
                Positioned(top: 6, right: 6,
                  child: GestureDetector(
                    onTap: () => setState(() {
                      if (isFront) { _frontBytes = null; _frontBase64 = null; }
                      else         { _backBytes  = null; _backBase64  = null; }
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: _C.error, borderRadius: BorderRadius.circular(20)),
                      child: const Icon(Icons.close, color: Colors.white, size: 13),
                    ),
                  ),
                ),
              ])
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: _C.blue.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFront ? Icons.credit_card_rounded : Icons.flip_to_back_rounded,
                    color: _C.blue, size: 28,
                  ),
                ),
                const SizedBox(height: 10),
                Text(label, style: const TextStyle(color: _C.blue, fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                const Text('Tap to upload', style: TextStyle(color: _C.textSec, fontSize: 11)),
              ]),
        ),
      ),
    );
  }


  Widget _statusChip(String label, bool done) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 18, height: 18,
        decoration: BoxDecoration(
          color: done ? _C.success : Colors.transparent,
          border: Border.all(color: done ? _C.success : _C.border, width: 1.5),
          shape: BoxShape.circle,
        ),
        child: done ? const Icon(Icons.check, color: Colors.white, size: 11) : null,
      ),
      const SizedBox(width: 6),
      Text(label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: done ? _C.success : _C.textSec,
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.navy,
      body: CustomScrollView(
        slivers: [
        
          SliverAppBar(
  expandedHeight: 100,
  pinned: true,
  backgroundColor: _C.navyMid,
  elevation: 0,
  leading: IconButton(
    icon: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
    ),
    onPressed: () => Navigator.pop(context),
  ),
  flexibleSpace: FlexibleSpaceBar(
    collapseMode: CollapseMode.parallax,
    background: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_C.navyMid, _C.blue, _C.blueBright],
        ),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
        
          Positioned(
            top: -40, right: -40,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: -20, left: -30,
            child: Container(
              width: 140, height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _C.accent.withOpacity(0.08),
              ),
            ),
          ),
  
          FadeTransition(
            opacity: _heroFade,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 48), 
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: const Icon(Icons.account_balance_rounded, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Loan Application',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                          decoration: BoxDecoration(
                            color: _C.gold.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: _C.gold.withOpacity(0.5)),
                          ),
                          child: const Text(
                            'Quick & Secure',
                            style: TextStyle(
                              color: _C.gold,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
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
        ],
      ),
    ),
  ),
),
          
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF2F6FF),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 24, 18, 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [

                
                      _card(
                        title: 'Personal Information',
                        icon: Icons.person_rounded,
                        children: [
                          _field(controller: _nameCtrl, label: 'Full Name', icon: Icons.badge_outlined),
                          _field(controller: _emailCtrl, label: 'Email Address', icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Please enter email';
                              if (!v.contains('@')) return 'Enter a valid email';
                              return null;
                            }),
                          _field(controller: _contactCtrl, label: 'Contact Number', icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone, showDialCode: true),
                          _field(controller: _otherContactCtrl, label: 'Other Contact', icon: Icons.phone_callback_outlined,
                            keyboardType: TextInputType.phone, showDialCode: true,
                            validator: (_) => null),
                          _dropdown<String>(
                            label: 'Gender', icon: Icons.wc_rounded,
                            value: _gender, items: _genders,
                            onChanged: (v) => setState(() => _gender = v),
                            validator: (v) => v == null ? 'Please select gender' : null,
                          ),
                          _field(controller: _locationCtrl, label: 'Location', icon: Icons.location_on_outlined),
                          _field(controller: _addressCtrl, label: 'Current Address', icon: Icons.home_outlined, maxLines: 2),
                          _field(controller: _occupationCtrl, label: 'Occupation', icon: Icons.work_outline_rounded),
                          _field(controller: _incomeCtrl, label: 'Monthly Income (UGX)', icon: Icons.payments_outlined,
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Please enter monthly income';
                              if (double.tryParse(v) == null) return 'Enter a valid amount';
                              return null;
                            }),
                        ],
                      ),

                
                      _card(
                        title: 'Next of Kin',
                        icon: Icons.people_alt_rounded,
                        children: [
                          _field(controller: _kinNameCtrl, label: 'Next of Kin Name', icon: Icons.person_add_outlined),
                          _field(controller: _kinContactCtrl, label: 'Next of Kin Contact', icon: Icons.contact_phone_outlined,
                            keyboardType: TextInputType.phone, showDialCode: true),
                        ],
                      ),

              
                      _card(
                        title: 'Loan Details',
                        icon: Icons.account_balance_rounded,
                        children: [
                          _field(controller: _amountCtrl, label: 'Loan Amount (UGX)', icon: Icons.attach_money_rounded,
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Please enter loan amount';
                              if (double.tryParse(v) == null) return 'Please enter a valid amount';
                              if (double.parse(v) <= 0) return 'Amount must be greater than 0';
                              return null;
                            }),
                          _dropdown<String>(
                            label: 'Loan Type', icon: Icons.category_rounded,
                            value: _loanType, items: _loanTypes,
                            onChanged: (v) => setState(() => _loanType = v),
                            validator: (v) => v == null ? 'Please select a loan type' : null,
                          ),
                          _dropdown<String>(
                            label: 'Collateral', icon: Icons.security_rounded,
                            value: _collateral, items: _collaterals,
                            onChanged: (v) => setState(() => _collateral = v),
                            validator: (v) => v == null ? 'Please select a collateral type' : null,
                          ),
                        ],
                      ),

              
                      _card(
                        title: 'Identity Verification',
                        icon: Icons.verified_user_rounded,
                        children: [
                          const Text('Upload both sides of your National ID',
                            style: TextStyle(color: _C.textSec, fontSize: 13)),
                          const SizedBox(height: 14),
                          Row(children: [
                            _idBox(label: 'Front Side', isFront: true,  bytes: _frontBytes),
                            const SizedBox(width: 12),
                            _idBox(label: 'Back Side',  isFront: false, bytes: _backBytes),
                          ]),
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
                                _statusChip('Front uploaded', _frontBytes != null),
                                Container(width: 1, height: 20, color: _C.border),
                                _statusChip('Back uploaded',  _backBytes  != null),
                              ],
                            ),
                          ),
                        ],
                      ),

          
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: _isLoading
                          ? Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [_C.blue, _C.blueBright]),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                              ),
                            )
                          : DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [_C.blue, _C.blueBright],
                                  begin: Alignment.centerLeft, end: Alignment.centerRight),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(color: _C.blue.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6)),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: _submit,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                                label: const Text('Submit Application',
                                  style: TextStyle(fontSize: 17, color: Colors.white,
                                    fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                              ),
                            ),
                      ),
                      const SizedBox(height: 16),
                      
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Icon(Icons.lock_outline_rounded, color: _C.textSec, size: 13),
                        const SizedBox(width: 5),
                        const Text('Your data is encrypted & secure',
                          style: TextStyle(color: _C.textSec, fontSize: 12)),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



class LoanSuccessScreen extends StatelessWidget {
  final String amount;
  final String loanType;
  final String name;

  const LoanSuccessScreen({super.key, required this.amount, required this.loanType, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.navy,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 30),
            
              Container(
                width: 110, height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [_C.success, Color(0xFF69F0AE)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                  boxShadow: [BoxShadow(color: _C.success.withOpacity(0.4), blurRadius: 28, spreadRadius: 4)],
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 56),
              ),
              const SizedBox(height: 28),
              const Text('Application Submitted!',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, letterSpacing: 0.3)),
              const SizedBox(height: 10),
              const Text('Your loan application has been received\nand is currently under review.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white60, fontSize: 14, height: 1.6)),
              const SizedBox(height: 32),
          
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: _C.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 24, offset: const Offset(0, 8))],
                ),
                child: Column(
                  children: [
                    const Text('Application Summary',
                      style: TextStyle(color: _C.textSec, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                    const SizedBox(height: 20),
                    _row('Applicant', name, Icons.person_rounded),
                    _divider(),
                    _row('Loan Type', loanType, Icons.category_rounded),
                    _divider(),
                    _row('Amount', 'UGX $amount', Icons.attach_money_rounded),
                    _divider(),
                    _row('Status', 'Pending Review', Icons.hourglass_top_rounded, valueColor: _C.gold),
                  ],
                ),
              ),
              const SizedBox(height: 28),
          
              SizedBox(
                width: double.infinity, height: 56,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [_C.blue, _C.blueBright]),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: _C.blue.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(Icons.home_rounded, color: Colors.white),
                    label: const Text('Back to Home',
                      style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value, IconData icon, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: _C.surfaceDim, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: _C.blue, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(color: _C.textSec, fontSize: 13))),
        Text(value,
          style: TextStyle(color: valueColor ?? _C.textPri, fontWeight: FontWeight.w700, fontSize: 14)),
      ]),
    );
  }

  Widget _divider() => const Divider(color: _C.border, height: 1);
}