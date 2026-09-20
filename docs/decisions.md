# Engineering decisions

## 1. Flutter

Flutter is the requested mobile framework and enables one implementation for the reviewer APK/demo path.

## 2. Riverpod

Riverpod is used for dependency injection, composition, and presentation state. Providers are assembled in `app/app_providers.dart`, keeping the composition root explicit.

## 3. Java backend plus local Drift cache

The app uses a small Java backend with a database for the online source of truth. Drift stores the last successful payment data locally.

This gives the challenge a real network boundary without pretending that a payment can be safely approved offline.

### Online behavior

- fetch payments and summary from the backend;
- update Drift after successful reads;
- create, approve, and reject through the backend;
- update Drift only from successful mutation responses.

### Offline behavior

- show cached Home, Payments, and decided Payment Details;
- show an offline indicator or toast when the cache is being used;
- show a toast when the user attempts to create, approve, or reject offline;
- do not create or hydrate local pending payments;
- do not queue financial mutations for later replay.

## 4. Drift instead of a key-value store

Payments have structured fields, ordering, statuses, and summary queries. Drift provides typed tables, SQL filtering/order, migrations, and a scalable path for future pagination or audit data.

## 5. Dio and exception mapping

All remote calls go through Dio. Dio exceptions are mapped at the data boundary into app-level failures such as:

- no connection;
- timeout;
- unauthorized;
- server failure;
- invalid response;
- unknown failure.

The UI never handles raw `DioException` directly.

`ApiTraceInterceptor` records the complete request and response in the debug log,
including method, URL, headers, query, body, status, and response body. It is
disabled by default in release mode so diagnostic payloads do not leak from a
production build.

## 6. Interactors and operation state

Payment business actions are implemented as domain interactors, not generic use
case classes. Each interactor has its own state model under `domain/app_state`
with initial, loading, success, and failure states. The interactor catches every
repository error, including network and local-storage failures, and emits a typed
failure state. Riverpod remains the dependency-injection mechanism for repositories,
interactors, and the presentation controller.

## 7. AED only

The challenge examples use AED and do not specify a currency selector or multi-currency requirement. The first version therefore uses a fixed AED formatter. Currency remains a backend/domain field so multi-currency can be added later without redesigning every screen.

## 8. Hardcoded OTP

The demo OTP is `8888`. It is requested after the user selects Approve or Reject and before the mutation is sent.

After a valid OTP:

- execute the selected decision immediately;
- do not add another confirmation step;
- show an inline error beneath the OTP field for invalid input;
- do not limit retries in this challenge version.

With more time, replace this with device credentials/biometrics plus a server-validated OTP, attempt limits, lockout, expiry, and risk-based step-up authentication.

## 9. No optimistic mutation

Approve and Reject are financial decisions. The UI does not update the payment to a final state before the backend confirms success. This avoids displaying a state that did not actually move money.

After backend confirmation, the presentation controller performs a fresh feature, summary, and decided-list read through the repository. A load revision guard prevents an older in-flight read from overwriting a newer mutation result.

## 10. Rejected payments and Home summary

Rejected payments remain in the Payments list and Home Recent activity. They do not contribute to:

- Home total amount;
- Home payment count.

The summary represents money that actually moved, as stated by the challenge.

## 11. Pending visibility

Pending exists in the request overlay only. Once the user decides, the backend returns an approved or rejected payment and the item appears at the top of Payments.

## 12. FAB package

`flutter_floaty` is used as the interaction primitive for the debug FAB. The app wraps it in a feature adapter so payment state remains independent from the package. The adapter adds circular styling, idle opacity, drag growth, safe-area boundaries, nearest-edge snapping and session position retention.

Package URL: https://pub.dev/packages/flutter_floaty

The FAB is mounted in the root-level local overlay so it remains above approval sheets. Request creation shows a transparent center loading indicator; approval errors stay inline and are not duplicated as toasts.

## 13. Logging

Use three levels:

- Information: app start, connectivity transition, request started, successful refresh, successful decision.
- Warning: cache fallback, offline action attempt, recoverable malformed data, retryable failure.
- Error: unhandled repository failure, failed mutation, database failure, unexpected state.

Never log OTP, tokens, full recipient names, amounts, raw payment payloads, or personally identifiable data.

## 14. Refresh and pagination

Neither is required by the acceptance criteria. Automatic refresh on screen entry or connectivity restoration can be added if time remains. Pagination/load-more is recorded as future work.

## 15. Delete and Dismissible

Swipe delete calls the backend first. On success the active screen list drops that payment id immediately so Flutter `Dismissible` can leave the tree, then a shared screen refresh reloads summary and sibling tabs from the repository. Concurrent deletes of different rows are allowed; repeating the same id while in flight returns without toast spam.

## 16. Known follow-ups (not blocking handoff)

- Clear or rewrite the Drift summary row on decide/delete so cold cache cannot briefly hold a stale totals row before derive-from-decided fallback runs.
- Convert native acceptance to Patrol only if the reviewer requires a single Patrol E2E claim.
- Evidence pack (`evidence/` logs, screenshots, demo video) for client delivery.
- Stronger OTP/biometric, retry limits, audit events, encryption, pagination, observability — see earlier sections.
