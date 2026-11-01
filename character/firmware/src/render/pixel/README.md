# The pixel face

Updated 2026-11-01. Pixel's face, which the CYD draws: designs baked from
the animation bank into `firmware/include/faces.h` by facegen
(`tools/facegen/`), played on the 8-bit canvas. What the engine asks of
any face is in the engine's `characters/CHARACTER.md` §9; this is what's
the pixel face's own.

## Its moods

`faces.h` draws 13 moods (`kMoodNames`), and names every mood (`kNames`)
with the drawn one whose designs it wears (`kWears`): itself, or the one
the pack's table, `tools/borrowed.json`, lends it. The borrowers point at
the same designs, so they cost no frames.

## Its colours

The designs' colours are the face's own: `faces.h`'s `kColors`, colour 0
the black field. As it's made, the face writes them into the canvas
palette from the engine's `kFaceColorBase` (`render::useFaceColors`),
colour i at `kFaceColorBase + i - 1`, before the sage and clay of the
engine's last two entries. No other pack carries this file.

## What the Mac reads: `mac/faces.json`

facegen writes it into the pack. It holds:

- `moods`: every mood, in the pack's order. The Mac never times a
  reaction or picks its variation: the board does, by `faces.h` and
  `sfx.h`.
- `box`, `colors` and `faces`: the popover's still faces, each as
  `<mood>/<look>` for `idle`, `working` and `needs_you`, and
  `<startup_mood>/asleep`. A face it lacks shows the mood's idle one.
