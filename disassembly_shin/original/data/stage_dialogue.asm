; Indexed screen data; scene-specific interpretation is documented at its consumer.

StageDialogueScriptPointers::
    dw StageDialogue_Stage0Intro
    dw StageDialogue_Stage0Clear
    dw StageDialogue_Stage1Intro
    dw StageDialogue_Stage1Clear
    dw StageDialogue_Stage2Intro
    dw StageDialogue_Stage2Clear
    dw StageDialogue_Stage3Intro
    dw StageDialogue_Stage3Clear

StageDialogue_Stage0Intro::
    db $20, $04, $00, $7f, $91 ; message, palette mask, actor selectors 0-2
    db $21, $01, $00, $7f, $91 ; message, palette mask, actor selectors 0-2
    db $22, $04, $00, $7f, $91 ; message, palette mask, actor selectors 0-2
    db $fe, $7f ; FC message-control value and destination.
    dw wStageDialogueAnimSelectors + 2
    db $23, $01, $80, $7f, $7f ; message, palette mask, actor selectors 0-2
    db $fe, $7b ; FC message-control value and destination.
    dw wStageDialogueAnimSelectors
    db $ff ; End dialogue script.

StageDialogue_Stage0Clear::
    db $24, $04, $7b, $7f, $91 ; message, palette mask, actor selectors 0-2
    db $25, $01, $03, $7f, $92 ; message, palette mask, actor selectors 0-2
    db $26, $01, $04, $7f, $92 ; message, palette mask, actor selectors 0-2
    db $27, $04, $04, $7f, $92 ; message, palette mask, actor selectors 0-2
    db $28, $01, $05, $7f, $92 ; message, palette mask, actor selectors 0-2
    db $29, $00, $05, $7f, $92 ; message, palette mask, actor selectors 0-2
    db $ff ; End dialogue script.

StageDialogue_Stage1Intro::
    db $2a, $04, $7b, $7f, $93 ; message, palette mask, actor selectors 0-2
    db $2b, $01, $7b, $7f, $93 ; message, palette mask, actor selectors 0-2
    db $2c, $04, $7b, $7f, $93 ; message, palette mask, actor selectors 0-2
    db $2d, $01, $02, $7f, $93 ; message, palette mask, actor selectors 0-2
    db $2e, $04, $02, $7f, $93 ; message, palette mask, actor selectors 0-2
    db $fe, $7f ; FC message-control value and destination.
    dw wStageDialogueAnimSelectors + 2
    db $2f, $01, $02, $7f, $7f ; message, palette mask, actor selectors 0-2
    db $fe, $7b ; FC message-control value and destination.
    dw wStageDialogueAnimSelectors
    db $ff ; End dialogue script.

StageDialogue_Stage1Clear::
    db $30, $04, $7b, $7f, $09 ; message, palette mask, actor selectors 0-2
    db $31, $04, $7b, $7f, $09 ; message, palette mask, actor selectors 0-2
    db $32, $01, $7b, $7f, $09 ; message, palette mask, actor selectors 0-2
    db $29, $00, $7b, $7f, $09 ; message, palette mask, actor selectors 0-2
    db $ff ; End dialogue script.

StageDialogue_Stage2Intro::
    db $34, $04, $7b, $7f, $96 ; message, palette mask, actor selectors 0-2
    db $35, $01, $01, $7f, $96 ; message, palette mask, actor selectors 0-2
    db $36, $04, $01, $7f, $96 ; message, palette mask, actor selectors 0-2
    db $37, $01, $7b, $7f, $96 ; message, palette mask, actor selectors 0-2
    db $ff ; End dialogue script.

StageDialogue_Stage2Clear::
    db $38, $01, $80, $7f, $99 ; message, palette mask, actor selectors 0-2
    db $39, $04, $80, $7f, $99 ; message, palette mask, actor selectors 0-2
    db $fe, $30 ; FC message-control value and destination.
    dw wScreenPhaseCounter
    db $3a, $04, $80, $7f, $99 ; message, palette mask, actor selectors 0-2
    db $3b, $05, $06, $7f, $0a ; message, palette mask, actor selectors 0-2
    db $29, $00, $06, $7f, $0a ; message, palette mask, actor selectors 0-2
    db $ff ; End dialogue script.

StageDialogue_Stage3Intro::
    db $3d, $01, $07, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $3e, $04, $07, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $3f, $01, $7b, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $40, $02, $7b, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $41, $01, $08, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $fe, $7f ; FC message-control value and destination.
    dw wStageDialogueAnimSelectors
    db $42, $04, $7f, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $43, $02, $7f, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $ff ; End dialogue script.

