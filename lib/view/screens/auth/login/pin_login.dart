import 'package:flutter/material.dart';

class PinLoginScreen extends StatefulWidget {
  const PinLoginScreen({super.key});

  @override
  State<PinLoginScreen> createState() => _PinLoginScreenState();
}

class _PinLoginScreenState extends State<PinLoginScreen> {
  static const int pinLength = 4;
  String _pin = '';
  String? _errorText;

  void _onKeyTap(String value) {
    if (_pin.length >= pinLength) return;
    setState(() {
      _errorText = null;
      _pin += value;
    });

    if (_pin.length == pinLength) {
      _submitPin();
    }
  }

  void _onBackspace() {
    if (_pin.isEmpty) return;
    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
    });
  }

  void _submitPin() {
    // TODO: replace with real PIN verification
    const correctPin = '1234';

    if (_pin == correctPin) {
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      setState(() {
        _errorText = 'Incorrect PIN. Try again.';
        _pin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
            children: [
              const SizedBox(height: 8),

              // Back button
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),

              const Spacer(flex: 2),

              // Icon
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Icon(
                  Icons.lock_outline_rounded,
                  color: colorScheme.onPrimary,
                  size: 44,
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'Enter your PIN',
                style: textTheme.headlineSmall?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Enter your 4-digit PIN to continue',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 32),

              // PIN dots
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pinLength, (index) {
                  final filled = index < _pin.length;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled
                          ? colorScheme.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: filled
                            ? colorScheme.primary
                            : colorScheme.onSurface.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 16),

              SizedBox(
                height: 20,
                child: _errorText != null
                    ? Text(
                        _errorText!,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.error,
                        ),
                      )
                    : null,
              ),

              const Spacer(flex: 2),

              // Keypad
              _PinKeypad(
                onKeyTap: _onKeyTap,
                onBackspace: _onBackspace,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/paLogin');
                },
                child: Text(
                  'Use password instead',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                  ),
                ),
              ),

              const SizedBox(height: 12),
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
}

class _PinKeypad extends StatelessWidget {
  final ValueChanged<String> onKeyTap;
  final VoidCallback onBackspace;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _PinKeypad({
    required this.onKeyTap,
    required this.onBackspace,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
    ];

    return Column(
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row
                  .map((digit) => _KeypadButton(
                        label: digit,
                        onTap: () => onKeyTap(digit),
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ))
                  .toList(),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(width: 72, height: 72),
              _KeypadButton(
                label: '0',
                onTap: () => onKeyTap('0'),
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              _KeypadButton(
                icon: Icons.backspace_outlined,
                onTap: onBackspace,
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _KeypadButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _KeypadButton({
    this.label,
    this.icon,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 72,
          height: 72,
          child: Center(
            child: label != null
                ? Text(
                    label!,
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : Icon(
                    icon,
                    color: colorScheme.onSurface.withOpacity(0.7),
                    size: 26,
                  ),
          ),
        ),
      ),
    );
  }
}