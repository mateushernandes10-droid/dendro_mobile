---
name: Arbor Tech System
colors:
  surface: '#f9f9f8'
  surface-dim: '#d9dad9'
  surface-bright: '#f9f9f8'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f3f4f3'
  surface-container: '#edeeed'
  surface-container-high: '#e7e8e7'
  surface-container-highest: '#e1e3e2'
  on-surface: '#191c1c'
  on-surface-variant: '#414844'
  inverse-surface: '#2e3131'
  inverse-on-surface: '#f0f1f0'
  outline: '#717973'
  outline-variant: '#c1c8c2'
  surface-tint: '#3f6653'
  primary: '#012d1d'
  on-primary: '#ffffff'
  primary-container: '#1b4332'
  on-primary-container: '#86af99'
  inverse-primary: '#a5d0b9'
  secondary: '#3e6750'
  on-secondary: '#ffffff'
  secondary-container: '#bdeacd'
  on-secondary-container: '#426b54'
  tertiary: '#002d1b'
  on-tertiary: '#ffffff'
  tertiary-container: '#00452d'
  on-tertiary-container: '#65b68e'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#c1ecd4'
  primary-fixed-dim: '#a5d0b9'
  on-primary-fixed: '#002114'
  on-primary-fixed-variant: '#274e3d'
  secondary-fixed: '#c0edd0'
  secondary-fixed-dim: '#a4d1b4'
  on-secondary-fixed: '#002112'
  on-secondary-fixed-variant: '#264f39'
  tertiary-fixed: '#a1f4c8'
  tertiary-fixed-dim: '#86d7ad'
  on-tertiary-fixed: '#002113'
  on-tertiary-fixed-variant: '#005236'
  background: '#f9f9f8'
  on-background: '#191c1c'
  surface-variant: '#e1e3e2'
typography:
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Hanken Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-sm:
    fontFamily: Hanken Grotesk
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Hanken Grotesk
    fontSize: 18px
    fontWeight: '400'
    lineHeight: 28px
  body-md:
    fontFamily: Hanken Grotesk
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  label-md:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
    letterSpacing: 0.05em
  label-sm:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.05em
  headline-lg-mobile:
    fontFamily: Hanken Grotesk
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  base: 8px
  touch-target: 48px
  gutter-mobile: 16px
  gutter-desktop: 24px
  stack-sm: 4px
  stack-md: 12px
  stack-lg: 24px
---

## Brand & Style

The design system is engineered for professional foresters and environmental scientists. It merges the organic reliability of the forest with the cold precision of geospatial technology. The aesthetic is **Precise-Rugged**: a hybrid of high-tech data visualization and field-ready durability.

The UI avoids fragile decorations, opting for a functionalist approach that feels "heavy duty." It utilizes a "Digital Tools for the Wild" philosophy—meaning every interface element must feel as intentional and robust as a physical diameter tape or a laser hypsometer. The target emotional response is one of confidence, technical accuracy, and outdoor reliability.

## Colors

The palette is rooted in a deep, authoritative **Forest Green** (Primary) to establish trust and environmental context. This is contrasted with a **Light Moss Green** (Secondary) used for highlighting and success states, ensuring visibility against darker tones. 

Backgrounds utilize a curated **off-white** (Neutral) to reduce screen glare in outdoor sunlight while maintaining a clean, modern feel. Secondary text uses **slate grays** with a slight green tint to maintain a cohesive natural atmosphere without sacrificing legibility. 
- **Primary:** Actionable items and brand presence.
- **Secondary:** Visual accents and soft backgrounds for active states.
- **Surface:** High-visibility off-white for data clarity.

## Typography

This design system utilizes **Hanken Grotesk** for all primary interfaces. It was selected for its contemporary, sharp geometry and high legibility in high-glare environments. For technical data, coordinates, and measurement values, **JetBrains Mono** is employed to provide a "precision instrument" feel, ensuring that numbers are easily distinguishable and aligned.

- **Headlines:** Bold and impactful to anchor the page.
- **Body:** Generous line height to ensure readability while moving in the field.
- **Labels:** Monospaced for data-heavy views to emphasize technical accuracy.

## Layout & Spacing

The layout philosophy follows a **Rugged Grid** model. It prioritizes vertical stacking and large tap zones to accommodate users who may be wearing gloves or using devices in unstable outdoor conditions. 

- **Grid:** A 12-column fluid grid for desktop; a single-column stack for mobile.
- **Touch Targets:** A minimum 48px height for all interactive elements is strictly enforced.
- **Rhythm:** An 8px linear scale ensures consistent alignment of technical data points.
- **Margins:** Generous safe areas (24px on tablet/desktop) prevent critical information from being obscured by rugged device cases.

## Elevation & Depth

To maintain the "rugged technology" feel, the design system avoids soft, floating shadows. Instead, it uses **Tonal Layering** and **Technical Outlines**.

- **Surfaces:** Use flat, solid fills with subtle 1px borders (#DDE5E0) to define boundaries.
- **Active Elevation:** When an element is focused or active, it gains a subtle, hard-edged "shadow" or a primary color border (2px) to signify priority.
- **Data Cards:** These sit on the lowest elevation tier with a solid white background to pop against the off-white neutral canvas. No blurs or glass effects are used, ensuring maximum performance on lower-end mobile hardware common in field work.

## Shapes

The shape language is **Soft-Industrial**. We use a 0.25rem (4px) base radius. This provides just enough softening to feel modern and "designed," while retaining the structured, rectangular feel of industrial hardware. 

- **Buttons & Inputs:** Use the base `rounded` (4px).
- **Data Cards:** Use `rounded-lg` (8px) to create clear containers for complex information.
- **Status Pills:** Use `rounded-xl` (12px) to distinguish them from actionable buttons.

## Components

### Buttons
Primary buttons are high-contrast Forest Green with white text. They are "blocky" and occupy the full width of their container on mobile to maximize the tap area. Secondary buttons use a thick 2px outline for high visibility.

### Data Cards
Inventory cards are the core of the system. They feature a "Split Header" design: the left side shows the Tree Species (Hanken Grotesk), while the right side displays the ID number or Coordinates (JetBrains Mono). This separates biological data from technical data visually.

### Input Fields
Fields feature a thick bottom border and a distinct "Field Focus" state using a 2px Primary Green border. To facilitate data entry in the woods, inputs should always be paired with "Increment/Decrement" buttons (+/-) for numerical values like DBH (Diameter at Breast Height).

### Offline Indicators
A persistent status chip must be visible in the navigation bar. 
- **Synced:** Solid Primary Green.
- **Local-Only:** Secondary Moss Green with a "Syncing" icon.
- **Offline:** Slate Gray.

### List Items
List items utilize high-contrast dividers and large icons to differentiate tree types or plot categories at a glance. Every list item has a minimum height of 64px to ensure ease of navigation while walking.