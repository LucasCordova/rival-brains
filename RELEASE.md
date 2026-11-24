# Release checklist

Walk this list top to bottom for every build that leaves the team: a playtest
build, the showcase build, and the public release. Copy it into your own repo
and change the names.

## The build

- [ ] The version in Project Settings (Application, Config, Version) is the one you are about to ship.
- [ ] Exported from a clean clone of `main`, so the build contains only what is committed.
- [ ] A release export (Export With Debug is off).
- [ ] You played the exported build, outside the editor, from the title screen to a win and to a loss, and back to the title.
- [ ] Someone who did not make the export played it on a second machine or a second browser.
- [ ] Debug helpers are gone from the release build (the FPS label, cheat keys, test levels).
- [ ] Sound plays, and the settings from the pause menu still save.

## The page

- [ ] The title, a one-sentence pitch, and the controls are on the page.
- [ ] A cover image and at least three screenshots of real play.
- [ ] Credits: every team member, and every asset you did not make, with its license.
- [ ] The embed size matches the game window (1152 by 648 for Rival Brains), and the fullscreen button is on.
- [ ] You opened the page in a private browser window and played the game there.

## The repo

- [ ] `export_presets.cfg` is committed. `build/` is ignored.
- [ ] The commit you exported is tagged with the version (`git tag v1.0.0`, then `git push origin v1.0.0`).
- [ ] The README says how to play, links the itch.io page, and names the version.
