.syntax unified

.extern curr_task
.extern _sched_replace_curr_task

.macro __disable_irq reg
    mov \reg, #0xef
    msr basepri, \reg
.endm

.macro __enable_irq reg
    mov \reg, #0
    msr basepri, \reg
.endm

/*
 * the absolute offset is too big to encode in an ldr instruction, and
 * `ldr r2, =curr_task` doesn't seem to work, so it is implemented manually.
 */
curr_task_proxy:
    .globl   curr_task_proxy
    .type    curr_task_proxy,%object
    .word    curr_task

PendSV_Handler:
    .globl   PendSV_Handler
    .type    PendSV_Handler,%function
    .fnstart

    stmdb sp!, {r4-r11, r14} @ db - decrement downwards
                             @ !  - save resulting pointer back to sp

    tst r14, #0x10           @ if the task has FPU enabled, push high vfp registers.
    it eq
    vstmdbeq r0!, {s16-s31}

    ldr r3, curr_task_proxy @ load proxy
    ldr r2, [r3]            @ dereference proxy

    str sp, [r2]             @ store pointer to top of the stack in the start
                             @ of the current task struct

    stmdb sp!, {r3}
    __disable_irq reg=r0
    dsb
    isb
    bl _sched_replace_curr_task
    __enable_irq reg=r0
    ldmia sp!, {r3}


    ldr r2, [r3]            @ dereference proxy
    ldr r0, [r2]            @ load pointer to top of the stack from the start
                            @ of the current task struct

    msr msp, r0
    isb

    ldmia sp!, {r4-r11, r14} @ ia - increment after

    tst r14, #0x10
    it eq
    vldmiaeq sp!, {s16-s31}

    bx r14
    .fnend
