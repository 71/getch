when hostOS == "windows":
  proc wgetch(): char {. header: "<conio.h>", importc: "getch" .}
  proc wgetche(): char {. header: "<conio.h>", importc: "getche" .}

  proc getCh*(e = false): char =
    ## Immediately get the next character from stdin.
    ## If `e` is true, the character will be echoed.
    if e: wgetche() else: wgetch()

else:
  const
    NCCS    = 20
    TCSANOW = 0

    ECHO:   uint = 1 shl 3
    ICANON: uint = 1 shl 8

  type termios = object
    c_iflag*: uint
    c_oflag*: uint
    c_cflag*: uint
    c_lflag*: uint
    c_line*:  char
    c_cc*:    array[NCCS, char]

  proc tcgetattr(f: int, t: ptr termios): void {. header: "<termios.h>", importc: "tcgetattr" .}
  proc tcsetattr(f: int, s: int, t: ptr termios): void {. header: "<termios.h>", importc: "tcsetattr" .}
  proc getchar(): char {. importc: "getchar" .}

  proc getCh*(e = false): char =
    ## Immediately get the next character from stdin.
    ## If `e` is true, the character will be echoed.
    var
      oldt: termios
      newt: termios

    # Change terminal settings
    tcgetattr(0, oldt.addr)

    newt = oldt
    newt.c_lflag = newt.c_lflag and (not ICANON)
    newt.c_lflag = newt.c_lflag and (if e: ECHO else: not ECHO)

    # Disable buffered IO
    tcsetattr(0, TCSANOW, newt.addr)

    # Read next char
    result = getchar()

    # Restore terminal settings
    tcsetattr(0, TCSANOW, oldt.addr)