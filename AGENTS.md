# AGENTS.md

This file defines how Codex CLI should work in this repo. Treat it as the runbook for product and design decisions.

## Required design sources
- Always start with `AdditionalDocumentation/INDEX.md` and open the relevant doc(s) for the UI area you are changing.
- Extract 3-5 actionable rules from those docs before coding, and keep them in mind while implementing.
- If `scripts/design-check.sh` exists, run it after UI changes. If it does not exist, note that it was unavailable.

## Design rules (derived from AdditionalDocumentation)

### Liquid Glass (SwiftUI first)
- Use `glassEffect()` for glass surfaces; apply it after layout and styling modifiers.
- When multiple glass elements are on screen, wrap them in `GlassEffectContainer` and tune spacing to control merging.
- Use `.interactive()` for touchable glass. Prefer `.buttonStyle(.glass)` or `.buttonStyle(.glassProminent)` where appropriate.
- Keep corner radii and shapes consistent across the app; use subtle tints to indicate state or hierarchy.
- Limit the number of glass surfaces on screen and test performance on older devices. Ensure adequate text contrast on glass.

### Assistive Access (iOS)
- Distill to core actions, provide large controls, clear spacing, and simple step-by-step navigation.
- Avoid hidden gestures or time-sensitive interactions; provide visual alternatives to text.
- Use clear confirmation for destructive actions and provide feedback for all interactions.
- If you add Assistive Access support, set `UISupportsAssistiveAccess` in Info.plist and provide an Assistive Access scene. Test with `.assistiveAccess` previews.

### Toolbar and navigation
- Use meaningful IDs for customizable toolbars and group related actions with `ToolbarSpacer`.
- Consider `.searchToolbarBehavior(.minimize)` on compact screens and use `DefaultToolbarItem` when repositioning search.
- Use `sharedBackgroundVisibility` to manage glass backgrounds when toolbar items need to stand out.

### Text and editing
- Use `AttributedString` for rich text; avoid frequent recreation and cache complex values when possible.
- Keep text accessible: dynamic type, clear labels, and localization for user-facing strings.

### Widgets (only if requested)
- Support `widgetRenderingMode` and `widgetAccentable` groups.
- Use `containerBackground(for: .widget)` and test accented vs full-color modes.

### Visual Intelligence and App Intents (only if requested)
- Return results quickly, keep them relevant, and ensure display representations are localized.
- Provide deep links from results into the app for continuity.

### Concurrency and SwiftData
- Use async/await and keep UI work on `@MainActor` to avoid data races.
- Keep SwiftData inheritance shallow and aligned to query patterns; test migrations when changing models.

## Project-specific rules
- `project.yml` is the source of truth for XcodeGen. Run `xcodegen` after changes and commit `WongSmileClub.xcodeproj`.
- Core app code lives in `WongSmileClub/`; shared UI primitives are in `WongSmileClub/Components`.
- Seeded JSON lives in `WongSmileClub/Resources` and must use ISO 8601 dates.
- Offers include `tags` for future context and filtering; keep them consistent across content feeds.
- Keep all forms non-PHI and include a "Do not include medical details" warning when collecting inputs.
- Use `FormspreeClient` for submissions and configure endpoints via `WongSmileClub/Resources/Info.plist` + `AppConfig`.
- The `Archive/Chris` sample is unrelated and should remain out of the app build.

## Build and test (known-good commands)
- Generate project: `xcodegen`
- Build: `xcodebuild -project WongSmileClub.xcodeproj -scheme WongSmileClub -sdk iphonesimulator -destination 'generic/platform=iOS Simulator' build`
- Test: `xcodebuild -project WongSmileClub.xcodeproj -scheme WongSmileClub -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' test`
  - If the simulator name differs locally, swap in an available device from `xcrun simctl list devices`.
