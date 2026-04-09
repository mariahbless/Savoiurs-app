
import 'package:flutter/material.dart';
import 'loan_service.dart';
import 'loan_detail_screen.dart';

class LoanDashboardScreen extends StatefulWidget {
  const LoanDashboardScreen({super.key});

  @override
  State<LoanDashboardScreen> createState() => _LoanDashboardScreenState();
}

class _LoanDashboardScreenState extends State<LoanDashboardScreen> {
  List<dynamic> _loans = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchLoans();
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
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load loans. Please try again.';
        _loading = false;
      });
    }
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Colors.red, size: 60),
                      const SizedBox(height: 12),
                      Text(_error!,
                          style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: _fetchLoans,
                          child: const Text("Retry")),
                    ],
                  ),
                )
              : _loans.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_outlined,
                              size: 80, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          const Text(
                            "No loan applications yet.",
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _fetchLoans,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _loans.length,
                        itemBuilder: (context, index) {
                          final loan = _loans[index];
                          final status =
                              (loan['status'] ?? 'pending').toString();
                          final amount =
                              loan['amount']?.toString() ?? '0';
                          final purpose =
                              loan['description'] ?? 'Loan Application';
                          final date = loan['created_at'] != null
                              ? loan['created_at']
                                  .toString()
                                  .substring(0, 10)
                              : '';

                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14)),
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 14),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LoanDetailScreen(loan: loan),
                                  ),
                                );
                                _fetchLoans(); // Refresh after returning
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Status icon circle
                                    Container(
                                      width: 52,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        color: _statusColor(status)
                                            .withOpacity(0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        _statusIcon(status),
                                        color: _statusColor(status),
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    // Loan info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            purpose,
                                            style: const TextStyle(
                                                fontWeight:
                                                    FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "UGX ${_formatAmount(amount)}",
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                fontWeight:
                                                    FontWeight.w600),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            date,
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Status badge
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: _statusColor(status)
                                            .withOpacity(0.15),
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        border: Border.all(
                                            color: _statusColor(status),
                                            width: 1),
                                      ),
                                      child: Text(
                                        status.toUpperCase(),
                                        style: TextStyle(
                                          color: _statusColor(status),
                                          fontSize: 11,
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
                    ),
    );
  }

  String _formatAmount(String amount) {
    try {
      final num = double.parse(amount);
      return num
          .toStringAsFixed(0)
          .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'),
              (m) => '${m[1]},');
    } catch (_) {
      return amount;
    }
  }
}