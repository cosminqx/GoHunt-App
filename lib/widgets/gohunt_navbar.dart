import 'package:flutter/material.dart';

class GoHuntNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  const GoHuntNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1b271e), // schimbă aici dacă vrei exact ca în Figma
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), // poți reduce vertical dacă vrei
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarIcon(
            icon: Icons.home,
            selected: selectedIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavBarIcon(
            icon: Icons.card_giftcard,
            selected: selectedIndex == 1,
            onTap: () => onTap(1),
          ),
          _NavBarIcon(
            icon: Icons.qr_code,
            selected: selectedIndex == 2,
            onTap: () => onTap(2),
          ),
          _NavBarIcon(
            icon: Icons.emoji_events,
            selected: selectedIndex == 3,
            onTap: () => onTap(3),
          ),
          _NavBarIcon(
            icon: Icons.person,
            selected: selectedIndex == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _NavBarIcon({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: selected
                ? const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  )
                : null,
            padding: const EdgeInsets.all(6),
            child: Icon(
              icon,
              color: selected ? Colors.black : const Color(0xFFA2B3A6),
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}