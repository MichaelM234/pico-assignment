    .syntax unified
    .cpu cortex-m0plus
    .thumb

    .global main_asm

// ----------------------------------------------------
// Constants (tune these for your wiring)
// ----------------------------------------------------
.equ LED_FIRST, 2          // first GPIO pin for LED bar
.equ LED_COUNT, 10         // number of LEDs
.equ ADC_PIN, 26           // potentiometer connected to ADC0 (GPIO26)

// ----------------------------------------------------
// Entry point (called from main.c)
// ----------------------------------------------------
main_asm:
    // --- STEP 1: Initialize GPIO pins for LEDs ---
    // loop over LED_COUNT, call gpio_init + gpio_set_dir

movs r4, #0              // loop counter i = 0
init_led_loop:
    movs r0, #LED_FIRST      // r0 = LED_FIRST
    adds r0, r0, r4          // r0 = LED_FIRST + i
    bl gpio_init             // call gpio_init(pin)

    // set as output → gpio_set_dir(pin, 1)
    movs r1, #1              // direction = 1 (output)
    movs r0, #LED_FIRST
    adds r0, r0, r4
    bl gpio_set_dir          // call gpio_set_dir(pin, 1)

    // increment loop counter
    adds r4, r4, #1
    cmp r4, #LED_COUNT
    blt init_led_loop        // if (i < LED_COUNT) loop again



    // --- STEP 2: Initialize ADC ---
    // call adc_init, adc_gpio_init(ADC_PIN), adc_select_input(0)

loop:
    // --- STEP 3: Read potentiometer ---
    // call adc_read() → result in r0 (0–4095)

    // --- STEP 4: Scale ADC value into LED count ---
    // convert 0–4095 into 0–LED_COUNT

    // --- STEP 5: Update LEDs ---
    // loop through LEDs
    //   if (index < LED_COUNT_ON) → turn on
    //   else → turn off
    // use gpio_put()

    // --- STEP 6: Small delay ---
    // call sleep_ms(100)

    b loop                // repeat forever
