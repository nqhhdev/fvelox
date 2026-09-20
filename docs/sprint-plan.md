# App sprint plan

Phạm vi: Flutter app only. Backend là dependency bên ngoài.

## Sprint goal

Hoàn thành Payment Approval Flow theo acceptance criteria, có APK để reviewer dùng thử.

## Tickets

### 1 — Core screens and happy path

| ID | Ticket | DoD |
|---|---|---|
| APP-01 | App shell | Splash, light theme, iVelox-inspired tokens, bottom navigation. |
| HOME-01 | Home screen | Monthly total/count, Recent payments, empty/loading/error states. |
| PAY-01 | Payments screen | Decided payments, newest first, amount/name/status, empty state. |
| DETAIL-01 | Payment Details | Full details for approved/rejected only, correct back behavior. |
| APPROVAL-01 | Approval overlay | Overlay over current screen, masked party/amount, full reference. |
| APPROVAL-02 | OTP decision flow | Approve/Reject → OTP `8888` → execute immediately. Invalid OTP error below input. |
| STATE-01 | Shared state update | New decision appears at top; Home, Payments and Details stay consistent. |

### 2 — Global behavior, resilience and verification

| ID | Ticket | DoD |
|---|---|---|
| FAB-01 | Global draggable FAB | Visible on every screen, free drag, position retained during session. |
| OFFLINE-01 | Offline UI | Cached data remains readable; blocked actions show toast. |
| ERROR-01 | Error handling | Loading, empty, offline, failure and retry states are usable. |
| UI-01 | UI polish | AED formatting, no overflow, accessibility labels, consistent widgets. |
| LOG-01 | Logging | Info/warning/error logs at key points; no sensitive data logged. |
| E2E-01 | Native acceptance flow | Cover Home, Payments, Details, FAB, Approve, Reject, OTP, totals and swipe-delete with native `integration_test` and Patrol (`DemoPaymentRepository`). |
| RELEASE-01 | Handoff | Release APK, README, short decisions note, test instructions, optional evidence pack. |

## Key decisions

- Currency: AED only.
- Pending request exists only in the approval overlay.
- Rejected payments remain in lists but do not affect Home total/count.
- OTP is hardcoded as `8888` for the demo, with no retry limit.
- Offline mode is read-only.
- UI, state logic and data access remain separated.

## Definition of Done

- Reviewer can install and use the APK without project setup.
- All P0 acceptance criteria pass.
- Approve/Reject updates the app consistently.
- FAB remains visible and draggable across screens.
- Native acceptance integration test and Patrol cover the main acceptance flow; Patrol is the device-level runner.
- Known limitations and future improvements are documented.

## If time is limited

Keep all core screens, approval flow, FAB, state updates and APK. Defer extended unit/widget tests, pull-to-refresh, reconnect animation and advanced accessibility polish.
