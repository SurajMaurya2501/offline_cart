# OfflineMart (Offline-First)

A Flutter app built as OfflineMart with an **offline-first** approach. Data is synced once from the API into a local SQLite database (via **Drift**), then the whole app runs off that — with **GetX** for state management and **Google Sign-In** for auth.

---

## What It Does

- **Google Sign-In & Session Persistence** — log in once, session is saved locally, returning users skip straight to the dashboard.
- **Initial Sync** — pulls categories and products from DummyJSON on first login with a progress dialog; retry-safe if the network drops mid-sync.
- **Offline-First** — screens never call the API directly, they just watch Drift streams through GetX controllers, so the app works fully offline after sync.
- **Dashboard** — profile, sync stats, last sync time, quick actions.
- **Categories & Products** — browse, search, sort (price/rating), pull-to-refresh.
- **Product Details** — image carousel, pricing, discount, stock, rating.
- **Favourites** — reactive wishlist stored in SQLite.
- **Cart** — quantity controls, live subtotal/discount/total.

---

## Screenshots

| | | |
|---|---|---|
| [Splash](screenshots/splash_screen.jpeg) | [Login](screenshots/login_screen.jpeg) | [Initial Sync](screenshots/sync_initial_data.jpeg) |
| [Dashboard](screenshots/dashboard_screen.jpeg) | [Manual Sync](screenshots/dashboard_manual_sync.jpeg) | [Categories](screenshots/categories.jpeg) |
| [Products Listing](screenshots/products_listing.jpeg) | [Product Details](screenshots/product_details.jpeg) | [Favourites](screenshots/favorites.jpeg) |
| [Cart](screenshots/cart.jpeg) | | |

Architecture diagram: [docs/flutter_product_catalog_architecture.png](docs/flutter_product_catalog_architecture.png)

---

## Tech Stack

- Flutter (Dart 3)
- GetX — state management
- Drift (SQLite) — local DB with DAOs and `watch()` streams
- Dio — networking (sync only)
- Google Sign-In + Firebase Core — auth
- `internet_connection_checker_plus` — connectivity

---

## Folder Structure

```text
lib/
├── core/extensions/     # Helper extensions
├── data/
│   ├── local/           # Drift DB, DAOs, tables
│   ├── models/          # JSON models
│   └── network/         # Dio client, Google Auth
├── presentation/
│   ├── controllers/     # GetX controllers
│   ├── screens/         # auth, cart, dashboard, favourites, products, splash
│   └── widgets/
└── main.dart
```

## Future Improvements

- Auto-sync on reconnect instead of manual refresh only
- Pagination instead of fetching all products upfront

---

## Getting Started

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # if tables/DAOs change
flutter run
```

## Build

```bash
flutter build apk --release
```
