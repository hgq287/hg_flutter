## Summary

- Layer touched: `app` / `core` / `domain` / `data` / `features` / `hg_native` / `ci`
- This change adds a: **port** / **adapter** / **feature UI** / **docs** / **chore**

## Architecture

- [ ] Domain does not import Flutter, Dio, go_router, or `hg_native`
- [ ] Widgets do not import Dio or MethodChannels
- [ ] Intelligence cannot mutate money, payees, or limits

## Secrets

- [ ] No `.env` / `.env.local` / client secrets in the diff
- [ ] Tokens only go through `SecureStore`

## Test plan

- [ ] `make ci` (or the quality workflow) is green
