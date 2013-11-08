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



local titleLogo = display.newImageRect( "logo.png", 229, 84)
titleLogo:setReferencePoint( display.CenterReferencePoint )
titleLogo.x = display.contentWidth * 0.5
titleLogo.y = 200

--local hackatonEdition = display.newImageRect( "hackatonedition.png", 320, 120)
--hackatonEdition:setReferencePoint( display.CenterReferencePoint )
--hackatonEdition.x = display.contentWidth * 0.5
--hackatonEdition.y = -10
--physics.addBody( hackatonEdition , { density=100, friction=0, bounce=0})

--crate = display.newImageRect( "crate.png", 100, 100 )	
--crate.x, crate.y = 160, -100
--physics.addBody( crate, { density=10.5, friction=0.3, bounce=0.0 } )
--skies:insert (crate)
--crate:toFront()

physics.start()

local grassShape = { -160,-10, 160,-10, 160,15, -160,15 }
physics.addBody( bg_low, "static", { friction=0.3, shape=grassShape } )

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

	--create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="GO CRATING ",
		labelColor = { default={241,55,40,255}, over={128} },
		width=154, height=40,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn:setReferencePoint( display.CenterReferencePoint )
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 180

	--local buttonShape = { -120,50, 150,60, 150,150, -120,150 }
	--physics.addBody( playBtn, "static", { friction=0.3, shape=buttonShape } )
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( titleLogo )
	group:insert( playBtn )
	--group:insert( hackatonEdition )

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
	hackatonEdition:removeSelf()
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
end

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