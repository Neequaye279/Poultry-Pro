import 'package:flutter/material.dart';

class SecurityMethodToggle extends StatelessWidget {
  const SecurityMethodToggle({
    super.key,
    required this.isPinSelected,
    required this.onSelectPin,
    required this.onSelectPassword,
  });

  final bool isPinSelected;
  final VoidCallback onSelectPin;
  final VoidCallback onSelectPassword;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      height: 54,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.onSurface.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _SecurityMethodItem(
            icon: Icons.tag,
            text: "PIN",
            selected: isPinSelected,
            onTap: onSelectPin,
          ),
          _SecurityMethodItem(
            icon: Icons.key,
            text: "Password",
            selected: !isPinSelected,
            onTap: onSelectPassword,
          ),
        ],
      ),
    );
  }
}

class _SecurityMethodItem extends StatelessWidget {
  const _SecurityMethodItem({
    required this.icon,
    required this.text,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final color = selected
        ? colors.primary
        : colors.onSurface.withValues(alpha: 0.34);

    return Expanded(
      child: GestureDetector(
        onTap: selected ? null : onTap,
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: selected ? colors.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: colors.onSurface.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(color: color, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
