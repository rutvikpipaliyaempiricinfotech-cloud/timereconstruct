# timereconstruct

Flutter client for the Supabase-backed reader app.

## Running it

Config is injected at build time. Nothing is committed.

```
flutter run \
  --dart-define=SUPABASE_URL=https://<project-ref>.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=<publishable-key>
```

The publishable (anon) key is the only key the client ever sees. Service role
keys do not belong in this repo or on a device.

## Layout

| Path | What lives there |
| --- | --- |
| `lib/auth/` | Session cache, refresh, and the token callback handed to the SDK |
| `lib/auth/legacy/` | Pre-rewrite manager, kept for the migration tool |
| `lib/lifecycle/` | Foreground and connectivity handling |
| `lib/data/` | Gateway plus one repository per table |
| `lib/screens/` | One screen per repository |

## Session handling

We supply our own `accessToken` callback to `Supabase.initialize`, so token
resolution runs through `lib/auth/token_provider.dart` on every request rather
than through GoTrue's session. `RefreshScheduler` refreshes ahead of expiry,
and `ConnectivityMonitor` retries once the network returns.

## Screens and tables

| Screen | Table |
| --- | --- |
| Feed | `posts` |
| Profile | `profiles` |
| Notifications | `notifications` |
| Explore | `public_posts` |
| Comments | `comments` |
| Settings | `settings` |
| Announcements | `announcements` |
| Feature flags | `feature_flags` |
