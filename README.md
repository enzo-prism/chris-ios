# WongSmileClub

Production-ready SwiftUI app for Christopher B. Wong DDS (Palo Alto, CA). The current structure is "Care + Club" focused on patient utility and practice growth without becoming a medical records app.

## App structure (5 tabs)
- Care: recall reminders, patient portal access, education library, personal questions list, specialists, offers preview, emergency.
- Book: request appointments, online scheduling, call, emergency guidance.
- Club: earn + redeem points, pending vs approved balances, rewards, and public review links (points gated).
- Offers: limited-time partner offers (optional remote feed).
- More: profile, points history, practice info, support, report-a-concern, legal, about.

## Configure practice info + endpoints
Update `WongSmileClub/Resources/Info.plist` (single source of truth):

- `PracticeName`
- `PracticeCity`
- `PracticePhone`
- `EmergencyPhone`
- `PracticeAddress`
- `PracticeSchedulingURL`
- `PracticePatientPortalURL`
- `PracticeWebsiteURL`
- `PracticeInstagramHandle`
- `InstagramDisclosureText`
- `GoogleReviewURL`
- `YelpReviewURL`
- `SupportEmail`
- `PrivacyPolicyURL`
- `TermsURL`
- `CommunityGuidelinesURL`
- `PracticeHours` (array of strings)

Formspree endpoints (replace TODO placeholders):
- `FormspreeAppointmentEndpoint`
- `FormspreeReferralEndpoint`
- `FormspreeMediaEndpoint`
- `FormspreeFeedbackEndpoint`
- `FormspreeRedemptionEndpoint`
- `FormspreeSpecialistCoordinationEndpoint`
- `FormspreeReportConcernEndpoint`

Feature flag (default OFF):
- `EnablePointsForPublicReviews` (NOT RECOMMENDED)
- `EnableDemoCareData` (kept OFF for production)

Optional remote content feeds (fallback to bundled JSON):
- `OffersFeedURL`
- `RewardsFeedURL`
- `EducationFeedURL`
- `SpecialistsFeedURL`

## Seeded demo data
- Rewards, offers, education, and specialist network data are seeded from `WongSmileClub/Resources/Rewards.json`, `WongSmileClub/Resources/Offers.json`, `WongSmileClub/Resources/EducationTopics.json`, and `WongSmileClub/Resources/Specialists.json`.
- Remote feeds are optional and cached to Application Support.

## Project generation
The Xcode project is generated from `project.yml` using XcodeGen.

```sh
xcodegen
```

## Run
1. Build for simulator (pick any installed simulator):
   ```sh
   xcodebuild -project WongSmileClub.xcodeproj -scheme WongSmileClub -destination 'platform=iOS Simulator,name=iPhone 15' build
   ```
2. Launch in Xcode by opening `WongSmileClub.xcodeproj`.

## Tests
```sh
xcodebuild -project WongSmileClub.xcodeproj -scheme WongSmileClub -destination 'platform=iOS Simulator,name=iPhone 15' test
```

## Notes
- All placeholders in `Info.plist` are marked with `TODO`.
- Path A scope: no PHI storage/transmission and no official clinical records. For official records, patients use the Patient Portal link.
- Points for public reviews are disabled by default and require explicit confirmation if enabled.
- If you regenerate the project, commit the updated `WongSmileClub.xcodeproj`.

## What is stubbed
- Replace all TODO placeholders in `WongSmileClub/Resources/Info.plist`.
- Links for privacy, terms, community guidelines, and support are expected to be configured.

## Archive
- `Archive/Chris` and `Archive/Chris.xcodeproj` are unrelated legacy samples and not part of the app build.
