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
--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5


local function onPlayBtnRelease()
	
	displayCrates.text = "RESTART"
	storyboard.gotoScene( "dummyScene", "fade", 500 )
	
	--storyboard.reloadScene()
	
	return true	-- indicates successful touch
end

--lastY = 100, lastCrateY = 0
-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------




-- Called when the scene's view does not exist:
function scene:createScene( event )
	numberOfCrates = 0

	crates = display.newGroup()
	crateTable = {}
	displayCrates = display.newText( crates.numChildren, 10, 0, "Helvetica", 20 )

	local group = self.view

	--local crates = display.newGroup()


	-- create a grey rectangle as the backdrop
	local background = display.newRect( 0, 0, screenW, screenH )
	background:setFillColor( 128 )
	
	-- make a crate (off-screen), position it, and rotate slightly
	local crate = display.newImageRect( "crate.png", 19, 19 )
	crate.x, crate.y = 160, -100
	crate.rotation = 15

	local goalLine = display.newLine( 0, 250, 320, 250)
	
	-- add physics to the crate
	physics.addBody( crate, { density=1.0, friction=0.3, bounce=0.1 } )
	
	-- create a grass object and add physics (with custom shape)
	local grass = display.newImageRect( "grass.png", screenW, 40 )
	grass:setReferencePoint( display.BottomLeftReferencePoint )
	grass.x, grass.y = 0, display.contentHeight
	
	-- define a shape that's slightly shorter than image bounds (set draw mode to "hybrid" or "debug" to see)
	local grassShape = { -halfW,-15, halfW,-15, halfW,15, -halfW,15 }
	physics.addBody( grass, "static", { friction=0.3, shape=grassShape } )
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( grass)
	group:insert( crate )
	group:insert( goalLine)

end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	physics.start()

	local function countdown(group, crateTable) 
		local levelTime = 3
		local displayTime = display.newText( levelTime, 160, 240, "Helvetica", 100 )
		group:insert(displayTime)

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
		  		displayTime.text = screenH - math.floor(maxCrate)
		  		local displayWin = display.newText( "YOU", 100, 150, "Helvetica", 50 )
		  		group:insert(displayWin)
		  		if maxCrate < 250 then
		  			displayWin.text = "YOU WIN"
		  	    else
		  	    	displayWin.text = "YOU LOOSE"
		  	    end
		  	end
		end
		timer.performWithDelay( 1000, checkTime, levelTime )
	end

	local function onScreenTouched(event)
		if event.phase == "began" and numberOfCrates < 15 then
			local size = math.random(10,30)
			crate = display.newImageRect( "crate.png", size, size )	
			crate.x, crate.y = event.x, event.y		
			--display.getCurrentStage():setFocus(crate);
		elseif event.phase == "cancelled" then
			display.remove(crate)
		elseif event.phase == "moved" and numberOfCrates < 15 then
			crate.x, crate.y = event.x, event.y	
		elseif event.phase == "ended" and numberOfCrates < 15 then
			crates:insert( crate )
			displayCrates.text = crates.numChildren
			physics.addBody( crate, { density=0.5, friction=0.3, bounce=0.1 } )
			crateTable[numberOfCrates] = crate
			numberOfCrates = numberOfCrates +1
			--numberOfCrates = numberOfCrates + 1
		--else
  			--end
  		--else
  		--	onPlayBtnRelease()
		end
		if(numberOfCrates == 15) then
			countdown(group, crateTable)
		end	

	end
	Runtime:addEventListener("touch", onScreenTouched)	
end



-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	display.remove(group)
	--display.remove(crates)
	--crateTable = {}
	for p,v in pairs( crateTable ) do
		display.remove( crateTable[p] )
		crateTable[p] = nil
	end
	numberOfCrates = 0
	physics.stop()
	Runtime:removeEventListener("touch", onScreenTouched)	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )

end



-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

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