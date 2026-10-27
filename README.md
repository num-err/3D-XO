# 3D Tic-Tac-Toe — Atari Remake in TIC-80

A remake of Atari's *3-D Tic-Tac-Toe* (1980) for the [TIC-80](https://tic80.com) fantasy console, written in Lua. Two players take turns placing X and O on a 4×4×4 cube; the first to get four in a row along any straight line through the cube wins.

Built with [Germain Hirwa](https://github.com/ghirwa1) for CS 86: Game Systems at Swarthmore College.

---

## How to play

| Key | Action |
|---|---|
| Arrow keys | Move the cursor within a layer |
| `Z` / `X` | Move up / down a layer |
| `A` | Place your mark |
| Any key after a win or draw | Start a new game |

The board is drawn as four stacked layers (L1–L4) in a slanted perspective, so you can see the whole cube at once. Wins can run along a row, across a layer, straight down through the layers, or diagonally through the entire cube — which is what makes the 3D version much harder to read than the 2D game.

## How it works

**Board.** The cube is stored as a 3D array indexed by layer, row, and column, with `0` for empty, `1` for X, and `2` for O.

**Win detection.** Instead of hard-coding all 76 possible winning lines, the game checks the 13 distinct directions a line can run in 3D:

```lua
{1,0,0}, {0,1,0}, {0,0,1},                    -- along one axis
{1,1,0}, {1,-1,0},                            -- diagonal across a layer
{1,0,1}, {1,0,-1}, {0,1,1}, {0,1,-1},         -- diagonal across a side wall
{1,1,1}, {1,1,-1}, {1,-1,1}, {1,-1,-1},       -- diagonal through the whole cube
```

After each move, it walks forward and backward from the new mark in each direction and counts matching marks, staying inside the board. Four in a row is a win; a full board with no winner is a draw.

**Rendering.** Each cell is drawn as a small parallelogram with TIC-80's line primitives, offset per row to give the layers depth, with the current player's cursor highlighted.

## Running it

**In TIC-80:**

```
cd game
tic80 --fs .
load game.lua
run
```

**In a browser:** open `game/index.html` (the HTML export) from a local web server, e.g. `python3 -m http.server` inside `game/`.

## Files

```
game/
  game.lua            main game source
  exported_game.lua   bundled build (with middleclass / std.strict)
  index.html          HTML export, playable in the browser
writeup/              design write-up
```
