#include <stdio.h>
#include "pico/stdlib.h"

// Declare your assembly entry point
#include <stdio.h>
#include "pico/stdlib.h"
// Must declare the main assembly entry point before use.
void main_asm();
/**
* @brief Supplemental Assignment...
*
* @return int Returns exit-status zero on completion.
*/
int main() {
 // Jump into the main assembly code subroutine that implements the project.
 main_asm();
 // Returning zero indicates everything went okay.
 return 0;
}
