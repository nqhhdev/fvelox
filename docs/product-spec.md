# Product and screen specification

## Product name

`fvlox`

## Currency

`AED` only for this challenge. All displayed amounts use two decimal places where appropriate.

## Global shell

- Splash screen shown on launch.
- Bottom navigation: Home and Payments.
- Global draggable debug FAB rendered above all routes.
- Light theme only.
- iVelox-inspired cream/green visual language.

## Home

### Summary

Show the current month's approved money movement:

- total AED amount from approved payments only;
- count of approved payments only.

Rejected payments are excluded from both values. Pending requests are not part of the summary.

### Recent activity

Show recent decided activity, newest first. Approved and rejected payments may both appear. Each item shows:

- party name;
- AED amount;
- status;
- navigation affordance if details are available.

### States

- loading;
- loaded with data;
- empty;
- offline with cached data;
- error with retry;
- offline with no cache.

## Payments

Show all decided payments, newest first. A row contains enough information to recognize the payment:

- party;
- AED amount;
- Approved or Rejected status;
- date/reference where space allows.

After a successful approval or rejection, the new item is inserted at the top from the backend response.

## Payment details

Only approved and rejected payments can open details. Show:

- full party name;
- full AED amount;
- status;
- date;
- reference;
- note when supplied.

Back returns to the exact screen that opened the details.

## Incoming request overlay

The overlay is presented over the current screen and does not push a route.

Before decision:

- party is masked;
- amount is masked;
- reference is fully visible;
- actions are Reject and Approve.

After selecting an action:

- show OTP input;
- keep the selected action explicit;
- show invalid OTP error directly beneath the field;
- valid `8888` sends the decision immediately.

## Approval result behavior

### Approve

- wait for backend success;
- update cache and app state from response;
- close overlay;
- navigate to Payments;
- new item is at the top.

### Reject

- wait for backend success;
- update cache and app state from response;
- close overlay;
- return to the route underneath the overlay.

### Failure

- do not change the final payment state locally;
- keep the user informed with an inline/transient error;
- allow retry only after the current action state is clear;
- do not automatically replay a financial mutation.

## Offline experience

When offline and cache exists:

- Home, Payments, and decided Details remain readable;
- show a small offline indicator;
- FAB tap shows a toast explaining that a connection is required;
- Approve/Reject cannot be submitted.

When offline and cache is empty:

- show an empty/error state with Try again for reads;
- do not fabricate payment data.

## Accessibility and content quality

- All actionable controls have semantic labels.
- Status is not communicated by color alone.
- Amounts and references use readable text styles.
- Long party names and references use ellipsis or wrapping without overflow.
- Touch targets meet standard mobile minimums.
- OTP field supports numeric input and clear focus behavior.

