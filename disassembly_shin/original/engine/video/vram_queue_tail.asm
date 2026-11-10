GetVramQueueTail:: ; HL = wVramQueue + hVramQueuePos.
    ld hl, wVramQueue
    ldh a, [hVramQueuePos]
    rst $38
    ret


GetVramQueueTailDE::
    ld de, wVramQueue
    ldh a, [hVramQueuePos]
    rst $30
    ret
