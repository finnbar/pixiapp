grid = {}
currentCol = 1
palette = {{255,255,255},{0,0,0},{0,255,0},{255,0,0},{0,0,255},{255,255,0},{0,255,255},{255,0,255},{180,180,180},{0,180,50},{50,0,180},{180,50,0},{50,50,0},{0,50,50}}

require("libs.loveframes")

size = 15
div = 800/size

pressed = false

--declare GUI elements here LOCALLY!
local sliderR = loveframes.Create("slider") --R
local sliderG = loveframes.Create("slider") --G
local sliderB = loveframes.Create("slider") --B
local slidSize = loveframes.Create("slider")--size
sliderR:SetPos(850,100)
sliderR:SetWidth(320)
sliderR:SetMinMax(0,255)
sliderR:SetScrollable(true)
sliderG:SetPos(850,150)
sliderG:SetWidth(320)
sliderG:SetMinMax(0,255)
sliderG:SetScrollable(true)
sliderB:SetPos(850,200)
sliderB:SetWidth(320)
sliderB:SetMinMax(0,255)
sliderB:SetScrollable(true)
slidSize:SetPos(850,400)
slidSize:SetWidth(320)
slidSize:SetMinMax(2,40)
slidSize:SetValue(15)

function love.load()
	setupTable()
end

function setupTable()
	for x=1,size,1 do
		table.insert(grid,{})
		for y=1,size,1 do
			if grid[x][y] == nil then
				table.insert(grid[x],0)
			end
		end
	end
end

function love.draw()
	--call GUI elements
	love.graphics.setColor(255,255,255)
	love.graphics.print("R",860,80)
	love.graphics.print("G",860,130)
	love.graphics.print("B",860,180)
	love.graphics.print("size",860,380)
	love.graphics.print("Instructions:\nClick to place a pixel\nUse the sliders to make a new colour\nClick on any of the squares above the sliders\nto add that colour to the palette\nClick on a colour in the palette to use it\nsize is affected by slider\nenjoy!",860,450)
	local tot = sliderR:GetValue() + sliderG:GetValue() + sliderB:GetValue()
	love.graphics.setColor(766-tot,766-tot,766-tot)
	love.graphics.rectangle("line",890,20,50,50)
	love.graphics.setBackgroundColor(sliderR:GetValue(),sliderG:GetValue(),sliderB:GetValue())
	love.graphics.setColor(sliderR:GetValue(),sliderB:GetValue(),sliderG:GetValue())
	love.graphics.rectangle("fill",950,30,30,30)
	love.graphics.setColor(sliderG:GetValue(),sliderB:GetValue(),sliderR:GetValue())
	love.graphics.rectangle("fill",990,30,30,30)
	love.graphics.setColor(sliderG:GetValue(),sliderR:GetValue(),sliderB:GetValue())
	love.graphics.rectangle("fill",1030,30,30,30)
	love.graphics.setColor(sliderB:GetValue(),sliderR:GetValue(),sliderG:GetValue())
	love.graphics.rectangle("fill",1070,30,30,30)
	love.graphics.setColor(sliderB:GetValue(),sliderG:GetValue(),sliderR:GetValue())
	love.graphics.rectangle("fill",1110,30,30,30)
	for p=1,#palette,1 do
		love.graphics.setColor(palette[p][1],palette[p][2],palette[p][3])
		love.graphics.rectangle("fill",(p-1)*30,800,30,30)
	end
	for x=1,size,1 do
		for y=1,size,1 do
			if grid[x][y] > 0 then
				local q = grid[x][y]
				local a = 255-palette[currentCol][1]-palette[q][1]
				local b = 255-palette[currentCol][2]-palette[q][2]
				local c = 255-palette[currentCol][3]-palette[q][3]
				if a<4 and a>-4 then
					if b<4 and b>-4 then
						if c<4 and c>-4 then
							local tot = sliderR:GetValue() + sliderG:GetValue() + sliderB:GetValue()
							love.graphics.setColor(766-tot,766-tot,766-tot)
							love.graphics.rectangle("line",(x-1)*div,(y-1)*div,div,div)
						else
							love.graphics.setColor(palette[q][1],palette[q][2],palette[q][3])
							love.graphics.rectangle("fill",(x-1)*div,(y-1)*div,div,div)
						end
					else
						love.graphics.setColor(palette[q][1],palette[q][2],palette[q][3])
						love.graphics.rectangle("fill",(x-1)*div,(y-1)*div,div,div)
					end
				else
				love.graphics.setColor(palette[q][1],palette[q][2],palette[q][3])
				love.graphics.rectangle("fill",(x-1)*div,(y-1)*div,div,div)
				end
			end
		end
	end
	local x=love.mouse.getX()
	local y=love.mouse.getY()
	x=math.ceil(x/div)-1
	y=math.ceil(y/div)-1
	love.graphics.setColor(255,255,255)
	if currentCol > 0 then
		love.graphics.setColor(palette[currentCol][1],palette[currentCol][2],palette[currentCol][3])
	end
	if x<size and y<size then
		love.graphics.rectangle("line",x*div,y*div,div,div)
	else
		if y>(size-1) then
			if x<size then
				local x=love.mouse.getX()
				local y=love.mouse.getY()
				x=math.ceil(x/30)
				love.graphics.rectangle("line",(x-1)*30,800,30,30)
			end
		end
	end
	love.graphics.print(love.mouse.getX().."\n"..love.mouse.getY(),10,10)
	loveframes.draw()
	slidSize.OnValueChanged = function(obj)
		size = obj:GetValue()
		setupTable()
	end
	div = 800/size
