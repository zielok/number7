local gfx = playdate.graphics
local spriteUpdate <const> = playdate.graphics.sprite.update

local backGround = gfx.image.new('img/game')
local tiles = gfx.imagetable.new('img/puzzle')
local cursor = gfx.imagetable.new('img/cursor')
local explode = gfx.imagetable.new('img/explode')
local explodeHor = gfx.imagetable.new('img/explode7hor')
local explodeVer = gfx.imagetable.new('img/explode7ver')

local board = {}
local boardcopy = {}
local kursor = {}
local select = {}
local pathx = {}
local pathy = {}
local wybx = {}
local wyby = {}
wstawiaj = 0
local delayTime = 5
local explodeData = {};
local mergeActive = 0
local addLater = 0
score = 0


explodeData.active = 0
explodeData.type = 0

for i=0,4,1 do
    board[i] = {}
    boardcopy[i] = {}
end

local mergeTiles = {}
for i=1,25,1 do
    mergeTiles[i] = {x=0,y=0,value=0,tox=0,toy=0}
end

class('Game').extends()
function Game:init()
    drawBackgroundImage(backGround)
    self:initgame()
    gameState="game"
    removeSysMenu()
    sysMenuGame()
    FadeModule:setup1()
    FadeModule:setup1()
    self:draw()
    FadeModule:setup2()
    
end

