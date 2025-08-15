sub Main(args)

    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)

    scene = screen.CreateScene("MediaPlayer")

    m.global = screen.getGlobalNode()
    ? "args= "; formatjson(args)
    deeplink = getDeepLinks(args)
    ? "deeplink= "; deeplink
    m.global.addField("deeplink", "assocarray", false)
    m.global.deeplink = deeplink

    screen.show()

    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)

        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() then return
        end if
    end while

end sub

Function getDeepLinks(args) as Object
    deeplink = Invalid

    if args <> Invalid
        deeplink = {
            u: checkURL(args)
            t: check("v", args.t)
            videoName: check(tr("Unknown Video"), args.videoName)
            albumName: check("", args.albumName)
            songName: check(tr("Unknown Song"), args.songName)
            artistName: check(tr("Unknown Artist"), args.artistName)
            albumArt: check("", args.albumArt)
            songFormat: check("", args.songFormat)
            videoFormat: check("", args.videoFormat)
            timeOffset: strToInt(args.timeOffset)
            duration: strToInt(args.duration)
            enqueue: strToBool(args.enqueue)
            isLive: strToBool(args.isLive)
        }
    end if

    return deeplink
end Function

Function checkURL(args)
    if args.u <> Invalid
        return args.u
    elseif args.contentid <> Invalid
        return args.contentId
    end if
        return Invalid
end function

Function check(placeholder, value)
    if value <> Invalid and value <> ""
        return value
    else
        return placeholder
    endif
end function

Function strToInt(value)
    if value <> Invalid and value <> ""
        iValue = StrToI(value)
        return iValue
    else
        return Invalid
    endif
end function

Function strToBool(value)
    if value <> Invalid and value <> ""
        fString = LCase(value)
        if fString = "true"
            return true
        else
            return false
        endif
    else
        return Invalid
    endif
end function