end

function love.update()
	loveframes.update()
	if pressed then
		local x=math.ceil(love.mouse.getX()/div)
		local y=math.ceil(love.mouse.getY()/div)
		if pB == "l" then
			if x<(size+1) and y<(size+1) and y>0 and x>0 then
				grid[x][y] = currentCol
			else
				local x2=love.mouse.getX()
				local y2=love.mouse.getY()
				if x2>890 and x2<940 and y2>20 and y2<70 then
					table.insert(palette,{sliderR:GetValue(),sliderG:GetValue(),sliderB:GetValue()})
					currentCol = #palette
					sliderR:SetValue(255-sliderR:GetValue())
					sliderG:SetValue(255-sliderG:GetValue())
					sliderB:SetValue(255-sliderB:GetValue())
					pressed = false
				elseif x2>950 and x2<980 and y2>30 and y2<60 then
					table.insert(palette,{sliderR:GetValue(),sliderB:GetValue(),sliderG:GetValue()})
					currentCol = #palette
					sliderR:SetValue(255-sliderR:GetValue())
					sliderG:SetValue(255-sliderG:GetValue())
					sliderB:SetValue(255-sliderB:GetValue())
					pressed = false
				elseif x2>990 and x2<1020 and y2>30 and y2<60 then
					table.insert(palette,{sliderG:GetValue(),sliderB:GetValue(),sliderR:GetValue()})
					currentCol = #palette
					sliderR:SetValue(255-sliderR:GetValue())
					sliderG:SetValue(255-sliderG:GetValue())
					sliderB:SetValue(255-sliderB:GetValue())
					pressed = false
				elseif x2>1030 and x2<1060 and y2>30 and y2<60 then
					table.insert(palette,{sliderG:GetValue(),sliderR:GetValue(),sliderB:GetValue()})
					currentCol = #palette
					sliderR:SetValue(255-sliderR:GetValue())
					sliderG:SetValue(255-sliderG:GetValue())
					sliderB:SetValue(255-sliderB:GetValue())
					pressed = false
				elseif x2>1070 and x2<1110 and y2>30 and y2<60 then
					table.insert(palette,{sliderB:GetValue(),sliderR:GetValue(),sliderG:GetValue()})
					currentCol = #palette
					sliderR:SetValue(255-sliderR:GetValue())
					sliderG:SetValue(255-sliderG:GetValue())
					sliderB:SetValue(255-sliderB:GetValue())
					pressed = false
				elseif x2>1120 and x2<1150 and y2>30 and y2<60 then
					table.insert(palette,{sliderB:GetValue(),sliderG:GetValue(),sliderR:GetValue()})
					currentCol = #palette
					sliderR:SetValue(255-sliderR:GetValue())
					sliderG:SetValue(255-sliderG:GetValue())
					sliderB:SetValue(255-sliderB:GetValue())
					pressed = false
				end
				if y>(size-1) then
					if x<size then
						local x=math.ceil(love.mouse.getX()/30)
						if palette[x] ~= nil then
							currentCol = x
							sliderR:SetValue(255-palette[x][1])
							sliderG:SetValue(255-palette[x][2])
							sliderB:SetValue(255-palette[x][3])
						else
							currentCol = 0
						end
					end
				end
			end
		else if pB == "r" then
			if x<(size+1) and y<(size+1) then
				grid[x][y] = 0
			end
		end
	end
end

function love.mousereleased(x, y, button)
	loveframes.mousereleased(x,y,button)
	pressed = false
end

function love.mousepressed(x,y,button)
	loveframes.mousepressed(x,y,button)
	pressed = true
	pB = button
end
end