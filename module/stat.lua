---@type Zenitha.Scene
local scene = {}

local maskAlpha, cardShow
local card = GC.newCanvas(1200, 720)

local floor = math.floor

local baseColor = { .08, .26, .14 }
local areaColor = { .08, .23, .12 }
local titleColor = { COLOR.HEX("16582D") }
local textColor = { COLOR.HEX("54B06D") }
local scoreColor = { COLOR.HEX("B0FFC0") }
local setup = { stencil = true, card }

local function calculateRating()
    return "-----"
end

local sawMap = {
    { 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
    { 1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 1, 0, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0 },
    { 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0 },
}
local saw = { w = 30, h = 3 }
for y = 1, 3 do
    for x = 1, 30 do
        if sawMap[y][x] == 1 then
            table.insert(saw, { 'fRect', x - 1, y - 1, 1, 1 })
        end
    end
end
saw = GC.load(saw)
saw:setFilter('nearest', 'nearest')
saw:setWrap('repeat', 'repeat')
local sawQuad = GC.newQuad(0, 0, 180, 3, saw)
local bannerQuad = GC.newQuad(0, 220, 512, 256, TEXTURE.banner)
local function dblMidStr(str, x, y)
    GC.mStr(str, x, y)
    GC.setAlpha(.6)
    GC.mStr(str, x, y + 3)
end
function RefreshProfile()
    GC.setCanvas(setup)
    GC.origin()
    GC.clear(baseColor[1], baseColor[2], baseColor[3], 0)


    local t30 = GC.newText(FONT.get(30))
    local t50 = GC.newText(FONT.get(50))

    -- Banner
    GC.setColor(.42, .42, .42)
    GC.draw(TEXTURE.banner, bannerQuad, 0, 10, 0, 1200 / 512, 150 / 256)

    -- Main panel & frame
    GC.setColor(baseColor)
    -- base
    GC.rectangle('fill', 0, 720, 1200, -560)
    -- deco
    GC.draw(saw, sawQuad, 0, 720 - 560, 0, 7.2, 7.2, 0, 3)
    -- top ribbon
    GC.setColor(areaColor)
    GC.rectangle('fill', 0, 210, 1200, 60)
    -- bottom ribbon
    GC.rectangle('fill', 0, 720, 1200, -90)
    -- github link
    FONT.set(50)
    GC.setColor(scoreColor)
    GC.printf("↗  VIEW SOURCE FILE", 0, 640, 1200, 'center')
    -- bottom dark
    GC.setColor(.04, .16, .08)
    GC.rectangle('fill', 0, 720, 1200, -3)
    -- right dark
    GC.setColor(.08, .2, .1)
    GC.rectangle('fill', 1200, 720, -3, -560)
    GC.draw(TEXTURE.transition, 1200, 720 - 560, -1.5708, .626, -3)
    -- left light
    GC.setColor(.26, .42, .32)
    GC.rectangle('fill', 0, 720, 3, -560)
    GC.draw(TEXTURE.transition, 0, 720 - 560, -1.5708, .626, 3)

    -- X
    FONT.set(30)
    GC.setColor(COLOR.DL)
    GC.print("CLOSE", 1068 - 10, 45 - 3, 0, 1.2)

    -- PFP
    GC.setColor(1, 1, 1)
    GC.stc_setComp()
    GC.stc_rect(30, 0, 120, 120, 6)
    GC.draw(TEXTURE.avatar, 20, 0, 0, 130 / TEXTURE.avatar:getWidth())
    GC.stc_stop()

    -- ID
    FONT.set(30)
    GC.print(("Joined " .. STAT.joinDate):upper(), 165, 96, 0, .7)
    FONT.set(50)
    GC.setColor(COLOR.L)
    GC.print(STAT.uid, 165, 18, 0, 1.2)

    -- Time
    GC.ucs_move('m', 1065, 165)
    GC.setColor(areaColor)
    GC.rectangle('fill', 0, 0, 110, 40, 5)
    GC.setColor(1, 1, 1)
    FONT.set(30)
    GC.mStr(STAT.totalTime <= 36000 and
        { scoreColor, floor(STAT.totalTime / 60), textColor, "min" }
        or { scoreColor, floor(STAT.totalTime / 3600), textColor, "H" },
        55, 0)
    GC.ucs_back()

    -- Clicker
    GC.setColor(1, 1, 1)
    GC.mDraw(TEXTURE.clicker, 970, 182, 0, .626)

    -- Introduction
    GC.ucs_move('m', 25, 280)
    GC.setColor(areaColor)
    GC.rectangle('fill', 0, 0, 1150, 80)
    FONT.set(30)
    GC.setColor(titleColor)
    GC.print("ABOUT  ME", 7, 2, 0, .8)
    GC.setColor(textColor)
    GC.print(STAT.aboutme, 15, 35, 0, .8)
    GC.ucs_back()

    GC.setLineWidth(2)

    -- Rating
    GC.ucs_move('m', 25, 370)
    GC.setColor(areaColor)
    GC.rectangle('fill', 0, 0, 375, 120)
    FONT.set(30)
    GC.setColor(titleColor)
    GC.print("CLICKER  LEAGUE", 7, 2, 0, .8)
    GC.line(7, 90, 370 - 7, 90)
    FONT.set(50)
    t50:set(calculateRating())
    GC.setColor(scoreColor)
    GC.draw(t50, 370 / 2, 24, 0, 1, 1, t50:getWidth() / 2)
    GC.setAlpha(.6)
    GC.draw(t50, 370 / 2, 24 + 3, 0, 1, 1, t50:getWidth() / 2)
    GC.setColor(textColor)
    t30:set("CR")
    GC.draw(t30, 370 / 2 + t50:getWidth() / 2, 47)
    GC.ucs_back()

    -- Height
    GC.ucs_move('m', 412.5, 370)
    GC.setColor(areaColor)
    GC.rectangle('fill', 0, 0, 375, 120)
    FONT.set(30)
    GC.setColor(titleColor)
    GC.print("MAX  ALTITUDE", 7, 2, 0, .8)
    GC.line(7, 90, 370 - 7, 90)
    GC.setColor(textColor)
    t30:set(STAT.heightDate)
    GC.mDraw(t30, 370 / 2, 105, 0, .75)
    GC.setColor(scoreColor)
    FONT.set(50)
    dblMidStr(STAT.maxHeight .. "m", 370 / 2, 24)
    GC.ucs_back()

    -- Speedrun
    GC.ucs_move('m', 800, 370)
    GC.setColor(areaColor)
    GC.rectangle('fill', 0, 0, 375, 120)
    FONT.set(30)
    GC.setColor(titleColor)
    GC.print("FASTEST  SPEEDRUN", 7, 2, 0, .8)
    GC.line(7, 90, 370 - 7, 90)
    GC.setColor(textColor)
    t30:set(STAT.timeDate)
    GC.mDraw(t30, 370 / 2, 105, 0, .75)
    GC.setColor(scoreColor)
    FONT.set(50)
    dblMidStr(STRING.time(STAT.minTime), 370 / 2, 24)
    GC.ucs_back()

    -- Career
    GC.ucs_move('m', 25, 500)
    GC.setColor(areaColor)
    GC.rectangle('fill', 0, 0, 570, 120)
    FONT.set(30)
    GC.setColor(titleColor)
    GC.print("CAREER", 7, 2, 0, .8)
    FONT.set(50)
    GC.setColor(scoreColor)
    -- TODO
    GC.ucs_back()

    -- Full stats
    GC.ucs_move('m', 605, 500)
    GC.setColor(areaColor)
    GC.rectangle('fill', 0, 0, 570, 120)
    FONT.set(30)
    GC.setColor(titleColor)
    GC.print("FULL  STATS", 7, 2, 0, .8)
    local l = {
        { "Game",   { scoreColor, STAT.totalGame },                                   x = 26,  y = 35 },
        { "Ascent", { scoreColor, STAT.totalF10 },                                    x = 26,  y = 60 },
        { "Giga",   { scoreColor, STAT.totalGiga },                                   x = 26,  y = 85 },
        { "Flip",   { scoreColor, STAT.totalFlip },                                   x = 196, y = 35 },
        { "Quest",  { scoreColor, STAT.totalQuest },                                  x = 196, y = 60 },
        { "Attack", { scoreColor, STAT.totalAttack },                                 x = 196, y = 85 },
        { "Floor",  { scoreColor, STAT.totalFloor },                                  x = 380, y = 60 },
        { "Height", { scoreColor, floor(STAT.totalHeight * .001), textColor, " km" }, x = 380, y = 85 },
    }
    for i = 1, #l do
        local v = l[i]
        GC.setColor(textColor)
        GC.print(v[1], v.x, v.y, 0, .75)
        GC.setColor(1, 1, 1)
        GC.print(v[2], v.x + 80, v.y, 0, .75)
    end
    GC.ucs_back()

    GC.setCanvas()
end

function scene.load()
    TASK.lock('stat_no_quit')
    maskAlpha, cardShow = 0, 0
    TWEEN.new(function(t)
        maskAlpha = t
    end):setTag('stat_in'):setDuration(.26):run():setOnFinish(function()
        TWEEN.new(function(t)
            cardShow = t
        end):setTag('stat_in'):setDuration(.1):run():setOnFinish(function()
            TASK.unlock('stat_no_quit')
        end)
    end)

    RefreshProfile()

    local W = scene.widgetList.link
    W.y = GAME.anyRev and -210 or 210
    W:resetPos()
    W = scene.widgetList.close
    W.y = GAME.anyRev and 196 or -196
    W:resetPos()
end

function scene.keyDown(key, isRep)
    if isRep then return true end
    if key == 'escape' and TASK.lock('stat_no_quit') then
        SFX.play('menuclick')
        TWEEN.tag_kill('stat_in')
        TWEEN.new(function(t)
            cardShow = 1 - t
        end):setDuration(.26):run():setOnFinish(function()
            TWEEN.new(function(t)
                maskAlpha = 1 - t
            end):setDuration(.26):run():setOnFinish(function()
                SCN.back('none')
                TASK.unlock('stat_no_quit')
            end)
        end)
    end
    ZENITHA.setCursorVis(true)
    return true
end

function scene.update(dt)
    SCN.scenes.tower.update(dt)
    for _, W in next, SCN.scenes.tower.widgetList do
        W:update(dt)
    end
end

function scene.draw()
    SCN.scenes.tower.draw()
    GC.replaceTransform(SCR.xOy)
    WIDGET.draw(SCN.scenes.tower.widgetList)
    SCN.scenes.tower.overDraw()
    GC.origin()
    GC.setColor(0, 0, 0, maskAlpha * .7023)
    GC.rectangle('fill', 0, 0, SCR.w, SCR.h)

    if cardShow > 0 then
        GC.replaceTransform(SCR.xOy_m)
        GC.setColor(1, 1, 1, cardShow)
        local k = .9 + cardShow * .1
        GC.mDraw(card, 0, 0, 0, k * .67, k ^ 26 * .67 * (GAME.anyRev and -1 or 1))
    end
end

scene.widgetList = {
    WIDGET.new {
        name = 'back', type = 'button',
        pos = { 0, 0 }, x = 60, y = 140, w = 160, h = 60,
        color = { .15, .15, .15 },
        sound_hover = 'menutap',
        fontSize = 35, text = "    BACK", textColor = 'DL',
        onClick = function() love.keypressed('escape') end,
    },
    WIDGET.new {
        name = 'link', type = 'button_invis',
        pos = { .5, .5 }, y = 210, w = 800, h = 60,
        onClick = function()
            SFX.play('menuconfirm')
            love.system.openURL("https://github.com/MrZ626/ZenithClicker")
        end,
    },
    WIDGET.new {
        name = 'close', type = 'button_invis',
        pos = { .5, .5 }, x = 344, y = -196, w = 100, h = 50,
        onClick = function() love.keypressed('escape') end,
    },
    WIDGET.new {
        name = 'protect', type = 'button_invis',
        pos = { .5, .5 }, w = 820, h = 500,
    },
    WIDGET.new {
        type = 'button_invis',
        pos = { .5, .5 }, w = 3500, h = 2600,
        onClick = function() love.keypressed('escape') end,
    }
}

return scene
