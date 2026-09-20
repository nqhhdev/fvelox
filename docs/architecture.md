# Architecture

## Goals

The architecture is intentionally simple enough for a two-day challenge while preserving boundaries that can scale into a real fintech feature.

The design follows:

- separation of UI, presentation logic, domain logic, and data access;
- dependency inversion through repository contracts;
- single source of truth for rendered payment state;
- explicit success, loading, empty, offline, and failure states;
- immutable domain models where practical;
- backend authority for payment mutations;
- testable interactors and controllers.

## Dependency direction

```text
Presentation  →  Domain  ←  Data
                    ↑
                 Core contracts/infrastructure
```

The domain does not import Flutter, Dio, Drift, or Riverpod. Data implements domain repository contracts. Presentation depends on domain interactors and state models, not on concrete data sources. Riverpod providers in `lib/app/providers/` are the composition root; the feature presentation provider is only a package barrel.

## Source layout

```text
fvelox/
├── README.md
├── docs/
│   ├── architecture.md
│   ├── decisions.md
│   ├── testing.md
│   ├── product-spec.md
│   ├── sprint-plan.md
│   └── asset-licenses.md
├── pubspec.yaml
├── assets/
│   ├── icons/
│   └── l10n/
├── lib/
│   ├── main.dart
│   ├── app/
│   │   ├── providers/          # composition root
│   │   ├── router/
│   │   └── theme/
│   ├── core/
│   │   ├── errors/
│   │   ├── network/
│   │   ├── local_database/
│   │   ├── connectivity/
│   │   ├── logging/
│   │   └── design_system/
│   ├── l10n/
│   ├── gen/
│   └── features/
│       └── payment_approval/
│           ├── domain/
│           │   ├── entities/
│           │   ├── app_state/{home,payments,approval,feature,shared}/
│           │   ├── interactors/{home,payments,approval,feature}/
│           │   └── repositories/
│           ├── data/
│           │   ├── models/
│           │   ├── extensions/
│           │   ├── data_sources/
│           │   └── repositories/
│           └── presentation/
│               ├── shell/
│               ├── screens/
│               ├── view_models/{home,payments,approval,details,feature,refresh,shell}/
│               ├── providers/
│               └── widgets/
├── test/
└── integration_test/
    ├── acceptance_criteria_test.dart
    ├── app_launch_test.dart
    ├── base/
    ├── robots/
    └── scenarios/
```

## Layer responsibilities

### Presentation

Contains Flutter UI, route composition, Riverpod providers, controllers/view models, and reusable payment widgets.

Allowed:

- render state;
- call a controller method in response to user interaction;
- show dialogs, overlays, toast/snackbar messages;
- format display values through presentation formatters.

Not allowed:

- direct Dio or Drift calls;
- calculating business totals in widgets;
- deciding whether a payment is mutable;
- mapping raw API JSON inside a widget.

### Domain

Contains framework-independent business concepts:

- `Payment` entity;
- payment status value object/enum;
- repository interfaces;
- `GetPaymentFeatureInteractor`;
- `GetPaymentSummaryInteractor`;
- `GetDecidedPaymentsInteractor`;
- `GetPaymentDetailsInteractor`;
- `CreateDemoRequestInteractor`;
- `DecidePaymentInteractor`;
- `DeletePaymentInteractor` and `DeletePaymentsInteractor`;
- `ValidatePaymentOtpInteractor`;
- business rules such as rejected payments not contributing to money-moved summary and pending payments not being eligible for details.

### Data

Contains implementation details:

- API DTOs;
- Drift table and DAO mapping;
- JSON parsing and serialization;
- remote data sources;
- local cache data sources;
- repository implementations;
- Dio exception mapping into `AppFailure`.

### Core

Contains cross-feature infrastructure only:

- Dio client and interceptors;
- failure types;
- Drift database setup;
- connectivity observer;
- logging abstraction;
- shared design-system widgets and tokens.

## State ownership

Each domain interactor owns its operation state in `domain/app_state`: initial, loading, success, and failure. Interactors catch repository failures from both network and local storage and emit a typed failure state. Riverpod providers inject the interactors; the presentation controller consumes their final state and projects it into screen state.

The repository exposes the latest successful backend result to the presentation layer. The Riverpod controller owns screen state such as:

- initial loading;
- background refresh while preserving the current screen content;
- loaded data;
- empty data;
- offline cached data;
- recoverable failure;
- mutation in progress;
- mutation failure.

Drift is updated only after a successful backend response. There is no optimistic final status before the backend confirms a decision, and there is no offline mutation queue.

Pending requests live in the approval overlay only. Create does not write pending rows into the decided-payment Drift cache; list/detail queries also filter out pending status. After a successful **decide** or **delete**, controllers request a screen refresh that re-runs the read interactors so Home, Payments, and summary stay aligned with the repository. Create alone does not refresh decided lists (nothing decided yet).

