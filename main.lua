local core = {}
local key = {}
local buf = {}
local start = 0

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
    core["scene"] = 0 -- Scene : menu/game/other
    core["touch"] = -1 -- nbr item generated
    core["mem"] = 0 --Garbage collector
    key.setting()
    core["score"] = 0
    core["combo"] = 0
    love.keyboard.setKeyRepeat(false)
    core["logo"] = love.graphics.newImage("logo.png")
    core["gameOver"] = love.graphics.newImage("gameover.png")
    core["music"] = love.audio.newSource("music.mp3", 'stream')
    core["timer"] = 60  -- mettre 300
    core["spead"] = 0
    core["click"] = 0
    core["menu"] = love.graphics.newImage("menu1.png")   
    core["health"] = 20
    --mainFont = love.graphics.newFont("maghody.ttf", 12)
    --love.graphics.setFont(mainFont)
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
            buf[i].y = buf[i].y + core.spead  -- spead
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
    
    dt = math.min(dt, 1/60) --fps
    if core.scene == 0 and core.click == 0 then
        positionx = love.mouse.getX()
        positiony = love.mouse.getY()
        if (positionx > 50 and positionx < 150 and positiony > 500 and positiony < 700 and love.mouse.isDown(1)) then
            start = love.timer.getTime()
            core.scene = 1
        end
    end
    -- 
    if core.scene == 0 and love.mouse.isDown(1) == false then
        core.click = 0
    end
    if core.scene == 3 and core.click == 0 then
        if love.mouse.isDown(1) then
            core.scene = 0
            core.timer = 60
            core.score = 0
            core.combo = 0
            core.click = 1
            core.health = 5
        end
    end
    if core.scene == 2 then
        if love.timer.getTime() - start > 1 then
            core["timer"] = core["timer"] - 1
            core.health = core.health - 1
            start = love.timer.getTime()
        end
        key.appendBuffer()
        key.scrolling()
        memoryCleaner()
    end
    if core.timer == 0 or core.health == 0 then
        core.scene = 3
    end
    if core.scene == 1 then
        positionx = love.mouse.getX()
        positiony = love.mouse.getY()
        if (positionx > 230 and positionx < 300 and positiony > 100 and positiony < 150 and love.mouse.isDown(1)) then
            core.scene = 2
            core.spead = 6
        end
        if (positionx > 230 and positionx < 300 and positiony > 200 and positiony < 250 and love.mouse.isDown(1)) then
            core.scene = 2
            core.spead = 11
        end
        if (positionx > 230 and positionx < 300 and positiony > 300 and positiony < 350 and love.mouse.isDown(1)) then
            core.scene = 2
            core.spead = 16
        end
    end
end

function love.draw()
    if core.scene == 0 then
        core.drawSceneMenu()
    end
    if core.scene == 1 then
        core.drawSceneDiff()
    end
    if core.scene == 2 then
        core.drawSceneGame()
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
    if myKey == "q" and key.checkClicked(100) == 1 then    
        core.score = core.score + 10 + core.combo*2
        core.combo = core.combo + 1
        core.health = core.health + 1
    end
    if myKey == "s" and key.checkClicked(175) == 1 then     
        core.score = core.score + 10 + core.combo*2
        core.combo = core.combo + 1
        core.health = core.health + 1
    end
    if myKey == "d" and key.checkClicked(250) == 1 then        
        core.score = core.score + 10 + core.combo*2
        core.combo = core.combo + 1
        core.health = core.health + 1
    end
    if myKey == "f" and key.checkClicked(325) == 1 then
        core.score = core.score + 10 + core.combo*2
        core.combo = core.combo + 1
        core.health = core.health + 1
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
    love.graphics.print("score:", 420, 100, 0, 2, 2)
    love.graphics.print(core.score, 420, 180, 0, 3, 3)
    love.graphics.print("combo:", 600, 100, 0, 2, 2)
    love.graphics.print(core.combo, 600, 180, 0, 3, 3)
    love.audio.play(core.music)
    love.graphics.print("timer:", 500, 50, 0, 2, 2)
    love.graphics.print(core.timer, 600, 45, 0, 3, 3)
    love.graphics.print("health:", 450, 500, 0, 3, 3)
    love.graphics.print(core.health, 600, 500, 0, 3, 3)
end

function core.drawSceneMenu()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(core.logo, 100, 20)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("fill", 0, 500, 800, 60)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print("Play", 50, 500, 0, 4, 4)
end

function core.drawSceneDiff()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("easy", 230, 100, 0, 3, 3)
    love.graphics.print("normal", 230, 200, 0, 3, 3)
    love.graphics.print("hard", 230, 300, 0, 3, 3)
end

function core.drawSceneGameOver()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Game Over", 230, 100, 0, 5, 5)
    love.graphics.print("Score final:", 300, 300, 0, 3, 3)
    love.graphics.print(core.score, 300, 370, 0, 3, 3)
    love.graphics.rectangle("fill", 0, 500, 800, 60)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print("Restart", 50, 500, 0, 4, 4)
    love.audio.stop(core.music)
end