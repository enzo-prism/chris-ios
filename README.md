# WongSmileClub

Production-ready SwiftUI app for Christopher B. Wong DDS (Palo Alto, CA). Built for fast booking, emergency contact, Smile Points, rewards, and limited-time offers.

## Configure practice info + endpoints
Update `WongSmileClub/Resources/Info.plist` (single source of truth):

- `PracticeName`
- `PracticePhone`
- `PracticeAddress`
- `PracticeWebsite`
- `InstagramHandle`
- `SchedulingURL`
- `GoogleReviewURL`
- `YelpURL`
- `PracticeHours` (array of strings)

Formspree endpoints (replace TODO placeholders):
- `FormspreeAppointmentEndpoint`
- `FormspreeReferralEndpoint`
- `FormspreeMediaEndpoint`
- `FormspreeFeedbackEndpoint`
- `FormspreeRedemptionEndpoint`

Feature flag (default OFF):
- `EnablePointsForPublicReviews` (NOT RECOMMENDED)

## Project generation
The Xcode project is generated from `project.yml` using XcodeGen.

```sh
xcodegen
```

## Run
1. Build for simulator (pick any installed simulator):
   ```sh
   xcodebuild -project WongSmileClub.xcodeproj -scheme WongSmileClub -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' build
   ```
2. Launch in Xcode by opening `WongSmileClub.xcodeproj`.

## Tests
```sh
xcodebuild -project WongSmileClub.xcodeproj -scheme WongSmileClub -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.5' test
```

## Notes
- All placeholders in `Info.plist` are marked with `TODO`.
- No PHI: all forms warn patients to avoid medical details.
- Points for public reviews are disabled by default and clearly labeled NOT RECOMMENDED.
- Rewards and offers are seeded from bundled JSON in `WongSmileClub/Resources/`.
 - If you regenerate the project, commit the updated `WongSmileClub.xcodeproj`.

## What is stubbed
- Replace all TODO placeholders in `WongSmileClub/Resources/Info.plist`.
- Legal text in the Profile screen is placeholder only.
