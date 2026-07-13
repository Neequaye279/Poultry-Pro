import 'package:flutter/material.dart';

class SegmentedTabs extends StatelessWidget {
  const SegmentedTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
    this.activeColors,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final List<Color>? activeColors;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final selected = selectedIndex == i;
          final activeColor = activeColors != null
              ? activeColors![i]
              : cs.primary;
          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(i),
              child: AnimatedContainer(
                height: 35,
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 9),
                decoration: BoxDecoration(
                  color: selected ? cs.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? activeColor : cs.scrim,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class FormFieldInput extends StatelessWidget {
  const FormFieldInput({
    super.key,
    this.label,
    required this.placeholder,
    this.icon,
    required this.controller,
    this.errorText,
    this.optional = false,
    this.keyboardType,
  });

  final String? label;
  final String placeholder;
  final IconData? icon;
  final TextEditingController controller;
  final String? errorText;
  final bool optional;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final hasValue = controller.text.isNotEmpty;
    final borderColor = errorText != null
        ? cs.error
        : hasValue
        ? cs.primary
        : cs.onSurface.withValues(alpha: 0.15);

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                optional ? '${label!} (optional)' : label!,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface.withValues(alpha: 0.7),
                  letterSpacing: 0.4,
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: cs.surface,
              border: Border.all(color: borderColor, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 15, color: hasValue ? cs.primary : cs.scrim),
                  const SizedBox(width: 9),
                ],
                Expanded(
                  child: TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    style: TextStyle(fontSize: 13, color: cs.onSurface),
                    decoration: InputDecoration(
                      hintText: placeholder,
                      hintStyle: TextStyle(color: cs.scrim),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 3),
              child: Text(
                errorText!,
                style: TextStyle(fontSize: 11, color: cs.error),
              ),
            ),
        ],
      ),
    );
  }
}

class FormFieldSelect extends StatelessWidget {
  const FormFieldSelect({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.icon,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: cs.onSurface.withValues(alpha: 0.7),
                letterSpacing: 0.4,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: cs.surface,
              border: Border.all(
                color: cs.onSurface.withValues(alpha: 0.15),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 15, color: cs.scrim),
                  const SizedBox(width: 9),
                ],
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: value,
                      isExpanded: true,
                      style: TextStyle(fontSize: 13, color: cs.onSurface),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: cs.scrim,
                      ),
                      items: options
                          .map(
                            (o) => DropdownMenuItem(value: o, child: Text(o)),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) onChanged(v);
                      },
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
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onTap,
    this.outline = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool outline;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: outline ? Colors.transparent : cs.primary,
            borderRadius: BorderRadius.circular(11),
            border: outline ? Border.all(color: cs.primary, width: 1.5) : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: outline ? cs.primary : cs.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
