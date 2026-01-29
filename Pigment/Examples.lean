import Pigment

section Examples

open Pigment

-- Example 1: Basic usage with auto-detection
def example1 : IO Unit := run do
  let msg := "Hello, World!".style |> red |> bold |> underline
  println msg

-- Example 2: Success/Error messages
def example2 : IO Unit := run do
  Quicky.success "Tests passed!"
  Quicky.error "Build failed"
  Quicky.warning "Deprecated function"
  Quicky.info "Processing 100 files..."

-- Example 3: Complex styling
def example3 : IO Unit := run do
  let fancy := "Fancy Text!".style
    |> rgb 255 100 200
    |> bgRgb 20 20 40
    |> bold
    |> italic
  println fancy

-- Example 4: Hex colors
def example4 : IO Unit := run do
  let hex := "Brand Color".style |> hex "#FF6B6B" |> bold
  println hex

-- Example 5: Temporarily disable colors
def example5 : IO Unit := run do
  Quicky.success "This is colored"
  withEnabled false do
    Quicky.success "This is NOT colored"
  Quicky.success "This is colored again"

-- Example 6: Override color support
def example6 : IO Unit := run do
  -- Force basic colors even if terminal supports more
  withSupport .basic do
    let msg := "Basic colors only".style |> rgb 255 100 200
    println msg  -- Will fallback to basic colors

-- Example 7: Run with explicit config
def example7 : IO Unit :=
  runWith { enabled := true, support := .truecolor } do
    let msg := "Forced truecolor".style |> rgb 100 200 255
    println msg

-- Example 8: Plain output (no colors)
def example8 : IO Unit := runPlain do
  Quicky.success "No colors here"
  Quicky.error "Still no colors"

-- Example 9: Check what config is detected
def example9 : IO Unit := run do
  let cfg ← getConfig
  IO.println s!"Detected support: {repr cfg.support}"
  IO.println s!"Colors enabled: {cfg.enabled}"

-- Example 10: Nested config overrides
def example10 : IO Unit := run do
  Quicky.info "Default config"
  withSupport .basic do
    Quicky.info "Basic colors"
    withEnabled false do
      Quicky.info "No colors"
    Quicky.info "Basic colors again"
  Quicky.info "Back to default"

-- Example 11: Rainbow text
def example11 : IO Unit := run do
  let r := "R".style |> hex "#FF0000" |> bold
  let a := "a".style |> hex "#FF7F00" |> bold
  let i := "i".style |> hex "#FFFF00" |> bold
  let n := "n".style |> hex "#00FF00" |> bold
  let b := "b".style |> hex "#0000FF" |> bold
  let o := "o".style |> hex "#4B0082" |> bold
  let w := "w".style |> hex "#9400D3" |> bold
  printLine [r, a, i, n, b, o, w]

-- Example 12: Styled banner
def example12 : IO Unit := run do
  let border := "════════════════════".style |> cyan |> bold
  println border
  let title := "  PIGMENT LIBRARY  ".style |> hex "#FF1493" |> bold |> underline
  println title
  println border

-- Example 13: Progress indicators
def example13 : IO Unit := run do
  let done := "█".style |> green
  let pending := "░".style |> dim
  printLine [done, done, done, pending, pending]
  Quicky.success "60% Complete"

-- Example 14: Color palette showcase
def example14 : IO Unit := run do
  let palette := "● Red".style |> red |> bold
  println palette
  let palette2 := "● Green".style |> green |> bold
  println palette2
  let palette3 := "● Blue".style |> blue |> bold
  println palette3
  let palette4 := "● Yellow".style |> yellow |> bold
  println palette4
  let palette5 := "● Magenta".style |> magenta |> bold
  println palette5
  let palette6 := "● Cyan".style |> cyan |> bold
  println palette6

-- Example 15: Layered styling
def example15 : IO Unit := run do
  let base := "CRITICAL".style |> red |> bold |> underline
  let withBg := "ERROR".style |> white |> bgRed |> bold
  let fancy := "WARNING".style |> yellow |> bold |> blink
  println base
  println withBg
  println fancy

