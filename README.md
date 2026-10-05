# Smartico Swift SDK

<!-- These badges only resolve once github.com/smarticoai/smartico-swift-sdk is
     public (and, for the Swift Package Index one, submitted to
     swiftpackageindex.com). Until then they render as "not found". -->
[![Latest tag](https://img.shields.io/github/v/tag/smarticoai/smartico-swift-sdk?label=version)](https://github.com/smarticoai/smartico-swift-sdk/tags)
[![Swift Package Index](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsmarticoai%2Fsmartico-swift-sdk%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/smarticoai/smartico-swift-sdk)

Swift client for the Smartico gamification platform. Connects over
WebSocket, identifies the user, and exposes the whole public API as typed
`async throws` functions.

Foundation only — no UIKit, no WebKit. The library runs in an iOS app and in a
plain macOS process alike, which is what lets the parity tool run on the Mac
without a simulator. Hosting the wrapper pages in a `WKWebView` is
the app's job; the SDK only speaks their message protocol (see below).

## Installing

SwiftPM resolves the package straight from its git repository — there is no
binary and no registry. In `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/smarticoai/smartico-swift-sdk", from: "0.1.0"),
],
targets: [
    .target(name: "MyApp", dependencies: [
        .product(name: "SmarticoPublicAPI", package: "smartico-swift-sdk"),
    ]),
],
```

In an Xcode project: **File → Add Package Dependencies…**, paste
`https://github.com/smarticoai/smartico-swift-sdk`, keep "Up to Next Major
Version", and add the `SmarticoPublicAPI` library to the app target.

Use the version in the badge above — it tracks the latest tag, so it cannot go
stale the way a number written here would.

That is everything. The package has **zero dependencies**: the socket is
`URLSessionWebSocketTask`, HTTP is `URLSession`, JSON is a small value type of
its own (`JSON`, `Serialization/JSON.swift`). Nothing else is resolved,
downloaded or linked.

Until the repository is public and tagged — or while working on the SDK
itself — depend on a local checkout instead:

```swift
.package(path: "../smartico-swift-sdk"),
```

SwiftPM names a package after the last component of its URL or path, so as
long as the checkout keeps the directory name `smartico-swift-sdk`, the
`.product(…)` line stays the same. In Xcode, the same is **File → Add Package Dependencies…
→ Add Local…**.

## Quick start

```swift
import SmarticoPublicAPI

Smartico.initialize(
    labelKey: "<your-label-key>",
    options: SmarticoOptions(
        brandKey: "<your-brand-key>",
        // Called by the SDK itself after connecting and on every reconnect.
        // Return nil while nobody is logged in. The hash expires — fetch a
        // fresh one from your backend on every call, never cache it.
        getUser: {
            guard isLoggedIn() else { return nil }
            return SmarticoUser(extUserId: extUserId, hash: await fetchHash())
        }
    )
)

let levels = try await Smartico.api.getLevels()
let missions = try await Smartico.api.getMissions()
```

There is no manual `identify()`. The SDK calls `getUser` on its own and sends
IDENTIFY as soon as it has credentials.

Four things to know about the call shape:

- The entry point is `Smartico.initialize(labelKey:options:)` — `init` is not a
  legal name for a static method.
- API methods are `async throws`. Failures are
  `SmarticoError` cases: `.timeout(cid:)`, `.connectionClosed`,
  `.notInitialized`, `.http(_:)`, `.decoding(_:)`. Four cannot fail and say
  so: `getLeaderBoardSettings()` and `getUserLevelExtraCounters()` read session
  state without a round-trip (`async` only), and the fire-and-forget
  `reportImpressionEvent` / `reportClickEvent` are plain functions.
- `Smartico.on(…)` returns a `SubscriptionToken`, and `Smartico.off(token)`
  removes it — a Swift closure has no identity to remove it by.
- Listener callbacks run **on the main queue**, in order. Every iOS host is a UI
  host, so a callback can touch UI state directly.

The environment is derived from the label key — a 38-character key ends in
`-<env digit>`, so `Env.wsUrl(_:)` resolves the right host without any
configuration. See `Transport/Protocol.swift`.

## What's in the API

63 of the 72 WSAPI methods, as `extension SmarticoApi` methods split across 16
per-domain files (`Api/LevelsApi.swift`, `Api/MissionsApi.swift`, …), with the
method names, parameter names and defaults of the JS SDK. The surface stays
flat for callers:

```swift
let tournaments = try await Smartico.api.getTournamentsList()
let badges = try await Smartico.api.getBadges()
let purchase = try await Smartico.api.buyStoreItem(item_id: itemId)
let inbox = try await Smartico.api.getInboxMessages()
```

Not implemented: the nine `gamePick*` methods.

Beyond the data surface, the facade covers:

- **Server pushes** — `let token = Smartico.on("props_change") { props in … }`,
  by friendly name or raw cid (`Smartico.on(108)`). Subscriptions survive
  re-init; `Smartico.off(token)` ends one.
- **Engagement popups** — cid 110 is consumed internally, deduped by
  `engagement_uid`, and queued. The host decides *when* to show one:
  `takeEngagement()` / `onEngagementsChanged { … }` (which returns its
  unsubscribe closure). Each popup is then driven by a `PopupBridgeSession` —
  see the next section.
- **Deep links** — `Smartico.dp("dp:gf_missions")`, routed through bindings you
  register with `configureDp(_:)` (a `DpBindings` conformer: open a screen, a
  widget, a URL). Grammar: `dp:<action>[&key[=value]]*`.
- **Push notifications** — `registerPushToken(_:platform:appPackageId:)` and
  `reportPushEngagement(_:ref:)`, which queues reports fired before identify
  (cold-start taps) and flushes them. On iOS the token is the **APNs device
  token as lowercase hex**, and the platform is `PushPlatform.NATIVE_IOS`. The
  SDK sends whatever string it is given; the conversion is the app's:

  ```swift
  let hex = deviceToken.map { String(format: "%02x", $0) }.joined()
  Smartico.registerPushToken(hex, platform: PushPlatform.NATIVE_IOS, appPackageId: Bundle.main.bundleIdentifier)
  ```

## Method reference

Every method, its parameters and every field it returns are documented once,
in the JS SDK's repository — one page per method under
[`smarticoai/public-api/docs/capabilities`](https://github.com/smarticoai/public-api/tree/main/docs/capabilities)
(what a call returns, field by field) and
[`docs/ui`](https://github.com/smarticoai/public-api/tree/main/docs/ui)
(how a screen is meant to use it). This SDK does not repeat them: the method
names, parameter names and result fields are the same, and that is checked
mechanically before every release (`npm run signatures` for the call shape,
the parity capture for the fields — see Verification).

The pages are written for JavaScript, so read them with this translation:

| In the docs | In Swift |
|---|---|
| `_smartico.api.getMissions()` | `try await Smartico.api.getMissions()` |
| `getRaffleDrawRun({ raffle_id, run_id })` — one options object | `getRaffleDrawRun(raffle_id:run_id:)` — the same names as argument labels |
| `Promise<TMissionOrBadge[]>` | `[TMissionOrBadge]` |
| `number` | `Int64` for ids, counters and timestamps, `Double` for everything else |
| a field that may be `undefined` | an optional (`String?`, `Int64?`, …) — every result field is optional |
| `onUpdate` callback | does not exist — the 30-second cache behind it is not ported; every call hits the socket, and server pushes (`Smartico.on("reload_achievements")`, …) tell you when to call again |
| `import { TMissionOrBadge } from '@smartico/public-api'` | nothing to import — the type is in this module, under the same name |
| the nine `gamePick*` methods | not implemented |

The types are generated from `@smartico/public-api` **0.0.434** (the version in
each file's header under `Types/`), so the docs at that version are the ones
that match. The field descriptions travel with the types: the generator copies
the JSDoc onto every struct and field, so Xcode's Quick Help on
`TMissionOrBadge.is_completed` shows the same text as the page.

## Hosting the wrapper pages in WKWebView

Popups and hosted widgets (mini-games, the gamification UI) are Smartico web
pages — `WRAPPER_POPUP_URL` and `WRAPPER_GF_URL` — that talk to the app over a
small message protocol. The SDK implements that protocol in
`PopupBridgeSession` and `WidgetBridgeSession`; the app supplies the
`WKWebView` and two pipes:

- **User agent.** Set `webView.customUserAgent = SMTO_WRAPPER_UA`. The pages
  require it (the integration guide's `device_type` WRAPPER).
- **Page → app.** Register a `WKScriptMessageHandler` under the name
  **`SmarticoBridge`**. The tracker's `NativeBridge.ts` looks for
  `window.webkit.messageHandlers.SmarticoBridge` and posts to it, so no JS shim
  is needed. Hand `message.body` to the session untouched —
  `handleMessage(body:)` accepts the `String` a page posts and the
  `[String: Any]` WebKit makes of a posted object.
- **App → page.** The popup session calls your `injectJs(_:)` with a complete
  `window.dispatchEvent(new MessageEvent('message',{data:…}))` statement; run it
  with `evaluateJavaScript`.

```swift
import SmarticoPublicAPI
import WebKit

final class PopupWebHost: NSObject, WKScriptMessageHandler, PopupSessionHooks {
    let webView: WKWebView
    private var session: PopupBridgeSession?

    init(payload: EngagementPayload, labelKey: String, brandKey: String, extUserId: String) {
        webView = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        super.init()
        webView.customUserAgent = SMTO_WRAPPER_UA
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.alpha = 0                       // add it to your view hierarchy now; it stays invisible
        webView.isUserInteractionEnabled = false
        webView.configuration.userContentController.add(self, name: "SmarticoBridge")
        session = Smartico.createPopupSession(payload: payload, hooks: self)
        // the popup wrapper gets its content injected, so no hash here
        let url = buildWrapperUrl(labelKey: labelKey, brandKey: brandKey, extUserId: extUserId, wrapper: WRAPPER_POPUP_URL)
        webView.load(URLRequest(url: URL(string: url)!))
    }

    func userContentController(_ controller: WKUserContentController, didReceive message: WKScriptMessage) {
        session?.handleMessage(body: message.body)
    }

    func injectJs(_ js: String) {
        webView.evaluateJavaScript(js, completionHandler: nil)
    }

    func onReadyToShow() {
        webView.alpha = 1
        webView.isUserInteractionEnabled = true
    }

    func onClose() {
        webView.alpha = 0
        webView.isUserInteractionEnabled = false
        webView.configuration.userContentController.removeScriptMessageHandler(forName: "SmarticoBridge")
        session = nil
        // …and take the next popup, if any
    }
}
```

Two rules that are easy to get wrong:

- **Keep the popup WebView in the hierarchy, invisible, until `onReadyToShow`.**
  The wrapper page reports "ready to be shown" only after it has loaded and
  rendered. A WebView created only when it should become visible never gets
  there — the popup is taken off the queue and then silently never appears.
  Start it with `alpha = 0` and no touches; it loads and runs its JS; reveal it
  when the session says so.
- **Break the retain cycles on close.** The session holds its hooks strongly,
  and `WKUserContentController` holds its message handler strongly. When one
  object is the hooks, the handler and the session's owner — as above — remove
  the handler and drop the session in `onClose`, or the page, the WebView and
  your host are never freed.

A widget works the same way through `Smartico.createWidgetSession(hooks:)`,
minus the inject step: it gets identity and its deep link from the URL —
`buildWrapperUrl(…, base:, hash:, dp:)`, with `base` set to the server-built
`native_app_gf_url` when identify supplied one (it is mirrored into
`Smartico.getPublicProps()`). Its hooks are `onReady()` (hide your loader),
`onClose()` (pop the screen) and `onNavigateInWidget(_:)` — a widget deep link
emitted inside the widget; reload the same WebView with that `dp` in its URL
instead of routing it globally.

## Project layout

```
Package.swift                  one library product, SmarticoPublicAPI; no dependencies
Sources/SmarticoPublicAPI/
  Smartico.swift               the facade
  Types/                       GENERATED — do not edit (345 files)
  Api/                         hand-written, one file per domain
  Transport/                   WebSocket actor, reconnect, identify, request/response by cid
  Engagement/                  popup queue + dedupe, popup bridge session
  Dp/                          deep-link router
  Bridge/                      native bridge for hosted widgets, wrapper URLs
  Serialization/               JSON value type, wire-tolerant decoding
Tools/ParityDump/              live capture tool — NOT part of the product
codegen/                       TypeScript, generates Types/ — a separate npm project
```

`Types/` is generated from the `@smartico/public-api` TypeScript declarations
and **committed**: `swift build` must never need node. Everything else is
written by hand — the generator produces contracts only, never logic.

`Tools/ParityDump` is an executable target, not a product: `swift build`
compiles it so it cannot rot unnoticed, but a package that depends on this one
only ever sees the `SmarticoPublicAPI` library.

## Build

```bash
swift build
```

It runs on the Mac itself — macOS 12 is a declared platform for exactly this —
so it needs no simulator.

That the package compiles for iOS — the platform that matters — is a separate
check. It needs no signing team:

```bash
xcodebuild -scheme SmarticoPublicAPI -destination 'generic/platform=iOS Simulator' -derivedDataPath build CODE_SIGNING_ALLOWED=NO build
```

It puts its derived data in `build/` (gitignored), the directory the parity
capture also writes to — `rm -rf build` afterwards clears both.

Requirements: to consume the package, Xcode 15 / Swift 5.9 or newer and iOS 15
or newer. The manifest is `swift-tools-version: 5.9` and the sources build in
Swift 5 language mode, so newer toolchains, Swift 6 included, compile them
unchanged. This repository is developed with Xcode 26.6 (Swift 6.3.3).

## Regenerating the types

After bumping `@smartico/public-api`:

```bash
cd codegen && npm ci && npm run gen
```

(`npm install` instead of `npm ci` when bumping the pinned version.)
`npm run gen` rewrites `Sources/SmarticoPublicAPI/Types/` from scratch; then
review the diff and rebuild. It deletes the output directory first, so
hand-edits to `Types/` do not survive — anything the mechanical mapping cannot
decide belongs in `codegen/mappings.ts`:

- `INTEGRAL_NAME_PATTERNS` — TypeScript's `number` is both `Int64` and
  `Double`; the field name decides which.
- `FIELD_TYPE_OVERRIDES` — where the declaration disagrees with the wire.
- `EXTRA_FIELDS` — fields the server sends but the declarations omit.
- `INLINE_TYPES` — anonymous object literals worth a real struct.
- `SKIP_DECLARATIONS` — web-embed plumbing that has no meaning here.

Check the method surface against WSAPI afterwards, still in `codegen/`:

```bash
npm run signatures
```

Offline: method names and parameters vs the `.d.ts`. It should end with
`implemented: 62/71` and `signature issues: 0`.

## Releasing

There is nothing to upload and nothing to sign: SwiftPM reads versions from git
tags, so a release is a semver tag pushed to the public repository.

```bash
git tag 0.1.0
git push origin 0.1.0
```

Consumers on `from: "0.1.0"` pick it up on their next resolve (Xcode:
**File → Packages → Update to Latest Package Versions**; command line:
`swift package update`). The repository has to be public for that to work
without GitHub credentials.

Nothing in the package hardcodes its version — the tag is the version.
`SDK_VERSION` (`smartico-swift-0.0.1`, sent as `tracker_version` at INIT) is a
protocol client id and does not follow the tag.

Worth running before a tag: `swift build`, the iOS `xcodebuild` line above,
and `npm run signatures`. None of them needs node except the last —
`Types/` is committed, so releasing never runs the generator.

Optionally, submit the repository to the [Swift Package
Index](https://swiftpackageindex.com/add-a-package) once it is public. It then
picks up new tags on its own, builds the package on its platforms, and the
badge above starts resolving. Nothing else depends on it — SwiftPM never reads
the index.

## Verification

Two harnesses, and they answer different questions.

**`npm run signatures`** — offline. Reads `Api/*.swift` and the pinned `.d.ts`
and compares method names and parameters. Catches a method that was never
ported or whose signature drifted. Run it after every regeneration.

**Parity** — live. The contracts are generated, so they can't be wrong; the
hand-written transforms in `Api/` can. Parity captures a real server response,
runs it through both the reference implementation the types are generated from
and ours, and diffs the results field by field.

Because it talks to a live label, it needs credentials. They come from the
environment:

```
SMARTICO_LABEL_KEY   the label key
SMARTICO_BRAND_KEY   the brand key
SMARTICO_EXT_USER    the external user id to identify as
SMARTICO_SALT        optional; the identify secret — defaults to "null", which demo labels use
```

```bash
cd codegen && npm ci && cd ..
export SMARTICO_LABEL_KEY=<label key> SMARTICO_BRAND_KEY=<brand key> SMARTICO_EXT_USER=<external user id>
swift run ParityDump --check
swift run ParityDump
cd codegen && npm run parity
```

All from the repository root. `npm ci` is once per clone (`node_modules` is
not committed). `--check` prints
which credentials were picked up, the endpoint and the output directory, without
connecting. The capture itself needs nothing but the Swift toolchain; only the
diffing half needs node.

`ParityDump` captures 14 domains into `build/parity/` of the package, wherever
it is run from — for each one the raw response (`<domain>.raw.json`) and what
our transform made of it (`<domain>.swift.json`), plus a `meta.json` recording
which environment the capture came from (avatar transforms expand `avatar_id`
against that host, so the diff needs to know). `npm run parity` then reports per
field: `MISSING in swift`, `extra in swift`, or `value differs`.

The raw half is the reply to the same cid (and the same default payload) the
typed getter sends; the other half is the getter's return value encoded with
`JSONEncoder`. The tool uses the library's public surface only, like any app.

On a real label the identify secret lives on the operator's backend, so a
capture only works against a label whose secret you hold.

Two things parity cannot tell apart from a real bug: a stale dump compared
against freshly patched code, and a time-dependent field (a mission's
`availability_status` flips when its window closes — and the two halves are two
requests a moment apart). Re-capture before concluding anything.

## Wire tolerance

The server speaks JSON numbers: the same field can arrive as `5`, `5.0` or
`1.37861765E8`, and booleans sometimes ride as `0`/`1`/`"true"`. A synthesized
`Decodable` throws on every one of those. So every generated struct carries its own
`init(from:)` that reads each field through the lenient helpers in
`Serialization/Lenient.swift` (`lenientInt64`, `lenientDouble`, `lenientBool`,
`lenientString`, …):

- an integral field takes `5`, `5.0`, `1.37861765E8` and `"5"`;
- a `Bool` takes `true`/`false`, `0`/`1`, `"true"`/`"false"`, `"1.0"`;
- a number or bool arriving for a `String` field becomes its text;
- a missing key or an explicit `null` is `nil`, never an error;
- unknown keys are ignored — the server adds fields freely.

`encode(to:)` stays synthesized. Every generated field is optional, and the
memberwise `init` defaults every argument to `nil`, for the same reason: a
payload that omits a field must not fail to parse.

## License

MIT — see `LICENSE`.
