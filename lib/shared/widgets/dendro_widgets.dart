import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/dendro_theme.dart';
import '../../core/constants/dendro_assets.dart';

class DendroScreen extends StatelessWidget {
  const DendroScreen({
    required this.title,
    required this.icon,
    required this.children,
    this.floatingActionButton,
    this.showBackButton,
    this.onBack,
    super.key,
  });

  final String title;
  final IconData icon;
  final List<Widget> children;
  final Widget? floatingActionButton;
  final bool? showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final shouldShowBackButton =
        showBackButton ?? Navigator.of(context).canPop();

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
              DendroHeader(
                title: title,
                icon: icon,
                showBackButton: shouldShowBackButton,
                onBack: onBack,
              ),
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
  const DendroHeader({
    required this.title,
    required this.icon,
    this.showBackButton = false,
    this.onBack,
    super.key,
  });

  final String title;
  final IconData icon;
  final bool showBackButton;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        if (showBackButton)
          SizedBox(
            width: 38,
            height: 38,
            child: IconButton(
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Voltar',
              style: IconButton.styleFrom(
                backgroundColor: DendroColors.primarySoft,
                foregroundColor: DendroColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          )
        else
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

class PlotDimensionsInput extends StatelessWidget {
  const PlotDimensionsInput({
    required this.widthController,
    required this.lengthController,
    this.widthValidator,
    this.lengthValidator,
    super.key,
  });

  final TextEditingController widthController;
  final TextEditingController lengthController;
  final String? Function(String?)? widthValidator;
  final String? Function(String?)? lengthValidator;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final inputFormatters = [
      FilteringTextInputFormatter.allow(RegExp('[0-9,.]')),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 13),
          child: Text(
            'Parcela:',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            controller: widthController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.next,
            inputFormatters: inputFormatters,
            decoration: const InputDecoration(
              hintText: 'X',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
            ),
            validator: widthValidator,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8).copyWith(top: 13),
          child: Text(
            'x',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Expanded(
          child: TextFormField(
            controller: lengthController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.next,
            inputFormatters: inputFormatters,
            decoration: const InputDecoration(
              hintText: 'X',
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 12,
              ),
            ),
            validator: lengthValidator,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8, top: 13),
          child: Text(
            'm',
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
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
    final rawBackground = backgroundColor ?? theme.cardColor;
    final resolvedBackground = _cardBackgroundForTheme(
      rawBackground,
      theme.brightness,
    );
    final lightBackground =
        ThemeData.estimateBrightnessForColor(resolvedBackground) ==
        Brightness.light;
    final foregroundColor = lightBackground ? DendroColors.text : Colors.white;
    final usesReadableCard =
        resolvedBackground == DendroColors.darkReadableCard ||
        resolvedBackground == DendroColors.darkReadableCardHighlight;
    final inputTheme = DendroTheme.light.inputDecorationTheme.copyWith(
      fillColor: usesReadableCard ? DendroColors.darkReadableField : null,
      labelStyle: const TextStyle(
        color: DendroColors.textMuted,
        fontWeight: FontWeight.w700,
      ),
      hintStyle: const TextStyle(color: DendroColors.textMuted),
      prefixIconColor: DendroColors.primary,
      suffixIconColor: DendroColors.primary,
    );

    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: resolvedBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              borderColor ??
              (usesReadableCard
                  ? DendroColors.darkReadableBorder
                  : DendroColors.outline),
        ),
      ),
      child: Theme(
        data: lightBackground
            ? theme.copyWith(
                colorScheme: DendroTheme.light.colorScheme,
                textTheme: theme.textTheme.apply(
                  bodyColor: DendroColors.text,
                  displayColor: DendroColors.text,
                ),
                primaryTextTheme: theme.primaryTextTheme.apply(
                  bodyColor: DendroColors.text,
                  displayColor: DendroColors.text,
                ),
                inputDecorationTheme: inputTheme,
                iconButtonTheme: IconButtonThemeData(
                  style: IconButton.styleFrom(
                    foregroundColor: DendroColors.primary,
                  ),
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: DendroColors.primary,
                    textStyle: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
                outlinedButtonTheme: OutlinedButtonThemeData(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: DendroColors.primary,
                    side: const BorderSide(color: DendroColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                listTileTheme: theme.listTileTheme.copyWith(
                  textColor: DendroColors.text,
                  iconColor: DendroColors.textMuted,
                  titleTextStyle: const TextStyle(
                    color: DendroColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  subtitleTextStyle: const TextStyle(
                    color: DendroColors.textMuted,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            : theme,
        child: DefaultTextStyle.merge(
          style: TextStyle(color: foregroundColor),
          child: IconTheme.merge(
            data: IconThemeData(
              color: lightBackground ? DendroColors.textMuted : Colors.white,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Color _cardBackgroundForTheme(Color color, Brightness brightness) {
    if (brightness != Brightness.dark) return color;
    if (color == DendroColors.darkReadableCard ||
        color == DendroColors.darkReadableCardHighlight ||
        color == DendroColors.darkReadableField) {
      return color;
    }
    if (ThemeData.estimateBrightnessForColor(color) == Brightness.dark) {
      return color;
    }
    if (color == DendroColors.primarySoft ||
        color == const Color(0xFFE0F2E8) ||
        color == const Color(0xFFEAF7EF)) {
      return DendroColors.darkReadableCardHighlight;
    }
    return DendroColors.darkReadableCard;
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
    final resolvedColor = _backgroundForTheme(
      color,
      Theme.of(context).brightness,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: resolvedColor,
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

  Color _backgroundForTheme(Color color, Brightness brightness) {
    if (brightness != Brightness.dark) return color;
    if (color == DendroColors.darkReadableField ||
        color == DendroColors.darkReadableCard ||
        color == DendroColors.darkReadableCardHighlight) {
      return color;
    }
    if (ThemeData.estimateBrightnessForColor(color) == Brightness.dark) {
      return color;
    }
    return DendroColors.darkReadableField;
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
