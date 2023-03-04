local QUIT = false


function love.load()
        arenaWidth = 800
        arenaHeight = 600

        -- KEYBOARD KEYS
        keys = {}
        keys.vim = true
        if keys.vim then
                keys.left       = {"h", "left"}
                keys.right      = {"l", "right"}
        else
                keys.left       = "left"
                keys.right      = "right"
        end
        keys.up         = {"w"}
        keys.down       = {"r", "s"}
        keys.exit = "q"

        player = {}
        player.x = arenaWidth / 2
        player.y = arenaHeight / 2
        player.r = 15   -- player radius
        player.a = 0    -- player angle
        player.turnSpeed = 10
        player.speedX = 10
        player.speedY = 0

        back = {}
        back.x = 0
        back.y = 0

        move = true
        debug = {}
        debug.main = true
        debug.vector = true
        debug.numbers = true

        -- FOR QUICKLY TURRNING BACKWARDS
        down = {}
        down.main = true
        down.count = 0
        down.max = 3



        -- TILESET
        TileW, TileH = 32,32
        Tileset = love.graphics.newImage('countryside.png')
        local tilesetW, tilesetH = Tileset:getWidth(), Tileset:getHeight()

        Quads = {
                love.graphics.newQuad(0,   0, TileW, TileH, tilesetW, tilesetH), -- 1 = grass
                love.graphics.newQuad(32,  0, TileW, TileH, tilesetW, tilesetH), -- 2 = box
                love.graphics.newQuad(0,  32, TileW, TileH, tilesetW, tilesetH), -- 3 = flowers
                love.graphics.newQuad(32, 32, TileW, TileH, tilesetW, tilesetH)  -- 4 = boxtop
        }

        TileTable = {

                { 4,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,4 },
                { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,1,4 },
                { 4,1,3,1,1,1,1,1,1,1,1,1,1,1,1,3,1,1,1,1,1,1,1,1,4 },
                { 4,1,1,1,1,1,1,1,2,1,1,2,1,1,1,1,1,1,1,1,1,1,1,1,4 },
                { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4 },
                { 4,1,1,4,1,1,1,1,1,2,2,1,1,4,1,1,1,4,1,4,2,2,1,1,4 },
                { 4,1,1,4,1,1,1,1,4,3,3,4,1,2,1,1,1,2,1,4,1,1,1,1,4 },
                { 4,1,1,4,1,1,1,1,4,3,3,4,1,1,4,1,4,1,1,4,2,2,1,1,4 },
                { 4,1,1,4,1,1,1,1,4,3,3,4,1,1,2,1,2,1,1,4,1,1,1,1,4 },           
                { 4,1,1,4,1,1,1,1,2,3,3,2,1,1,1,4,1,1,1,4,1,1,1,1,4 },
                { 4,1,1,2,2,2,2,1,1,2,2,1,1,1,1,2,1,3,1,2,2,2,1,1,4 },
                { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4 },
                { 4,1,1,1,1,1,1,1,1,2,1,1,1,1,2,2,4,1,1,1,1,1,1,1,4 },
                { 4,1,1,1,1,1,1,1,4,3,4,1,1,1,1,1,2,1,1,1,1,1,1,1,4 },
                { 4,1,1,3,1,1,1,1,2,3,2,1,1,1,1,2,1,1,1,1,1,1,1,1,4 },
                { 4,1,1,1,1,1,1,1,1,2,1,1,2,1,2,1,1,1,1,1,1,1,3,1,4 },
                { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4 },
                { 4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4 },
                { 2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2 }
        }
end



