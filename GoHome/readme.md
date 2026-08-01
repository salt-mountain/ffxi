# GoHome

A small Windower addon that watches your incoming **/tell**s for a specific
person saying a specific phrase, and — after a short randomized delay — either
uses a configured item (default: **Instant Warp**) or tells them you don't have
it. Built-in cooldown so it can't be spammed.

## How it works

- Listens to the incoming chat packet (0x017) and only reacts to **tells**
  (not say/party/linkshell/shout).
- The sender must be in your **allowed list** (case-insensitive).
- The message must exactly match the **trigger phrase** (case-insensitive, trimmed).
- On a valid trigger:
  1. A **cooldown** gate runs first — repeat triggers within the cooldown are
     silently ignored, so nobody can spam you into warping repeatedly.
  2. A **randomized jitter** delay (default 1.5–4.0s) passes so the response
     isn't instant/robotic.
  3. If you **have** the item → it's used (`/item "Instant Warp" <me>`).
     If you **don't** → you get a log line, and (optionally) a `/tell` back to
     the sender saying you can't.

## Install

Drop the `GoHome` folder into `Windower/addons/`, then in game:

```
//lua load GoHome
```

To load automatically every session, add `lua load GoHome` to your
`Windower/scripts/init.txt`.

## Configuration

Edit the `config` block at the top of `GoHome.lua`, or use the in-game commands.
Key settings:

| Setting | Default | Meaning |
|---|---|---|
| `allowed_senders` | `{ 'Aurievaryn' }` | Names allowed to trigger (case-insensitive) |
| `trigger_phrase` | `go home` | Exact phrase to match (case-insensitive) |
| `item_name` | `Instant Warp` | Item to use |
| `cooldown_seconds` | `30` | Anti-spam window |
| `jitter_min` / `jitter_max` | `1.5` / `4.0` | Randomized response delay range |
| `reply_on_missing` | `true` | `/tell` the sender when you lack the item |

## Commands

```
//gh list             Show current allowed senders, phrase, item, cooldown
//gh add <name>       Add an allowed sender
//gh remove <name>    Remove an allowed sender
//gh phrase <text>    Change the trigger phrase
//gh test             Run the item-check + action once (no cooldown), on yourself
```

(`//gohome` also works as the full command name.)

## Notes / limitations

- Item must be in your **main inventory** to be used (that's how FFXI's `/item`
  works for scrolls like Instant Warp).
- Changes made with `//gh add/remove/phrase` last until you reload the addon.
  For permanent changes, edit the `config` block in `GoHome.lua`.
- This runs an action in response to someone else's message. Keep the allowed
  list and phrase tight (they already default to tell-only + exact match +
  cooldown) so it can't fire accidentally or be abused.
