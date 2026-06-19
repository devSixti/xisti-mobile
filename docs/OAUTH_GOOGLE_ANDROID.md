# Google OAuth — XISTI Android (`com.app.xisti`)

Proyecto GCP / Firebase: **xisti-app-ad901** (`980764435052`)

## Mapeo real (según `google-services.json` de Firebase)

Firebase asocia cada `client_id` con un `certificate_hash` concreto. **No depende del nombre del archivo** que descargaste.

| `client_id` (sufijo) | SHA-1 (`certificate_hash`) | Uso típico |
|----------------------|----------------------------|------------|
| `5ddt7lsm69u97degn21tgfiklte1e3v3` | `3C:9B:D1:09:70:54:3E:00:1E:DB:BD:3C:ED:F1:4D:E7:9C:80:95:B6` | Play App Signing |
| `gfbjgjb5h69nnnpja5v9t3qd0ihm61ub` | `6E:0A:D2:2C:71:A5:D3:BE:E5:E4:1D:31:82:AA:52:4E:A6:48:AA:0B` * | Debug (`~/.android/debug.keystore`) |
| `q2dl4gn4823lmfioklsvajs7k73c8sq6` | `FD:32:AC:8E:EE:0F:7F:39:ED:AC:D4:60:FC:0D:1F:71:E2:EE:B0:03` | Release (`xisti-release.keystore`) |

\* En el JSON de Firebase el hash del cliente `gfbjgj...` aparece como `...bee5e41d3182...` (falta una `e`). Si Google Sign-In falla en debug, corrige el SHA-1 en GCP/Firebase a `6e0ad22c71a5d3bee5e4e1d3182aa524ea648aa0b`.

## Mapeo de archivos descargados (referencia)

| Archivo en `Descargas/` | `client_id` |
|-------------------------|-------------|
| `...-5ddt7lsm69u97degn21tgfiklte1e3v3...json` | App Signing (Play) |
| `...-gfbjgjb5h69nnnpja5v9t3qd0ihm61ub...json` | Debug |
| `...-q2dl4gn4823lmfioklsvajs7k73c8sq6...json` | Release |

## Qué hacer con los JSON de `Descargas/`

- **No** los subas a Git (no van en la app Flutter).
- **No** uses esos `client_secret` en `xisti-mobile`: los clientes Android no los necesitan en código.
- **Admin Laravel** (`GOOGLE_CLIENT_ID` / `GOOGLE_CLIENT_SECRET`): crea un cliente OAuth tipo **Aplicación web** en GCP y usa ese par en `.env` del admin (Socialite), no los de Android.

## Copia local (opcional, gitignored)

```bash
mkdir -p xisti-mobile/android/oauth-client-secrets
cp ~/Descargas/client_secret_980764435052-*.json xisti-mobile/android/oauth-client-secrets/
```

## iOS

Cliente OAuth **iOS** (`client_type: 2`): `980764435052-rudvg41gq53dr17pce16a5p0adsuq226.apps.googleusercontent.com`

Requisitos (google_sign_in 7.x):

1. `ios/Runner/GoogleService-Info.plist` — claves `CLIENT_ID` y `REVERSED_CLIENT_ID`
2. `ios/Runner/Info.plist` — `GIDClientID`, `GIDServerClientID`, `CFBundleURLSchemes` con reversed client id
3. Dart — `GoogleSignIn.instance.initialize(clientId: ..., serverClientId: ...)` en `social_login.dart`

Si falta `GIDClientID`, Google Sign-In falla en iOS con error de configuración.

## Cliente Web (`client_type: 3`) — obligatorio en Android

`google_sign_in` 7.x exige `serverClientId` (cliente OAuth **Aplicación web**). Debe existir en `google-services.json`:

```json
{
  "client_id": "980764435052-jvlsr21keklk5i5djg3giqqfv35054th.apps.googleusercontent.com",
  "client_type": 3
}
```

Si falta, en Firebase Console → **Authentication** → **Google** → habilitar y volver a descargar config:

```bash
firebase apps:sdkconfig ANDROID 1:980764435052:android:4f3b06c480ee148e87ee49 --project xisti-app-ad901 > android/app/google-services.json
```

En Dart también está en `lib/config/google_sign_in_config.dart` (`kGoogleWebClientId`).

## Probar Google Sign-In

```bash
cd xisti-mobile
flutter run   # debug → SHA-1 debug → cliente gfbjgj...
flutter build apk --release   # release → cliente q2dl4g...
```

Tras publicar en Play, el build de tienda usa el certificado **App Signing** → cliente `q2dl4g...`.
