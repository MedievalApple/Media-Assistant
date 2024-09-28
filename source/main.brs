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

    if args.u <> Invalid and args.t <> Invalid
        deeplink = {
            u: check(Invalid, args.u)
            t: check("v", args.t)
            videoName: check("Unknown Video", args.videoName)
            songName: check("Unknown Song", args.songName)
            artistName: check("Media Assistant", args.artistName)
            albumArt: check("pkg:/images/record_full.png", args.albumArt)
            songFormat: check("", args.songFormat)
            videoFormat: check("", args.videoFormat)
        }
    elseif args.contentid <> Invalid
        deeplink = {
            u: check(Invalid, args.contentId)
            t: check("v", args.t)
            videoName: check("Unknown Video", args.videoName)
            songName: check("Unknown Song", args.songName)
            artistName: check("Media Assistant", args.artistName)
            albumArt: check("pkg:/images/record_full.png", args.albumArt)
            songFormat: check("", args.songFormat)
            videoFormat: check("", args.videoFormat)
        }
    end if

    return deeplink
end Function

Function check(placeholder, value)
    if value <> Invalid and value <> ""
        return value
    else
        return placeholder
    endif
end function