function love.update(dt)
        if player.speedX > 1000 or player.speedX < -1000
                or player.speedY > 1000 or player.speedY < -1000 then -- DEATH
                player.speedX = 0
                player.speedY = 0
        end

        local shipSpeed = 25

        if love.keyboard.isDown('q') then
                if QUIT == false then
                        QUIT = true
                else
                        QUIT = false
                end
                love.timer.sleep(0.25)
        elseif not QUIT then -- IF QUIT MENU THEN STOP
                if move then
                        if love.keyboard.isDown(keys.down) and down.main == true then -- TURNS 180 DEGREES
                                player.a = player.a + (math.pi)

                                back.x = player.speedX + math.cos(player.a)
                                back.y = player.speedY + math.sin(player.a)

                                -- down.count = 0
                                down.main = false
                        elseif love.keyboard.isDown(keys.down) and down.count < down.max then
                                -- CONTINUED PRESS ADDS VOLOCITY
                                local shipSpeed2 = shipSpeed*2 -- Back wards is faster
                                player.speedX = player.speedX + math.cos(player.a) * shipSpeed2 * dt
                                player.speedY = player.speedY + math.sin(player.a) * shipSpeed2 * dt
                                down.count = down.count + 1*dt
                        elseif love.keyboard.isDown(keys.up) then -- ADD VELOCITY
                                down.main = true

                                player.speedX = player.speedX + math.cos(player.a) * shipSpeed * dt
                                player.speedY = player.speedY + math.sin(player.a) * shipSpeed * dt
                        end

                        if love.keyboard.isDown(keys.right) then
                                player.a = player.a + player.turnSpeed * dt
                        elseif love.keyboard.isDown(keys.left) then
                                player.a = player.a - player.turnSpeed * dt
                        end
                end

                if down.count > 0 then -- RENEWING NITRO
                        down.count = down.count - 0.3*dt
                end

                -- WRAPPING THE SHIP ANGLE
                if down == true then
                        player.a = player.a % (2 * math.pi)
                end

                player.x = player.x + player.speedX * dt
                player.y = player.y + player.speedY * dt

                -- WRAPPING SHIP
                player.x = (player.x + player.speedX * dt) % arenaWidth
                player.y = (player.y + player.speedY * dt) % arenaHeight
        end
end



function love.draw()
        globalDark = {0, 0, 0, 1}
        globalLight = {0, 0, 1, 1}
        globalGreen = {0, 1, 0, 1}


        -- GLOBAL COLOR
        love.graphics.setColor(255, 255, 255)

        -- IF IN PAUSE MENU TURN GLOBAL RED
        if QUIT == true then
                globalLight = {1, 0, 0, 1}
                globalGreen = {1, 1, 1, 1}
                local Rwidth = 250
                love.graphics.setColor(1, 0, 0)
                love.graphics.rectangle("fill", arenaWidth-Rwidth, 0, Rwidth, 25)
        end

        for rowIndex=1, #TileTable do
                local row = TileTable[rowIndex]
                for columnIndex=1, #row do
                        local number = row[columnIndex]
                        local x = (columnIndex-1)*TileW
                        local y = (rowIndex-1)*TileH
                        love.graphics.draw(Tileset, Quads[number], x, y)
                end
        end

        -- PLAYER
        love.graphics.setColor(globalLight)
        love.graphics.circle( 'fill', player.x, player.y, player.r )

        love.graphics.setColor(globalGreen)
        shipDistance = 10
        love.graphics.circle( 'fill',
                player.x + math.cos(player.a) * shipDistance,
                player.y + math.sin(player.a) * shipDistance,
                3
        )

        -- DEBUG {{{
        if debug.main then
                if debug.vector then
                        -- DIRECTION VECTOR
                        love.graphics.setColor(0, 1, 0, 0.5)
                        love.graphics.circle( 'fill',
                                player.x, player.y,
                                (player.speedY)/4
                        )
                        love.graphics.setColor(1, 0, 0, 0.5)
                        love.graphics.circle( 'fill',
                                player.x, player.y,
                                (player.speedX)/4
                        )
                end 

                if debug.numbers then
                        -- NUMBERS
                        love.graphics.setColor(globalLight)
                        love.graphics.print(table.concat({
                                'shipAngle: '..player.a,
                                'shipX: '..player.x,
                                'shipY: '..player.y,
                                'shipSpeedX: '..player.speedX,
                                'shipSpeedY: '..player.speedY,
                                'randomSeed: '..math.random(os.time()),
                                'nitro: '..down.count
                        }, '\n'))
                end
        end
        -- }}}
end

function love.quit()
        if not QUIT then
                return true
        else
                return false
        end
end
