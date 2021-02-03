local core = {}
local key = {}
local buf = {}
--local highscores = {}
local start = 0
local state = not love.mouse.isVisible()

function key.setting()
    -- Setup Keys config
    key[0], key[1], key[2], key[3] = {}, {}, {}, {}
    key[0].x = 100
    key[0].y = -50
    key[0].width = 50
    key[0].height = 50
    key[0].mode = 0
    key[1].x = 175
    key[1].y = -50
    key[1].width = 50
    key[1].height = 50
    key[1].mode = 0
    key[2].x = 250
    key[2].y = -50
    key[2].width = 50
    key[2].height = 50
    key[2].mode = 0
    key[3].x = 325
    key[3].y = -50
    key[3].width = 50
    key[3].height = 50
    key[3].mode = 0
end

function love.load()
    love.window.setMode(800, 600, flags)
    love.window.setTitle("Guitar Presque Hero")
    core["scene"] = 0   -- Scene : menu/game/other
    core["touch"] = -1  -- nbr item generated
    core["mem"] = 0     -- Garbage collector
    key.setting()
    core["score"] = 0
    core["combo"] = 0
    core["q"] = love.graphics.newImage("q3.png")
    core["s"] = love.graphics.newImage("s3.png")
    core["d"] = love.graphics.newImage("d3.png")
    core["f"] = love.graphics.newImage("f3.png")
    love.keyboard.setKeyRepeat(false)
    core["logo"] = love.graphics.newImage("acceuil21.png")
    core["perso"] = love.graphics.newImage("perso.png")
    core["music"] = love.audio.newSource("My Fate.mp3", 'stream')
    core["timer"] = 400  -- mettre 300
    core["spead"] = 0
    core["click"] = 0   
    core["health"] = 20 -----------mettre 10
    core["play"] = 0
    core["visible"] = 0
    core["anim"] = 0
    --core["highscore"] = 0
    mainFont = love.graphics.newFont("27thRPS-Regular.TTF", 50)
    love.graphics.setFont(mainFont)
    cursorClick = love.mouse.newCursor("handt8.PNG", 20, 20)
    cursor = love.mouse.newCursor("pointer1.PNG", 10, 0)
    love.mouse.setCursor(cursor)

    --info = love.filesystem.getInfo( "scores.lua")
    --if not love.filesystem.exists("scores.lua") then
    --    scores = love.filesystem.newFile("scores.lua")
    --end

    --love.filesystem.write("scores.lua", "core.highscore\n=\n", core.highscore)

    --local highscores = {}
    --for line in love.filesystem.lines("scores.lua") do
    --    table.insert(highscores, line)
    --end
    --core.highscore = highscores[3]
end

function key.appendBuffer()
    if (math.random(1000) < 20) then
        -- append nbr items
        core.touch = core.touch + 1
        -- create object depending on key config
        buf[core.touch] = {}
        buf[core.touch].x = key[math.random(4) - 1].x
        buf[core.touch].y = -50
        buf[core.touch].anim = 1
    end
end

function key.scrolling()
    for i = 0, core.touch do
        -- scrolling objects
        if (buf[i] ~= nil) then
            buf[i].y = buf[i].y + core.spead
        end
        -- reset objects
        if (buf[i] ~= nil and buf[i].y == 600) then
            buf[i].y = nil
            buf[i].x = nil
            buf[i] = nil
        end
    end
end

function memoryCleaner()
    -- clean memory
    core.mem = core.mem + 1
    if (core.mem == 500) then
        collectgarbage()
    end
end

