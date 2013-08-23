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

local NUMBER_OF_CRATES = 15
local ZOOM_FACTOR = 0.2
--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5

local countedDown = false

local function onPlayBtnRelease()
	
	displayCrates.text = "RESTART"
	--storyboard.gotoScene( "dummyScene", "fade", 500 )
	
	--storyboard.reloadScene("level1")
	restart()
	return true	-- indicates successful touch
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
		--group:removeChild(crate)
		print("touch")
		local size = math.random(10,30)
		crate = display.newImageRect( "crate.png", size, size )	
		crate.x, crate.y = event.x, event.y	
		--group:scale(1/ZOOM_FACTOR,1/ZOOM_FACTOR)
		--crates:scale(1/ZOOM_FACTOR, 1/ZOOM_FACTOR)
		--for i=crates.numChildren,1,-1 do
        --	local child = crates[i]
        --	child:scale(1/ZOOM_FACTOR, 1/ZOOM_FACTOR)
		--end
		--crate:scale(1/ZOOM_FACTOR, 1/ZOOM_FACTOR)	
	elseif event.phase == "moved" and numberOfCrates < NUMBER_OF_CRATES then
		crate.x, crate.y = event.x, event.y	
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
		--group:scale(ZOOM_FACTOR,ZOOM_FACTOR)
		--crates:scale(ZOOM_FACTOR,ZOOM_FACTOR)
		--for i=crates.numChildren,1,-1 do
        --	local child = crates[i]
        --	child:scale(ZOOM_FACTOR, ZOOM_FACTOR)
		--end
		--crate:scale(ZOOM_FACTOR, ZOOM_FACTOR)
	--elseif(numberOfCrates == NUMBER_OF_CRATES) and not countedDown then
	--	countdown(group, crateTable)
	elseif countedDown then
	 	--storyboard.gotoScene( "dummyScene", "fade", 500 )
	 	restart()			
	end	
end

Runtime:addEventListener("touch", onScreenTouched)

function frameListener(event)
	if (numberOfCrates == NUMBER_OF_CRATES) and not countedDown then
		countdown()
		countedDown = true
	end
end

Runtime:addEventListener("enterFrame", frameListener)





function countdown() 
	local levelTime = 5
	--displayTime.text = levelTime
	local function checkTime(event)
		
	  	levelTime = levelTime - 1
	  	displayTime.text = levelTime
	  			
	  	if ( levelTime <= 0 ) then
	  		maxCrate = 5000
	  		--if( numberOfCrates < 1000 ) then
	  			print("CRATES:", table.getn(crateTable))
		  		for i=0,numberOfCrates-1,1 do
		  			print(crateTable[i].y)
		  			if crateTable[i].y < maxCrate then		
		  				maxCrate = crateTable[i].y
		  				
		  			end
		  			print("maxcrate:", maxCrate)
		  		end
		  	--end
		  	print("ScreenH", screenH, "maxcrate:", maxCrate)
	  		displayTime.text = screenH - math.floor(maxCrate)
	  		if maxCrate < 250 then
	  			displayWin.text = "YOU WIN"
	  			countedDown = true
	  	    else
	  	    	displayWin.text = "YOU LOOSE"
	  	    	countedDown = true
	  	    end
	  	end
	end
	timer.performWithDelay( 1000, checkTime, levelTime )
end

function scene:createScene( event )
	print("create scene")
	scene:addEventListener( "enterScene", scene )
end

function scene:enterScene( event )
	print("enter scene")
	group = self.view
	numberOfCrates = 0	
	crateTable = {}
	
	--local group = self.view
	local background = display.newRect( 0, 0, screenW, screenH )
	background:setFillColor( 128 )

	local crate = display.newImageRect( "crate.png", 19, 19 )
	crate.x, crate.y = 160, -100
	crate.rotation = 30

	local goalLine = display.newLine( 0, 250, 320, 250)
	physics.addBody( crate, { density=1.0, friction=0.3, bounce=1 } )

	local grass = display.newImageRect( "grass.png", screenW, 40 )
	grass:setReferencePoint( display.BottomLeftReferencePoint )
	grass.x, grass.y = 0, display.contentHeight

	local grassShape = { -halfW,-15, halfW,-15, halfW,15, -halfW,15 }
	physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )

	group:insert( background )
	group:insert( grass)
	group:insert( crate )
	group:insert( goalLine)
	
	physics.start()
	crates = display.newGroup()
	textz = display.newGroup()
	displayCrates = display.newText( "", 10, 0, "Helvetica", 20 )
	displayWin = display.newText( "", 150, 150, "Helvetica", 50 )
	displayTime = display.newText( "", 160, 240, "Helvetica", 100 )
	textz:insert(displayTime)
	textz:insert(displayWin)
	textz:insert(displayCrates)	
end



-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	print("exitScene")
	--local group = self.view
	--display.remove(group)
	display.remove(textz)
	display.remove(crates)
	--crateTable = {}
	for p,v in pairs( crateTable ) do
	--	display.remove( crateTable[p] )
		crateTable[p] = nil
	end
	crateTable = nil
	numberOfCrates = 0
	physics.pause()

	--Runtime:removeEventListener("touch", onScreenTouched)	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	print("destroy!!!")

end



-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

print("add listeners")
-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished


-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )



-----------------------------------------------------------------------------------------

return scene