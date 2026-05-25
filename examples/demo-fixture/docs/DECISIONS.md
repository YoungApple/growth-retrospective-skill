# ADR log (demo fixture)

## ADR-0001: Use TypeScript everywhere
**Date**: 2026-05-11
**Status**: accepted
Standardize on TS for backend + tooling. Avoids JS/TS context-switching.

## ADR-0002: Postgres + Supabase
**Date**: 2026-05-12
**Status**: accepted
Solo-dev capacity favors managed Postgres. Supabase chosen over alternatives because of built-in auth + storage.

## ADR-0003: Caching layer in front of LLM calls
**Date**: 2026-05-14
**Status**: superseded by ADR-0005
Initial decision to cache LLM response by prompt hash. Implemented in PR #18.

## ADR-0004: silent_watchdog ErrorKind
**Date**: 2026-05-17
**Status**: accepted
Surface backend stall events to iOS as a typed error kind so the user gets a toast instead of silence.

## ADR-0005: Remove the LLM caching layer
**Date**: 2026-05-19
**Status**: accepted (supersedes ADR-0003)
After 5 days of production: cache hit rate <8%, cache invalidation logic added 200 lines of complexity, and 2 incidents traced to stale cached responses. Net cost > net benefit. Cache layer ripped out in PR #24.

**Reversal evidence**: ADR-0003 was 5 days old when reversed. Highest-information signal so far on this project.

## ADR-0006: 9-type entity taxonomy
**Date**: 2026-05-21
**Status**: accepted
Person / Theme / Project / Task / Place / Event / Food / Decision / Org. Settles a debate from `memory-research-2026-05.md` and `-v2.md`.

## ADR-0007: Per-session meeting-notes
**Date**: 2026-05-23
**Status**: accepted
Add an additive `meeting_notes` column rather than replacing `key_moments`. Backward compatible.
