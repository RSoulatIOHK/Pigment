import Pigment.Examples

def separator : IO Unit :=
  IO.println "\n----------------------------------------\n"

def runTest (name : String) (test : IO Unit) : IO Unit := do
  IO.println s!"Running {name}:"
  test
  separator

def main : IO Unit := do
  IO.println "=== Pigment Library Test Suite ===\n"

  runTest "Example 1: Basic usage with auto-detection" example1
  runTest "Example 2: Success/Error messages" example2
  runTest "Example 3: Complex styling" example3
  runTest "Example 4: Hex colors" example4
  runTest "Example 5: Temporarily disable colors" example5
  runTest "Example 6: Override color support" example6
  runTest "Example 7: Run with explicit config" example7
  runTest "Example 8: Plain output (no colors)" example8
  runTest "Example 9: Check what config is detected" example9
  runTest "Example 10: Nested config overrides" example10
  runTest "Example 11: Rainbow text" example11
  runTest "Example 12: Styled banner" example12
  runTest "Example 13: Progress indicators" example13
  runTest "Example 14: Color palette showcase" example14
  runTest "Example 15: Layered styling" example15
  runTest "Example 16: Code-like output" example16
  runTest "Example 17: Status dashboard" example17
  runTest "Example 18: RGB gradient effect" example18
  runTest "Example 19: 256-color palette" example19
  runTest "Example 20: All text styles" example20
  runTest "Example 21: Color Grid with Gradients and Complex Formatting" example21
  runTest "Example 22: Multiple colors on same line" example22

  IO.println "=== All tests completed ==="
