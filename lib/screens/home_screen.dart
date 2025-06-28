import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../auth_service.dart';
import 'login_screen.dart';
import '../widgets/gohunt_navbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, this.clues = const []});
  final List clues;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = user?.displayName ?? 'Name';

    return Scaffold(
      backgroundColor: const Color(0xFF121613),
      appBar: AppBar(
        title: const Text('GoHunt'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Provider.of<AuthService>(context, listen: false).logout();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Top map & greeting
            SizedBox(
              height: 320,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    "https://lh3.googleusercontent.com/aida-public/AB6AXuCkg9Pu5VKgpYcd2LDblxKSIR6DzyUYW7rNHxtUmed-t-t5CKRAibiXRGMd8InKXmopWUGv080OEs8Fu2i4EBpLSUIGE_ydC41tUFPZ4mxUT0emXdFe548o7a490JGjthde4kvVWwMgy_k_2_VgRRL1b-l8yOqAnqopJo0x1SN3bMBirZw6UojfHagsIzJRBSDHizRV_3Bs2rHtWk2eMx6tS7CL3_YCOT046g4BTV0z5oH9w95BPk8FiqkrmNhWbQro52BlqEYI8Jlo",
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 16,
                    top: 48,
                    child: Text(
                      'Hello, $displayName!',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w800,
                        fontSize: 45,
                        color: Color(0xFF1F241F),
                        height: 1.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Missions Title
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text(
                "Missions",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                  letterSpacing: -0.015,
                ),
              ),
            ),
            // Missions List
            _MissionCard(
              title: "Urban Explorer Challenge",
              description: "Explore hidden gems in the city and earn rewards.",
              imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuAV08pQerTM6_FjImNeDWeQD7OGUTMm8TxJeaHV2bStcReGIJmc-VpNl1oQimA19lAfOKkdUdf2Mnm5StlRycy1Xd9rFnCZrlMo-XJtlbUmyJgvorWuZ7Vgp2A-WlJ5F-kvIA764YFQRmk4D55Qd_2tOc9HPrZxYFxWdEZPXeg_q3sBFXaI__Nvw9cAMtzlwyomYcIkI0s0mTo_TMpWMUCwlTD6kV6OdLby6BmnnJ06RoWw05TLhMpR3hkv_NoJicIa1AkvhqBgvRdf",
            ),
            _MissionCard(
              title: "Historical Landmarks Hunt",
              description: "Discover the city's rich history through its landmarks.",
              imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuCHEUpYRIXuYvEkOIvRa0uELpOUGRVI5-XJYVwwJdic0Ly1F6qUQbo70YETywqYsnYhLCkTsAxScOREFIOEr67VexdkHig-v1FBYeU7RvDtALPLBvo_APNejMU4iGqZQ4IdNhLwP5aGtJQxuPIia7hQahl33lfF_Kn-gP7pOd56cYU2WyDDz4u651T7Z3fYM2ZI9GE0r2Xec4HKj63rUTQFe-qGUbwK2fhHI0yTr3KeUXlnpFFVR09vhAW9tfLI63NgM7c1KrYOQP5n",
            ),
            _MissionCard(
              title: "Street Art Scavenger",
              description: "Find and photograph vibrant street art around the city.",
              imageUrl: "https://lh3.googleusercontent.com/aida-public/AB6AXuBJoC-9S6X3lf4g7n685bIeDJVns-YoJQHSWiTj-jzJRd-IDy_1Q2AqCFKX76tAa1PToIfY0oTfAoRDzuW9yV8J6m_CfNbs1QwkEhelCVAOTosRKxt626pbJ1Z92ahPYHGWL4idUvSl2nbS5di22z0O4mla-wJ86ry5mq8ZL4fnHQb4eXLeBVR2sVT4NR-Y0cPPrKQaIMNb3Hl6ukqqa0NluV5VF8AP21Z-_1FosQH2GAtqylIZaQggeAq3o5tr5f1VtjSbBg3iiz5f",
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: GoHuntNavBar(
        selectedIndex: 0,
        onTap: (index) {
          if (index == 4) {
            Navigator.pushNamed(context, '/profile');
          } else if (index == 0) {
            // already on home
          }
          // Adaugă navigare pentru celelalte indexuri dacă ai alte ecrane
        },
      ),
    );
  }
}


class _MissionCard extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  const _MissionCard({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                const SizedBox(height: 4),
                Text(description,
                    style: const TextStyle(
                        color: Color(0xFFA2B3A6),
                        fontSize: 13,
                        fontWeight: FontWeight.normal)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
