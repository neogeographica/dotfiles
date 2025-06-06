-- Array of cycle-able color schemes.

-- Manually edit this value to choose allowlist or denylist.

local mode = 'allowlist'

-- If allowlist mode, just return a list of chosen schemes. First one in the
-- list will be the scheme at startup.

if mode == 'allowlist' then
  return {
    'Poimandres',
    'SpaceGray Eighties',
    'SpaceGray Eighties Dull',
    '3024 (base16)',
    'Dracula (Gogh)',
    'Guezwhoz',
    'IR Black (base16)',
    'nightfox',
  }
end

-- If not allowlist mode, then first let's identify the schemes that should
-- NOT be cycle-able. Building this list by browsing the schemes and
-- discarding the ones I'm sure I don't want, or duplicates... also in this
-- mode any new schemes that appear in future releases will be available by
-- default. Only looking at dark themes here (see below).

local wezterm = require 'wezterm'

local schemes_denylist = {
  '3024 (dark) (terminal.sexy)',
  '3024 Night',
  '3024 Night (Gogh)',
  '3024Night (Gogh)',
  'Aardvark Blue',
  'Abernathy',
  'Adventure',
  'Adventure Time (Gogh)',
  'AdventureTime',
  'Afterglow',
  'Afterglow (Gogh)',
  'Alien Blood (Gogh)',
  'AlienBlood',
  'Andromeda',
  'Apathy (base16)',
  'Apple Classic',
  'Apprentice (Gogh)',
  'Apprentice (base16)',
  'Argonaut',
  'Arthur',
  'Arthur (Gogh)',
  'Ashes (base16)',
  'Ashes (dark) (terminal.sexy)',
  'Atelier Cave (base16)',
  'Atelier Dune (base16)',
  'Atelier Estuary (base16)',
  'Atelier Heath (base16)',
  'Atelier Lakeside (base16)',
  'Atelier Sulphurpool (base16)',
  'AtelierSulphurpool',
  'Atom',
  'Atom (Gogh)',
  'Aura (Gogh)',
  'Aurora',
  'Ayu Dark (Gogh)',
  'AyuDark (Gogh)',
  'Ayu Mirage',
  'Ayu Mirage (Gogh)',
  'AyuMirage (Gogh)',
  'Azu (Gogh)',
  'Bamboo Multiplex',
  'Banana Blueberry',
  'Batman',
  'Belafonte Night',
  'Belafonte Night (Gogh)',
  'BelafonteNight (Gogh)',
  'Belge (terminal.sexy)',
  'Bespin (base16)',
  'Bespin (dark) (terminal.sexy)',
  'Bim (Gogh)',
  'Birds Of Paradise (Gogh)',
  'BirdsOfParadise',
  'Bitmute (terminal.sexy)',
  'Black Metal (Bathory) (base16)',
  'Black Metal (Burzum) (base16)',
  'Black Metal (Dark Funeral) (base16)',
  'Black Metal (Gorgoroth) (base16)',
  'Black Metal (Immortal) (base16)',
  'Black Metal (Khold) (base16)',
  'Black Metal (Marduk) (base16)',
  'Black Metal (Mayhem) (base16)',
  'Black Metal (Nile) (base16)',
  'Black Metal (Venom) (base16)',
  'Black Metal (base16)',
  'Blazer',
  'Blazer (Gogh)',
  'Blue Matrix',
  'BlueBerryPie',
  'BlueDolphin',
  'Borland',
  'Borland (Gogh)',
  'Breath (Gogh)',
  'Breath Darker (Gogh)',
  'BreathSilverfox (Gogh)',
  'Breeze',
  'Brewer (dark) (terminal.sexy)',
  'Bright (base16)',
  'Broadcast',
  'Broadcast (Gogh)',
  'Brogrammer',
  'Brogrammer (Gogh)',
  'Brogrammer (base16)',
  'Brush Trees Dark (base16)',
  'Builtin Pastel Dark',
  'Builtin Solarized Dark',
  'Builtin Tango Dark',
  'C64',
  'C64 (Gogh)',
  'Cai (Gogh)',
  'Calamity',
  'Canvased Pastel (terminal.sexy)',
  'Catch Me If You Can (terminal.sexy)',
  'Catppuccin Frappe',
  'Catppuccin Frappé (Gogh)',
  'Catppuccin Macchiato',
  'Catppuccin Mocha',
  'Chalk',
  'Chalk (base16)',
  'Chalk (Gogh)',
  'Chalk (dark) (terminal.sexy)',
  'Chalkboard',
  'Chalkboard (Gogh)',
  'ChallengerDeep',
  'Chameleon (Gogh)',
  'Ciapre',
  'Ciapre (Gogh)',
  'Circus (base16)',
  'City Streets (terminal.sexy)',
  'Classic Dark (base16)',
  'Clone Of Ubuntu (Gogh)',
  'CloneofUbuntu (Gogh)',
  'Cloud (terminal.sexy)',
  'Cobalt 2 (Gogh)',
  'Cobalt Neon',
  'Cobalt Neon (Gogh)',
  'Cobalt2',
  'CobaltNeon (Gogh)',
  'Codeschool (base16)',
  'Codeschool (dark) (terminal.sexy)',
  'Color Star (terminal.sexy)',
  'Colorful Colors (terminal.sexy)',
  'Colors (base16)',
  'Count Von Count (terminal.sexy)',
  'Crayon Pony Fish (Gogh)',
  'CrayonPonyFish',
  'Cyberdyne',
  'DWM rob (terminal.sexy)',
  'DanQing (base16)',
  'Darcula (base16)',
  'Dark Pastel (Gogh)',
  'Dark Violet (base16)',
  'Dark+',
  'DarkPastel (Gogh)',
  'Darkside',
  'Darktooth (base16)',
  'Dawn (terminal.sexy)',
  'Deafened (terminal.sexy)',
  'DeHydration (Gogh)',
  'Decaf (base16)',
  'Default Dark (base16)',
  'Derp (terminal.sexy)',
  'Desert',
  'Desert (Gogh)',
  'Dimmed Monokai (Gogh)',
  'DimmedMonokai',
  'Dissonance (Gogh)',
  'Django',
  'DjangoRebornAgain',
  'DjangoSmooth',
  'Doom Peacock',
  'Dracula',
  'Dracula (base16)',
  'Dracula (Official)',
  'Dracula+',
  'Duotone Dark',
  'ENCOM',
  'Earthsong',
  'Earthsong (Gogh)',
  'Edge Dark (base16)',
  'Ef-Autumn',
  'Ef-Bio',
  'Ef-Cherie',
  'Ef-Elea-Dark',
  'Ef-Maris-Dark',
  'Ef-Melissa-Dark',
  'Ef-Rosa',
  'Ef-Symbiosis',
  'Ef-Trio-Dark',
  'Ef-Tritanopia-Dark',
  'Eighties (base16)',
  'Eighties (dark) (terminal.sexy)',
  'Eldorado dark (terminal.sexy)',
  'Elemental',
  'Elemental (Gogh)',
  'Elementary',
  'Elementary (Gogh)',
  'Elic (Gogh)',
  'Elio (Gogh)',
  'Embers (base16)',
  'Embers (dark) (terminal.sexy)',
  'Epiphany (terminal.sexy)',
  'Eqie6 (terminal.sexy)',
  'Equilibrium Dark (base16)',
  'Equilibrium Gray Dark (base16)',
  'Erebus (terminal.sexy)',
  'Espresso',
  'Espresso (Gogh)',
  'Espresso (base16)',
  'Espresso Libre',
  'Espresso Libre (Gogh)',
  'EspressoLibre (Gogh)',
  'Eva (base16)',
  'Eva Dim (base16)',
  'Everblush',
  'Everforest Dark (Gogh)',
  'EverforestDark (Gogh)',
  'Fahrenheit',
  'Fairy Floss (Gogh)',
  'Fairy Floss Dark (Gogh)',
  'FairyFloss (Gogh)',
  'FairyFlossDark (Gogh)',
  'Fairyfloss',
  'FarSide (terminal.sexy)',
  'Fideloper',
  'Firefly Traditional',
  'FishTank',
  'Fishtank (Gogh)',
  'Flat',
  'Flat (Gogh)',
  'Flat (base16)',
  'FlatRemix (Gogh)',
  'Flatland',
  'Flatland (Gogh)',
  'flexoki-dark',
  'Floraverse',
  'Foxnightly (Gogh)',
  'Framer',
  'Freya (Gogh)',
  'FrontEndDelight',
  'Frontend Delight (Gogh)',
  'Frontend Fun Forrest (Gogh)',
  'FrontendDelight (Gogh)',
  'FrontendFunForrest (Gogh)',
  'FrontendGalaxy (Gogh)',
  'FunForrest',
  'Galizur',
  'GJM (terminal.sexy)',
  'GeoHot (Gogh)',
  'Geohot (Gogh)',
  'Glacier',
  'Gogh (Gogh)',
  'Google (dark) (terminal.sexy)',
  'GoogleDark (Gogh)',
  'gotham (Gogh)',
  'Gotham (Gogh)',
  'Gotham (terminal.sexy)',
  'Grandshell (terminal.sexy)',
  'Grape',
  'Grape (Gogh)',
  'Grass',
  'Grass (Gogh)',
  'Grayscale (dark) (terminal.sexy)',
  'Grayscale Dark (base16)',
  'Green Screen (base16)',
  'Greenscreen (dark) (terminal.sexy)',
  'Grey-green',
  'Gruber (base16)',
  'Gruvbox Dark (Gogh)',
  'Gruvbox Material (Gogh)',
  'Gruvbox dark, hard (base16)',
  'Gruvbox dark, medium (base16)',
  'Gruvbox dark, pale (base16)',
  'Gruvbox dark, soft (base16)',
  'GruvboxDark',
  'GruvboxDarkHard',
  'Hacktober',
  'Hardcore',
  'Hardcore (Gogh)',
  'Hardcore (base16)',
  'Harper',
  'Harper (Gogh)',
  'HaX0R_BLUE',
  'HaX0R_GR33N',
  'HaX0R_R3D',
  'Heetch Dark (base16)',
  'Helios (base16)',
  'Hemisu Dark (Gogh)',
  'HemisuDark (Gogh)',
  'Highway',
  'Highway (Gogh)',
  'Hipster Green',
  'Hipster Green (Gogh)',
  'HipsterGreen (Gogh)',
  'Homebrew',
  'Homebrew (Gogh)',
  'Hopscotch',
  'Hopscotch (base16)',
  'Horizon Dark (base16)',
  'HorizonDark (Gogh)',
  'hund (terminal.sexy)',
  'Hurtado',
  'Hybrid',
  'Hybrid (Gogh)',
  'IBM3270(HighContrast) (Gogh)',
  'Ibm 3270 (HighContrast) (Gogh)',
  'Ibm 3270 (High Contrast) (Gogh)',
  'iceberg-dark',
  'ICGreenPPL (Gogh)',
  'ICOrangePPL (Gogh)',
  'IC_Green_PPL',
  'IC_Orange_PPL',
  'Ic Green Ppl (Gogh)',
  'Ic Orange Ppl (Gogh)',
  'Icy Dark (base16)',
  -- Got to this point so far, looking at color schemes in order.
  -- Some other misc denies:
  'IR_Black',
  'iTerm2 Pastel Dark Background',
  'iTerm2 Solarized Dark',
  'jmbi (terminal.sexy)',
  'kokuban (Gogh)',
  'matrix',
  'mono-amber (Gogh)',
  'mono-cyan (Gogh)',
  'mono-green (Gogh)',
  'mono-red (Gogh)',
  'mono-white (Gogh)',
  'mono-yellow (Gogh)',
  'pinky (base16)',
  'purplepeter',
  's3r0 modified (terminal.sexy)',
  'seoulbones_dark',
  'summercamp (base16)',
  'synthwave-everything',
  'theme2 (terminal.sexy)',
  'tlh (terminal.sexy)',
  'zenburned',
}

-- Turn the array into a set to make it easy to check membership.
local schemes_denylist_set = {}
for _, scheme_name in ipairs(schemes_denylist) do
  schemes_denylist_set[scheme_name] = true
end

-- Build a list of dark themes that aren't in the deny set.
local allSchemes = wezterm.color.get_builtin_schemes()
local darkSchemes = {}
for name, scheme in pairs(allSchemes) do
  if schemes_denylist_set[name] == nil then
    if scheme.background then
      local bg = wezterm.color.parse(scheme.background)
      ---@diagnostic disable-next-line: unused-local
      local h, s, l, a = bg:hsla()
      if l < 0.4 then
        table.insert(darkSchemes, name)
      end
    end
  end
end
table.sort(darkSchemes)

return darkSchemes
