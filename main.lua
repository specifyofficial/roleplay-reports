screen = Vector2(guiGetScreenSize())
w, h = 600,275 
nx, ny = (screen.x-w)/2, (screen.y-h)/2

fonts = {
    awesome = dxCreateFont("FontAwesome.ttf",50),
    awesomelittle = dxCreateFont("FontAwesome.ttf",12),
    regular = dxCreateFont("np-light.ttf",17),
    regularlittle = dxCreateFont("np-light.ttf",12),
    bold = dxCreateFont("np-bold.ttf",17)
}

bindKey('F2','down',function()
    if not isTimer(render) then
        wait = 0
        selected = false
        addEventHandler('onClientCharacter', root, write)
        showCursor(true)
        guiSetInputMode('no_binds')
        guiSetInputEnabled(true)
        edit = 'Buraya rapor sebebini yazabilirsin.'
        state = true
        render = setTimer(function()
            if getKeyState('backspace') and wait <= getTickCount() then
                wait = getTickCount() + 125
                delete()
            end
            roundedRectangle(nx,ny,w,h,state and tocolor(15,15,15,245) or tocolor(100,100,100,245))
            dxDrawText('laura roleplay rapor arayüzüne hoş geldin.',nx,ny+8,nx+w,h,state and tocolor(200,200,200) or tocolor(15,15,15),1,fonts.bold,"center")
            roundedRectangle(nx+20,ny+50,w-40,h-100,state and tocolor(25,25,25) or tocolor(115,115,115))
            dxDrawText(selected and edit..' |' or edit,nx+35,ny+65,nx+35+w-70,ny+95+h-100,state and selected and tocolor(245,245,245) or state and tocolor(180,180,180) or selected and tocolor(10,10,10) or tocolor(30,30,30),1,fonts.regularlittle,selected and "left" or "center", "top", true, true)
            roundedRectangle(nx+40,ny+h-43,w-80,40,state and tocolor(20,20,20) or tocolor(100,100,100))
            dxDrawText('Gönder', nx+40,ny+h-10,nx+40+w-80,ny+h-40,state and mousePos(nx+40,ny+h-80,w-80,40) and tocolor(225,225,225) or state and tocolor(180,180,180) or mousePos(nx+40,ny+h-80,w-80,40) and tocolor(25,25,25) or tocolor(20,20,20),1,fonts.bold,"center","center")
            if getKeyState('mouse1') then 
                if mousePos(nx+20,ny+50,w-40,h-160) then
                    selected = true
                    edit = ''
                elseif mousePos(nx+40,ny+h-43,w-80,40) and selected then
                    killTimer(render)
                    removeEventHandler('onClientCharacter', root, write)
                    showCursor(false)
                    guiSetInputMode('allow_binds')
                    triggerServerEvent("clientSendReport", localPlayer,  localPlayer, edit, 1)
                end
            end
        end,0,0)
    else
        killTimer(render)
        removeEventHandler('onClientCharacter', root, write)
        showCursor(false)
        guiSetInputMode('allow_binds')
    end
end)

function delete()
    if selected then
        if #edit > 0 then
            local firstPart = edit:sub(0, #edit-1)
            local lastPart = edit:sub(#edit+1, #edit)
            edit = firstPart..lastPart
        end
    end
end

function eventWrite(...)
	write(...)
end

function write(char)
	if selected then
        edit = edit..char
        playSound('assets/sound.mp3')
	end
end

function mousePos ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 200);
		end
		
		if (not bgColor) then
			bgColor = borderColor;
		end
		
		--> Background
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		
		--> Border
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI); -- top
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI); -- bottom
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI); -- left
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI); -- right
	end
end
