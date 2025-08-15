Sub Init()
    m.top.functionName = "listenInput"
End Sub

function ListenInput()
    port=createobject("romessageport")
    InputObject=createobject("roInput")
    InputObject.setmessageport(port)

    while true
      msg=port.waitmessage(500)
      if type(msg)="roInputEvent" then
        print "INPUT EVENT!"
        if msg.isInput()
            inputData = msg.getInfo()
            'print inputData'
            for each item in inputData
                print item  +": " inputData[item]
            end for

            ' pass the deeplink to UI
            deeplink = Invalid

            if inputData <> Invalid
                deeplink = {
                    u: checkURL(inputData)
                    t: check("v", inputData.t)
                    videoName: check(tr("Unknown Video"), inputData.videoName)
                    albumName: check("", inputData.albumName)
                    songName: check(tr("Unknown Song"), inputData.songName)
                    artistName: check(tr("Unknown Artist"), inputData.artistName)
                    albumArt: check("", inputData.albumArt)
                    songFormat: check("", inputData.songFormat)
                    videoFormat: check("", inputData.videoFormat)
                    timeOffset: strToInt(inputData.timeOffset)
                    duration: strToInt(inputData.duration)
                    enqueue: strToBool(inputData.enqueue)
                    isLive: strToBool(inputData.isLive)
                }
            end if

            print "got input deeplink= "; deeplink
            m.top.inputData = deeplink

        end if
      end if
    end while
end function

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