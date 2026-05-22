
import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final List<Map<String, dynamic>> coreValues = [
    {"icon": Icons.security_rounded, "title": "Integrity", "color": Color(0xFF0057D9)},
    {"icon": Icons.thumb_up_rounded, "title": "Excellence", "color": Color(0xFF00897B)},
    {"icon": Icons.group_rounded, "title": "Teamwork", "color": Color(0xFFF57C00)},
    {"icon": Icons.lightbulb_rounded, "title": "Innovation", "color": Color(0xFF6A1B9A)},
  ];

  final List<Map<String, String>> stats = [
    {"value": "1,200+", "label": "Clients Served", "icon": "👥"},
    {"value": "1,000+", "label": "Loans Disbursed", "icon": "💰"},
    {"value": "24 hrs", "label": "Approval Time", "icon": "⚡"},
    {"value": "1", "label": "Branch", "icon": "🏢"},
  ];

  final List<Map<String, dynamic>> contactItems = [
    {"icon": Icons.phone_rounded, "label": "Phone", "value": "+256 783 519 023", "color": Color(0xFF0057D9)},
    {"icon": Icons.email_rounded, "label": "Email", "value": "saviours@gmail.com", "color": Color(0xFF00897B)},
    {"icon": Icons.location_on_rounded, "label": "Address", "value": "Plot 123, Ntinda - Kampala", "color": Color(0xFFFF375F)},
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.1),
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
          // ─────────── SLIVER HERO ───────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: const Color(0xFF0057D9),
            foregroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              "About Us",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroHeader(),
            ),
          ),

          // ─────────── BODY ───────────
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
                      // ── MISSION CARD ──
                      _buildMissionCard(),

                      const SizedBox(height: 28),

                      // ── CORE VALUES ──
                      _buildSectionTitle("Our Core Values"),
                      const SizedBox(height: 16),
                      _buildCoreValues(),

                      const SizedBox(height: 28),

                      // ── STATS ──
                      _buildSectionTitle("Our Achievements"),
                      const SizedBox(height: 16),
                      _buildStatsGrid(),

                      const SizedBox(height: 28),

                      // ── WHY US ──
                      _buildSectionTitle("Why Choose Us"),
                      const SizedBox(height: 16),
                      _buildWhyUs(),

                      const SizedBox(height: 28),

                      // ── CONTACT ──
                      _buildSectionTitle("Get In Touch"),
                      const SizedBox(height: 16),
                      _buildContactSection(),

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
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
    child: Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        // Decorative circles
        Positioned(
          top: -40, right: -40,
          child: Container(
            width: 160, height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.07),
            ),
          ),
        ),
        Positioned(
          bottom: -30, left: -30,
          child: Container(
            width: 120, height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.07),
            ),
          ),
        ),
        Positioned(
          top: 60, left: 40,
          child: Container(
            width: 70, height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),

        // Content — fully centered
        Positioned.fill(
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Image.asset(
                      'assets/savlogo.jpg',
                      height: 48,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Title
                  const Text(
                    "Saviours Finance Int LTD",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Pills row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _heroPill(" Finance"),
                      const SizedBox(width: 8),
                      _heroPill(" Kampala"),
                      const SizedBox(width: 8),
                      _heroPill(" Licensed"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
  Widget _heroPill(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Text(label,
          style: const TextStyle(color: Colors.white, fontSize: 12)),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4, height: 20,
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

  Widget _buildMissionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A84FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.flag_rounded,
                    color: Color(0xFF0057D9), size: 22),
              ),
              const SizedBox(width: 12),
              const Text(
                "Our Mission",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D1B40),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            "Saviours Finance Int LTD is dedicated to providing fast, safe, and reliable financial solutions to individuals and businesses. "
            "Our mission is to empower our clients with flexible loans tailored to their needs, helping them achieve their financial goals.",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0057D9).withOpacity(0.08),
                  const Color(0xFF0A84FF).withOpacity(0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF0A84FF).withOpacity(0.2)),
            ),
            child: Row(
              children: const [
                Icon(Icons.format_quote_rounded,
                    color: Color(0xFF0057D9), size: 22),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Empowering lives through accessible finance.",
                    style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF0057D9),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCoreValues() {
  return GridView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: coreValues.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.4,
    ),
    itemBuilder: (context, index) {
      final item = coreValues[index];
      final color = item["color"] as Color;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // Icon Container
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    item["icon"] as IconData,
                    color: color,
                    size: 26,
                  ),
                ),

                const SizedBox(height: 12),

                // Title
                Text(
                  item["title"] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D1B40),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
  Widget _buildStatsGrid() {
  return GridView.builder(
    physics: const NeverScrollableScrollPhysics(),
    shrinkWrap: true,
    itemCount: stats.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,

      // Increased height slightly to avoid overflow
      childAspectRatio: 1.3,
    ),
    itemBuilder: (context, index) {
      final stat = stats[index];

      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFF0057D9),
              Color(0xFF0A84FF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0057D9).withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [

              // Icon
              Text(
                stat["icon"]!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),

              const SizedBox(height: 8),

              // Value
              Text(
                stat["value"]!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 4),

              // Label
              Text(
                stat["label"]!,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
  Widget _buildWhyUs() {
    final points = [
      {"icon": Icons.verified_rounded, "title": "Fully Licensed", "desc": "Regulated and trusted financial institution"},
      {"icon": Icons.speed_rounded, "title": "Fast Turnaround", "desc": "Loan decisions within 24 hours"},
      {"icon": Icons.handshake_rounded, "title": "Client First", "desc": "Flexible terms designed around you"},
      {"icon": Icons.lock_rounded, "title": "Data Privacy", "desc": "Your information is always protected"},
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: points.asMap().entries.map((entry) {
          bool isLast = entry.key == points.length - 1;
          final p = entry.value;
          return Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A84FF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(p["icon"] as IconData,
                        color: const Color(0xFF0057D9), size: 18),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p["title"] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0D1B40),
                          ),
                        ),
                        Text(
                          p["desc"] as String,
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black45),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.check_circle_rounded,
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

  Widget _buildContactSection() {
    return Column(
      children: contactItems.map((item) {
        final color = item["color"] as Color;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item["icon"] as IconData, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item["label"] as String,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black45),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item["value"] as String,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D1B40),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(Icons.arrow_forward_ios_rounded,
                  color: Colors.grey.shade300, size: 16),
            ],
          ),
        );
      }).toList(),
    );
  }
}