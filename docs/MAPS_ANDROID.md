# Google Maps en Android — XISTI

## SHA-1 del certificado debug (este equipo)

```
6E:0A:D2:2C:71:A5:D3:BE:E5:E4:1D:31:82:AA:52:4E:A6:48:AA:0B
```

Comprobar en cualquier momento:

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep SHA1
```

Keystore: `~/.android/debug.keystore` (alias `androiddebugkey`, passwords `android`).

## Dos cosas distintas en Google Cloud

| Qué configuraste | Para qué sirve | Dónde va |
|------------------|----------------|----------|
| **SHA-1** en cliente OAuth Android | **Iniciar sesión con Google** | Firebase → `google-services.json` (`certificate_hash`) |
| **API key** + **Maps SDK for Android** | **Ver el mapa** (teselas grises/beige = key inválida) | `AndroidManifest` → `com.google.android.geo.API_KEY` |

Poner el SHA-1 en OAuth **no activa** el mapa. El mapa necesita una **API key** con restricción Android (`com.app.xisti` + SHA-1 de arriba).

## SHA-1 en Firebase (ya deberían estar)

En `android/app/google-services.json`:

| SHA-1 | Uso |
|-------|-----|
| `6e0ad22c71a5d3bee5e41d3182aa524ea648aa0b` | Debug |
| `fd32ac8eee0f7f39edacd460fc0d1f71e2eeb003` | Release (`xisti-release.keystore`) |
| `3c9bd10970543e001eddbd3cedf14de79c8095b6` | Play App Signing |

## Configurar Maps en GCP (proyecto `xisti-app-ad901`)

1. [Google Cloud Console](https://console.cloud.google.com/) → proyecto **xisti-app-ad901**.
2. **APIs y servicios** → **Biblioteca** → activar **Maps SDK for Android**.
3. **Credenciales** → API key (puedes reutilizar la de iOS o crear una nueva).
4. Restricciones de la key → **Aplicaciones Android**:
   - Nombre del paquete: `com.app.xisti`
   - Huella SHA-1: `6E:0A:D2:2C:71:A5:D3:BE:E5:E4:1D:31:82:AA:52:4E:A6:48:AA:0B` (debug)
   - Añade también la SHA-1 de release si pruebas APK release.
5. La app usa la key de `android/app/google-services.json` (`api_key.current_key`). En GCP, **esa misma key** debe tener activado **Maps SDK for Android** y restricción Android (`com.app.xisti` + SHA-1).

6. Recompilar:

```bash
./scripts/build-qa-apk.sh emulator   # emulador
./scripts/build-qa-apk.sh celular    # teléfono
```

## Emulador

Usa una imagen **con Google Play** (no solo “Google APIs” antigua). Si el mapa sigue en beige, casi siempre es API key o SHA-1 no registrados en esa key.

## Rutas / Places en el backend

Autocomplete y rutas pasan por el **servidor** (`server_map_key` en `general_settings`), no por la key del manifest. Si el mapa se ve pero no hay sugerencias de dirección, revisa en admin/EC2 `map_key` y `server_map_key`.
