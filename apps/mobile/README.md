# apps/mobile

The iOS and Android application.

**Getting started**

```bash
# Expo (React Native)
npx create-expo-app apps/mobile
# or Flutter
flutter create apps/mobile
```

**Note:** take shared types from `packages/types` and the API client from
`packages/sdk`. The API URL comes from `.env`, never hardcoded.

**Not using it?** Delete this directory. `make` and CI keep working.
