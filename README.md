# Pigment

A terminal color library for Lean 4.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

## Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [Examples](#examples)
- [API Reference](#api-reference)
- [Configuration](#configuration)
- [Contributing](#contributing)

## Features

- Chainable API using the pipe operator
- Multiple color modes: 8, 16, 256, and 24-bit RGB
- Automatic terminal capability detection
- Text styling (bold, italic, underline, dim, etc.)
- Hex color codes support
- Inline color composition
- Zero dependencies

## Installation

Add Pigment to your `lakefile.toml`:

```toml
[[require]]
name = "Pigment"
git = "https://github.com/RSoulatIOHK/Pigment"
rev = "main"
```

Then import it in your Lean file:

```lean
import Pigment
open Pigment
```

## Quick Start

```lean
import Pigment
open Pigment

def main : IO Unit := run do
  println ("Hello, World!".style |> green |> bold)
```

Colors and styles are chained with the pipe operator:

```lean
"Error".style |> red |> bold |> underline
```

Available color modes:

```lean
-- Basic colors
"text".style |> red

-- RGB
"text".style |> rgb 255 128 64

-- Hex codes
"text".style |> hex "#FF1493"

-- 256-color palette
"text".style |> color256 196

-- Backgrounds
"text".style |> white |> bgRed
```

## Examples

### Success/Error Messages

```lean
def showBuildStatus : IO Unit := run do
  Quicky.success "Build completed successfully"
  Quicky.error "Failed to connect to database"
  Quicky.warning "Disk space running low (85%)"
  Quicky.info "Processing 1000 items..."
  Quicky.debug "Cache hit: 95%"
```

### Progress Bars

```lean
def showProgress (percent : Nat) : IO Unit := run do
  let done := "█".style |> green
  let pending := "░".style |> dim
  let pct := s!"{percent}%".style |> yellow |> bold

  let doneCount := percent / 10
  let pendingCount := 10 - doneCount

  let blocks := List.replicate doneCount done ++ List.replicate pendingCount pending
  printLine (blocks ++ [" ".style, pct])
```

### Inline Status Messages

```lean
def compileStatus (file : String) (status : String) : IO Unit := run do
  let label := "[".style |> dim
  let statusText := if status == "OK"
    then "OK".style |> green |> bold
    else "FAIL".style |> red |> bold
  let close := "]".style |> dim
  let filename := file.style |> cyan

  printLine [label, statusText, close, " ".style, filename]
```

### Code Syntax Highlighting

```lean
def showCode : IO Unit := run do
  let kw := "def".style |> magenta |> bold
  let name := "factorial".style |> blue |> bold
  let punct := "(".style |> dim
  let param := "n".style |> cyan
  let punct2 := ":".style |> dim
  let type_ := "Nat".style |> yellow
  let punct3 := ")".style |> dim

  printLine [kw, " ".style, name, punct, param, punct2, " ".style, type_, punct3]
```

### Dashboards

```lean
def systemDashboard : IO Unit := run do
  let title := "System Status".style |> hex "#00BFFF" |> bold |> underline
  println title
  IO.println ""

  Quicky.success "CPU: 25% (Normal)"
  Quicky.success "Memory: 4.2 GB / 16 GB"
  Quicky.warning "Disk: 85% used (127 GB free)"
  Quicky.error "Network: Connection lost"

  IO.println ""
  let time := "Last updated: 14:32:05".style |> dim
  println time
```

## API Reference

### Colors

Basic: `red`, `green`, `blue`, `yellow`, `cyan`, `magenta`, `white`, `black`

Backgrounds: `bgRed`, `bgGreen`, `bgBlue`, `bgYellow`, `bgCyan`, `bgMagenta`, `bgWhite`, `bgBlack`

Advanced:
- `rgb r g b` - 24-bit RGB
- `bgRgb r g b` - RGB background
- `hex "#RRGGBB"` - Hex color
- `bgHex "#RRGGBB"` - Hex background
- `color256 idx` - 256-color palette (0-255)
- `bgColor256 idx` - 256-color background

### Styles

`bold`, `dim`, `italic`, `underline`, `blink`, `reverse`, `hidden`, `strikethrough`

### Output

- `println` - Print with newline
- `print` - Print without newline
- `printLine` - Print multiple styled texts on one line

### Quick Helpers

- `Quicky.success msg` - Green checkmark
- `Quicky.error msg` - Red X
- `Quicky.warning msg` - Yellow warning
- `Quicky.info msg` - Cyan info
- `Quicky.debug msg` - Dim debug

## Configuration

Manual configuration:

```lean
-- Force 256-color mode
def main : IO Unit := runWith { enabled := true, support := .colors256 } do
  println ("256-color mode".style |> color256 196)

-- Disable colors
def main : IO Unit := runPlain do
  println ("No colors".style |> red)

-- Conditional colors
def main : IO Unit := run do
  println ("Colored".style |> green)
  withEnabled false do
    println ("Plain".style |> red)
  println ("Colored again".style |> blue)
```

Functions:
- `run` - Auto-detected config (recommended)
- `runWith cfg` - Explicit configuration
- `runPlain` - No colors
- `withEnabled bool` - Toggle colors temporarily
- `withSupport level` - Override color support level

### Environment Variables

The library respects standard environment variables:

- `NO_COLOR` - Disable all colors
- `COLORTERM=truecolor` or `COLORTERM=24bit` - Enable 24-bit RGB
- `TERM=*256color*` - Enable 256-color mode
- `TERM=*color*` - Enable basic colors

```bash
NO_COLOR=1 lake exe myapp
COLORTERM=truecolor lake exe myapp
```

### Troubleshooting

If colors aren't showing, check your terminal:

```bash
echo $TERM
```

Force colors if auto-detection fails:

```lean
def main : IO Unit := runWith { enabled := true, support := .truecolor } do
  -- your code
```

For hex colors, ensure your terminal supports truecolor (24-bit).

## More Examples

The library includes 22 examples in [Pigment/Examples.lean](Pigment/Examples.lean):

- Example 2: Success/Error Messages
- Example 13: Progress Bars
- Example 16: Syntax Highlighting
- Example 17: Dashboards
- Example 18: RGB Gradients
- Example 20: All Text Styles
- Example 21: Color Grid (9×6)
- Example 22: Inline Colors

Run all examples:

```bash
lake build
lake test
```

## Tips

For CI/CD, respect `NO_COLOR`:
```bash
NO_COLOR=1 lake exe myapp
```

## Contributing

Contributions welcome. Open an issue for bugs or feature requests, or submit a PR.

```bash
git clone https://github.com/RSoulatIOHK/Pigment
cd Pigment
lake build          # Build library
lake test           # Run examples
```

## License

Apache License 2.0 - see [LICENSE](LICENSE) for details.
