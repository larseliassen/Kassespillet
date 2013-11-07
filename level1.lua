-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start(); physics.pause()

local widget = require "widget"

local skies = display.newGroup()

local NUMBER_OF_CRATES = 20
local ZOOM_FACTOR = 0.2

highscore = 0

local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

--------------------------------------------

local function loadBackground(filename, xMulti, y, speed) 
	local background = display.newImage(filename)
	background:setReferencePoint( display.BottomLeftReferencePoint )
	background.x, background.y = display.contentWidth*xMulti, y
	background.speed = speed
	return background
end

local background1 = loadBackground("background.png", 1, 75, 0.5)
skies:insert( background1 )
local background1_2 = loadBackground("background.png", 2, 75, 0.5)
skies:insert( background1_2 )
local background2 = loadBackground("background2.png", 1, 420, 1)
skies:insert( background2 )
local background2_2 = loadBackground("background2.png", 2, 420, 1)
skies:insert( background2_2 )
local background3 = loadBackground("background3.png", -2, 150, -1)
skies:insert( background3 )
local background3_2 = loadBackground("background3.png", -1, 150, -1)
skies:insert( background3_2 )

local bg_low = display.newImage ("bg_low2.png")
bg_low:setReferencePoint( display.BottomLeftReferencePoint)
bg_low.x, bg_low.y = 0, display.contentHeight
skies:insert( bg_low)

local countedDown = false
local finished = false

local function onPlayBtnRelease()
	displayCrates.text = "RESTART"
	restart()
	return true
end

local function restart()
	print("restart")
	numberOfCrates = 0
	for p,v in pairs( crateTable ) do
		crateTable[p] = nil
	end
	crateTable = {}
	for i=crates.numChildren,1,-1 do
        local child = crates[i]
        child.parent:remove( child )
	end
	numberOfCrates = 0
	crates = nil
	crates = display.newGroup()
	crate = nil
	displayCrates.text = ""
	displayWin.text = ""
	displayTime.text = ""
	countedDown = false
	finished = false
	physics.setGravity( 0, 10 )
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------
function onScreenTouched(event)
	if event.phase == "began" and numberOfCrates < NUMBER_OF_CRATES then
		print("touch")
		local size = math.random(20,30)
		crate = display.newImageRect( "crate.png", size, size )	
		crate.x, crate.y = event.x - 50, event.y + 50		
	elseif event.phase == "moved" and numberOfCrates < NUMBER_OF_CRATES then
		if crate ~= nil then
			crate.x, crate.y = event.x - 50, event.y	+ 50
		end
	elseif event.phase == "ended" and numberOfCrates < NUMBER_OF_CRATES then
		print("ended")
		print(crates.numChildren)
		if crate ~= nil then 
			crates:insert( crate )
			displayCrates.text = NUMBER_OF_CRATES - crates.numChildren
			physics.addBody( crate, { density=0.5, friction=0.3, bounce=0.5 } )
			crateTable[numberOfCrates] = crate
			numberOfCrates = numberOfCrates +1
		end
		print(table.getn(crateTable))
	elseif countedDown == true then
	 	restart()			
	end	
end

Runtime:addEventListener("touch", onScreenTouched)

local function updateBackground(background)
	background.x = background.x - background.speed*0.5
	if(background.x < -display.contentWidth) then
		background.x = display.contentWidth
	end
end

function updateBackgrounds()
	updateBackground(background1)
	updateBackground(background1_2)
	updateBackground(background2)
	updateBackground(background2_2)
	updateBackground(background3)
	updateBackground(background3_2)
end

function frameListener(event)
	if (numberOfCrates == NUMBER_OF_CRATES) and finished == false then
		finished = true
		countdown()
	end
	updateBackgrounds()
end

Runtime:addEventListener("enterFrame", frameListener)



function countdown() 
	local levelTime = 5

	local function checkTime(event)
		
	  	levelTime = levelTime - 1
	  	displayTime.text = levelTime
	  			
	  	if ( levelTime <= 0 ) then
	  		maxCrate = 5000
		  	for i=0,numberOfCrates-1,1 do		  			
		  		if crateTable[i].y < maxCrate then		
		  			maxCrate = crateTable[i].y		  				
		  		end		
		  	end		  	
		  	score = screenH - math.floor(maxCrate)
	  		displayTime.text = score
	  		displayPoints()	  		
	  		addEndCrate()	  			
	  	end
	end

	timer.performWithDelay( 1000, checkTime, levelTime )
end

function displayPoints()
	if maxCrate > 250 then 
		displayWin.text = "YOU LOSE"
	else
		displayWin.text = "YOU WIN"		
	end
	countedDown = true
	print("SCORE 2", score, "HS", highscore)
	if(score > highscore) then
	  	highscore = score
	  	displayHS.text = highscore
	end
end

function addEndCrate()
	crate = display.newImageRect( "crate.png", 100, 100 )	
	crate.x, crate.y = 160, -100
	physics.addBody( crate, { density=10.5, friction=0.3, bounce=0.0 } )
	crates:insert (crate)
end

function scene:createScene( event )	
end

function scene:enterScene( event )
	print("enter scene")
	group = self.view
	numberOfCrates = 0	
	crateTable = {}
	local background = display.newRect(0,0,screenW, screenH)
	background:setFillColor( 53, 175, 229, 255 )
	background:toBack()

	local goalLine = display.newLine( 0, 250, 320, 250)
	goalLine:setColor(255, 255, 255, 150)

	local grass = display.newImageRect("bg_low2.png", screenW, 40 )
	grass:setFillColor(10, 255, 20, 200)
	grass:setReferencePoint( display.BottomLeftReferencePoint )
	grass.x, grass.y = 0, display.contentHeight

	local grassShape = { -halfW,-10, halfW,-10, halfW,15, -halfW,15 }
	physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )

	group:insert( background1 )
	group:insert( background2 )
	group:insert( grass)	
	group:insert( goalLine)
	
	physics.start()
	crates = display.newGroup()
	textz = display.newGroup()
	displayCrates = display.newText( "", 10, 0, "Helvetica", 20 )
	displayWin = display.newText( "", 150, 150, "Helvetica", 50 )
	displayTime = display.newText( "", 160, 240, "Helvetica", 100 )
	displayHSStatic = display.newText("Highscore:", 170, 0, "Helvetica", 20)
	displayHS = display.newText(highscore, 280, 0, "Helvetica", 20)
	textz:insert(displayTime)
	textz:insert(displayWin)
	textz:insert(displayCrates)	
end



-- Called when scene is about to move offscreen:
function scene:exitScene( event )
end
-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
end



-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

print("add listeners")
-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )



-----------------------------------------------------------------------------------------

return scene