# Fastlane — iOS CD (sin Mac local)

El CD corre en **GitHub Actions** (`macos-latest`). No hace falta Xcode en tu PC.

## Lane principal

```bash
bundle exec fastlane deploy_app_store
```

1. **Match** — sincroniza certificados desde el repo privado (`MATCH_GIT_URL`). Si el repo está vacío, el lane hace bootstrap automático (`readonly: false`).
2. **Flutter** — `flutter build ipa --release --export-method app-store`
3. **upload_to_testflight** — sube el build a App Store Connect (aparece en TestFlight y luego puedes enviar a revisión App Store).

## Secrets en GitHub

Ver comentarios en `.github/workflows/app-release-cd.yml`.

## Primera ejecución

Con el repo Match **vacío**, el primer push a `main` creará certificados y perfiles en el repo privado. Si Apple ya tiene el máximo de certificados Distribution, revoca uno antiguo en [Certificates](https://developer.apple.com/account/resources/certificates/list) o importa el existente con `fastlane match import` (requiere Mac una vez).

## Versión

Incrementa `version` en `pubspec.yaml` antes de cada merge a `main` (el build number `+N` debe ser mayor que el último subido).
