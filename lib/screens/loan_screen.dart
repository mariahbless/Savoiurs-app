import 'package:flutter/material.dart';
import 'terms_screen.dart';

class LoanScreen extends StatefulWidget {
  const LoanScreen({super.key});

  @override
  State<LoanScreen> createState() => _LoanScreenState();
}

class _LoanScreenState extends State<LoanScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  int _selectedProduct = -1;

  final List<Map<String, dynamic>> loanProducts = [
    {
      "icon": Icons.person_rounded,
      "title": "Personal Loan",
      "limit": "Up to 50M",
      "desc": "Cover personal expenses with ease",
      "gradient": [Color(0xFF0057D9), Color(0xFF0A84FF)],
    },
    {
      "icon": Icons.business_center_rounded,
      "title": "Business Loan",
      "limit": "Up to 50M",
      "desc": "Fuel your business growth",
      "gradient": [Color(0xFF00897B), Color(0xFF26C6DA)],
    },
    {
      "icon": Icons.school_rounded,
      "title": "School Fees Loan",
      "limit": "Up to 30M",
      "desc": "Invest in quality education",
      "gradient": [Color(0xFFF57C00), Color(0xFFFFCA28)],
    },
    {
      "icon": Icons.home_work_rounded,
      "title": "Land Title Loan",
      "limit": "Up to 50M",
      "desc": "Leverage your property assets",
      "gradient": [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
    },
  ];

  final List<Map<String, dynamic>> benefits = [
    {"icon": Icons.flash_on_rounded, "text": "Instant Decision"},
    {"icon": Icons.percent_rounded, "text": "Low Rates"},
    {"icon": Icons.shield_rounded, "text": "100% Secure"},
    {"icon": Icons.support_agent_rounded, "text": "24/7 Support"},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: CustomScrollView(
        slivers: [
         
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: const Color(0xFF0057D9),
            foregroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroHeader(),
            ),
            title: const Text(
              "Loan Products",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            centerTitle: true,
          ),

       
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                     
                      _buildBenefitsRow(),

                      const SizedBox(height: 28),

                  
                      _buildSectionTitle("Choose a Loan Type"),

                      const SizedBox(height: 16),

                      
                      ...loanProducts.asMap().entries.map((entry) {
                        return _buildLoanCard(entry.key, entry.value);
                      }),

                      const SizedBox(height: 10),

                    
                      _buildEligibilityBanner(),

                      const SizedBox(height: 28),

                     
                      _buildSectionTitle("Requirements"),
                      const SizedBox(height: 14),
                      _buildRequirements(),

                      const SizedBox(height: 28),

                     
                      _buildApplyButton(context),

                      const SizedBox(height: 12),

                     
                      Center(
                        child: Text(
                          "By applying, you agree to our Terms & Conditions.",
                          style: TextStyle(
                              fontSize: 12, color: const Color.fromARGB(255, 12, 1, 1)),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      const SizedBox(height: 30),
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

  
  Widget _buildHeroHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0035A0), Color(0xFF0A84FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
       
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
       
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 70, 22, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "🟢  No Active Loans",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "UGX 50,000,000",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Maximum eligible amount",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBenefitsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: benefits.map((b) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0A84FF).withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Icon(b["icon"] as IconData,
                  color: const Color(0xFF0057D9), size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              b["text"] as String,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0D1B40),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

 
  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: const Color(0xFF0A84FF),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D1B40),
          ),
        ),
      ],
    );
  }


  Widget _buildLoanCard(int index, Map<String, dynamic> product) {
    final bool isSelected = _selectedProduct == index;
    final List<Color> gradientColors =
        (product["gradient"] as List).cast<Color>();

    return GestureDetector(
      onTap: () => setState(() =>
          _selectedProduct = isSelected ? -1 : index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? gradientColors[0]
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? gradientColors[0].withOpacity(0.25)
                  : Colors.black.withOpacity(0.07),
              blurRadius: isSelected ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
             
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(product["icon"] as IconData,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
            
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product["title"] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0D1B40),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      product["desc"] as String,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
           
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: gradientColors[0].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      product["limit"] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: gradientColors[0],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Icon(
                    isSelected
                        ? Icons.check_circle_rounded
                        : Icons.chevron_right_rounded,
                    color: isSelected
                        ? gradientColors[0]
                        : Colors.grey.shade400,
                    size: 22,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

 
  Widget _buildEligibilityBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF0057D9).withOpacity(0.08),
            const Color(0xFF0A84FF).withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF0A84FF).withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0A84FF).withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified_rounded,
                color: Color(0xFF0057D9), size: 22),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You're Pre-Qualified!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF0D1B40),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  "Based on your profile, you qualify for up to UGX 50M.",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

   
  Widget _buildRequirements() {
    final reqs = [
      {"icon": Icons.badge_rounded, "text": "Valid National ID"},
      {"icon": Icons.receipt_long_rounded, "text": "Proof of Income / Pay Slip"},
      {"icon": Icons.account_balance_rounded, "text": "Bank Statement (3 months)"},
      {"icon": Icons.home_rounded, "text": "Proof of Residence"},
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, blurRadius: 8, offset: Offset(0, 3))
        ],
      ),
      child: Column(
        children: reqs.asMap().entries.map((entry) {
          bool isLast = entry.key == reqs.length - 1;
          var req = entry.value;
          return Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A84FF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(req["icon"] as IconData,
                        color: const Color(0xFF0057D9), size: 18),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    req["text"] as String,
                    style: const TextStyle(
                        fontSize: 14, color: Color(0xFF0D1B40)),
                  ),
                  const Spacer(),
                  const Icon(Icons.check_rounded,
                      color: Color(0xFF30D158), size: 18),
                ],
              ),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: Colors.grey.shade100, height: 1),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

 
  Widget _buildApplyButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0035A0), Color(0xFF0A84FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0057D9).withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const TermsAndConditionsScreen()),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.attach_money_rounded, color: Colors.white, size: 22),
              SizedBox(width: 8),
              Text(
                "Apply for a Loan",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.4,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}