function Game:update()
    if (playdate.buttonJustPressed("left")) then
        --print("left")
        self:cursorMove(-1,0)
    elseif (playdate.buttonJustPressed("right")) then
        --print("right")
        self:cursorMove(1,0)
    elseif (playdate.buttonJustPressed("up")) then
        --print("up")
        self:cursorMove(0,-1)
    elseif (playdate.buttonJustPressed("down")) then
        --print("down")
        self:cursorMove(0,1)
    elseif (playdate.buttonJustPressed("a")) then
        if (mergeActive==0 and addLater==0 and paintwstaw==0 and npath==0) then 
            if select[0]==0 then
                if board[kursor[1]][kursor[2]]>0 then
                    Game:selectblock()
                 else 
                    --select puste pole
                 end
            else
                if board[kursor[1]][kursor[2]]==0 then
                --move block
                    select[0]=0
                    Game:copyboard()
                    boardcopy[select[1]][select[2]]=0
                    Game:pathfind(select[1],select[2],kursor[1],kursor[2],100)
                    if boardcopy[kursor[1]][kursor[2]]>100 then
                        npath=0
                        movesprite=board[select[1]][select[2]]
                        Game:addtopath(kursor[1],kursor[2])
                        smove:play()
                        board[select[1]][select[2]]=0
                    else 
                        swrong:play()
                    end
                else 
                    Game:selectblock()
                end
            end
        end
    else
        if (delayTime<=0) then
            if (playdate.buttonIsPressed("left")) then
                --print("Pleft")
                self:cursorMove(-1,0)
            elseif (playdate.buttonIsPressed("right")) then
                --print("Pright")
                self:cursorMove(1,0)
            elseif (playdate.buttonIsPressed("up")) then
                --print("Pup")
                self:cursorMove(0,-1)
            elseif (playdate.buttonIsPressed("down")) then
                --print("Pdown")
                self:cursorMove(0,1)
            end
        end
    end
    

    kursor[3] = kursor[3] +1
    if (kursor[3]>#cursor) then kursor[3] = 1
    end
    delayTime = delayTime -1
end

function Game:cursorMove(x,y)
    if (delayTime<7) then
        delayTime = 8
        kursor[1] = kursor[1]+x
        kursor[2] = kursor[2]+y
        if (kursor[1]<0) then kursor[1] = 0
        elseif (kursor[1]>4) then kursor[1] = 4
        elseif (kursor[2]<0) then kursor[2] = 0
        elseif (kursor[2]>4) then kursor[2] = 4
        end
    end
end

function Game:draw()
    spriteUpdate()
    Game:updateMergeTile()

    --czekamy się az polącza i ewentualnie dodajemy dwa nowe tile
    if (mergeActive==0) then
            merged = false
        if (addLater==1) then
            addLater = 0
            self:checkallboard()
            if (merged==false) then
                self:wstawDwa()
            else
                addLater = 1
            end
        end
    end
    --draw board
    local temp
    for i=0,4,1 do
        for i2=0,4,1 do
            temp = board[i][i2]
            if (temp>0) then
                if (select[0]==1 and i==select[1] and i2==select[2]) then
                    temp = temp +7
                end
                tiles:drawImage(temp,83+48*i,3+48*i2)
            end
            temp = boardcopy[i][i2]
            if paintwstaw>0 and temp>0 and npath==0 then
                tiles:getImage(temp):scaledImage(playdate.easingFunctions.outBounce(30-paintwstaw,0,1,30)):drawCentered(83+48*i+21,3+48*i2+21)
            end
        end
    end

    --malowania wstawiania klocków
    if paintwstaw>0 and npath==0 then
        paintwstaw=paintwstaw-1
        if paintwstaw==0 then
            for i=0,4,1 do 
                for i2=0,4,1 do
                    if boardcopy[i][i2]>0 then
                        board[i][i2]=boardcopy[i][i2]
                        boardcopy[i][i2] = 0
                    end
                end
            end
            self:checkallboard()
            while merged do
                merged = false
                self:checkallboard()
            end
        end
    end

    -- tiles sie poruszają
    if npath>0 then
        tiles:drawImage(movesprite,83+48*pathx[npath-1],3+48*pathy[npath-1])
        npath=npath-1
        if npath==1 then
            board[kursor[1]][kursor[2]]=movesprite
            Game:checkboard(kursor[1],kursor[2])
            if (merged==false) then
                self:wstawDwa()
            else 
                addLater = 1
                --self:checkallboard()
            end
        end
    end

    --draw kursor
    cursor:drawImage(kursor[3],81+48*kursor[1],1+48*kursor[2])

    --explode
    if (explodeData.active==1) then
        if (explodeData.type==0) then
            explode:drawImage(12-math.floor(explodeData.time/2),explodeData.x,explodeData.y)
        else 
            explodeHor:drawImage(12-math.floor(explodeData.time/2),explodeData.x,1)
            explodeVer:drawImage(12-math.floor(explodeData.time/2),81,explodeData.y)
        end
        explodeData.time = explodeData.time -1
    end

     myFont:drawTextAligned(score,361,138,kTextAlignment.center)
     myFont:drawTextAligned(highscore,38,150,kTextAlignment.center)
end

function Game:wstawDwa()
    self:initwstaw()
    self:wstaw(maxvalue)
    ileJest = self:checkend()
    if (ileJest>=24) then
        Gameover:init()
    else
        self:wstaw(maxvalue)
    end
end


function Game:addtopath(x,y)
    pathx[npath]=x
    pathy[npath]=y
    npath=npath+1
    zm=boardcopy[x][y]-1
    if x>0 then
        if boardcopy[x-1][y]==zm then
            self:addtopath(x-1,y)
        end
    end
    if x<4 then
        if boardcopy[x+1][y]==zm then
            self:addtopath(x+1,y)
        end
    end
    if y>0 then
        if boardcopy[x][y-1]==zm then
            self:addtopath(x,y-1)
        end
    end
    if y<4 then
        if boardcopy[x][y+1]==zm then
            self:addtopath(x,y+1)
        end
    end
end

function Game:initgame()
    for i=0,4,1 do 
        for i2=0,4,1 do
            board[i][i2]=0
            boardcopy[i][i2]=0
        end
    end
    self:initwstaw()
    self:wstaw(1)
    self:wstaw(1)
    self:wstaw(2)
--[[
    self:wstaw(7)
    self:wstaw(7)
    self:wstaw(7)
    self:wstaw(7)
    self:wstaw(7)
    self:wstaw(7)
    self:wstaw(7)
    self:wstaw(7)
    self:wstaw(7)
    self:wstaw(7)
    self:wstaw(7)
    self:wstaw(7)
    self:wstaw(7)
    self:wstaw(7)
    self:wstaw(7)
    self:wstaw(7)
    self:wstaw(7)
    self:wstaw(7)
    self:wstaw(7)
    self:wstaw(7)
    ]]
    self:checkallboard()
    licznik=0
    kursor[1] = 2 -- x
    kursor[2] = 2 -- y
    kursor[3] = 1 -- anim frame
    select[0]=0
    select[1]=-1
    select[2]=-1
    maxvalue=2
    score=0
    npath = 0
    merged = false
    mergeActive = 0
    addLater = 0
end

function Game:checkend()
    liczba=0
    for ti=0,4,1 do 
        for ti2=0,4,1 do
            if boardcopy[ti][ti2]>0 or board[ti][ti2]>0 then
            liczba=liczba+1
            end
        end
    end
    return liczba

end

function Game:checkallboard()
    for ti=0,4,1 do 
        for ti2=0,4,1 do
            if board[ti][ti2]>0 then
                self:checkboard(ti,ti2)
            end
        end
    end
end

function Game:copyboard() 
    for i=0,4,1 do 
        for i2=0,4,1 do
            boardcopy[i][i2]=board[i][i2]
        end
    end
end

function Game:clearcopyboard() 
    for i=0,4,1 do 
        for i2=0,4,1 do
            boardcopy[i][i2]=0
        end
    end
end

function Game:selectblock()
    select[0]=1
    select[1]=kursor[1]
    select[2]=kursor[2]
end

function Game:initwstaw()
    self:clearcopyboard()
    paintwstaw=0
end

function Game:wstaw(maxi)
    if maxi==7 then
        maxi=6
    end
    local alos = (math.random(1,maxi))
    local testq=0
    
    while (testq==0) do
        x1 = math.random(5)-1
        y1 = math.random(5)-1
        if boardcopy[x1][y1]==0 and board[x1][y1]==0 then
            boardcopy[x1][y1]=alos
            testq=1
            --print("" .. x1 .." " .. y1)
        end
    end
    paintwstaw=30
    
end

function Game:checkarea(ki,ki2,val) 
    if ki>=0 and ki<=4 and ki2>=0 and ki2<=4 then
        if val>0 and boardcopy[ki][ki2]==0 then
            if val==board[ki][ki2] then
                boardcopy[ki][ki2]=1
                many=many+1
                self:checkarea(ki+1,ki2,val)
                self:checkarea(ki-1,ki2,val)
                self:checkarea(ki,ki2+1,val)
                self:checkarea(ki,ki2-1,val)
            end
        end
    end
end



function Game:checkFreeMergeTile(x1,y1,xval,tox,toy)
    temp = true
    ia = 1
    while (temp) do
        if (mergeTiles[ia].value==0) then
            mergeTiles[ia].x = x1*48
            mergeTiles[ia].y = y1*48
            mergeTiles[ia].value = xval
            mergeTiles[ia].tox = (tox - x1)*48/15
            mergeTiles[ia].toy = (toy - y1)*48/15
            mergeTiles[ia].licznik = 15
            temp = false
            mergeActive = 1
        end
        ia = ia +1
    end
end

function Game:updateMergeTile()
    for ia=1,25,1 do
        if (mergeTiles[ia].value~=0) then
            mergeTiles[ia].x = mergeTiles[ia].x + mergeTiles[ia].tox 
            mergeTiles[ia].y = mergeTiles[ia].y + mergeTiles[ia].toy
            tiles:drawImage(mergeTiles[ia].value,83+mergeTiles[ia].x,3+mergeTiles[ia].y)
            mergeTiles[ia].licznik = mergeTiles[ia].licznik - 1
            if (mergeTiles[ia].licznik==0) then
                mergeTiles[ia].value = 0
                mergeActive = 0
            end
        end
    end
end

function Game:checkboard(x, y)
    many = 1
    zap = board[x][y]
    self:clearcopyboard()
    boardcopy[x][y]=1
    self:checkarea(x+1,y,zap)
    self:checkarea(x-1,y,zap)
    self:checkarea(x,y+1,zap)
    self:checkarea(x,y-1,zap)

    if many>2 then
        -- tutaj zaczenie łaczenia
        merged = true
        score=score+many*zap
        if (zap+1>maxvalue) then
            maxvalue=zap+1
            if maxvalue>7 then 
                maxvalue=7
            end
        end
        boardcopy[x][y] = 0
        for i=0,4,1 do 
            for i2=0,4,1 do
                if boardcopy[i][i2]>0 then
                    self:checkFreeMergeTile(i,i2,board[i][i2],x,y)
                    board[i][i2]=0
                    explodeData.type = 0
                    explodeData.active = 1
                    explodeData.time = 24
                    explodeData.x = x*48+83-9
                    explodeData.y = y*48+3-9
                end
            end
        end
        board[x][y]=zap+1
        if board[x][y]>7 then 
            sseven:play()
            explodeData.type = 1
            explodeData.active = 1
            explodeData.time = 24
            explodeData.x = x*48+83
            explodeData.y = y*48+3
            board[x][0]=0
            board[x][1]=0
            board[x][2]=0
            board[x][3]=0
            board[x][4]=0
            board[0][y]=0
            board[1][y]=0
            board[2][y]=0
            board[3][y]=0
            board[4][y]=0
        else
            smerge:play()
        end
    end
end

function Game:pathfind(sx,sy,ex,ey,val)
    if boardcopy[sx][sy]==0 or boardcopy[sx][sy]>val then
        boardcopy[sx][sy]=val
        if sx==ex and sy==ey then
            return true
        else 
            if sx>0 then
                if (boardcopy[sx-1][sy]==0 or boardcopy[sx-1][sy]>val) then
                    self:pathfind(sx-1,sy,ex,ey,val+1)
                end
            end
            if sx<4 then
                if (boardcopy[sx+1][sy]==0 or boardcopy[sx+1][sy]>val) then
                    self:pathfind(sx+1,sy,ex,ey,val+1)
                end
            end
            if sy>0 then
                if (boardcopy[sx][sy-1]==0 or boardcopy[sx][sy-1]>val) then
                    self:pathfind(sx,sy-1,ex,ey,val+1)
                end
            end
            if sy<4 then
                if (boardcopy[sx][sy+1]==0 or boardcopy[sx][sy+1]>val) then
                    self:pathfind(sx,sy+1,ex,ey,val+1)
                end
            end
        end
    end
end

