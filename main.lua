Grid_size = 60
Grid_width = 8
Colors = 2
Update_steps = 25

Steps_count = 0
Paused = false

Ant = {}
Grid = {}

function love.load()
    love.window.setTitle("Langton's ant")
    love.window.setMode(Grid_size * Grid_width, Grid_size * Grid_width)

    local font = love.graphics.newFont("ThaLeahFat.ttf", 16)
    love.graphics.setFont(font)

    Reset()
end

function love.draw()
    for i = 1, Grid_size do
        for j = 1, Grid_size do
            if Grid[i][j] == 0 then
                love.graphics.setColor(0, 0, 0, 1)
            elseif Grid[i][j] == 1 then
                love.graphics.setColor(1, 1, 1, 1)
            elseif Grid[i][j] == 2 then
                love.graphics.setColor(1, 1, 0, 1)
            else
                love.graphics.setColor(0, 0, 1, 1)
            end

            love.graphics.rectangle("fill", (j - 1) * Grid_width, (i - 1) * Grid_width, Grid_width, Grid_width)
        end
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print("Steps: " .. Steps_count, 8, 8)
    love.graphics.print(Paused and "Paused" or "", 8, 20)

    local w, h = love.window.getMode()
    love.graphics.print("P to pause, R to reset", 8, h - 16)
end

function love.update(dt)
    if not Paused then
        for i = 1, Update_steps do
            Update_ant()
        end
    end
end

function love.keypressed(key)
    if key == "r" then
        Reset()
    elseif key == "p" then
        Paused = not Paused
    end
end

function Update_ant()
    local a, b = math.modf(Grid[Ant.x][Ant.y] / 2)
    local can_move = true

    if b == 0 then
        Ant.dx, Ant.dy = -1 * Ant.dy, Ant.dx
    else
        Ant.dx, Ant.dy = Ant.dy, -1 * Ant.dx
    end

    if Ant.x + Ant.dx >= 1 and Ant.x + Ant.dx <= Grid_size then
        Ant.x = Ant.x + Ant.dx
    else
        can_move = false
    end

    if Ant.y + Ant.dy >= 1 and Ant.y + Ant.dy <= Grid_size then
        Ant.y = Ant.y + Ant.dy
    else
        can_move = false
    end
    
    if can_move then
        Steps_count = Steps_count + 1
    end

    Grid[Ant.x][Ant.y] = Grid[Ant.x][Ant.y] + 1

    if Grid[Ant.x][Ant.y] >= Colors then
        Grid[Ant.x][Ant.y] = 0
    end

    return can_move
end

function Reset()
    Paused = false
    Steps_count = 0

    Ant = {
        x = math.floor(Grid_size / 2),
        y = math.floor(Grid_size / 2),
        dx = 1,
        dy = 0
    }

    for i = 1, Grid_size do
        Grid[i] = {}
        for j = 1, Grid_size do
            Grid[i][j] = 0
        end
    end
end