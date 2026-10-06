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
| `demo5` | Data-driven: the numbers move into `RivalStats` (.tres files); swap the rival's personality in the Inspector. |
| `demo6` | UI and a global: a HUD scene, a pause menu, and a `Scoreboard` autoload that outlives a scene reload. Tags `demo6-lap1` and `demo6-lap2` are the catch-up checkpoints. |
| `main` | Same as `demo4`. |

## Running a demo

```bash
git checkout demo1
```

Open `project.godot` in Godot (standard build) and run. `project.godot` is
identical on every branch (actions and layers are baked in from demo1), so
switching branches only touches scenes and scripts: accept Godot's reload
prompt and run again. The one exception is `demo6`, which registers an autoload
in `project.godot`: after checking it out (or leaving it), use Project, then
Reload Current Project. Movement is arrows or WASD; Space drives the menus from
`demo4` on; Escape pauses in `demo6`.

## The layer map

| Node | Layer | Mask | In English |
| --- | --- | --- | --- |
| Walls | world | (none) | I am the world. |
| Player | player | world | Walls stop me. |
| Rival | rivals | world | Walls stop me too; my brain does the rest. |
| Fig | snacks | player | I notice the player, then I am eaten. |
