; 107 descriptors: destination VRAM word, then message pointer.
; Some legacy message labels have an ID suffix different from the actual descriptor ID.
MessageDescriptorTable::
    dw _SCRN0 + $000, Message_00_DpadIcon ; message $00
    dw _SCRN0 + $0a3, Message_01_MekemekeRewardDescription ; message $01
    dw _SCRN0 + $0a3, Message_02_BugCatchingRewardDescription ; message $02
    dw _SCRN0 + $0a3, Message_03_SlideJumpRewardDescription ; message $03
    dw _SCRN0 + $0a3, Message_04_MinigameExit ; message $04
    dw _SCRN0 + $0a3, Message_05_ChocobiReward ; message $05
    dw _SCRN0 + $0a3, Message_06_FormReward ; message $06
    dw _SCRN0 + $0a3, Message_07_ExtraLifeReward ; message $07
    dw _SCRN0 + $0a3, Message_08_MinigameFailure ; message $08
    dw _SCRN0 + $044, Message_09_MekemekeInstructions ; message $09
    dw _SCRN0 + $044, Message_0A_BugCatchingInstructions ; message $0a
    dw _SCRN0 + $044, Message_0B_SlideJumpInstructions ; message $0b
    dw _SCRN0 + $0a3, Message_0C_NoStamps ; message $0c
    dw _SCRN0 + $1a6, Message_0D_MainMenu ; message $0d
    dw _SCRN0 + $1a6, Message_0E_MinigameMenu ; message $0e
    dw _SCRN0 + $0a6, Message_0F_SceneTestMenu ; message $0f
    dw _SCRN0 + $228, Message_10_Start ; message $10
    dw _SCRN0 + $228, Message_11_Number1 ; message $11
    dw _SCRN0 + $228, Message_12_Number2 ; message $12
    dw _SCRN0 + $228, Message_13_Number3 ; message $13
    dw _SCRN0 + $148, Message_4C_LevelText ; message $14
    dw _SCRN0 + $084, Message_15_PicnicTitle ; message $15
    dw _SCRN0 + $084, Message_16_KindergartenTitle ; message $16
    dw _SCRN0 + $084, Message_17_DepartmentStoreTitle ; message $17
    dw _SCRN0 + $084, Message_18_GuamTitle ; message $18
    dw _SCRN0 + $22c, Message_19_RemainingAttempts ; message $19
    dw _SCRN0 + $0e7, Message_1A_OgenkiPrompt ; message $1a
    dw _SCRN0 + $0e7, Message_1B_DashitePrompt ; message $1b
    dw _SCRN0 + $083, Message_1C_Stage1Intro ; message $1c
    dw _SCRN0 + $083, Message_1D_Stage2Intro ; message $1d
    dw _SCRN0 + $083, Message_1E_Stage3Intro ; message $1e
    dw _SCRN0 + $083, Message_1F_Stage4Intro ; message $1f
    dw _SCRN0 + $042, Message_20_TakeshiStealsChocobi ; message $20
    dw _SCRN0 + $042, Message_21_ShinchanMetaIntro ; message $21
    dw _SCRN0 + $042, Message_22_TakeshiRunsAway ; message $22
    dw _SCRN0 + $042, Message_23_TutorialLeadIn ; message $23
    dw _SCRN0 + $042, Message_24_TakeshiReturnsChocobi ; message $24
    dw _SCRN0 + $042, Message_25_ChocobiRecovered ; message $25
    dw _SCRN0 + $042, Message_26_DrinkSound ; message $26
    dw _SCRN0 + $042, Message_27_DrinkReaction ; message $27
    dw _SCRN0 + $042, Message_28_ChocobiAfterSweat ; message $28
    dw _SCRN0 + $042, Message_29_StageClearPassword ; message $29
    dw _SCRN0 + $042, Message_2A_KawamuraAppears ; message $2a
    dw _SCRN0 + $042, Message_2B_WhoAreYou ; message $2b
    dw _SCRN0 + $042, Message_2C_KawamuraIntroducesHimself ; message $2c
    dw _SCRN0 + $042, Message_2D_ShinchanTeasesKawamura ; message $2d
    dw _SCRN0 + $042, Message_2E_KawamuraChallenge ; message $2e
    dw _SCRN0 + $042, Message_2F_ShinchanAfterKawamuraLeaves ; message $2f
    dw _SCRN0 + $042, Message_30_KawamuraLosesAgain ; message $30
    dw _SCRN0 + $042, Message_31_KawamuraRetry ; message $31
    dw _SCRN0 + $042, Message_32_Password_WagamamaDanaa ; message $32
    dw _SCRN0 + $047, Message_33_StageNumberText ; message $33
    dw _SCRN0 + $042, Message_34_ActionKamenShowIntro ; message $34
    dw _SCRN0 + $042, Message_35_HiroshiEmbarrassed ; message $35
    dw _SCRN0 + $042, Message_36_MisaeTellsShinchanToGo ; message $36
    dw _SCRN0 + $042, Message_37_HoHoi ; message $37
    dw _SCRN0 + $042, Message_38_ActionKamenShowAlreadyStarted ; message $38
    dw _SCRN0 + $042, Message_39_ActionGreatBeam ; message $39
    dw _SCRN0 + $042, Message_3A_ActionKamenVictory ; message $3a
    dw _SCRN0 + $042, Message_3B_ActionKamenLaugh ; message $3b
    dw _SCRN0 + $042, Message_3C_TurboStageClearPassword ; message $3c
    dw _SCRN0 + $042, Message_3D_GuamExcitement ; message $3d
    dw _SCRN0 + $042, Message_3E_ArrivedAfterLongTrip ; message $3e
    dw _SCRN0 + $042, Message_3F_WhatIsGuam ; message $3f
    dw _SCRN0 + $042, Message_40_MisaeExpectedThat ; message $40
    dw _SCRN0 + $042, Message_41_Gals ; message $41
    dw _SCRN0 + $042, Message_42_HiroshiCallsShinchan ; message $42
    dw _SCRN0 + $042, Message_43_MisaeExpectedTrouble ; message $43
    dw _SCRN0 + $042, Message_44_MisaeFindsShinchan ; message $44
    dw _SCRN0 + $042, Message_45_Secret ; message $45
    dw _SCRN0 + $042, Message_46_MisaeAngrySecret ; message $46
    dw _SCRN0 + $042, Message_47_HiroshiCalmsMisae ; message $47
    dw _SCRN0 + $042, Message_48_TimeToGoHome ; message $48
    dw _SCRN0 + $042, Message_49_ShinchanAsksMisae ; message $49
    dw _SCRN0 + $042, Message_4A_StopImitatingDad ; message $4a
    dw _SCRN0 + $042, Message_4B_PressStartPrompt ; message $4b
    dw _SCRN0 + $3e8, Message_4C_LevelText ; message $4c
    dw _SCRN0 + $3e6, Message_4B_PressStartPrompt ; message $4d
    dw _SCRN1 + $042, Message_4E_TitleText ; message $4e
    dw _SCRN1 + $046, Message_4F_CreditOriginalAuthor ; message $4f
    dw _SCRN1 + $046, Message_50_CreditProducer ; message $50
    dw _SCRN1 + $045, Message_51_CreditSpecialThanks1 ; message $51
    dw _SCRN1 + $045, Message_52_CreditSpecialThanks2 ; message $52
    dw _SCRN1 + $046, Message_53_CreditCoordinator ; message $53
    dw _SCRN1 + $047, Message_54_CreditProgrammer ; message $54
    dw _SCRN1 + $047, Message_55_CreditDesigner ; message $55
    dw _SCRN1 + $044, Message_56_CreditComposer ; message $56
    dw _SCRN1 + $045, Message_57_CreditTestPlayers ; message $57
    dw _SCRN1 + $046, Message_58_CreditPresentsBy ; message $58
    dw _SCRN1 + $048, Message_59_CreditEnd ; message $59
    dw _SCRN0 + $044, Message_5A_PasswordHardModeHint ; message $5a
    dw _SCRN0 + $044, Message_5B_TurboModeHint ; message $5b
    dw _SCRN0 + $044, Message_5D_ClearCongratulations ; message $5c
    dw _SCRN1 + $041, Message_5E_TutorialMoveAndJump ; message $5d
    dw _SCRN1 + $041, Message_5F_TutorialStompEnemies ; message $5e
    dw _SCRN1 + $041, Message_60_TutorialTransformationBasics ; message $5f
    dw _SCRN1 + $041, Message_61_TutorialFlyingSquirrelJump ; message $60
    dw _SCRN1 + $041, Message_62_TutorialFlyingSquirrelAttack ; message $61
    dw _SCRN1 + $041, Message_63_TutorialChickenJump ; message $62
    dw _SCRN1 + $041, Message_64_TutorialChickenAttack ; message $63
    dw _SCRN1 + $041, Message_65_TutorialCockroachNarrowPassage ; message $64
    dw _SCRN1 + $041, Message_66_TutorialCockroachAttack ; message $65
    dw _SCRN1 + $041, Message_67_TutorialOutro ; message $66
    dw _SCRN0 + $329, Message_67_ScrollingCredits ; message $67
    dw _SCRN0 + $0e6, Message_68_FormSet ; message $68
    dw _SCRN0 + $0a7, Message_69_ContinuePrompt ; message $69
    dw _SCRN0 + $188, Message_6A_ContinueMenu ; message $6a

    ASSERT @ - MessageDescriptorTable == $6b * 4

MessageSubstitutionPointers::
    dw MessageSubstitutionText_00 ; substitution $00
    dw MessageSubstitutionText_01 ; substitution $01
    dw MessageSubstitutionText_02 ; substitution $02
    dw MessageSubstitutionText_03 ; substitution $03
    dw MessageSubstitutionText_04 ; substitution $04
    dw MessageSubstitutionText_05 ; substitution $05
    dw MessageSubstitutionText_06 ; substitution $06
    dw MessageSubstitutionText_07 ; substitution $07
    dw MessageSubstitutionText_08 ; substitution $08
    dw MessageSubstitutionText_09 ; substitution $09
    dw MessageSubstitutionText_0a ; substitution $0a
    dw MessageSubstitution_FlyingSquirrel ; substitution $0b
    dw MessageSubstitution_Cockroach ; substitution $0c
    dw MessageSubstitution_Chicken ; substitution $0d
    dw MessageDescriptorTable ; substitution $0e
    dw MessageDescriptorTable ; substitution $0f
    ASSERT @ - MessageSubstitutionPointers == $10 * 2