function love.update(dt)

    positionx = love.mouse.getX()
    positiony = love.mouse.getY()
    dt = math.min(dt, 1/60) --fps
    if core.scene == 0 and core.click == 0 then
        if (positionx > 50 and positionx < 150 and positiony > 500 and positiony < 560) then
            love.mouse.setCursor(cursorClick)
            if love.mouse.isDown(1) then
            start = love.timer.getTime()
            core.scene = 0.5
            end
        else
            love.mouse.setCursor(cursor)
        end
    end
    -----------------------------------------------------------
    if core.scene == 0 and love.mouse.isDown(1) == false then
        core.click = 0
    end
    -----------------------------------------------------------
    if core.scene == 3 and core.click == 0 then    
        core.visible = core.visible + 1 
        if (positionx > 50 and positionx < 230 and positiony > 500 and positiony < 560 or
        positionx > 680 and positionx < 790 and positiony > 500 and positiony < 560) then
            love.mouse.setCursor(cursorClick)
            if love.mouse.isDown(1) and positionx > 50 and positionx < 230 and positiony > 500 and positiony < 560 then
                core.scene = 0
                core.timer = 60
                core.score = 0
                core.combo = 0
                core.click = 1
                core.health = 20
                core.visible = 0
                core.wall = 0
                core.math = 0
            end
            if love.mouse.isDown(1) and positionx > 680 and positionx < 770 and positiony > 500 and positiony < 560 then
                love.quit()
            end
        else
            love.mouse.setCursor(cursor)
        end
    end
    -----------------------------------------------------------
    if core.scene == 2 then
       
        love.mouse.setVisible(state)
      
        if love.timer.getTime() - start > 1 then
            core["timer"] = core["timer"] - 1
            core.health = core.health - 1
            start = love.timer.getTime()
        end
        key.appendBuffer()
        key.scrolling()
        memoryCleaner()
    end
    -----------------------------------------------------------
    if core.timer == 0 or core.health == 0 then
        core.scene = 3
    end
    -----------------------------------------------------------
    if core.scene == 1 then
        if (positionx > 230 and positionx < 300 and positiony > 100 and positiony < 150 and love.mouse.isDown(1)) then
            core.scene = 2
            core.spead = 6  --------------------mettre 6
        end
        if (positionx > 230 and positionx < 350 and positiony > 200 and positiony < 250 and love.mouse.isDown(1)) then
            core.scene = 2
            core.spead = 11
        end
        if (positionx > 230 and positionx < 350 and positiony > 300 and positiony < 350 and love.mouse.isDown(1)) then
            core.scene = 2
            core.spead = 16
        end
        if (positionx > 230 and positionx < 330 and positiony > 100 and positiony < 150) or
        (positionx > 230 and positionx < 370 and positiony > 200 and positiony < 250) or
        (positionx > 230 and positionx < 330 and positiony > 300 and positiony < 350) then
            love.mouse.setCursor(cursorClick)
        else
            love.mouse.setCursor(cursor)
        end
    end
    -----------------------------------------------------------
    if core.scene == 0.5 then
        if (positionx > 250 and positionx < 350 and positiony > 150 and positiony < 200) or
        (positionx > 250 and positionx < 490 and positiony > 250 and positiony < 300) or
        (positionx > 250 and positionx < 525 and positiony > 350 and positiony < 400) then
            love.mouse.setCursor(cursorClick)
        else
            love.mouse.setCursor(cursor)
        end
        if (positionx > 250 and positionx < 350 and positiony > 150 and positiony < 200) then
            if core.play == 0 then
                core.music = love.audio.newSource("My Fate.mp3", 'stream')
                love.audio.play(core.music)
                core.play = 1
            end
            if love.mouse.isDown(1) then
                core.scene = 1
            end
        elseif (positionx > 250 and positionx < 490 and positiony > 250 and positiony < 300) then
            love.audio.newSource("Under The Gun.mp3", 'stream')
            if core.play == 0 then
                core.music = love.audio.newSource("Under The Gun.mp3", 'stream')
                love.audio.play(core.music)
                core.play = 1
            end
            if love.mouse.isDown(1) then
                core.scene = 1
            end
        elseif (positionx > 250 and positionx < 525 and positiony > 350 and positiony < 400) then
            love.audio.newSource("Erebus.mp3", 'stream')
            if core.play == 0 then
                core.music = love.audio.newSource("Erebus.mp3", 'stream')
                love.audio.play(core.music)
                core.play = 1
            end
            if love.mouse.isDown(1) then
                core.scene = 1
            end
        else
            love.audio.stop(core.music)
            core.play = 0
        end
    end
    ---------------------------------------------------------
    if core.visible == 1 then
        local state = not love.mouse.isVisible()
        love.mouse.setVisible(state)   
    end

    love.dropObject()

    --if core.score > core.highscore then
    --    core.highscore = core.score
    --    love.filesystem.write("scores.lua", "core.highscore\n=\n", core.highscore)
    --end

end

function love.draw()
    if core.scene == 0 then
        core.drawSceneMenu()
    end
    if core.scene == 0.5 then
        core.drawSceneSong()
    end
    if core.scene == 1 then
        core.drawSceneDiff()
    end
    if core.scene == 2 then
        core.drawSceneGame()
        --love.dropObject()
        --core.animPerso()
    end
    if core.scene == 3 then
        core.drawSceneGameOver()
    end
end

function core.ui()
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.rectangle("fill", 95, 0, 60, 600)
    love.graphics.rectangle("fill", 170, 0, 60, 600)
    love.graphics.rectangle("fill", 245, 0, 60, 600)
    love.graphics.rectangle("fill", 320, 0, 60, 600)
end

function key.checkClicked(x)
    for i = 0, core.touch do
        if (buf[i] ~= nil and buf[i].x == x and buf[i].y > 500 and buf[i].y < 650) then
            buf[i].anim = buf[i].anim - 0.4
            return (1)
        end
    end
    return (0)
end

function key.fadeOut()
    for i = 0, core.touch do
        if (buf[i] ~= nil and buf[i].anim < 1) then
            buf[i].anim = buf.anim - 0.1
        end
        if (buf[i] ~= nil and buf[i].anim == 0) then
            buf[i].y = nil
            buf[i].x = nil
            buf[i] = nil
        end
    end
end

