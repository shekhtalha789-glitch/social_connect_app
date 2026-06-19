---
name: Kinetic Minimalist
colors:
  surface: '#fbf8ff'
  surface-dim: '#dcd9e0'
  surface-bright: '#fbf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f5f2f9'
  surface-container: '#f0edf4'
  surface-container-high: '#eae7ee'
  surface-container-highest: '#e4e1e8'
  on-surface: '#1b1b20'
  on-surface-variant: '#464553'
  inverse-surface: '#303035'
  inverse-on-surface: '#f3eff7'
  outline: '#777585'
  outline-variant: '#c7c4d6'
  surface-tint: '#4e4ec9'
  primary: '#4241bc'
  on-primary: '#ffffff'
  primary-container: '#5b5bd6'
  on-primary-container: '#edeaff'
  inverse-primary: '#c1c1ff'
  secondary: '#b7131a'
  on-secondary: '#ffffff'
  secondary-container: '#db322f'
  on-secondary-container: '#fffbff'
  tertiary: '#51525c'
  on-tertiary: '#ffffff'
  tertiary-container: '#6a6a75'
  on-tertiary-container: '#edebf8'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e2dfff'
  primary-fixed-dim: '#c1c1ff'
  on-primary-fixed: '#0a006b'
  on-primary-fixed-variant: '#3533b0'
  secondary-fixed: '#ffdad6'
  secondary-fixed-dim: '#ffb4ac'
  on-secondary-fixed: '#410002'
  on-secondary-fixed-variant: '#93000d'
  tertiary-fixed: '#e2e1ee'
  tertiary-fixed-dim: '#c6c5d1'
  on-tertiary-fixed: '#1a1b24'
  on-tertiary-fixed-variant: '#454650'
  background: '#fbf8ff'
  on-background: '#1b1b20'
  surface-variant: '#e4e1e8'
typography:
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
    letterSpacing: -0.01em
  title-md:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.01em
  caption:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  container-margin: 20px
  stack-gap: 16px
  section-gap: 24px
  gutter: 16px
---

## Brand & Style
The design system focuses on a refined, humanist take on modern digital interaction. It prioritizes clarity and breathability, moving away from dense information architecture to foster a sense of calm and focused social connection.

The style is **Modern/Corporate** with a "Soft-Systematic" lean. It utilizes the structural logic of Material 3 but applies a more editorial sense of whitespace and softer geometry. The emotional response should be one of reliability and ease—a "quiet" interface that recedes to let user content and photography take center stage.

## Colors
The palette is centered around a vibrant indigo-violet, used purposefully to denote action and presence. 

- **Primary:** High-signal indigo for primary actions, active navigation states, and interactive links.
- **Accent:** A spirited red reserved exclusively for the "Like" interaction and critical alerts.
- **Neutrals:** A sophisticated cool-gray spectrum. Secondary text uses a muted cool-gray to create clear information hierarchy against the near-black primary text.
- **Surface Strategy:** The system uses subtle shifts in background value rather than heavy borders to define containers. Surfaces in the light mode are tinted with a hint of blue to maintain a "cool" professional temperature.

## Typography
The system utilizes **Inter** for its neutral, geometric precision and exceptional legibility on mobile screens.

- **Headlines:** Set with tight letter-spacing and bold weights to provide strong visual anchors.
- **Section Titles:** Use Medium weights to distinguish content groups without competing with primary headlines.
- **Body Text:** Standardized at 16px for optimal readability, with a secondary 14px size for metadata or dense list items.
- **Captions:** Always rendered in the muted secondary text color to deprioritize auxiliary information.

## Layout & Spacing
The design system employs a **Fluid Grid** logic optimized for mobile viewports. 

- **Margins:** A standard 20px horizontal margin ensures content does not feel cramped against the bezel.
- **Rhythm:** An 8px linear scale governs all spacing. Use 16px for internal component padding and 24px for vertical separation between distinct content blocks.
- **Touch Targets:** All interactive elements maintain a minimum hit area of 48x48px, even if the visual representation is smaller.

## Elevation & Depth
The system uses **Tonal Layering** combined with high-diffusion shadows.

- **Level 0 (Background):** Pure white or deep charcoal.
- **Level 1 (Cards/Surfaces):** Use a subtle tint shift (`surface_light` or `surface_dark`).
- **Shadows:** Use extremely soft, low-opacity shadows (Blur: 20px, Y: 4px, Opacity: 4%) to lift cards off the background without creating "dirty" edges.
- **Focus States:** Active inputs or focused elements utilize a 2px primary indigo stroke rather than a shadow change.

## Shapes
Geometry is friendly but disciplined. 

- **Base Radius:** 8px for small components (chips, tooltips).
- **Standard Radius:** 12px for buttons and input fields to feel modern and accessible.
- **Container Radius:** 16px for cards and bottom sheets to emphasize the "contained" nature of social posts.
- **Avatars:** Always 100% circular to contrast against the rectangular grid of the feed.

## Components

- **Buttons:** 
  - *Primary:* 52px height, filled Indigo. Labels are centered, 16px Bold White.
  - *Secondary:* 52px height, 1.5px Indigo stroke, Indigo label.
  - *FAB:* Extended pill shape. Uses the Primary Indigo fill. Icon sits to the left of the label.
- **Input Fields:** 56px height. Outlined with a 1px border (`divider_light`). On focus, the border increases to 2px Primary Indigo and the label floats to the top-left stroke.
- **Cards:** 16px corner radius. Internal padding is 16px. Content is separated by white space or very thin (1px) dividers.
- **Navigation:**
  - *Bottom Bar:* 56-64px height. Active state uses a filled icon variant with a subtle background "pill" tint in 10% opacity Primary Indigo.
- **Avatars:** If no image is present, use a 10% Primary Indigo background with a Bold Primary Indigo initial centered within.
- **Chips/Tags:** Small (32px height), rounded 8px, using `surface_light` background and `secondary_text` labels.