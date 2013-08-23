local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

function scene:createScene( event )
    local group = self.view
    print("dummy scene")
    storyboard.removeScene("level1")
	storyboard.reloadScene("level1")
	--storyboard.removeAll()
	--storyboard.gotoScene("level1")
    storyboard.gotoScene( "level1", "fade", 500 )
end

scene:addEventListener( "createScene", scene )

return scene