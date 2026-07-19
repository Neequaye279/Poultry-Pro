import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Preset FAQ data. Swap this out later for content pulled from a CMS
/// or Supabase table if you want it editable without a redeploy.
class _FaqItem {
  final String question;
  final String answer;
  const _FaqItem(this.question, this.answer);
}

const List<_FaqItem> _faqItems = [
  _FaqItem(
    'How do I back up my farm data?',
    'Go to Settings > Data > Backup to Cloud. Your profile, flock records, '
        'and logs are securely uploaded to your account. You can restore '
        'them any time by signing in on a new device.',
  ),
  _FaqItem(
    'Is my data safe if I lose my phone?',
    'Yes, as long as you have backed up at least once. Sign in with the '
        'same account on a new device and your most recent backup will be '
        'restored automatically.',
  ),
  _FaqItem(
    'How do I change my PIN?',
    'Go to Settings > Account > Change PIN. You will need to enter your '
        'current PIN before setting a new one.',
  ),
  _FaqItem(
    'Can I use the app without an internet connection?',
    'Yes. All your records are saved locally first, so you can keep '
        'working offline. Backup to Cloud requires an internet connection '
        'to sync your data.',
  ),
  _FaqItem(
    'How do I turn off notifications?',
    'Go to Settings > Preferences and toggle Notifications off.',
  ),
  _FaqItem(
    'How do I switch between light and dark mode?',
    'Go to Settings > Preferences > Appearance and choose Light, Dark, or '
        'System default.',
  ),
  _FaqItem(
    'Who can see my farm data?',
    'Only you. Your data is tied to your account and is not shared with '
        'other users of the app.',
  ),
];

class HelpFaqScreen extends StatefulWidget {
  const HelpFaqScreen({super.key});

  @override
  State<HelpFaqScreen> createState() => _HelpFaqScreenState();
}

class _HelpFaqScreenState extends State<HelpFaqScreen> {
  int? _expandedIndex;

  void _toggle(int index) {
    setState(() {
      _expandedIndex = _expandedIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header, styled to match the Settings screen header.
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: 1.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(color: colors.scrim.withValues(alpha: 0.5)),
                  SizedBox(height: screenHeight * 0.03),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.02,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            LucideIcons.arrowLeft,
                            color: colors.onSurface,
                          ),
                        ),
                        Container(
                          height: 35,
                          width: 35,
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            LucideIcons.circleHelp,
                            size: 17,
                            color: colors.primary,
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Help & FAQ',
                              style: TextStyle(
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                                color: colors.onSurface,
                              ),
                            ),
                            Text(
                              'Answers to common questions',
                              style: TextStyle(
                                fontSize: 14,
                                color: colors.scrim,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.06,
                  vertical: screenHeight * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FREQUENTLY ASKED QUESTIONS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: colors.scrim,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...List.generate(_faqItems.length, (index) {
                      final item = _faqItems[index];
                      final isOpen = _expandedIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(14),
                                onTap: () => _toggle(index),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.question,
                                          style: TextStyle(
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w600,
                                            color: colors.onSurface,
                                          ),
                                        ),
                                      ),
                                      AnimatedRotation(
                                        turns: isOpen ? 0.5 : 0,
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        child: Icon(
                                          LucideIcons.chevronDown,
                                          size: 18,
                                          color: colors.scrim,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              AnimatedCrossFade(
                                firstChild: const SizedBox(
                                  width: double.infinity,
                                ),
                                secondChild: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    0,
                                    16,
                                    16,
                                  ),
                                  child: Text(
                                    item.answer,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      height: 1.4,
                                      color: colors.onSurface.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                  ),
                                ),
                                crossFadeState: isOpen
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                duration: const Duration(milliseconds: 200),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                    Text(
                      'STILL NEED HELP?',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: colors.scrim,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Support',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: colors.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Reach out and we\'ll get back to you within '
                            '1-2 business days.',
                            style: TextStyle(
                              fontSize: 13,
                              color: colors.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _ContactRow(
                            icon: LucideIcons.mail,
                            label: 'eliakimrobertzekey@gmail.com',
                          ),
                          const SizedBox(height: 10),
                          _ContactRow(
                            icon: LucideIcons.phone,
                            label: '+233 20 000 0000',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ContactRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 16, color: colors.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: colors.onSurface,
          ),
        ),
      ],
    );
  }
}
