layers = {}
currentCol = 1
palette = {{255,255,255},{0,0,0},{0,255,0},{255,0,0},{0,0,255},{255,255,0},{0,255,255},{255,0,255},{180,180,180},{0,180,50},{50,0,180},{180,50,0},{50,50,0},{0,50,50}}

require("libs.loveframes")

size = 40  --grid size
div = 800/size
olDiv = 800/size

ex,ey,ex2,ey2 = 0,0,0,0
letgo = true
focus = true

func = 0
--0: normal brush; 1,2: rectangle;

backg = true

lay = 1

up,down,left,right = false,false,false,false

lOf = 0
uOf = 0

pressed = false

--declare GUI elements here LOCALLY!
local sliderR = loveframes.Create("slider") --R
local sliderG = loveframes.Create("slider") --G
local sliderB = loveframes.Create("slider") --B
local slidSize = loveframes.Create("slider")--size
local pixSize = loveframes.Create("slider") --pixel size
local list = loveframes.Create("list")
local addLay = loveframes.Create("button")
local offsetX = loveframes.Create("slider")
local offsetY = loveframes.Create("slider")
local resetOffset = loveframes.Create("button")
local instructions = loveframes.Create("button")
local saveF = loveframes.Create("textinput")
local saveIt = loveframes.Create("button")
local openIt = loveframes.Create("button")
local paint = loveframes.Create("button")
local rect = loveframes.Create("button")
local settings = loveframes.Create("button")
settings:SetPos(850,540)
settings:SetText("settings")
rect:SetPos(1030,450)
rect:SetText("rectangle")
paint:SetPos(940,450)
paint:SetText("paint")
saveIt:SetPos(1050,500)
saveIt:SetText(".pixl SAVE")
openIt:SetPos(1050,525)
openIt:SetText(".pixl OPEN")
saveF:SetPos(850,500)
saveF:SetText("THIS ISN'T WORKING YET :P")
instructions:SetPos(940,540)
instructions:SetText("HELP!")
local tooltips = {}
for e=1,7,1 do
	tooltips[e] = loveframes.Create("tooltip")
end
frame = 0
tooltips[1]:SetObject(sliderR)
tooltips[1]:SetText("RGB Red Value (0-255)")
tooltips[2]:SetObject(sliderG)
tooltips[2]:SetText("RGB Green Value (0-255)")
tooltips[3]:SetObject(sliderB)
tooltips[3]:SetText("RGB Blue Value (0-255)")
tooltips[4]:SetObject(slidSize)
tooltips[4]:SetText("Size of the canvas (2x2 to 40x40)")
tooltips[5]:SetObject(pixSize)
tooltips[5]:SetText("Size of each pixel")
tooltips[6]:SetObject(offsetX)
tooltips[6]:SetText("Pixel x offset")
tooltips[7]:SetObject(offsetY)
tooltips[7]:SetText("Pixel y offset")
resetOffset:SetPos(1010,290)
resetOffset:SetSize(100,20)
resetOffset:SetText("Reset offset")
offsetX:SetPos(850,320)
offsetX:SetWidth(320)
offsetX:SetMinMax(-1,1)
offsetX:SetValue(0)
offsetY:SetPos(850,350)
offsetY:SetWidth(320)
offsetY:SetMinMax(-1,1)
offsetY:SetValue(0)
addLay:SetPos(850,745)
addLay:SetText("Add Layer")
list:SetPos(850,590)
--first button
layBut = {} --butttons in the "add layer" dialouge
layBut[1] = loveframes.Create("button")
list:AddItem(layBut[1])
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
slidSize:SetValue(40)
pixSize:SetPos(850,260)
pixSize:SetWidth(320)
pixSize:SetMinMax(0,div)
pixSize:SetValue(div)

function love.load()
	setupTable(1)
end

function setupTable(layer)
	if layers[layer] == nil then
		table.insert(layers,{}) --layers[l]
	end
	local l = layer
	for x=1,size,1 do
		table.insert(layers[l],{}) --layers[l][x] (LinuX!)
		for y=1,size,1 do
			table.insert(layers[l][x],{}) --layers[l][x][y] (LinuXY?)
			for z=1,3,1 do
				table.insert(layers[l][x][y],0) --layers[l][x][y][z] (LinuXYZ... ok forget it)
			end
		end
	end
end