-- Example 16: Code-like output
def example16 : IO Unit := run do
  let keyword := "def".style |> magenta |> bold
  let space1 := " ".style
  let funcName := "main".style |> blue
  let punctuation := "()".style |> dim
  let operator := ":".style |> dim
  let space2 := " ".style
  let type_ := "IO Unit".style |> cyan
  printLine [keyword, space1, funcName, punctuation, operator, space2, type_]

-- Example 17: Status dashboard
def example17 : IO Unit := run do
  let header := "System Status".style |> hex "#00BFFF" |> bold |> underline
  println header
  Quicky.success "CPU: Normal"
  Quicky.success "Memory: OK"
  Quicky.warning "Disk: 85% used"
  Quicky.error "Network: Down"

-- Example 18: RGB gradient effect
def example18 : IO Unit := run do
  let g1 := "▓".style |> rgb 255 0 0
  let g2 := "▓".style |> rgb 200 55 0
  let g3 := "▓".style |> rgb 150 105 0
  let g4 := "▓".style |> rgb 100 155 0
  let g5 := "▓".style |> rgb 50 205 0
  let g6 := "▓".style |> rgb 0 255 0
  printLine [g1, g2, g3, g4, g5, g6]

-- Example 19: 256-color palette
def example19 : IO Unit := run do
  let c1 := "■".style |> color256 196
  let c2 := "■".style |> color256 202
  let c3 := "■".style |> color256 226
  let c4 := "■".style |> color256 46
  let c5 := "■".style |> color256 21
  let c6 := "■".style |> color256 201
  printLine [c1, c2, c3, c4, c5, c6]

-- Example 20: All text styles
def example20 : IO Unit := run do
  let t1 := "Bold text".style |> bold
  let t2 := "Dim text".style |> dim
  let t3 := "Italic text".style |> italic
  let t4 := "Underlined text".style |> underline
  let t5 := "Blinking text".style |> blink
  let t6 := "Reversed text".style |> reverse
  let t7 := "Hidden text".style |> hidden
  let t8 := "Strikethrough text".style |> strikethrough
  println t1
  println t2
  println t3
  println t4
  println t5
  println t6
  println t7
  println t8

