import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/gohunt_navbar.dart';

class UserInfoScreen extends StatelessWidget {
  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    // Fallback dacă nu există displayName sau email
    final displayName = user?.displayName ?? 'User';
    final username = user?.email != null
        ? '@${user!.email!.split('@').first}'
        : '@username';

    return Scaffold(
      backgroundColor: const Color(0xFF111812),
      appBar: AppBar(
        backgroundColor: const Color(0xFF111812),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: -0.015,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          // Avatar & Info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              children: [
                // Avatar
                Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : const NetworkImage(
                              "https://lh3.googleusercontent.com/aida-public/AB6AXuBbpeXIq3c-E_noyV_YRT17j8siAwPoOEvTRehVv8FNcrxHOftyN0rIKEr-gRtDjnNFFXEW2xBXbSBbgOvnMDhpuBv2XFgrC_cnNHHlWqH0tUucmUcrWboVuHLk2wCfPX9AcD1PzkmKpvikyYuorL6d9K1qfYzQqc05ej9ED4GTue23XKhcMAtRTLa4BJnX0gDhV-gfU_n6blLyXu_nNpf4rFYvb3NmajpmTt0VyhqeDXtm0zrNxFKbJnePKRshOlRsNz9uyHDNaZDT",
                            ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Name, username, joined
                Text(
                  displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: -0.015,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  username,
                  style: const TextStyle(
                    color: Color(0xFF9bbba2),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  user?.metadata.creationTime != null
                      ? "Joined ${user!.metadata.creationTime!.year}"
                      : "Joined",
                  style: const TextStyle(
                    color: Color(0xFF9bbba2),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Edit Profile Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF273a2b),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        letterSpacing: 0.015,
                      ),
                      minimumSize: const Size(84, 40),
                    ),
                    onPressed: () {},
                    child: const Text("Edit Profile"),
                  ),
                ),
              ],
            ),
          ),
          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _StatCard(label: "Hunts", value: "12"),
                const SizedBox(width: 8),
                _StatCard(label: "Challenges", value: "34"),
                const SizedBox(width: 8),
                _StatCard(label: "Points", value: "56"),
              ],
            ),
          ),
          // Recent Activity Title
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              "Recent Activity",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                letterSpacing: -0.015,
              ),
            ),
          ),
          // Recent Activity List
          _ActivityTile(
            icon: Icons.emoji_events,
            bgColor: Color(0xFF273a2b),
            title: "Urban Art Hunt",
            subtitle: "Completed",
            time: "2d",
          ),
          _ActivityTile(
            icon: Icons.emoji_events,
            bgColor: Color(0xFF273a2b),
            title: "Hidden Gems of Downtown",
            subtitle: "Completed",
            time: "1w",
          ),
          _ActivityTile(
            icon: Icons.location_on,
            bgColor: Color(0xFF273a2b),
            title: "Historic Landmarks Challenge",
            subtitle: "In Progress",
            time: "2w",
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: GoHuntNavBar(
        selectedIndex: 4,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (index == 4) {
            // deja pe profil, nu face nimic
          }
          // Adaugă navigare pentru celelalte indexuri dacă ai alte ecrane
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: const Color(0xFF3a5540)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF9bbba2),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final String title;
  final String subtitle;
  final String time;
  const _ActivityTile({
    required this.icon,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
      decoration: const BoxDecoration(
        color: Color(0xFF111812),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF9bbba2),
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: const TextStyle(
              color: Color(0xFF9bbba2),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}