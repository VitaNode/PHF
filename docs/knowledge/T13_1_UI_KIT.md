# T13.1 UI Kit Documentation

## Overview
This document outlines the usage of the foundational UI components and theme configuration for the PaperHealth (PHF) application.

## Design System

### Colors
- **Primary**: Teal `#008080` (Medical, Trust)
- **Warning**: Orange `#FFFF9900`
- **Error**: Red `#D32F2F`
- **Background**: White `#FFFFFF` / Grey `#F2F2F7`

### Typography
- **Font Family**: `Inconsolata` (Monospace for data precision)
- **Usage**:
  - `headlineLarge`: 32px Bold
  - `bodyLarge`: 16px Regular
  - `bodyMedium`: 14px Regular

## Components

### 1. AppTheme
**Location**: `lib/presentation/theme/app_theme.dart`
**Usage**:
```dart
MaterialApp(
  theme: AppTheme.lightTheme,
  ...
)
```
Provides a centralized `ThemeData` enforcing the design system rules, including button shapes (8px radius) and card styles (12px radius).

### 2. ActiveButton
**Location**: `lib/presentation/widgets/atoms/active_button.dart` (Assumed path based on task)
**Purpose**: Primary action button with loading state support.
**Features**:
- Minimum touch target 44px.
- Built-in loading indicator.
- Disabling support.

### 3. SecurityIndicator
**Location**: `lib/presentation/widgets/atoms/security_indicator.dart` (Assumed path based on task)
**Purpose**: Visual feedback for encryption status.
**States**:
- **Encrypted**: Green Lock Icon.
- **Unencrypted/Warning**: Red/Orange Alert Icon.

### 4. AppCard
**Location**: `lib/presentation/widgets/atoms/app_card.dart`
**Purpose**: Container for content grouping.
**Style**:
- White background.
- 12px rounded corners.
- Subtle border `#E5E5EA`.
- Zero elevation (flat design).

## Best Practices
- **Do**: Use `Theme.of(context)` to access colors and text styles.
- **Do Not**: Hardcode Hex colors in widgets.
- **Do**: Use `AppCard` for all list items and content blocks.