function love.keypressed(myKey)
    if myKey == "q" then
        core.q = love.graphics.newImage("q5.png")
        if key.checkClicked(100) == 1 then    
        core.score = core.score + 10 + core.combo*2
        core.combo = core.combo + 1
        core.health = core.health + 1
        core.animPerso()
        end
    end
    if myKey == "s" then
        core.s = love.graphics.newImage("s2.png")
        if key.checkClicked(175) == 1 then     
        core.score = core.score + 10 + core.combo*2
        core.combo = core.combo + 1
        core.health = core.health + 1
        end
    end
    if myKey == "d" then
        core.d = love.graphics.newImage("d2.png")
        if key.checkClicked(250) == 1 then        
        core.score = core.score + 10 + core.combo*2
        core.combo = core.combo + 1
        core.health = core.health + 1
        end
    end
    if myKey == "f" then
        core.f = love.graphics.newImage("f2.png")
        if key.checkClicked(325) == 1 then
        core.score = core.score + 10 + core.combo*2
        core.combo = core.combo + 1
        core.health = core.health + 1
        end
    end
end

function love.keyreleased(myKey)
    if myKey == "q" then 
        core.q = love.graphics.newImage("q3.png")
    end
    if myKey == "s" then 
        core.s = love.graphics.newImage("s3.png")
    end
    if myKey == "d" then 
        core.d = love.graphics.newImage("d3.png")
    end
    if myKey == "f" then 
        core.f = love.graphics.newImage("f3.png")
    end
end

function core.drawSceneGame()
    core.ui()
    for i = 0, core.touch do
        -- if objects exists, print it with color
        if (buf[i] ~= nil) then
            love.graphics.setColor(0, 0.66, 0.66, 1)
            if buf[i].anim < 1 then
                love.graphics.setColor(0, 0, 0, buf[i].anim)
            end
            love.graphics.rectangle("fill", buf[i].x, buf[i].y, 50, 30)
        end
    end
    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle("fill", 0, 500, 800, 40)
    love.graphics.print("Score:", 420, 100, 0, 0.7, 0.7)
    love.graphics.print(core.score, 420, 180, 0, 1, 1)
    love.graphics.print("Combo:", 600, 100, 0, 0.7, 0.7)
    love.graphics.print(core.combo, 600, 180, 0, 1, 1)
    love.audio.play(core.music)
    love.graphics.print("Timer:", 500, 50, 0, 0.7, 0.7)
    love.graphics.print(core.timer, 600, 45, 0, 1, 1)
    love.graphics.print("Health:", 450, 500, 0, 0.7, 0.7)
    love.graphics.print(core.health, 600, 500, 0, 1, 1)
    love.graphics.draw(core.q, 109, 505)
    love.graphics.draw(core.s, 184, 504)
    love.graphics.draw(core.d, 259, 504)
    love.graphics.draw(core.f, 334, 504)
end

function core.drawSceneMenu() 
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(core.logo, 0, 0)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 0, 500, 200, 60)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print("Play", 50, 496, 0, 1.3, 1.3)
    love.graphics.rectangle("fill", 100, 100, 50, 30)
end

function core.drawSceneDiff()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Easy", 230, 100, 0, 1.1, 1.1)
    love.graphics.print("Normal", 230, 200, 0, 1.1, 1.1)
    love.graphics.print("Hard", 230, 300, 0, 1.1, 1.1)
    love.audio.stop(core.music)
end

function core.drawSceneGameOver()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Game Over", 230, 80, 0, 2, 2)
    love.graphics.print("Score final :", 250, 220, 0, 1.2, 1.2)
    love.graphics.print(core.score, 320, 270, 0, 1, 1)
    --love.graphics.print("Highscore :", 250, 320, 0, 1.2, 1.2)
    --love.graphics.print(core.score, 320, 350, 0, 1, 1)
    love.graphics.rectangle("fill", 0, 500, 800, 60)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print("Restart", 50, 496, 0, 1.3, 1.3)
    love.audio.stop(core.music)
    love.graphics.print("Quit", 680, 496, 0, 1.3, 1.3)
end

function core.drawSceneSong()
    love.graphics.print("Select a Song :", 230, 50, 0, 1.3, 1.3)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Vimic", 250, 150, 0, 1, 1)
    love.graphics.print("Born of Osiris", 250, 250, 0, 1, 1)
    love.graphics.print("Aversions Crown", 250, 350, 0, 1, 1)
end

function core.animPerso()
        if key.checkClicked(100) == 1 and myKey == "q" then
            core.perso = love.graphics.newImage("perso.png")
            love.graphics.draw(core.perso, 480, 264)
        elseif key.checkClicked(175) == 1 then
            core.perso = love.graphics.newImage("perso2.png")
            love.graphics.draw(core.perso, 480, 283)
        elseif key.checkClicked(250) == 1 then
            core.perso = love.graphics.newImage("perso41.png")
            love.graphics.draw(core.perso, 470, 270)
        elseif key.checkClicked(325) == 1 then
            core.perso = love.graphics.newImage("perso9.png")
            love.graphics.draw(core.perso, 480, 283)
        else
            core.perso = love.graphics.newImage("perso1.png")
            love.graphics.draw(core.perso, 420, 284)
        end
end

function love.quit()
    love.event.quit()
    --love.filesystem.write("scores.lua", "core.highscore\n=\n", core.highscore)
end

function love.dropObject()
    if love.timer.getTime() == 2 then
        love.graphics.rectangle("fill", 100, 50, -50, 30)
    end
end