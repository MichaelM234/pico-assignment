.syntax unified
.cpu cortex-m0plus
.thumb

/* C functions */
.global gpio_init
.global sleep_ms

/* wrappers (defined in main.c) */
.global gpio_set_dir_wrapper
.global gpio_put_wrapper

/* libgcc divide */
.global __aeabi_uidiv

/* entry from C */
.global main_asm

/* constants */
.equ LED_BASE_PIN,     2
.equ LED_COUNT,        10

/* RESETS */
.equ RESETS_BASE,      0x4000c000
.equ RESETS_RESET,     (RESETS_BASE + 0x00)
.equ RESETS_DONE,      (RESETS_BASE + 0x08)
.equ RESETS_ADC_BIT,   (1 << 0)

/* ADC */
.equ ADC_BASE,         0x4004c000
.equ ADC_CS,           (ADC_BASE + 0x00)
.equ ADC_RESULT,       (ADC_BASE + 0x04)

/* ADC CS bits */
.equ CS_ERR_STICKY,    (1 << 10)
.equ CS_READY,         (1 << 8)
.equ CS_START_ONCE,    (1 << 2)
.equ CS_EN,            (1 << 0)

.equ LOOP_DELAY_MS,    40

/*  shared data  */
.data
.align 4
.global adc_value
adc_value:
  .word 0              /* latest 12-bit ADC reading (0..4095) */

.text
.thumb

/*  main_asm  */
main_asm:
  push {r4-r7, lr}

  /*  Init bar-graph GPIOs GP2..GP11  */
  movs  r4, #LED_BASE_PIN        /* current pin */
  movs  r5, #LED_COUNT           /* remaining */

1:
  /* gpio_init(pin) */
  mov   r0, r4
  bl    gpio_init

  /* gpio_set_dir_wrapper(pin, true) */
  mov   r0, r4
  movs  r1, #1
  bl    gpio_set_dir_wrapper

  /* gpio_put_wrapper(pin, 0) */
  mov   r0, r4
  movs  r1, #0
  bl    gpio_put_wrapper

  adds  r4, #1
  subs  r5, #1
  bne   1b

  /* ADC out of reset  */
  ldr   r0, =RESETS_RESET
  ldr   r1, [r0]
  ldr   r2, =RESETS_ADC_BIT
  bics  r1, r1, r2
  str   r1, [r0]

  /* wait until RESETS_DONE bit set */
  ldr   r2, =RESETS_DONE
  ldr   r3, =RESETS_ADC_BIT
2:
  ldr   r1, [r2]
  ands  r1, r1, r3
  beq   2b

  /*  Enable ADC, CH0 (GPIO26)  */
  ldr   r3, =ADC_CS
  movs  r0, #0
  ldr   r1, =CS_ERR_STICKY
  orrs  r0, r0, r1
  ldr   r1, =CS_EN
  orrs  r0, r0, r1
  str   r0, [r3]

  /* Wait for READY=1 */
3:
  ldr   r1, [r3]
  ldr   r2, =CS_READY
  ands  r1, r1, r2
  beq   3b

  /*  Main loop  */
loop_top:
  /* start one conversion */
  ldr   r1, [r3]
  ldr   r2, =CS_START_ONCE
  orrs  r1, r1, r2
  str   r1, [r3]

  /* wait READY=1 again */
4:
  ldr   r1, [r3]
  ldr   r2, =CS_READY
  ands  r1, r1, r2
  beq   4b

  /* read RESULT (bits 11:0), store in adc_value */
  ldr   r0, =ADC_RESULT
  ldr   r1, [r0]
  movs  r0, #0x0F
  lsls  r0, r0, #8            /* 0x0F00 */
  adds  r0, #0xFF             /* 0x0FFF */
  ands  r1, r1, r0
  ldr   r0, =adc_value
  str   r1, [r0]

  /* leds_on = (adc * 10) / 4095 */
  mov   r6, r1                 /* adc */
  lsls  r6, r6, #3             /* *8 */
  adds  r6, r6, r1             /* *9 */
  adds  r6, r6, r1             /* *10 */
  mov   r0, r6
  ldr   r1, =4095
  bl    __aeabi_uidiv
  mov   r7, r0                 /* leds_on (0..10) */

  /*  Update LEDs GP2..GP11  */
  movs  r4, #LED_BASE_PIN
  movs  r5, #0                 /* i = 0 */

set_led_loop:
  cmp   r5, r7
  blt   5f
  movs  r1, #0
  b     6f
5:
  movs  r1, #1
6:
  mov   r0, r4
  bl    gpio_put_wrapper

  adds  r4, #1
  adds  r5, #1
  cmp   r5, #LED_COUNT
  blt   set_led_loop

  /* small delay */
  movs  r0, #LOOP_DELAY_MS
  bl    sleep_ms

  b     loop_top

  /* never returns */
  pop {r4-r7, pc}