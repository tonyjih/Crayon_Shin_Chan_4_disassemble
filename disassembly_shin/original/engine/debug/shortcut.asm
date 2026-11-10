IF DEF(DEBUG)
UpdateGameStateWithDebugShortcut::
; Intercept a new SELECT + START chord before gameplay can pause.
    ldh a, [hGameState]
    cp $02
    jr nz, .update

    ldh a, [hJoyHeld]
    cp PADF_SELECT | PADF_START
    jr nz, .update

    ldh a, [hJoyPressed]
    and PADF_SELECT | PADF_START
    jp nz, EnterDebugMenu

.update
    jp UpdateCurrentGameState
ENDC
