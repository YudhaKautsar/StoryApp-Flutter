import 'package:flutter/material.dart';

import '../core/session_controller.dart';
import 'generated/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({required this.session, super.key});

  final SessionController session;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    return PopupMenuButton<String>(
      tooltip: strings.language,
      icon: const Icon(Icons.language_rounded),
      onSelected: session.changeLanguage,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'id',
          child: _LanguageOption(
            label: strings.languageIndonesian,
            selected: session.languageCode == 'id',
          ),
        ),
        PopupMenuItem(
          value: 'en',
          child: _LanguageOption(
            label: strings.languageEnglish,
            selected: session.languageCode == 'en',
          ),
        ),
      ],
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 24,
          child: selected ? const Icon(Icons.check_rounded, size: 18) : null,
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