-- Example 21: Color Grid with Gradients and Complex Formatting
def example21 : IO Unit := run do
  -- Title with multiple styles
  let title := "🎨 COLOR GRID SHOWCASE 🎨".style
    |> hex "#FF00FF" |> bold |> italic |> underline
  println title
  IO.println ""

  -- Red gradient row (horizontal)
  let redLabel := "RED    ".style |> red |> bold
  let r1 := "███".style |> rgb 255 0 0 |> bold
  let r2 := "███".style |> rgb 220 0 0 |> bold
  let r3 := "███".style |> rgb 180 0 0 |> bold
  let r4 := "███".style |> rgb 140 0 0 |> bold
  let r5 := "███".style |> rgb 100 0 0 |> bold
  let r6 := "███".style |> rgb 60 0 0 |> bold
  printLine [redLabel, r1, r2, r3, r4, r5, r6]

  -- Orange gradient row
  let orangeLabel := "ORANGE ".style |> hex "#FF8C00" |> bold
  let o1 := "███".style |> hex "#FF4500" |> bold
  let o2 := "███".style |> hex "#FF6347" |> bold
  let o3 := "███".style |> hex "#FF7F50" |> bold
  let o4 := "███".style |> hex "#FF8C00" |> bold
  let o5 := "███".style |> hex "#FFA500" |> bold
  let o6 := "███".style |> hex "#FFB733" |> bold
  printLine [orangeLabel, o1, o2, o3, o4, o5, o6]

  -- Yellow gradient row
  let yellowLabel := "YELLOW ".style |> yellow |> bold
  let y1 := "███".style |> rgb 255 255 0 |> bold
  let y2 := "███".style |> rgb 240 240 0 |> bold
  let y3 := "███".style |> rgb 220 220 0 |> bold
  let y4 := "███".style |> rgb 200 200 0 |> bold
  let y5 := "███".style |> rgb 180 180 0 |> bold
  let y6 := "███".style |> rgb 160 160 0 |> bold
  printLine [yellowLabel, y1, y2, y3, y4, y5, y6]

  -- Green gradient row
  let greenLabel := "GREEN  ".style |> green |> bold
  let g1 := "███".style |> rgb 0 255 0 |> bold
  let g2 := "███".style |> rgb 0 220 0 |> bold
  let g3 := "███".style |> rgb 0 180 0 |> bold
  let g4 := "███".style |> rgb 0 140 0 |> bold
  let g5 := "███".style |> rgb 0 100 0 |> bold
  let g6 := "███".style |> rgb 0 60 0 |> bold
  printLine [greenLabel, g1, g2, g3, g4, g5, g6]

  -- Cyan gradient row
  let cyanLabel := "CYAN   ".style |> cyan |> bold
  let c1 := "███".style |> rgb 0 255 255 |> bold
  let c2 := "███".style |> rgb 0 220 220 |> bold
  let c3 := "███".style |> rgb 0 180 180 |> bold
  let c4 := "███".style |> rgb 0 140 140 |> bold
  let c5 := "███".style |> rgb 0 100 100 |> bold
  let c6 := "███".style |> rgb 0 60 60 |> bold
  printLine [cyanLabel, c1, c2, c3, c4, c5, c6]

  -- Blue gradient row
  let blueLabel := "BLUE   ".style |> blue |> bold
  let b1 := "███".style |> rgb 0 0 255 |> bold
  let b2 := "███".style |> rgb 0 0 220 |> bold
  let b3 := "███".style |> rgb 0 0 180 |> bold
  let b4 := "███".style |> rgb 0 0 140 |> bold
  let b5 := "███".style |> rgb 0 0 100 |> bold
  let b6 := "███".style |> rgb 0 0 60 |> bold
  printLine [blueLabel, b1, b2, b3, b4, b5, b6]

  -- Purple gradient row
  let purpleLabel := "PURPLE ".style |> magenta |> bold
  let p1 := "███".style |> rgb 128 0 255 |> bold
  let p2 := "███".style |> rgb 110 0 220 |> bold
  let p3 := "███".style |> rgb 90 0 180 |> bold
  let p4 := "███".style |> rgb 70 0 140 |> bold
  let p5 := "███".style |> rgb 50 0 100 |> bold
  let p6 := "███".style |> rgb 30 0 60 |> bold
  printLine [purpleLabel, p1, p2, p3, p4, p5, p6]

  -- Magenta gradient row
  let magentaLabel := "MAGENTA".style |> magenta |> bold
  let m1 := "███".style |> rgb 255 0 255 |> bold
  let m2 := "███".style |> rgb 220 0 220 |> bold
  let m3 := "███".style |> rgb 180 0 180 |> bold
  let m4 := "███".style |> rgb 140 0 140 |> bold
  let m5 := "███".style |> rgb 100 0 100 |> bold
  let m6 := "███".style |> rgb 60 0 60 |> bold
  printLine [magentaLabel, m1, m2, m3, m4, m5, m6]

  IO.println ""
  -- Grayscale gradient row
  let grayLabel := "GRAYS  ".style |> dim
  let gs1 := "███".style |> rgb 255 255 255 |> bold
  let gs2 := "███".style |> rgb 200 200 200 |> bold
  let gs3 := "███".style |> rgb 150 150 150 |> bold
  let gs4 := "███".style |> rgb 100 100 100 |> bold
  let gs5 := "███".style |> rgb 50 50 50 |> bold
  let gs6 := "███".style |> rgb 0 0 0 |> bold
  printLine [grayLabel, gs1, gs2, gs3, gs4, gs5, gs6]

  IO.println ""
  -- Footer
  let footer := "═════════════════════════════════════════════".style |> hex "#00FFFF" |> bold
  println footer
  let endMsg := "GRID COMPLETE".style
    |> hex "#FFD700" |> bgRgb 20 20 20 |> bold |> italic
  println endMsg
  println footer

