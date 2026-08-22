import 'package:flutter/material.dart';

import '../../app/theme/dendro_theme.dart';
import '../../core/constants/dendro_assets.dart';

class DendroScreen extends StatelessWidget {
  const DendroScreen({
    required this.title,
    required this.icon,
    required this.children,
    this.floatingActionButton,
    super.key,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(
              16,
              14,
              16,
              floatingActionButton == null ? 24 : 96,
            ),
            children: [
              DendroHeader(title: title, icon: icon),
              const SizedBox(height: 20),
              ...children,
            ],
          ),
          if (floatingActionButton != null)
            Positioned(right: 16, bottom: 16, child: floatingActionButton!),
        ],
      ),
    );
  }
}

class DendroHeader extends StatelessWidget {
  const DendroHeader({required this.title, required this.icon, super.key});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: DendroColors.primarySoft,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: DendroColors.primary, size: 22),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ).copyWith(color: colorScheme.onSurface),
          ),
        ),
        const SizedBox(width: 10),
        const DendroLogoMark(),
      ],
    );
  }
}

class DendroLogoMark extends StatelessWidget {
  const DendroLogoMark({this.size = 34, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        DendroAssets.logo,
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}

class DendroCard extends StatelessWidget {
  const DendroCard({
    required this.child,
    this.backgroundColor,
    this.borderColor,
    this.padding = const EdgeInsets.all(14),
    super.key,
  });

  final Widget child;
  final Color? backgroundColor;
  final Color? borderColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor ?? DendroColors.outline),
      ),
      child: child,
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({required this.title, this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
              ).copyWith(color: colorScheme.onSurface),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill({
    required this.label,
    this.color = DendroColors.primarySoft,
    this.textColor = DendroColors.primary,
    super.key,
  });

  final String label;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 11,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class MetricTile extends StatelessWidget {
  const MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    super.key,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DendroCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 19, color: DendroColors.secondary),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: DendroColors.textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: DendroColors.text,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
