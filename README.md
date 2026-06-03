# XISTI Mobile

App Flutter única (pasajero + conductor) para **XISTI**.

## Identidad

| Campo | Valor |
|-------|--------|
| Package Dart | `app_xisti` |
| Android `applicationId` | `com.app.xisti` |
| iOS bundle (configurar en Xcode) | `com.app.xisti` |
| API producción | `https://admin.xistiapp.com/api/customer/` (cuando DNS esté activo) |
| API debug default | `http://54.159.169.235/api/customer/` |
| Tema | Oscuro urbano — verde neón `#39FF14`, morado `#9333EA` |

## Build

```bash
flutter pub get
dart run flutter_launcher_icons
dart run flutter_native_splash:create
flutter build apk --debug
# Cuando admin.xistiapp.com resuelva DNS:
flutter build apk --release --dart-define=API_DOMAIN=https://admin.xistiapp.com
```

## Repositorio

https://github.com/devSixti/xisti-mobile

## Firebase / Maps

No commitear credenciales. Tras crear proyecto Firebase **XISTI**:

1. `flutterfire configure` → regenera `lib/firebase_options.dart`, `google-services.json`, `GoogleService-Info.plist`
2. Copiar `service_account.json` al backend (ver SETUP_SERVICIOS.md)

## Documentación

[`../docs/SETUP_SERVICIOS.md`](../docs/SETUP_SERVICIOS.md)