-- Example 22: Multiple colors on same line
def example22 : IO Unit := run do
  -- Title
  let title := "MULTI-COLOR LINES".style |> hex "#FFD700" |> bold |> underline
  println title

  -- Rainbow on one line
  let r := "R".style |> hex "#FF0000" |> bold
  let a := "A".style |> hex "#FF7F00" |> bold
  let i := "I".style |> hex "#FFFF00" |> bold
  let n := "N".style |> hex "#00FF00" |> bold
  let b := "B".style |> hex "#00BFFF" |> bold
  let o := "O".style |> hex "#0000FF" |> bold
  let w := "W".style |> hex "#9400D3" |> bold
  printLine [r, a, i, n, b, o, w]

  -- Color gradient bar
  let bar1 := "█".style |> rgb 255 0 0 |> bold
  let bar2 := "█".style |> rgb 255 128 0 |> bold
  let bar3 := "█".style |> rgb 255 255 0 |> bold
  let bar4 := "█".style |> rgb 0 255 0 |> bold
  let bar5 := "█".style |> rgb 0 255 255 |> bold
  let bar6 := "█".style |> rgb 0 0 255 |> bold
  let bar7 := "█".style |> rgb 128 0 255 |> bold
  let bar8 := "█".style |> rgb 255 0 255 |> bold
  printLine [bar1, bar2, bar3, bar4, bar5, bar6, bar7, bar8]

  -- Status line with multiple colors
  let label := "[".style |> dim
  let status := "SUCCESS".style |> green |> bold
  let label2 := "]".style |> dim
  let space := " ".style
  let msg := "Build completed in 2.5s".style |> cyan
  printLine [label, status, label2, space, msg]

  -- Code syntax on one line
  let kw := "def".style |> magenta |> bold
  let sp1 := " ".style
  let fname := "main".style |> blue |> bold
  let paren1 := "(".style |> dim
  let paren2 := ")".style |> dim
  let colon := ":".style |> dim
  let sp2 := " ".style
  let typ := "IO Unit".style |> cyan
  printLine [kw, sp1, fname, paren1, paren2, colon, sp2, typ]

  -- Progress bar with percentage
  let done1 := "█".style |> green
  let done2 := "█".style |> green
  let done3 := "█".style |> green
  let pending1 := "░".style |> dim
  let pending2 := "░".style |> dim
  let sp3 := " ".style
  let pct := "60%".style |> yellow |> bold
  printLine [done1, done2, done3, pending1, pending2, sp3, pct]

  -- Mixed styles on one line
  let bold1 := "BOLD".style |> bold
  let sp4 := " + ".style
  let ital := "italic".style |> italic
  let sp5 := " + ".style
  let under := "underline".style |> underline
  let sp6 := " + ".style
  let colored := "colored".style |> hex "#FF1493" |> bold
  printLine [bold1, sp4, ital, sp5, under, sp6, colored]

  -- Artistic line
  let star1 := "★".style |> hex "#FFD700" |> bold
  let star2 := "★".style |> hex "#FF8C00" |> bold
  let star3 := "★".style |> hex "#FF4500" |> bold
  let txt := " STELLAR ".style |> white |> bgRgb 50 0 100 |> bold |> italic
  let star4 := "★".style |> hex "#FF4500" |> bold
  let star5 := "★".style |> hex "#FF8C00" |> bold
  let star6 := "★".style |> hex "#FFD700" |> bold
  printLine [star1, star2, star3, txt, star4, star5, star6]

  -- Footer
  let check := "✓".style |> green |> bold
  let sp7 := " ".style
  let msg2 := "All examples demonstrate inline colors!".style |> cyan |> italic
  printLine [check, sp7, msg2]

end Examples
