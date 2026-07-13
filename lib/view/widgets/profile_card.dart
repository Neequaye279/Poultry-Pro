import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class ProfileCard extends StatelessWidget {
  final String farmer;
  final String farm;
  final VoidCallback onTap;
  final bool isEditing;
  const ProfileCard({
    super.key,
    required this.farm,
    required this.farmer,
    required this.onTap,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 55.0,
            width: 55.0,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Center(
              child: Icon(LucideIcons.idCard, color: Colors.white, size: 35.0),
            ),
          ),
          SizedBox(width: 10.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                farmer,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                farm,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.0,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 35.0,
              width: 35.0,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(11.0),
              ),
              child: Icon(
                isEditing ? LucideIcons.x : LucideIcons.squarePen,
                color: Colors.white,
                size: 17.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
