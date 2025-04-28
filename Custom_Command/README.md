# Q1 Reflective Report

## Breakdown: How the Script Handles Arguments and Options

- The script uses the `getopts` tool to parse command-line options efficiently.
- It recognizes two flags:
  - `-n`: Enables showing line numbers beside matching lines.
  - `-v`: Inverts the matching logic, showing non-matching lines instead.
- It also supports `--help` to display usage instructions.
- After processing options, it shifts arguments and expects:
  1. A **search string**.
  2. A **filename**.
- Input validation ensures:
  - At least two arguments are provided.
  - The specified file exists.
- Then, the script reads the file line by line:
  - Performs a **case-insensitive** search.
  - Depending on the options (`-n`, `-v`), it decides whether and how to print the line.

---

## Reflective Paragraph

If I were to extend the script to support regular expressions (`regex`) and more options like `-i`, `-c`, or `-l`, I would redesign the matching part by:
- Replacing the simple `grep -i` with a full regex evaluator (still using `grep` but with extra flags).
- Adding flags parsing for each new option in `getopts`.
- Structuring the script more modularly:
  - One function for parsing options.
  - One function for matching logic.
  - One function for displaying output.

This modular design would make it easier to add new features without affecting the core functionality.

---

## Hardest Part and Why

The hardest part was handling combinations of multiple options together (`-vn`, `-nv`) correctly.
Using `getopts` made it easier, but ensuring the logical conditions for match/invert and line-number display required careful thought.
Also, ensuring clean error handling (for missing files or wrong arguments) without breaking the script flow added extra complexity.

---

## Bonus Features Implemented

- `--help` option prints a clear usage guide.
- `getopts` used for professional and clean option parsing.

---
