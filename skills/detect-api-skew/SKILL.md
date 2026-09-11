---
name: detect-api-skew
description: Investigate and report frontend-backend API version skew, contract drift, and stale-client risks from a pull request or change set. Use when reviewing a PR that changes APIs, clients, contracts, release configuration, or cache behavior; diagnosing client failures after backend releases; or assessing independently deployed frontend and backend services.
---

# Detect API Skew

Assess whether a frontend that is older, cached, independently released, or otherwise out of sync can fail against the current backend. Produce an evidence-led risk report; do not infer an actual production incident from a static mismatch alone.

## 1. Read the pull request first

1. Obtain the PR title, description, target branch, source revision, changed files, and full diff. Use the code host integration when available; otherwise compare the checked-out PR revision with its merge base or supplied base revision.
2. Read the diff before searching the repository. Treat the PR description as context, not proof.
3. List every changed API surface: route, method, operation ID, schema/type, request field, response field, validation rule, error/status code, authentication/policy rule, generated client, cache setting, feature flag, or release workflow.
4. Identify frontend packages, backend services, API gateways, shared contract packages, deployment configuration, and test suites that own those changed surfaces.
5. Identify the delivery model. Look for independent deployments, mobile/desktop clients, service workers, CDN cache headers, immutable asset names, feature flags, API versioning, rollback policies, and deprecation windows.
6. If the PR, base revision, relevant client, server, build artifact, or deployment metadata is unavailable, continue with the available evidence and call out the limitation.

## 2. Test the rollout matrix

Use the PR base revision as the default representation of an already-deployed frontend or backend. For each changed API surface, investigate both directions:

| Scenario | Compare | Exposure |
| --- | --- | --- |
| Backend first or stale bundle | Base frontend against PR backend | Existing or cached clients call the changed server |
| Frontend first | PR frontend against base backend | Newly released client calls the old server |

Use Git to inspect unchanged base-side call sites and schemas when needed; do not limit the audit to frontend files edited in the PR. If release tags, mobile-version support, or production deployment versions are available, add those clients to the matrix and state the exact revisions used.

## 3. Map the contract

Find the authoritative contract first. Prefer generated OpenAPI, GraphQL schema, protobuf/IDL, typed RPC definitions, shared client packages, or gateway configuration over duplicated route strings.

Trace both sides of each material API change:

- Backend routes, request validation, response serializers, error mapping, authentication, pagination, and feature-flagged behavior.
- Frontend call sites, generated clients, request builders, response parsing, state selectors, error handling, retries, and assumptions about optional or enum values.
- Contract generation and publication steps, including whether the frontend consumes the same revision that the backend exposes.

Use focused searches for route paths, operation IDs, schema/type names, JSON field names, status codes, enum values, client wrappers, and release configuration. Use Git history and diffs to determine whether a change was additive, tightened, renamed, removed, or reordered.

## 4. Scan for skew hazards

Classify a finding only when it has a concrete code, contract, test, release, or configuration reference.

| Risk | Evidence to seek | Typical outcome |
| --- | --- | --- |
| Breaking request change | Newly required field, renamed parameter, narrower validation, changed encoding | Older client receives 4xx or silently changes behavior |
| Breaking response change | Removed/renamed field, scalar/object change, enum removal, changed nullability | Older client crashes, renders incorrectly, or discards data |
| Endpoint lifecycle | Deleted route, altered method/path, changed default or status code | Cached or lagging client calls an unsupported API |
| Auth and policy change | New scope, stricter session rule, altered CSRF/CORS/rate limit | Older client is unexpectedly rejected |
| Release-order exposure | Separate pipelines, no compatibility gate, frontend cache/service worker/CDN TTL | A valid old bundle reaches a new backend |
| Contract-discipline gap | Missing contract tests, client generation pinned loosely, schema not published | Future drift can ship undetected |

Treat additive optional fields and retained endpoints as lower risk unless client code is demonstrably brittle. Examine server compatibility behavior, such as accepting legacy fields, returning aliases, defaults, or supporting multiple schema versions, before reporting a breaking mismatch.

## 5. Verify the exposure

For each candidate, answer all applicable questions:

1. Can an older frontend actually reach the new behavior?
2. Does backend compatibility preserve the old request and response shape?
3. Can browser, service-worker, CDN, native-app, or rollback caching extend the stale-client window?
4. Is the mismatch protected by a coordinated release, feature flag, API version, minimum-client policy, or runtime fallback?
5. Do tests exercise old-client/new-server and new-client/old-server combinations where independent rollout permits them?

Run existing contract, integration, and client tests when feasible. When no suitable test exists, report that absence as a coverage gap rather than claiming a failure.

## 6. Report findings

Lead with confirmed high-risk findings, then medium and low risks. For every finding include:

- **Severity**: critical, high, medium, low, or informational.
- **Skew scenario**: the PR/base revisions and release order that creates the issue.
- **Evidence**: precise repository paths, symbols, contract diff, configuration, or test result.
- **Impact**: user-visible behavior and affected clients.
- **Why protection is insufficient**: only when applicable.
- **Recommended mitigation**: preserve a compatibility shim, stage an additive migration, version the API, coordinate rollout, purge/update caches, add a fallback, or add a targeted contract test.
- **Confidence**: verified, likely, or possible, with any missing evidence.

Finish with the PR/base revisions examined, changed API surfaces, checks run, assumptions, and the highest-value next action. If no issue is found, say so plainly and list the remaining blind spots, such as unavailable deployment metadata or untested generated clients.

## Guardrails

- Do not change production settings, deploy, invalidate caches, or publish contracts unless the user explicitly requests it.
- Do not recommend a breaking change merely because both sides compile in one workspace; independently deployed clients may lag.
- Keep unrelated code-quality observations out of the skew report.
