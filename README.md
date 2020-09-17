No longer maintained -- you may want to use [`terminal.getch`](https://nim-lang.org/docs/terminal.html#getch)
in the Nim standard library instead.

<details><summary>Original README</summary>

# getch
Simple and lightweight `getch()` proc for [Nim](https://github.com/nim-lang/Nim).  
Should work on all platforms.

## Example
````nim
import getch

# Get next char from stdin
let ch: char = getCh()

# Get next char from stdin, and echo it
let ch: char = getCh(true)
````

## Installation
`nimble install getch`
</details>
