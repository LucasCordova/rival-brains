# Rival Brains

The week 5 state machines lecture demo: one arena, one Bearcat, one rival,
and a brain that gets smarter one branch at a time (demo1 and demo2 on
Tuesday, demo3 and demo4 on Thursday). This is the lecture running as a game.
## The demos

| Branch | The rival's brain |
| --- | --- |
| `demo1` | No brain: chase forever. Relentless, dumb, and unfixable without states. |
| `demo2` | PATROL and CHASE: sight range, give-up range, and a tint per state. |
| `demo3` | FRIGHTENED: the fig forces a transition from outside; a timer walks it back. |
| `demo4` | Machines all the way up: TITLE, PLAYING, CAUGHT. Screens are states too. |
| `main` | Same as `demo4`. |

## Running a demo

```bash
git checkout demo1
```

Open `project.godot` in Godot (standard build) and run. `project.godot` is
identical on every branch (actions and layers are baked in from demo1), so
switching branches only touches scenes and scripts: accept Godot's reload
prompt and run again. Movement is arrows or WASD; Space drives the menus in
`demo4`.

## The layer map

| Node | Layer | Mask | In English |
| --- | --- | --- | --- |
| Walls | world | (none) | I am the world. |
| Player | player | world | Walls stop me. |
| Rival | rivals | world | Walls stop me too; my brain does the rest. |
| Fig | snacks | player | I notice the player, then I am eaten. |