function love.draw()
	--call GUI elements
	paint.OnClick = function(obj)
		func = 0
	end
	rect.OnClick = function(obj)
		func = 1
	end
	instructions.OnClick = function(obj)  --instructions pane
		if type(frame) ~= "table" then
			focus = false
			frame = loveframes.Create("frame")
			frame:Center()
			frame:SetName("Instructions:")
			text = {}
			for t=1,4,1 do
				text[t] = loveframes.Create("text",frame)
			end
			text[1]:SetPos(4,30)
			text[1]:SetText("Left click to place a pixel, right-click to remove")
			text[2]:SetPos(4,42)
			text[2]:SetText("Edit colours with the sliders, as well as pixel")
			text[3]:SetPos(4,54)
			text[3]:SetText("size and offset. You can add layers with the")
			text[4]:SetPos(4,66)
			text[4]:SetText("\"add layer\" button. Enjoy! :)")
		end
	end
	settings.OnClick = function(obj)
		if type(frame) ~= "table" then
			focus = false
			frame = loveframes.Create("frame")
			frame:Center()
			frame:SetName("settings")
			sets = {}
			sets[1] = loveframes.Create("text",frame)
			sets[1]:SetPos(40,40)
			sets[1]:SetText("Multicoloured Background")
			sets[2] = loveframes.Create("checkbox",frame)
			sets[2]:SetChecked(backg)
			sets[2]:SetPos(15,35)
		end
	end
	if type(frame) == "table" then
		frame.OnClose = function(obj)
			if sets ~= nil then
				backg = sets[2]:GetChecked()
			end
			focus = true
			frame = nil
			sets = nil
			text = nil
		end
	end
	for w=1,#layBut,1 do
		layBut[w]:SetText("Layer " .. w)
		layBut[w].OnClick = function(obj)
			lay = w
		end
	end
	addLay.OnClick = function(obj)  --ADD A NEW LAYER! <3
		table.insert(layBut,loveframes.Create("button"))
		list:AddItem(layBut[#layBut])
		setupTable(#layBut)
	end
	resetOffset.OnClick = function(obj)
		offsetX:SetValue(0) --sets offset BACK TO 0
		offsetY:SetValue(0)
	end
	local tot = sliderR:GetValue() + sliderG:GetValue() + sliderB:GetValue()
	if backg then
		love.graphics.setColor(766-tot,766-tot,766-tot)
	else
		love.graphics.setColor(255,255,255)
	end
	if func == 1 or func == 2 then
		if ex>0 and ey>0 then
			love.graphics.rectangle("line",(ex-1)*div,(ey-1)*div,10,10)
			love.graphics.rectangle("line",((ex-1)*div)+10,((ey-1)*div)+10,10,10)
		end
	end
	love.graphics.print("R",860,80)
	love.graphics.print("G",860,130)
	love.graphics.print("B",860,180)
	love.graphics.print("pixel size",860,240)
	love.graphics.print("size",860,380)
	love.graphics.print("pixel offset x and y",860,300)
	if backg then
		love.graphics.rectangle("line",890,20,50,50)
		love.graphics.setBackgroundColor(sliderR:GetValue(),sliderG:GetValue(),sliderB:GetValue())
	else
		local b,c,d = love.graphics.getColor()
		love.graphics.setColor(sliderR:GetValue(),sliderG:GetValue(),sliderB:GetValue())
		love.graphics.rectangle("fill",890,20,50,50)
		love.graphics.setBackgroundColor(0,0,0)
		love.graphics.setColor(b,c,d)
	end
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
	for p=1,#palette,1 do  --palette at bottom of screen
		love.graphics.setColor(palette[p][1],palette[p][2],palette[p][3])
		love.graphics.rectangle("fill",(p-1)*30,800,30,30)
	end
	local counterLay = #layers
	if counterLay==0 then counterLay=1 end
	for l=1,counterLay,1 do
		for x=1+lOf,size,1 do
			for y=1+uOf,size,1 do
				if layers[l][x][y][1] > 0 then
					local q = layers[l][x][y][1]
					local pSize = layers[l][x][y][2]
					local off = layers[l][x][y][3]
					if palette[currentCol] ~= nil and palette[q] ~= nil then
						local a = sliderR:GetValue()==palette[q][1]
						local b = sliderG:GetValue()==palette[q][2]
						local c = sliderB:GetValue()==palette[q][3]
						if a and b and c then
							local tot = sliderR:GetValue() + sliderG:GetValue() + sliderB:GetValue()
							love.graphics.setColor(766-tot,766-tot,766-tot)
							love.graphics.rectangle("line",((x-1)*div+((div-pSize)/2))+(div*off[1]),((y-1)*div+((div-pSize)/2))-(div*off[2]),div-(div-pSize),div-(div-pSize))
						else
							love.graphics.setColor(palette[q][1],palette[q][2],palette[q][3])
							love.graphics.rectangle("fill",((x-1)*div+((div-pSize)/2))+(div*off[1]),((y-1)*div+((div-pSize)/2))-(div*off[2]),div-(div-pSize),div-(div-pSize))
						end
					end
				end
			end
		end
	end
	local x=love.mouse.getX()
	local y=love.mouse.getY()
	x=math.floor(x/div)
	y=math.floor(y/div)
	love.graphics.setColor(255,255,255)
	if currentCol > 0 then
		love.graphics.setColor(palette[currentCol][1],palette[currentCol][2],palette[currentCol][3])
	end
	if x>=size or y>=size then
		if y>(size-1) then
			if x<size then
				local x=love.mouse.getX()
				local y=love.mouse.getY()
				x=math.ceil(x/30)
				love.graphics.rectangle("line",(x-1)*30,800,30,30)
			end
		end
	else
		love.graphics.rectangle("line",x*div,y*div,div,div)
	end
	love.graphics.print(love.mouse.getX().."\n"..love.mouse.getY(),10,10)
	loveframes.draw()
	slidSize.OnValueChanged = function(obj)
		size = obj:GetValue()
		div = 800/size
		olDiv = div
		for l=1,#layers,1 do
			for x=1+lOf,size,1 do
				for y=1+uOf,size,1 do
					if layers[l][x][y][2] == olDiv then
						layers[l][x][y][2] = div
					else
						layers[l][x][y][2] = (layers[l][x][y][2]/olDiv)*div
					end
				end
			end
		end
	end
	pixSize:SetMinMax(0,div)
end

function love.update()
	loveframes.update()
	if pressed then
		--general colour selection
		local x=math.ceil(love.mouse.getX()/div)
		local y=math.ceil(love.mouse.getY()/div)
		if not (x<(size+1) and y<(size+1) and y>0 and x>0) then
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
			local x2=love.mouse.getX()
			local y2=love.mouse.getY()
			if y2>800 then
				if x2<1000 then
					local x=math.ceil(love.mouse.getX()/30)
					if palette[x] ~= nil then
						currentCol = x
						sliderR:SetValue(255-palette[x][1])
						sliderG:SetValue(255-palette[x][2])
						sliderB:SetValue(255-palette[x][3])
					end
				end
			end
		end
		if func == 0 then
			local x=math.ceil(love.mouse.getX()/div)
			local y=math.ceil(love.mouse.getY()/div)
			if pB == "l" then
				if x<(size+1) and y<(size+1) and y>0 and x>0 then
					if layers[lay][x][y] ~= nil then
						layers[lay][x][y][1] = currentCol
						layers[lay][x][y][2] = pixSize:GetValue()
						layers[lay][x][y][3] = {offsetX:GetValue(),offsetY:GetValue()}
					end
				end
			elseif pB == "r" then
				if x<(size+1) and y<(size+1) then
					layers[lay][x][y][1] = 0
					layers[lay][x][y][2] = 0
				end
			end
		elseif func == 1 then
			if pB == "l" then
				if letgo then
					ex = math.ceil(love.mouse.getX()/div)
					ey = math.ceil(love.mouse.getY()/div)
					if ex<size and ey<size then workaround = true else workaround = false end
				end
			end
		elseif func == 2 then
			if pB == "l" then
				ex2 = math.ceil(love.mouse.getX()/div)
				ey2 = math.ceil(love.mouse.getY()/div)
				if ex2<size and ey2<size then
					if ex>ex2 then
						x1 = ex2
						x2 = ex
					else
						x1 = ex
						x2 = ex2
					end
					if ey>ey2 then
						y1 = ey2
						y2 = ey
					else
						y1 = ey
						y2 = ey2
					end
					for x=x1,x2,1 do
						for y=y1,y2,1 do
							layers[lay][x][y][1] = currentCol
							layers[lay][x][y][2] = pixSize:GetValue()
							layers[lay][x][y][3] = {offsetX:GetValue(),offsetY:GetValue()}
						end
					end
					func = 1
					workaround = false
					ex,ey,ex2,ey2 = 0,0,0,0
					letgo = false
				end
			elseif pB == "r" then func = 1 end
		end
	end
end

function love.mousereleased(x, y, button)
	loveframes.mousereleased(x,y,button)
	pressed = false
	if func == 1 and workaround then
		func = 2
		workaround = false
	end --second part of rectangle
	letgo = true
end

function love.mousepressed(x,y,button)
	loveframes.mousepressed(x,y,button)
	if focus then
		pressed = true
		pB = button
	end
end

function love.keypressed(key, unicode)
	loveframes.keypressed(key,unicode)
end

function love.keyreleased(key)
	loveframes.keyreleased(key)
end