Delete additionally removes the deleted id from the active screen list as soon as the API succeeds. That keeps Flutter `Dismissible` from remaining in the tree while the async refresh is still in flight; the refresh then reconciles summary and the sibling tab.

Skeletons are reserved for the first screen read. Later refreshes set a separate
`isRefreshing` flag, keep the existing list/summary mounted, and replace the data
atomically when the repository response arrives. This prevents full-screen blinking
after approve, reject, or delete.

The offline-cached state is represented by the connectivity stream and `OfflineBanner`; cached Home, Payments, and decided Details stay readable while create/decide/delete actions remain read-only and show an error toast.

The backend currently exposes a full decided-payment collection without ETags or a
delta/since cursor. The repository therefore requests the authoritative collection
when refreshing. The local Drift transaction avoids a full table wipe: it removes
stale IDs and upserts the returned rows in one batch.

When a summary read is offline or the summary endpoint fails, the repository derives
the summary from the decided-payment cache instead of trusting a potentially stale
summary row. The domain summary rule counts approved payments only; rejected and
pending payments never contribute. Concurrent decided-payment reads are coalesced
inside the repository so Home and Payments share one in-flight backend request.

## Single source of truth

The state flow is:

```text
Backend response
      ↓ success
Repository maps response
      ↓
Update Drift cache
      ↓
Controller re-reads repository after mutations
      ↓
Riverpod state refreshes
      ↓
Home / Payments / Details render the same payment state
```

For API diagnostics, `ApiTraceInterceptor` logs the complete request, response, and
error structure through `AppLogger` while debug logging is enabled; credentials and
OTP are redacted. It is attached in the Dio composition root, not in a widget or
interactor.

For a failed mutation, the existing cache and visible state remain unchanged. The app shows an error and offers retry after the current backend state has been checked.

## Payment state machine

```text
                    create request
                         ↓
                    PENDING overlay
                    ↙             ↘
              APPROVED          REJECTED
```

- `PENDING` is transient and exists only while the approval overlay is active. It is not hydrated into the decided-payment cache used by Home/Payments/Details.
- `APPROVED` and `REJECTED` are persisted by the backend and cached locally.
- A pending payment cannot open details.
- An approved or rejected payment can open details.
- Swipe-to-delete is available for decided rows only; the active list drops the row immediately on API success, then a repository reload reconciles summary and sibling screens.
- The bulk-delete API and interactor are retained for batch-capable callers and are covered by API tests; the current product AC exposes the safer single-row swipe action only.

## Feature gate

`GetPaymentFeatureInteractor` is the single feature-gate read. When the backend reports the feature disabled, the shell renders `PaymentFeatureDisabledScreen`, clears the payment data view, and does not mount the payment actions. The default feature is enabled only as the repository fallback for an unavailable feature response.

## Overlay and navigation

The approval request is an overlay/sheet above the current route, not a new route. The route underneath is captured implicitly by the overlay context.

- Approve success: dismiss overlay, refresh state, navigate to Payments.
- Reject success: dismiss overlay, refresh state, reveal the previous route.
- Cancel: dismiss overlay without a decision; no repository mutation. The debug FAB is hidden while the sheet is open.
- Delete success: drop the row from the active screen list immediately, then refresh decided list and summary from the repository before treating the UI as fully reconciled.
- Mutation failure: keep the decision flow visible with an error message and retry action; do not silently retry.

## Draggable debug FAB

The app uses `flutter_floaty` as the interaction primitive for the always-visible debug FAB. The adapter is mounted in a root-level local `Overlay`, above the router's Navigator and modal routes.

Required configuration intent:

- mount above the app content through the app-level overlay;
- allow free drag, then snap to the nearest safe horizontal edge;
- disable stash/dismiss behavior;
- disable tap-to-expand behavior;
- keep the actual FAB tap callback responsible for creating a request;
- retain the placement in memory for the current app session;
- keep the FAB visible across Home, Payments, Details, and the approval overlay;
- use local drag state during the gesture and Riverpod UI state for the committed
  position, interaction state and request-loading state.

If the package cannot satisfy the tap/overlay behavior without workarounds, replace only this adapter with a small custom `Stack` + `GestureDetector` implementation. The rest of the architecture remains unchanged.

## SOLID application

- Single Responsibility: widgets render, controllers coordinate, interactors apply business actions, repositories access data.
- Open/Closed: add a new data source or authentication method behind an interface.
- Liskov Substitution: remote and local sources satisfy the repository contracts.
- Interface Segregation: interactors depend on small repository methods rather than a large service object.
- Dependency Inversion: the domain owns contracts; data and infrastructure implement them.
