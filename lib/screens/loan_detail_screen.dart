import 'package:flutter/material.dart';
import '../constants.dart';
import 'loan_service.dart';
import 'loan_edit_screen.dart';
import 'repayment_screen.dart';

class LoanDetailScreen extends StatefulWidget {
  final Map<String, dynamic> loan;

  const LoanDetailScreen({super.key, required this.loan});

  @override
  State<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends State<LoanDetailScreen> {
  late Map<String, dynamic> _loan;
  List<dynamic> _repayments = [];
  bool _loadingRepayments = false;

  @override
  void initState() {
    super.initState();
    _loan = Map<String, dynamic>.from(widget.loan);
    _fetchRepayments();
  }

  Future<void> _fetchRepayments() async {
    setState(() => _loadingRepayments = true);
    try {
      final repayments = await LoanService.getRepayments(_loan['id']);
      if (mounted) {
        setState(() {
          _repayments = repayments;
          _loadingRepayments = false;
        });
      }
    } catch (_) {
     
      if (mounted) {
        setState(() => _loadingRepayments = false);
      }
    }
  }

  bool get _isPending =>
      (_loan['status'] ?? '').toString().toLowerCase() == 'pending';

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

  double get _totalRepaid {
    double total = 0;
    for (final r in _repayments) {
      total += double.tryParse(r['amount']?.toString() ?? '0') ?? 0;
    }
    return total;
  }

  double get _loanAmount =>
      double.tryParse(_loan['amount']?.toString() ?? '0') ?? 0;

  double get _balance =>
      (_loanAmount - _totalRepaid).clamp(0, double.infinity);

  @override
  Widget build(BuildContext context) {
    final status = (_loan['status'] ?? 'pending').toString();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Loan Details"),
        centerTitle: true,
        actions: [
          if (_isPending)
  Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ElevatedButton.icon(
      onPressed: () async {
        final updated = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoanEditScreen(loan: _loan),
          ),
        );
        if (updated != null && mounted) {
          setState(() => _loan = Map<String, dynamic>.from(updated));
        }
      },
      icon: const Icon(Icons.edit, size: 16, color: Colors.blue),
      label: const Text("Edit", style: TextStyle(color: Colors.blue)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
      ),
    ),
  ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _statusColor(status).withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: _statusColor(status), width: 1.5),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      color: _statusColor(status)),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Loan Status",
                          style: TextStyle(
                              color: Colors.grey, fontSize: 12)),
                      Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          color: _statusColor(status),
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (!_isPending)
                    const Tooltip(
                      message:
                          "Editing is only available for pending loans",
                      child: Icon(Icons.lock, color: Colors.grey),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 20),

           
            _infoCard("Loan Information", [
              _infoRow("Purpose",
                  (_loan['description'] ?? _loan['purpose'])?.toString() ?? '-'),
              _infoRow(
                  "Amount",
                  "UGX ${_formatAmount(_loan['amount']?.toString() ?? '0')}"),
              _infoRow("Duration",
                  "${_loan['duration_months']?.toString() ?? '-'} months"),
              _infoRow("Interest Rate",
                  "${_loan['interest_rate']?.toString() ?? '0'}%"),
              _infoRow(
                  "Applied On",
                  _loan['created_at'] != null
                      ? _loan['created_at'].toString().length >= 10
                          ? _loan['created_at']
                              .toString()
                              .substring(0, 10)
                          : _loan['created_at'].toString()
                      : '-'),
              if (_loan['approved_at'] != null)
                _infoRow(
                    "Approved On",
                    _loan['approved_at'].toString().length >= 10
                        ? _loan['approved_at']
                            .toString()
                            .substring(0, 10)
                        : _loan['approved_at'].toString()),
              if (_loan['disbursed_at'] != null)
                _infoRow(
                    "Disbursed On",
                    _loan['disbursed_at'].toString().length >= 10
                        ? _loan['disbursed_at']
                            .toString()
                            .substring(0, 10)
                        : _loan['disbursed_at'].toString()),
            ]),

            const SizedBox(height: 16),

           
            _infoCard("Applicant Details", [
              _infoRow("Full Name", _loan['name']?.toString() ?? '-'),
              _infoRow("Email", _loan['email']?.toString() ?? '-'),
              _infoRow("Contact", _loan['contact']?.toString() ?? '-'),
              _infoRow("Other Contact", _loan['other_contact']?.toString() ?? '-'),
              _infoRow("Gender", _loan['gender']?.toString() ?? '-'),
              _infoRow("Location", _loan['location']?.toString() ?? '-'),
              _infoRow("Current Address", _loan['current_address']?.toString() ?? '-'),
              _infoRow("Occupation", _loan['occupation']?.toString() ?? '-'),
              _infoRow("Monthly Income", _loan['monthly_income'] != null 
                  ? "UGX ${_formatAmount(_loan['monthly_income'].toString())}"
                  : '-'),
              _infoRow("Collateral", _loan['collateral']?.toString() ?? '-'),
            ]),

            const SizedBox(height: 16),

            
            _infoCard("Next of Kin", [
              _infoRow("Name", _loan['next_of_kin_name']?.toString() ?? '-'),
              _infoRow("Contact", _loan['next_of_kin_contact']?.toString() ?? '-'),
            ]),

            const SizedBox(height: 16),

           
            if (_loan['id_image_front'] != null || _loan['id_image_back'] != null)
              _infoCard("Identity Documents", [
                const Text("National ID (Front & Back)", style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    if (_loan['id_image_front'] != null)
                      Expanded(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                '${AppConstants.baseUrl}/storage/${_loan['id_image_front']}',
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 120,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text("Front Side", style: TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ),
                    if (_loan['id_image_front'] != null && _loan['id_image_back'] != null)
                      const SizedBox(width: 12),
                    if (_loan['id_image_back'] != null)
                      Expanded(
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                '${AppConstants.baseUrl}/storage/${_loan['id_image_back']}',
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  height: 120,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text("Back Side", style: TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ),
                  ],
                ),
              ]),

            const SizedBox(height: 16),

            
            _infoCard("Repayment Summary", [
              _infoRow(
                  "Loan Amount",
                  "UGX ${_formatAmount(_loanAmount.toStringAsFixed(0))}"),
              _infoRow(
                  "Total Repaid",
                  "UGX ${_formatAmount(_totalRepaid.toStringAsFixed(0))}",
                  valueColor: Colors.green),
              _infoRow(
                  "Balance Remaining",
                  "UGX ${_formatAmount(_balance.toStringAsFixed(0))}",
                  valueColor:
                      _balance > 0 ? Colors.red : Colors.green),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: _loanAmount > 0
                      ? (_totalRepaid / _loanAmount).clamp(0.0, 1.0)
                      : 0,
                  minHeight: 10,
                  backgroundColor: Colors.grey[200],
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${(_loanAmount > 0 ? (_totalRepaid / _loanAmount * 100).clamp(0, 100) : 0).toStringAsFixed(1)}% repaid",
                style: const TextStyle(
                    color: Colors.grey, fontSize: 12),
              ),
            ]),

            const SizedBox(height: 16),

        
            if (status.toLowerCase() == 'disbursed' ||
                status.toLowerCase() == 'approved')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RepaymentScreen(loanId: _loan['id']),
                      ),
                    );
                    _fetchRepayments();
                  },
                  icon: const Icon(Icons.payment,
                      color: Colors.white),
                  label: const Text("Make a Repayment",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                        const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),

            const SizedBox(height: 20),

          
            const Text("Repayment History",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
            const SizedBox(height: 10),

            _loadingRepayments
                ? const Center(
                    child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ))
                : _repayments.isEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            "No repayments made yet.",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    : Column(
                        children: _repayments.map((r) {
                          final rAmount =
                              r['amount']?.toString() ?? '0';
                          final rDate = r['created_at'] != null
                              ? r['created_at']
                                          .toString()
                                          .length >=
                                      10
                                  ? r['created_at']
                                      .toString()
                                      .substring(0, 10)
                                  : r['created_at'].toString()
                              : '-';
                          final method =
                              r['payment_method']?.toString() ??
                                  'N/A';
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12)),
                            margin:
                                const EdgeInsets.only(bottom: 10),
                            child: ListTile(
                              leading: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: Colors.green
                                      .withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check,
                                    color: Colors.green),
                              ),
                              title: Text(
                                  "UGX ${_formatAmount(rAmount)}",
                                  style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold)),
                              subtitle: Text(
                                  "$method  •  $rDate",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey)),
                              trailing: const Icon(
                                  Icons.receipt_long_outlined,
                                  color: Colors.grey),
                            ),
                          );
                        }).toList(),
                      ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, List<Widget> rows) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
            const Divider(height: 20),
            ...rows,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value,
      {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.grey, fontSize: 13)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: valueColor ?? Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmount(String amount) {
    try {
      final num = double.parse(amount);
      return num
          .toStringAsFixed(0)
          .replaceAllMapped(
              RegExp(r'(\d)(?=(\d{3})+$)'),
              (m) => '${m[1]},');
    } catch (_) {
      return amount;
    }
  }
}

