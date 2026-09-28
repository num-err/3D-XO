-- title:   3D Tic-Tac-Toe
-- author:  Germain Hirwa & Numer Ahmed
-- desc:    remake of Atari 3D Tic-Tac-Toe game 
-- version: 0.1
-- script:  lua


-- we turn an (x,y,z) position to a single slot number given that we store the whole cube in one 
-- long list of 64 slots since the lua tables are flat we initialize the board

size = 4

board = {}
for z = 0,3 do
    board[z] = {}
    for y = 0,3 do
        board[z][y] = {}
        for x = 0,3 do
            board[z][y][x] = 0
        end
    end
end

x, y, z = 0, 0, 0
player = 1
winner = 0
draw = false

directions = {
  {1,0,0}, {0,1,0}, {0,0,1},       -- straight along one axis
  {1,1,0}, {1,-1,0},               -- diagonal across the floor of a layer
  {1,0,1}, {1,0,-1},               -- diagonal across a side wall
  {0,1,1}, {0,1,-1},               -- diagonal across the front wall
  {1,1,1}, {1,1,-1}, {1,-1,1}, {1,-1,-1}, -- diagonal through the whole cube
}

-- checks if the coordinates are inside 4x4x4 board so that we don't try to check a cell outside 
-- our board when looking for a winning line
function inside(newX,newY,newZ)
    return newX >= 0 and newX < 4 and
           newY >= 0 and newY < 4 and
           newZ >= 0 and newZ < 4
end


function checkWin()
    for _,d in ipairs(directions) do
        local count = 1

        -- check in the positive direction
        for i = 1,3 do
            local newX = x + d[1]*i
            local newY = y + d[2]*i
            local newZ = z + d[3]*i

            if inside(newX,newY,newZ) and board[newZ][newY][newX] == player then
                count = count + 1
            else
                break
            end
        end

        -- check in the negative direction
        for i = 1,3 do
            local newX = x - d[1]*i
            local newY = y - d[2]*i
            local newZ = z - d[3]*i

            if inside(newX,newY,newZ) and board[newZ][newY][newX] == player then
                count = count + 1
            else
                break
            end
        end

        if count >= 4 then
            return true
        end
    end

    return false
end

-- This chekcs if the board is full to determine a draw
function boardFull()
    for z = 0,3 do
        for y = 0,3 do
            for x = 0,3 do
                if board[z][y][x] == 0 then
                    return false
                end
            end
        end
    end
    return true
end

function reset()
    for z = 0,3 do
        for y = 0,3 do
            for x = 0,3 do
                board[z][y][x] = 0
            end
        end
    end

    x,y,z = 0,0,0
    player = 1
    winner = 0
    draw = false
end

function TIC()

    if winner ~= 0 or draw then
        if btnp(0) or btnp(1) or btnp(2) or btnp(3)
        or btnp(4) or btnp(5) or btnp(6) then
            reset()
        end
    else

        -- controllers
        if btnp(0) then y = (y - 1) % 4 end
        if btnp(1) then y = (y + 1) % 4 end
        if btnp(2) then x = (x - 1) % 4 end
        if btnp(3) then x = (x + 1) % 4 end
        if btnp(4) then z = (z + 1) % 4 end
        if btnp(5) then z = (z - 1) % 4 end

        -- place mark
        if btnp(6) and board[z][y][x] == 0 then
            board[z][y][x] = player

            if checkWin() then
                winner = player
            elseif boardFull() then
                draw = true
            else
                if player == 1 then
                    player = 2
                else
                    player = 1
                end
            end
        end
    end

    cls(0)

    -- draw board
    for layer = 0,3 do

        print("L"..(layer+1),40,20+layer*29,13)

        for row = 0,3 do
            for col = 0,3 do

                -- These are the screen positions that we just decided arbitrary by trial & error
                local screenX = 74 + col*20 + (3-row)*6
                local screenY = 12 + row*6 + layer*29

                -- cursor
                if col == x and row == y and layer == z
                and winner == 0 and not draw then
                    rect(screenX,screenY,20,6,14)
                end

                -- cell
                line(screenX,screenY,screenX+20,screenY,13)
                line(screenX,screenY,screenX-6,screenY+6,13)
                line(screenX+20,screenY,screenX+14,screenY+6,13)
                line(screenX-6,screenY+6,screenX+14,screenY+6,13)

                local mark = board[layer][row][col]

                if mark == 1 then
                    line(screenX+5,screenY+1,screenX+9,screenY+5,12)
                    line(screenX+5,screenY+5,screenX+9,screenY+1,12)
                elseif mark == 2 then
                    circb(screenX+7,screenY+3,2,6)
                end
            end
        end
    end


    if winner == 1 then
        print("PLAYER X WINS!",8,4,12)
    elseif winner == 2 then
        print("PLAYER O WINS!",8,4,6)
    elseif draw then
        print("DRAW GAME!",8,4,15)
    elseif player == 1 then
        print("PLAYER X'S TURN",8,4,12)
    else
        print("PLAYER O'S TURN",8,4,6)
    end

    print("ARROWS: MOVE  Z: LAYER  A: PLACE",8,128,13)
end

-- <TILES>
-- 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- </TILES>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

