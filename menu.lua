-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local skies = display.newGroup()
-- include Corona's "widget" library
local widget = require "widget"

local physics = require "physics"
physics.start(); physics.pause()

	
local background = display.newRect( 0, 0, display.contentWidth, display.contentHeight)
background:setFillColor( 53, 175, 229, 255 )
background:toBack()
--local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight )
background:setReferencePoint( display.TopLeftReferencePoint )
background.x, background.y = 0, 0
--skies:toBack()

local bg_low = display.newImage ("bg_low.png")
bg_low:setReferencePoint( display.BottomLeftReferencePoint)
bg_low.x, bg_low.y = 0, display.contentHeight
skies:insert( bg_low)

	

local background1 = display.newImage( "background.png")
background1:setReferencePoint( display.BottomLeftReferencePoint )
background1.x, background1.y = display.contentWidth, 75
background1.speed = 0.5
skies:insert( background1 )
--background1:toBack()


local background1_2 = display.newImage( "background.png")
background1_2:setReferencePoint( display.BottomLeftReferencePoint )
background1_2.x, background1.y = display.contentWidth*2, 75
background1_2.speed = 0.5
--background1_2:toBack()
skies:insert( background1_2 )
--background1_2:toBack()

local background2 = display.newImage( "background2.png")
background2:setReferencePoint( display.BottomLeftReferencePoint )
background2.x, background2.y = display.contentWidth*2, 420
background2.speed = 1
skies:insert( background2 )
---background2:toBack()

local background2_2 = display.newImage( "background2.png")
background2_2:setReferencePoint( display.BottomLeftReferencePoint )
background2_2.x, background2_2.y = display.contentWidth, 420
background2_2.speed = 1
skies:insert( background2_2 )
--background2_2:toBack()

local background3 = display.newImage( "background3.png")
background3:setReferencePoint( display.BottomLeftReferencePoint )
background3.x, background3.y = -display.contentWidth*2, 150
background3.speed = -1
skies:insert( background3 )
--background3:toBack()

local background3_2 = display.newImage( "background3.png")
background3_2:setReferencePoint( display.BottomLeftReferencePoint )
background3_2.x, background3_2.y = -display.contentWidth, 150
background3_2.speed = -1
skies:insert( background3_2 )
--background3_2:toBack()

local titleLogo = display.newImageRect( "logo.png", 229, 84)
titleLogo:setReferencePoint( display.CenterReferencePoint )
titleLogo.x = display.contentWidth * 0.5
titleLogo.y = 200

	crate = display.newImageRect( "crate.png", 100, 100 )	
			crate.x, crate.y = 160, -100
			physics.addBody( crate, { density=10.5, friction=0.3, bounce=0.0 } )
			skies:insert (crate)
			crate:toFront()
			physics.start()

	local grassShape = { -160,-10, 160,-10, 160,15, -160,15 }
	physics.addBody( bg_low, "static", { friction=0.3, shape=grassShape } )

--skies:insert(titleLogo)
--titleLogo:toFront()

--------------------------------------------

-- forward declarations and other locals
local playBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to level1.lua scene
	for i=skies.numChildren,1,-1 do
        local child = skies[i]
        child.parent:remove( child )
	end
	storyboard.gotoScene( "level1", "fade", 500 )
	
	return true	-- indicates successful touch
end

-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view



	-- display a background image

	
	-- create/position logo/title image on upper-half of the screen

	
	--create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="GO CRATING ",
		labelColor = { default={241,55,40,255}, over={128} },
		--defaultFile="button.png",
		--overFile="button-over.png",
		width=154, height=40,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 180
	
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( titleLogo )
	group:insert( playBtn )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view

	
	-- INSERT code here (e.g. start timers, load audio, start listeners, etc.)
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	-- INSERT code here (e.g. stop timers, remove listenets, unload sounds, etc.)
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

function updateBackgrounds()
	background1.x = background1.x - background1.speed*0.5
	if(background1.x < -display.contentWidth) then
		background1.x = display.contentWidth
	end
	--background1:toBack()
	background1_2.x = background1_2.x - background1_2.speed*0.5
	if(background1_2.x < -display.contentWidth) then
		background1_2.x = display.contentWidth
	end
	--background1_2:toBack()
	background2.x = background2.x - background2.speed*0,5
	if(background2.x < -display.contentWidth) then
		background2.x = display.contentWidth
	end
	background2_2.x = background2_2.x - background2_2.speed*0.5
	if(background2_2.x < -display.contentWidth) then
		background2_2.x = display.contentWidth
	end
	--background2_2:toBack()
	background3.x = background3.x - background3.speed*0.5
	if(background3.x > display.contentWidth) then
		background3.x = -display.contentWidth
	end
	--background3:toBack()
	background3_2.x = background3_2.x - background3_2.speed*0.5
	if(background3_2.x > display.contentWidth) then
		background3_2.x = -display.contentWidth
	end
	--background3_2:toBack()
	titleLogo:toFront()
end

function frameListener(event)
	updateBackgrounds()
end

Runtime:addEventListener("enterFrame", frameListener)

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