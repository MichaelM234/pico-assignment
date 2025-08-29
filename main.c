#include <stdio.h>
#include "pico/stdlib.h"
#include "hardware/gpio.h"

// --- linkable wrappers for inline-only SDK functions ---
void gpio_set_dir_wrapper(uint gpio, bool out) { gpio_set_dir(gpio, out); }
void gpio_put_wrapper(uint gpio, bool value)   { gpio_put(gpio, value);  }

// main assembly entry point
void main_asm(void);

int main(void) {
  stdio_init_all();
  main_asm();
  return 0;
}
