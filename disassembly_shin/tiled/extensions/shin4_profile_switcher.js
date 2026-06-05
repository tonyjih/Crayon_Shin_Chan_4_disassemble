// Shin4 Tiled helper extension (experimental).
// It switches the firstgid=1 metatile tileset while keeping the TMX layout unchanged.
// Reads TMX properties written by export-tiled-shared:
//   shin4.profiles
//   shin4.profile.<name>.tsx
//   shin4.current_profile

(function() {
    var KNOWN_PROFILES = ["normal", "initial", "checkpoint", "after_switch", "after_checkpoint2"];
    var actions = {};

    function prop(map, name, fallback) {
        try {
            var v = map.property(name);
            if (v === undefined || v === null || v === "")
                return fallback;
            return String(v);
        } catch (e) {
            return fallback;
        }
    }

    function currentMap() {
        var asset = tiled.activeAsset;
        if (!asset || !asset.isTileMap)
            return null;
        return asset;
    }

    function profileList(map) {
        var profiles = prop(map, "shin4.profiles", "");
        if (!profiles)
            return [];
        var raw = profiles.split(",");
        var out = [];
        for (var i = 0; i < raw.length; i++) {
            var name = raw[i].replace(/^\s+|\s+$/g, "");
            if (name)
                out.push(name);
        }
        return out;
    }

    function hasProfile(list, profile) {
        for (var i = 0; i < list.length; i++) {
            if (list[i] === profile)
                return true;
        }
        return false;
    }

    function profilePath(map, profile) {
        var explicit = prop(map, "shin4.profile." + profile + ".tsx", "");
        var base = FileInfo.path(map.fileName);
        if (explicit)
            return FileInfo.joinPaths(base, explicit);
        var stage = prop(map, "stage", "");
        return FileInfo.joinPaths(base, "profiles/stage" + stage + "_" + profile + ".tsx");
    }

    function refreshProfileActions() {
        var map = currentMap();
        var list = map ? profileList(map) : [];
        for (var i = 0; i < KNOWN_PROFILES.length; i++) {
            var profile = KNOWN_PROFILES[i];
            var action = actions[profile];
            if (!action)
                continue;
            var available = hasProfile(list, profile);
            action.enabled = available;
            try { action.visible = available; } catch (e) {}
        }
    }

    function switchProfile(profile) {
        var map = currentMap();
        if (!map) {
            tiled.alert("Open a Shin4 TMX map first.");
            return;
        }
        var list = profileList(map);
        if (!hasProfile(list, profile)) {
            tiled.alert("Profile '" + profile + "' is not available for this map.\nAvailable: " + list.join(", "));
            refreshProfileActions();
            return;
        }
        var path = profilePath(map, profile);
        var fmt = tiled.tilesetFormatForFile(path);
        if (!fmt || !fmt.canRead) {
            tiled.alert("No readable tileset format for:\n" + path);
            return;
        }
        var ts = null;
        try {
            ts = fmt.read(path);
        } catch (e) {
            tiled.alert("Could not read profile tileset:\n" + path + "\n" + e);
            return;
        }
        if (!ts || !ts.isTileset) {
            tiled.alert("Profile file did not load as a tileset:\n" + path);
            return;
        }
        var old = null;
        for (var i = 0; i < map.tilesets.length; i++) {
            var name = map.tilesets[i].name;
            if (name.indexOf("stage_profile_") === 0 || name.indexOf("metatile") >= 0) {
                old = map.tilesets[i];
                break;
            }
        }
        if (!old && map.tilesets.length > 0)
            old = map.tilesets[0];
        if (!old) {
            tiled.alert("No tileset found on this map.");
            return;
        }
        var ok = false;
        try {
            map.macro("Switch Shin4 Profile", function() {
                ok = map.replaceTileset(old, ts);
                if (ok) {
                    map.setProperty("profile", profile);
                    map.setProperty("shin4.current_profile", profile);
                }
            });
        } catch (e) {
            tiled.alert("Failed to replace tileset:\n" + e);
            return;
        }
        if (!ok) {
            tiled.alert("Failed to replace tileset. The target tileset may already be referenced, or the old tileset was not found.");
            return;
        }
        refreshProfileActions();
        tiled.log("Shin4 profile switched to " + profile);
    }

    function makeAction(profile) {
        var action = tiled.registerAction("Shin4SwitchProfile_" + profile, function() {
            switchProfile(profile);
        });
        action.text = "Switch Profile: " + profile;
        actions[profile] = action;
    }

    for (var i = 0; i < KNOWN_PROFILES.length; i++)
        makeAction(KNOWN_PROFILES[i]);

    tiled.extendMenu("Map", [
        { separator: true },
        { action: "Shin4SwitchProfile_normal" },
        { action: "Shin4SwitchProfile_initial" },
        { action: "Shin4SwitchProfile_checkpoint" },
        { action: "Shin4SwitchProfile_after_switch" },
        { action: "Shin4SwitchProfile_after_checkpoint2" }
    ]);

    if (tiled.activeAssetChanged)
        tiled.activeAssetChanged.connect(refreshProfileActions);
    if (tiled.assetAboutToBeSaved)
        tiled.assetAboutToBeSaved.connect(refreshProfileActions);
    refreshProfileActions();
})();
