import 'package:flutter/material.dart';

class ChangePinContent extends StatefulWidget {
  final VoidCallback onCancel;
  final void Function(String currentPin, String newPin) onSave;

  const ChangePinContent({
    super.key,
    required this.onCancel,
    required this.onSave,
  });

  @override
  State<ChangePinContent> createState() => _ChangePinContentState();
}

class _ChangePinContentState extends State<ChangePinContent> {
  late TextEditingController _currentPinController;
  late TextEditingController _newPinController;
  late TextEditingController _confirmPinController;

  String? _currentPinError;
  String? _newPinError;
  String? _confirmPinError;

  @override
  void initState() {
    super.initState();
    _currentPinController = TextEditingController();
    _newPinController = TextEditingController();
    _confirmPinController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _savePin() {
    final currentPin = _currentPinController.text.trim();
    final newPin = _newPinController.text.trim();
    final confirmPin = _confirmPinController.text.trim();

    String? currentPinError;
    String? newPinError;
    String? confirmPinError;

    if (currentPin.isEmpty) {
      currentPinError = 'Current PIN is required';
    } else if (currentPin.length != 6) {
      currentPinError = 'PIN must be 6 digits';
    }

    if (newPin.isEmpty) {
      newPinError = 'New PIN is required';
    } else if (newPin.length != 6) {
      newPinError = 'PIN must be 6 digits';
    } else if (!RegExp(r'^\d{6}$').hasMatch(newPin)) {
      newPinError = 'PIN must contain only numbers';
    }

    if (confirmPin.isEmpty) {
      confirmPinError = 'Please confirm your PIN';
    } else if (newPinError == null && confirmPin != newPin) {
      confirmPinError = 'PINs do not match';
    }

    setState(() {
      _currentPinError = currentPinError;
      _newPinError = newPinError;
      _confirmPinError = confirmPinError;
    });

    if (currentPinError != null ||
        newPinError != null ||
        confirmPinError != null) {
      return;
    }

    widget.onSave(currentPin, newPin);
    _currentPinController.clear();
    _newPinController.clear();
    _confirmPinController.clear();
  }

  void _cancel() {
    _currentPinController.clear();
    _newPinController.clear();
    _confirmPinController.clear();
    setState(() {
      _currentPinError = null;
      _newPinError = null;
      _confirmPinError = null;
    });
    widget.onCancel();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel('Current PIN'),
        const SizedBox(height: 6),
        _PinField(
          controller: _currentPinController,
          errorText: _currentPinError,
          colors: colors,
        ),
        const SizedBox(height: 16),
        _FieldLabel('New PIN'),
        const SizedBox(height: 6),
        _PinField(
          controller: _newPinController,
          errorText: _newPinError,
          colors: colors,
        ),
        const SizedBox(height: 16),
        _FieldLabel('Confirm New PIN'),
        const SizedBox(height: 6),
        _PinField(
          controller: _confirmPinController,
          errorText: _confirmPinError,
          colors: colors,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _cancel,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colors.primary,
                  side: BorderSide(color: colors.primary, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: _savePin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

class _PinField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final ColorScheme colors;

  const _PinField({
    required this.controller,
    required this.errorText,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      keyboardType: TextInputType.number,
      maxLength: 6,
      style: TextStyle(color: colors.onSurface),
      decoration: InputDecoration(
        counterText: '',
        errorText: errorText,
        filled: true,
        fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.3),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colors.onSurface.withValues(alpha: 0.1),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: colors.onSurface.withValues(alpha: 0.1),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.error),
        ),
      ),
    );
  }
}
