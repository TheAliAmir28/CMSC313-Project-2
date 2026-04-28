Open a terminal and run:

``` bash
as double_number.s -o double_number.o
ld double_number.o -o double_number
```

-   `as` assembles the source file into an object file\
-   `ld` links the object file to create an executable

------------------------------------------------------------------------

## How to Run

Run the program with a number as a command-line argument:

``` bash
./double_number 13
```

------------------------------------------------------------------------
