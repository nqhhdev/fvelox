# Testing strategy

## Test priority

The project has unit, widget, native `integration_test`, and Patrol device-level acceptance coverage.

| Suite | Command | Covers |
|-------|---------|--------|
| Unit / widget | `flutter test` | Domain, repository, controllers, key UI |
| Native acceptance | `flutter test integration_test/acceptance_criteria_test.dart -d <device-id>` | Business AC with `DemoPaymentRepository` |
| Patrol acceptance | `patrol test --target integration_test/app_launch_test.dart --dart-define=FVELOX_PATROL_TEST=true` | App launch + payment acceptance flow |

The Patrol flow uses `FVELOX_PATROL_TEST=true` to inject an empty deterministic `DemoPaymentRepository` at app bootstrap. Production builds continue to use Dio.

## Current verification

- `flutter analyze` passes.
- `flutter test` passes.
- `flutter test integration_test/acceptance_criteria_test.dart -d <device-id>` passes on the configured Android API 36 emulator; the same suite is also verified on the configured iOS simulator.
- `build/app/outputs/flutter-apk/app-release.apk` builds successfully for Android arm64.
- Patrol test bundle builds successfully; Android native execution is blocked by `INSTALL_FAILED_INSUFFICIENT_STORAGE`, and iOS native execution is blocked by the simulator XCTest daemon.
- The acceptance test uses `DemoPaymentRepository` so the flow is deterministic and does not require backend credentials.
- The backend has no ETag/delta contract, so collection refresh tests intentionally verify authoritative full reads; local cache synchronization is covered separately.
- Repository tests verify that a stale summary is replaced by a summary derived from the decided cache after delete/decide, and that concurrent decided reads make one remote call.
- Native acceptance verifies the Home total after approve, unchanged total after reject, and changed list/summary after deleting an approved payment.
- Widget tests cover the offline banner; repository tests cover offline read-only mutations. Full airplane-mode E2E remains a **manual device check**.

`acceptance_criteria_test.dart` is not Patrol. It uses `IntegrationTestWidgetsFlutterBinding` and is executed by `flutter test`. The Patrol target is `integration_test/app_launch_test.dart`, which runs launch smoke **and** the payment acceptance scenario when started with `FVELOX_PATROL_TEST=true`. Patrol device execution is still blocked on the current emulators (storage / XCTest); native `flutter test` remains the verified business-flow proof.

## Native acceptance matrix

### Home

- Launch app and pass splash.
- Verify Home renders the monthly summary.
- Verify empty state when the demo repository returns no decided payments.
- Verify recent approved and rejected activity can be displayed.
- Verify rejected payments do not increase total AED or payment count.
- Swipe-delete an approved row and verify toast, row removal, and Home total change.

### Payments list

- Open Payments.
- Verify decided payments are shown newest first.
- Verify each row shows recognizable party, amount, and status.
- Create a request, approve it, and verify it appears at the top immediately.
- Create another request, reject it, and verify it appears at the top with Rejected status.

### Details

- Tap an approved row and verify full details.
- Tap a rejected row and verify full details.
- Verify back returns to the screen that opened the details.
- Verify a pending request cannot be opened as a details route because it is overlay-only.

### Approval overlay

- Start from Home or Payments where practical.
- Tap the global FAB.
- Verify the request appears over the current screen without navigation.
- Verify recipient and AED amount are masked.
- Verify the reference is fully visible.
- Choose Approve or Reject.
- Verify OTP field appears.
- Enter an incorrect OTP and verify the error appears below the field.
- Enter `8888` and verify the selected action is executed immediately.
- Verify Approve ends on Payments with an updated Home total after switching tabs.
- Verify Reject keeps the previous total and leaves the rejected payment visible.

### FAB

- Verify the FAB is visible on Home, Payments, and Details. While the approval sheet is open the FAB is hidden so it cannot intercept taps.
- Drag it across the screen and verify the position changes.
- Verify tapping it still creates a new request after dragging.

### Offline (not in native acceptance suite)

Coverage today:

- Widget: offline banner while connectivity is false.
- Repository / unit: offline blocks create/decide/delete; reads fall back to Drift; summary derives from decided cache when needed.

Manual device checklist before delivery:

- Load data online so Drift has a cache.
- Disable connectivity (airplane mode).
- Verify cached Home, Payments, and decided Details remain readable.
- Tap FAB and verify an offline toast appears.
- Attempt a mutation and verify no local final decided state is created.
- Restore connectivity and verify a later refresh uses the backend response.

## Error scenarios

- HTTP 4xx/5xx on read.
- Read timeout.
- Malformed payment payload.
- Database read/write failure.
- Approve/reject timeout after OTP.
- Duplicate tap / concurrent delete protection while a mutation is in progress.
- Fast swipe-delete must not leave a dismissed `Dismissible` in the tree.

## Test data rule

The request amount and recipient are random as required by the debug FAB behavior. E2E assertions should not hardcode the generated values. Assert visible structure, reference format, status, ordering, and the resulting summary behavior (compare totals before/after rather than hardcoding AED amounts after create).

## Patrol acceptance checklist before delivery

- Fresh install launches successfully.
- Empty Home state is visible at startup.
- FAB drag and session position retention work across Home, Payments, Details and the approval overlay.
- Approval overlay masks recipient and amount while showing the reference.
- Invalid OTP shows inline feedback; `8888` executes approve and reject immediately.
- Approve closes the overlay and ends on Payments with a success toast.
- Reject closes the overlay, returns to the underlying screen and shows a success toast.
- Decided details work and pending details remain unavailable.
- New decided rows appear in order and swipe-delete refreshes list and Home summary.
- APK can be installed without source setup.
- Production runs can omit the test define and use the configured API base URL.
- Offline, malformed-response, timeout, and long-content behavior remain covered by the native/unit/widget suites and manual release checks.

## Remaining release checks

- Patrol acceptance flow on the target device after freeing Android emulator storage and fixing the local iOS XCTest/simulator runner. The native runner and host test are configured under `android/app/src/androidTest`.
- Release APK installation and launch on a clean Android emulator.
- Manual offline airplane-mode check on device.
- Optional `evidence/` package: test logs, screenshots, short demo video.
- Widget golden tests and low-end Android performance profiling (follow-up, not required for this handoff).
