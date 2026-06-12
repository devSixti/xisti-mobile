# XISTI — Capturas tiendas (1080×2400)

Ruta canónica: `store-assets/screenshots/es/png/`  
Copia de trabajo: `../../artifacts/store-screenshots/`

| # | Archivo | Pantalla | Texto Play / App Store |
|---|---------|----------|------------------------|
| 1 | `01-rider-home.png` | Home pasajero | **Tu ciudad, en un mapa.** Moto, Carro y envíos urbanos en Medellín. |
| 2 | `02-rider-service-modes.png` | Modos de servicio | **Elige cómo moverte.** Transporte o encomiendas en la misma app. |
| 3 | `03-rider-searching.png` | Radar / búsqueda | **Tú pones el precio.** Negocia en pasos de $500 COP mientras llega tu conductor. |
| 4 | `04-rider-tracking.png` | Viaje en curso | **Sigue cada metro.** Ubicación en vivo, ETA y perfil del conductor. |
| 5 | `05-rider-history.png` | Historial | **Todo queda registrado.** Viajes, tarifas y recibos a un toque. |
| 6 | `06-driver-home.png` | Home conductor | **Conéctate cuando quieras.** Online, radio de búsqueda y solicitudes cercanas. |
| 7 | `07-driver-request.png` | Solicitud entrante | **Nueva solicitud.** Origen, destino y tarifa del pasajero al instante. |
| 8 | `08-driver-detail.png` | Detalle antes de aceptar | **Tú decides.** Revisa el viaje, oferta tu precio y acepta. |
| 9 | `09-driver-active.png` | Viaje activo conductor | **Gestiona el servicio.** Recogida, ruta y estados desde el móvil. |
| 10 | `10-rider-wallet.png` | Billetera | **Paga con saldo.** Recarga Wompi desde $13.000 COP. |

## Regenerar

```bash
DISPLAY=:0 ./scripts/xisti-start-emulators.sh
./scripts/xisti-store-raw.sh          # captura en vivo (requiere login OK)
./scripts/xisti-store-restore.sh    # restaurar mejores capturas previas
./scripts/xisti-publish-store-shots.sh
PUSH_EC2=1 ./scripts/xisti-publish-store-shots.sh
./scripts/xisti-deploy-landing.sh
```

## QA

- Usuarios: pasajero `3001234567`, conductor `3009876543`, OTP `123456`
- Resolución: **1080×2400** sin marcos de marketing
- API auth: `scripts/xisti-api-auth.sh` debe usar clave EC2 (no `CHANGE_ME` local)
