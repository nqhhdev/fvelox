# Assets and licenses

## Branding

The app name is `fvlox`. It does not reuse Mamo branding or the Mamo icon.

The app icon must be selected from an open-source fintech-appropriate source or created as an original simple mark. Before delivery, record:

- asset name and source URL;
- author or publisher;
- license;
- whether attribution is required;
- the exact local asset path.

Do not commit an icon copied from a proprietary product without permission.

## iVelox visual reference

The visual direction is inspired by the developer's own iVelox design system. Reuse only assets that the developer owns or is licensed to use. Port design tokens and widget behavior into Flutter; do not copy React source files into the Flutter app.

Reference repository: https://github.com/nqhhdev/ivelox-app

## Third-party package licenses

At minimum, record the package and license in the final release inventory:

- Flutter SDK — BSD-style Flutter/Dart ecosystem licenses.
- Riverpod — MIT.
- Dio — MIT.
- Drift — MIT.
- `flutter_floaty` — MIT.
- Patrol — license to be verified from the resolved package version.

The final project should include generated dependency license output where appropriate and should verify the actual resolved versions before handoff.

## Sensitive files

Never commit:

- backend credentials;
- API tokens;
- signing keys;
- production database credentials;
- personal repository credentials;
- real customer payment data.
