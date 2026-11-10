"""Export original menu and story assets for the native screen controller."""

from pathlib import Path

from shin_prev_byte_rle import decode as decode_graphics
from shin_rleff import decode as decode_layout
from shin4_level_pipeline import decode_2bpp_tile, decode_obj_2bpp_tile, parse_metasprite, rom_offset


def export_screens(out, rom, symbols, array, tutorial_vram):
    def at(label):
        return rom_offset(*symbols[label])

    def word(offset):
        return int.from_bytes(rom[offset:offset + 2], "little")

    def graphics(vram, label, destination, size=None):
        source = at(label)
        if size is None:
            raw, _ = decode_graphics(rom[source:], vram[destination - 1] if destination else 0)
        else:
            raw = rom[source:source + size]
        vram[destination:destination + len(raw)] = raw

    def pixels(name, vram):
        array(out, name + "_background", [pixel for tile in range(256)
                                         for pixel in decode_2bpp_tile(vram, tile, "signed")])
        array(out, name + "_objects", [pixel for tile in range(256)
                                      for pixel in decode_obj_2bpp_tile(vram, tile)])

    def tilemap(name, tiles):
        if len(tiles) != 20 * 18:
            raise ValueError(f"Unexpected size for {name}")
        array(out, name + "_map", tiles)

    def rom_tilemap(name, label):
        tiles, _ = decode_layout(rom[at(label):], 20 * 18)
        tilemap(name, tiles)

    def menu_background(tile_base, box):
        patterns = [rom[at(label):at(label) + 6] for label in (
            "MenuBackgroundRowPattern_438c", "MenuBackgroundRowPattern_4393",
            "MenuBackgroundRowPattern_439a")]
        tiles = bytearray(((tile + tile_base) & 0xff) if tile else 0
                          for group in range(6) for pattern in patterns
                          for tile in (pattern[group:] + pattern * 4)[:20])
        draw_box(tiles, box)
        return tiles

    def draw_box(tiles, box):
        x, y, width, height, mask = box
        table = at("TilemapBoxMaskTable_0902")
        for row in range(height + 2):
            edge = 0 if row == 0 else 6 if row == height + 1 else 3
            left, middle, right = (tile & mask for tile in rom[table + edge:table + edge + 3])
            start = (y + row) * 20 + x
            tiles[start:start + width + 2] = bytes([left] + [middle] * width + [right])

    def message(name, message_id, substitution_id=0, accent_base=0, window_row=0, rows=18):
        descriptor = at("MessageDescriptorTable") + message_id * 4
        destination = word(descriptor) - (0x9c00 if window_row > 0 else 0x9800)
        row, column = divmod(destination, 32)
        row += window_row
        bank = symbols["MessageDescriptorTable"][0]
        source = rom_offset(bank, word(descriptor + 2))
        stream = rom[source:rom.index(0xff, source)]
        if 0xfd in stream:
            sub = rom_offset(bank, word(at("MessageSubstitutionPointers") + substitution_id * 2))
            stream = stream.replace(b"\xfd", rom[sub:rom.index(0xff, sub)])
        out.write(f"inline constexpr TextGlyph {name}[] = {{\n")
        for line_index, line in enumerate(stream.split(b"\xfe")):
            # The flags select a different accent set for the first line only.
            accent = 0xff
            x = column
            for tile in line:
                if tile in (0x43, 0x45):
                    accent = tile if not accent_base or line_index else accent_base + (tile == 0x43)
                elif tile == 0xfc:
                    out.write("    {TextGlyph::control, 0, 0xff},\n")
                else:
                    y = row + 2 * line_index
                    if x >= 20 or y >= rows:
                        raise ValueError(f"Text extends offscreen in {name}")
                    out.write(f"    {{{y * 20 + x}, {tile:#04x}, {accent:#04x}}},\n")
                    x += 1
                    accent = 0xff
            out.write("    {TextGlyph::line_end, 0, 0xff},\n")
        out.write("};\n\n")

    def animation(name, bank, start):
        frames = []
        cursor = rom_offset(bank, start)
        beginning = cursor
        loop = 0
        hold = False
        while True:
            duration = rom[cursor]
            if duration == 0xfe:
                hold = True
                break
            if duration == 0xff:
                target = rom_offset(bank, word(cursor + 1))
                if not beginning <= target < cursor or (target - beginning) % 2:
                    raise ValueError(f"{name} has a loop outside its frame sequence")
                loop = (target - beginning) // 2
                break
            frames.append(f"{{{duration & 127}, {rom[cursor + 1]}, {str(duration > 127).lower()}}}")
            cursor += 2
        out.write(f"inline constexpr SceneFrame {name}_frames[] = {{{', '.join(frames)}}};\n")
        out.write(f"inline constexpr SceneAnimation {name}{{{name}_frames, {loop}, {str(hold).lower()}}};\n\n")

    out.write('#pragma once\n\n#include "campaign.hpp"\n\nnamespace shin4::scene_data {\n\n')
    maps = Path(__file__).resolve().parent.parent / "original/maps"
    rom_tilemap("title", "LayoutRle_b06_501e")
    rom_tilemap("password", "LayoutRle_b01_7e7c")
    tilemap("story", (maps / "stage_intro.bin").read_bytes())
    rom_tilemap("continue", "LayoutRle_b06_6801")
    tilemap("stage_card", menu_background(0, (3, 1, 12, 4, 0x8f)))
    tilemap("dialogue", menu_background(0x60, (1, 1, 16, 7, 0xef)))
    tilemap("ending_hint", menu_background(0, (3, 1, 12, 13, 0x8f)))
    tilemap("bonus", (maps / "bonus.bin").read_bytes())
    tilemap("mekemeke", (maps / "b06_6fe5.bin").read_bytes())
    tilemap("bug_hunt", (maps / "b06_60db.bin").read_bytes())
    array(out, "waterfall", (maps / "waterfall.bin").read_bytes())
    window = bytearray(20 * 18)
    draw_box(window, (0, 10, 18, 6, 0x8f))
    tilemap("ending_window", window)
    array(out, "ending_landscape", (maps / "b06_75fe.bin").read_bytes())

    common = bytearray(0x1800)
    graphics(common, "GfxRle_b06_4bc0", 0x1000)
    title = common.copy()
    graphics(title, "GfxRle_b06_4001", 0)
    pixels("title", title)
    password = title.copy()
    graphics(password, "Gfx_b06_50c4", 0x900, 0x260)
    pixels("password", password)
    intro = common.copy()
    graphics(intro, "Gfx_b06_50c4", 0x800, 0x200)
    graphics(intro, "GfxRle_b06_6156", 0xa00)
    pixels("intro", intro)
    continue_vram = common.copy()
    graphics(continue_vram, "GfxRle_b06_641e", 0)
    graphics(continue_vram, "GfxRle_b06_663c", 0x800)
    pixels("continue", continue_vram)
    ending_vram = common.copy()
    graphics(ending_vram, "GfxRle_b06_7099", 0)
    graphics(ending_vram, "GfxRle_b06_7581", 0x900)
    graphics(ending_vram, "Gfx_b06_50c4", 0x800, 0x100)
    pixels("ending", ending_vram)
    scrolling_vram = common.copy()
    graphics(scrolling_vram, "GfxRle_b02_7b8e", 0)
    graphics(scrolling_vram, "GfxRle_b02_7fe0", 0x800)
    for offset in range(0x1040, 0x1800, 2):
        scrolling_vram[offset] = 0xff
    pixels("scrolling_ending", scrolling_vram)
    start = at("EndingScrollBgRow")
    array(out, "scrolling_ending_row", rom[start:start + 20])
    start = at("EndingParticleSeeds")
    # The reset index counts down from eight to one, including the adjacent record.
    array(out, "ending_particle_seeds", rom[start:start + 9 * 3])
    hint_vram = common.copy()
    graphics(hint_vram, "GfxRle_b06_5334", 0x130)
    graphics(hint_vram, "GfxRle_b06_53ec", 0x300)
    graphics(hint_vram, "Gfx_b06_50c4", 0x800, 0x200)
    graphics(hint_vram, "GfxRle_b06_5556", 0xa00)
    pixels("ending_hint", hint_vram)
    bonus = hint_vram.copy()
    graphics(bonus, "Gfx_b05_5701", 0xd00, 0x300)
    pixels("bonus", bonus)
    bugs = common.copy()
    graphics(bugs, "GfxRle_b06_5851", 0)
    pixels("bug_hunt", bugs)
    mekemeke = bugs.copy()
    graphics(mekemeke, "GfxRle_b06_6839", 0)
    graphics(mekemeke, "GfxRle_b06_6e44", 0x900)
    pixels("mekemeke", mekemeke)
    slide = common.copy()
    graphics(slide, "GfxRle_b05_7481", 0)
    pixels("slide_jump", slide)
    graphics(tutorial_vram, "Gfx_b06_50c4", 0x800, 0x100)
    graphics(tutorial_vram, "GfxRle_b03_400f", 0x900)
    graphics(tutorial_vram, "GfxRle_b06_4bc0", 0x1000)
    pixels("tutorial", tutorial_vram)
    window = bytearray(20 * 18)
    draw_box(window, (0, 10, 18, 6, 0x8f))
    tilemap("tutorial_window", window)
    for index in range(10):
        message(f"tutorial_message_{index}", 0x5d + index, window_row=10)
    out.write("inline constexpr std::span<const TextGlyph> tutorial_messages[] = {" +
              ", ".join(f"tutorial_message_{i}" for i in range(10)) + "};\n\n")
    input_start = at("TutorialDemoInputScript")
    input_end = at("PasswordScreenLayoutRle_Bank1")
    array(out, "tutorial_inputs", rom[input_start:input_end])
    array(out, "tutorial_message_ticks", rom[at("TutorialMessageChangeTicks"):input_start])
    for stage, label in enumerate(("GfxRle_b06_7a71", "GfxRle_b06_7b22", "GfxRle_b06_7c0e", "GfxRle_b06_7e13")):
        dialogue = common.copy()
        graphics(dialogue, "GfxRle_b06_7700", 0)
        graphics(dialogue, label, 0x600)
        graphics(dialogue, "Gfx_b06_50c4", 0xe00, 0x200)
        pixels(f"dialogue_{stage}", dialogue)

    for label in ("TitleIntro", "TitleIdle", "TitleSecondary", "ContinueIdle", "ContinueAccepted",
                  "ContinueExitReaction", "ContinueExit", "Scene3Mode0State1", "Scene3Mode0State2",
                  "Scene3Mode0Primary", "Scene3Mode0Secondary", "Scene3Mode0Variant"):
        animation(label, *symbols[f"SceneAnim_{label}"])
    for name, label in (
        ("bug_down", "7913"), ("bug_right", "7921"), ("bug_left", "792f"), ("bug_up", "793d"),
        ("net_down", "791a"), ("net_right", "7928"), ("net_left", "7936"), ("net_up", "7944"),
        ("bug_win", "794b"), ("bug_fail", "7960"), ("bug_hit", "7967"), ("bug_final_win", "796e"),
        ("mekemeke_fire", "79b7"), ("mekemeke_idle", "79bb"), ("mekemeke_win", "79be"),
        ("mekemeke_hit", "79cd"), ("mekemeke_final_win", "79d4"),
        ("slide_win", "7a36"), ("slide_demo_win", "7a43"), ("slide_bounce", "7a4e"),
        ("slide_demo_ramp", "7a53"), ("slide_ramp", "7a58"), ("slide_final_win", "7a61"),
        ("ending_walk", "7b5a"), ("ending_turn", "7b65"), ("ending_dance", "7b70"),
        ("ending_guest", "7b85"),
    ):
        animation(name, *symbols[f"SceneAnim_{label}"])
    bank, start = symbols["EndingInitialAnimationPointers"]
    for i in range(4):
        animation(f"ending_initial_{i}", bank, word(rom_offset(bank, start) + 2 * i))
    out.write("inline constexpr SceneAnimation ending_initial_animations[] = {" +
              ", ".join(f"ending_initial_{i}" for i in range(4)) + "};\n\n")
    bank, start = symbols["StageDialogueAnimationPointers"]
    for i in range(11):
        animation(f"dialogue_anim_{i}", bank, word(rom_offset(bank, start) + 2 * i))
    out.write("inline constexpr SceneAnimation dialogue_animations[] = {" +
              ", ".join(f"dialogue_anim_{i}" for i in range(11)) + "};\n\n")
    bank, start = symbols["EndingAnimationPointers"]
    for i in range(22):
        animation(f"ending_anim_{i}", bank, word(rom_offset(bank, start) + 2 * i))
    out.write("inline constexpr SceneAnimation ending_animations[] = {" +
              ", ".join(f"ending_anim_{i}" for i in range(22)) + "};\n\n")
    positions = at("EndingInitialObjectX")
    array(out, "ending_actor_x", rom[positions:positions + 4])
    start = at("EndingCueRecords")
    credits = at("EndingCueMessageIds")
    out.write("inline constexpr EndingCue ending_cues[] = {\n")
    for i in range(3):
        entry, move, exit_x, _, *actors = rom[start + i * 24:start + (i + 1) * 24]
        selectors = ", ".join("{" + ", ".join(str(id_) for id_ in actors[j:j + 4]) + "}"
                              for j in range(0, len(actors), 4))
        out.write(f"    {{{rom[credits + i] - 0x4e}, {entry}, {move}, {exit_x}, {{{selectors}}}}},\n")
    out.write("};\n\n")

    table = at("Bank3MetaspritePtrTable")
    ids = range(0xf2)
    for frame in sorted(ids):
        parts = parse_metasprite(rom, 3, word(table + frame * 2))
        fields = ", ".join(f"{{{x}, {y}, {tile:#04x}, {flags:#04x}}}" for y, x, tile, flags in parts)
        if parts:
            out.write(f"inline constexpr SpritePart frame_{frame}[] = {{{fields}}};\n")
        else:
            out.write(f"inline constexpr std::span<const SpritePart> frame_{frame}{{}};\n")
    out.write("inline constexpr std::span<const SpritePart> frames[] = {\n    " +
              ", ".join(f"frame_{i}" for i in ids) + "\n};\n\n")
    for name in ("Grid", "Input"):
        bank, pointer = symbols[f"Password{name}CursorMetasprite"]
        y, x, tile, flags = parse_metasprite(rom, bank, pointer)[0]
        out.write(f"inline constexpr SpritePart password_{name.lower()}_cursor[]"
                  f" = {{{{{x}, {y}, {tile}, {flags}}}}};\n")
    out.write("inline constexpr SpritePart bonus_border_sprite[] = {{0, 0, 0xaf, 0x10}};\n")
    for name in ("Prompt", "Accepted", "Error"):
        offset = at(f"Password{name}Tiles")
        array(out, f"password_{name.lower()}_tiles", rom[offset:offset + 20])
    start = at("PasswordCodeTable")
    array(out, "password_codes", rom[start:start + 12 * 20])
    array(out, "password_lengths", rom[at("PasswordCodeLengths"):at("PasswordCodeTable")])

    message("main_menu_text", 0x0d)
    message("minigame_menu_text", 0x0e)
    for id_ in range(1, 13):
        message(f"bonus_text_{id_}", id_, 0x0b if id_ == 6 else 0, accent_base=0x8a)
    out.write("inline constexpr std::span<const TextGlyph> bonus_text[] = {{}, " +
              ", ".join(f"bonus_text_{i}" for i in range(1, 13)) + "};\n\n")
    for id_ in range(3):
        message(f"bonus_form_{id_}", 0x68, 0x0b + id_)
        message(f"bonus_form_reward_{id_}", 6, 0x0b + id_, accent_base=0x8a)
    for id_ in range(0x10, 0x14):
        message(f"countdown_{id_ - 0x10}", id_)
    for round_number in range(1, 11):
        message(f"round_banner_{round_number}", 0x14, round_number)
        message(f"slide_banner_{round_number}", 0x4c, round_number, window_row=-14)
    message("slide_start", 0x4d, accent_base=0x8a, window_row=-14)
    for name, label, length in (
        ("mekemeke_hud", "MekemekeHudTiles", 34), ("mekemeke_goals", "MekemekeRoundGoalTiles", 33),
        ("mekemeke_timers", "MekemekeRoundTimerDigits", 30),
        ("mekemeke_velocities", "MekemekeRoundEnemyVelocities", 40),
        ("mekemeke_lane_tiles", "MekemekeLaneTilePairs", 8),
        ("mekemeke_variant_chances", "MekemekeVariantChances", 10),
        ("mekemeke_normal_frames", "MekemekeEnemyFrames", 6),
        ("mekemeke_variant_frames", "MekemekeVariantEnemyFrames", 6),
        ("bug_hud", "BugHuntHudTiles", 34), ("bug_goals", "BugHuntRoundGoalTiles", 33),
        ("bug_weights", "BugHuntRoundSpawnWeights", 40),
        ("bug_frames", "BugHuntBugFrames", 40), ("bug_bounds", "BugHuntCatchBounds", 48),
        ("bug_wobble", "BugHuntSpecialBugYOffsets", 17),
        ("bug_gate_directions", "BugHuntGateDirectionChoices", 12),
        ("bug_hazard_positions", "BugHuntHazardRespawnPositions", 24),
        ("bug_popup_offsets", "BugHuntCaughtPopupXOffsets", 16),
    ):
        start = at(label)
        array(out, name, rom[start:start + length])
    table = at("SlidePlatformRoundPointers")
    bank = symbols["SlidePlatformRoundPointers"][0]
    out.write("inline constexpr SlidePlatform slide_platforms[10][10] = {\n")
    for round_index in range(10):
        cursor = rom_offset(bank, word(table + 2 * round_index))
        platforms = []
        while word(cursor) != 0xffff:
            x, y, flags = word(cursor), rom[cursor + 2], rom[cursor + 3]
            goal = word(cursor + 4) == 0xffff
            platforms.append(f"{{{x}, {y}, {flags}, {str(goal).lower()}}}")
            cursor += 4
        out.write("    {" + ", ".join(platforms) + "},\n")
    out.write("};\n\n")
    for id_ in range(0x4e, 0x5a):
        message(f"ending_credit_{id_}", id_, window_row=10)
    out.write("inline constexpr std::span<const TextGlyph> ending_credits[] = {" +
              ", ".join(f"ending_credit_{i}" for i in range(0x4e, 0x5a)) + "};\n\n")
    message("hard_mode_hint", 0x5a, accent_base=0x8a)
    message("turbo_mode_hint", 0x5b, accent_base=0x8a)
    message("clear_congratulations", 0x5c, accent_base=0x8a)
    message("scrolling_credits", 0x67, window_row=-25, rows=256)
    message("scene_test_labels", 0x0f)
    message("continue_prompt", 0x69)
    message("continue_options", 0x6a)
    message("continue_facing_right", 0x1a)
    message("continue_facing_left", 0x1b)
    for count in range(4):
        message(f"continue_remaining_{count}", 0x19, count)
    start = at("ContinueAcceptedMotionScript")
    end = rom.index(0xff, start)
    array(out, "continue_motion", rom[start:end])
    for stage in range(4):
        message(f"card_name_{stage}", 0x15 + stage)
        message(f"story_{stage}", 0x1c + stage, accent_base=0x8a)
        for mode in range(2):
            message(f"card_number_{stage}_{mode}", 0x33, 1 + stage + 4 * mode, 0x8a)
        message(f"second_round_password_{stage}", 0x29, 5 + stage, 0xea)
        message(f"turbo_password_{stage}", 0x3c, 5 + stage, 0xea)

    for stage in range(4):
        for kind in ("Intro", "Clear"):
            name = f"stage_{stage}_{kind.lower()}"
            cursor = at(f"StageDialogue_Stage{stage}{kind}")
            pages = []
            while rom[cursor] != 0xff:
                message_id, speaker, *actors = rom[cursor:cursor + 5]
                cursor += 5
                control_actor = -1
                control_value = 0
                if rom[cursor] == 0xfe:
                    control_value = rom[cursor + 1]
                    destination = word(cursor + 2)
                    control_actor = destination - 0xd80e  # wStageDialogueAnimSelectors
                    if destination == 0xd955:  # wScreenPhaseCounter
                        control_actor = 3  # Flash timer.
                    elif not 0 <= control_actor < 3:
                        raise ValueError(f"Unknown dialogue control destination {destination:#x}")
                    cursor += 4
                text_name = f"{name}_page_{len(pages)}"
                message(text_name, message_id, 1 + stage, 0xea)
                actor_list = ", ".join(str(actor) for actor in actors)
                pages.append(f"    {{{text_name}, {{{actor_list}}}, {speaker}, "
                             f"{control_actor}, {control_value}, {str(message_id == 0x29).lower()}}},\n")
            out.write(f"inline constexpr DialoguePage {name}[] = {{\n{''.join(pages)}}};\n\n")

    for name, label, length in (
        ("sgb_profiles", "SgbScreenPaletteTable_4d5f", 31 * 6),
        ("sgb_colors", "SgbPaletteTransferSource", 64 * 8),
        ("sgb_border_tiles", "Bank0TrailingGraphicsData_3ca2", 89 * 8),
        ("sgb_border_colors", "SgbBorderPaletteAssignments", 12),
        ("sgb_speaker_attributes", "StageDialogueSpeakerAttributes", 8 * 3),
        ("sgb_card_stencil", "StageIntroBackgroundStencil", 14),
        ("sgb_dialogue_stencils", "StageDialogueBackgroundStencils", 8 * 14),
        ("sgb_continue_colors", "ContinuePaletteColorPairs", 16),
    ):
        start = at(label)
        array(out, name, rom[start:start + length])
    attributes = (maps.parent / "sgb/border_tilemap.bin").read_bytes()
    array(out, "sgb_attribute_files", attributes[:17 * 90])
    pointers = at("SgbBorderRowPatternPointers")
    bank = symbols["SgbBorderRowPatternPointers"][0]
    out.write("inline constexpr unsigned char sgb_border_rows[3][7][8] = {\n")
    for mode in range(3):
        out.write("    {\n")
        for row in range(7):
            offset = rom_offset(bank, word(pointers + (mode * 8 + row) * 2))
            pattern = rom[offset:rom.index(0xff, offset)]
            out.write("        {" + ", ".join(str(tile) for tile in pattern) + "},\n")
        out.write("    },\n")
    out.write("};\n\n")
    out.write("} // namespace shin4::scene_data\n")