StageDialogue_Stage3Clear::
    db $44, $02, $7f, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $fe, $7b ; FC message-control value and destination.
    dw wStageDialogueAnimSelectors
    db $45, $01, $7b, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $46, $02, $7b, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $47, $04, $7b, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $48, $04, $7b, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $fe, $ff ; FC message-control value and destination.
    dw wScreenPhaseCounter
    db $49, $01, $7b, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $4a, $02, $7b, $9a, $9b ; message, palette mask, actor selectors 0-2
    db $ff ; End dialogue script.

StageDialogueSpeakerMarkerTiles::
; Two vertical tiles per marker. The first pair is used for the speaking actor.
    db $ff, $e0, $e5, $fd, $e5, $f0, $e5, $f0

StageDialogueActorXPositions::
    db $7c, $54, $24

; Indexed screen data; scene-specific interpretation is documented at its consumer.

StageDialogueAnimationPointers::
    dw SceneAnim_79e5
    dw SceneAnim_79ec
    dw SceneAnim_79f3
    dw SceneAnim_79fa
    dw SceneAnim_7a01
    dw SceneAnim_7a08
    dw SceneAnim_7a0f
    dw SceneAnim_7a16
    dw SceneAnim_7a1f
    dw SceneAnim_7a28
    dw SceneAnim_7a2f

StageDialogueSceneGfxPointers::
    dw GfxRle_b06_7a71
    dw GfxRle_b06_7b22
    dw GfxRle_b06_7c0e
    dw GfxRle_b06_7e13

StageDialogueSpeakerAttributes::
; Three ATTR_CHR data bytes per speaker mask used by the scripts.
    db $00, $00, $00, $c0, $00, $00, $00, $0c, $00, $c0, $0c, $00, $00, $00, $03, $c0
    db $00, $03, $00, $0c, $03

StageDialogueHiddenActorSlots::
; Eight scene-indexed actor selectors, with $ff disabling the highlight. Three trailing bytes are preserved.
    db $02, $ff, $02, $ff, $ff, $ff, $00, $ff, $c0, $0c, $03

; Indexed screen data; scene-specific interpretation is documented at its consumer.

StageDialogueVramQueuePointers::
    dw StageDialogueVramQueue_00
    dw StageDialogueVramQueue_01
    dw StageDialogueVramQueue_01

StageDialogueSgbPacketPointers::
    dw SgbPacket_DialogueHighlight_00
    dw SgbPacket_DialogueHighlight_01
    dw SgbPacket_DialogueHighlight_01

StageDialogueVramQueue_00::
    db $99, $c2, $04, $ef, $f1, $f2, $f9, $99, $e3, $03, $f5, $f6, $f7, $9a, $03, $02
    db $f3, $f4, $00

StageDialogueVramQueue_01::
    db $99, $ae, $03, $fd, $f0, $f3, $99, $ce, $03, $ef, $f1, $f2, $99, $ee, $03, $ee
    db $f5, $f6, $9a, $0e, $03, $f0, $f3, $f4, $00

StageDialogueFinalSceneVramQueue::
    db $99, $c3, $43, $00, $99, $e3, $43, $00, $9a, $03, $43, $00, $00

SgbPacket_DialogueHighlight_00::
    db $21, $02, $03, $00, $02, $0e, $05, $10, $00, $00, $00, $00, $00, $00, $00, $00

SgbPacket_DialogueHighlight_01::
    db $21, $02, $03, $00, $0e, $0d, $10, $10, $00, $00, $00, $00, $00, $00, $00, $00

SgbPacket_DialogueFinalSceneHighlight::
    db $21, $02, $03, $0a, $03, $0e, $05, $10, $00, $00, $00, $00, $00, $00, $00, $00

SgbPacket_DialogueSpeakerTemplate::
    db $39, $00, $0a, $10, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

StageDialogueBackgroundStencils::
; Seven 16-bit masks per scene.
    db $00, $00, $00, $00, $06, $00, $0e, $78, $0e, $70, $04, $70, $00, $00, $00, $00
    db $00, $00, $06, $00, $0e, $78, $0e, $70, $04, $70, $00, $00, $00, $00, $00, $00
    db $0e, $00, $0e, $70, $0e, $70, $04, $70, $00, $00, $00, $00, $00, $00, $00, $00
    db $0c, $70, $0e, $70, $0e, $70, $00, $00, $0c, $00, $0c, $00, $0c, $00, $0e, $70
    db $0c, $70, $0e, $70, $00, $00, $0e, $00, $0e, $00, $0e, $00, $0e, $70, $0e, $70
    db $00, $70, $00, $00, $84, $01, $8e, $01, $ce, $01, $8e, $f1, $8e, $71, $8e, $71
    db $00, $00, $84, $01, $8e, $01, $ce, $01, $8e, $01, $8e, $01, $8e, $01, $00, $00
