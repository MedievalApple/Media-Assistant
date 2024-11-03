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

          if inputData.u <> Invalid
              deeplink = {
                  u: check(Invalid, inputData.u)
                  t: check("v", inputData.t)
                  videoName: check("Unknown Video", inputData.videoName)
                  songName: check("Unknown Song", inputData.songName)
                  artistName: check("Media Assistant", inputData.artistName)
                  albumArt: check("pkg:/images/record_full.png", inputData.albumArt)
                  songFormat: check("", inputData.songFormat)
                  videoFormat: check("", inputData.videoFormat)
              }
          elseif inputData.contentid <> Invalid
              deeplink = {
                  u: check(Invalid, inputData.contentId)
                  t: check("v", inputData.t)
                  videoName: check("Unknown Video", inputData.videoName)
                  songName: check("Unknown Song", inputData.songName)
                  artistName: check("Media Assistant", inputData.artistName)
                  albumArt: check("pkg:/images/record_full.png", inputData.albumArt)
                  songFormat: check("", inputData.songFormat)
                  videoFormat: check("", inputData.videoFormat)
              }
          end if

          print "got input deeplink= "; deeplink
          m.top.inputData = deeplink

        end if
      end if
    end while
end function

Function check(placeholder, value)
    if value <> Invalid and value <> ""
        return value
    else
        return placeholder
    endif
end function