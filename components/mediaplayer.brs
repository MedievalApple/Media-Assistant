sub init()
    m.top.backgroundURI = "pkg:/images/background.png"

    m.video = m.top.findNode("videoPlayer")
    m.debuglabel = m.top.findNode("infoRectangle")
    m.debugtext = m.top.findNode("infoLabel")
    m.videotime = m.top.findNode("CurTime")
    m.videototal = m.top.findNode("TotalTime")
    m.videoprogress = m.top.findNode("ProgressBar")
    m.albumfade = m.top.findNode("AlbumFade")
    m.albumstate = m.top.findNode("state")
    m.audioui = m.top.findNode("AudioUI")

    m.songname = m.top.findNode("SongName")
    m.artistname = m.top.findNode("ArtistName")
    m.albumart = m.top.findNode("AlbumArt")

    m.InputTask=createObject("roSgNode","inputTask")
    m.InputTask.observefield("inputData","handleInputEvent")
    m.InputTask.control="RUN"

    m.video.observeField("state", "controlvideoplay")
    m.video.observeField("position", "trackvideoprogress")

    ' m.videoprogress.color = "0x11bdf2"
    ' m.video.trickPlayBar.filledBarBlendColor = "0x11bdf2"

    m.top.SignalBeacon("AppLaunchComplete")

    handleDeepLink(m.global.deeplink)
end sub

Function handleDeepLink(deeplink as object)

    m.overrideControls = false
    m.noDeeplink = false

    m.seek = 0
    m.live = false

    if deeplink = Invalid
        print "deeplink failed validation"
        m.debuglabel.visible = true
        m.noDeeplink = true
        m.debuglabel.setFocus(true)
    elseif deeplink.t = "v" and deeplink.u <> Invalid
        m.debuglabel.visible = false
        playvideo(deeplink.videoName, deeplink.u, deeplink.videoFormat)
        m.debugtext.text = deeplink.u
    elseif deeplink.t = "a" and deeplink.u <> Invalid
        m.debuglabel.visible = false
        m.audioui.visible = true
        playaudio(deeplink.u, deeplink.songFormat, deeplink.songName, deeplink.artistName, deeplink.albumArt)
        m.debugtext.text = deeplink.u
    else
        print "deeplink does not contain media type"
        m.debugtext.text = "Unable to process that Deeplink"
        m.debuglabel.visible = true
        m.noDeeplink = true
    end if
end Function

sub handleInputEvent(msg)
    ? "in handleInputEvent()"
    if type(msg) = "roSGNodeEvent" and msg.getField() = "inputData"
        deeplink = msg.getData()
        if deeplink <> invalid
            handleDeepLink(deeplink)
        end if
    end if
end sub

sub playaudio(url, format, name, artist, art)
    audiocontent = createObject("RoSGNode", "ContentNode")
    
    audiocontent.url = url
    audiocontent.streamformat = format

    m.video.content = audiocontent

    m.songname.text = name
    m.artistname.text = artist
    if (art <> "")
        m.albumart.uri = art
    end if
    m.video.enableTrickPlay = false
    m.overrideControls = true

    m.video.control = "play"
    m.video.visible = false
    m.video.setFocus(true)
end sub

sub playvideo(title, url, format)
    videocontent = createObject("RoSGNode", "ContentNode")

    videocontent.title = title
    videocontent.url = url
    videocontent.streamformat = format

    m.video.content = videocontent

    m.video.enableTrickPlay = true
    m.video.trickPlayBar.filledBarBlendColor = "0x662d91"

    m.video.control = "play"
    m.video.visible = true
    m.video.setFocus(true)
end sub

sub trackvideoprogress()
    TRY
        if (m.video.state = "playing" and m.video.duration <> Invalid) 
            m.videoprogress.color = "0x662d91"
            m.videototal.text = ConvertSec(m.video.duration)
            m.videotime.text = ConvertSec(m.video.position)
            m.videoprogress.width = MapRange(m.video.position, 0, m.video.duration, 0, 475)
            m.live = false
        end if
    CATCH e
        m.live = true
        m.videototal.text = ""
        m.videotime.text = "Live"
        m.videoprogress.width = 475
        m.videoprogress.color = "0xcc0000"
        if (m.albumart.uri = "pkg:/images/record_full.png")
            m.albumart.uri = "pkg:/images/radio_full.png"
        end if
    END TRY
end sub

sub ConvertSec(seconds as Integer) as String
    minutes = Fix(seconds / 60)
    remainingSeconds = seconds mod 60

    if(remainingSeconds < 10)
        remainingSeconds = "0" + right(Str(remainingSeconds), 1)
    else
        remainingSeconds = Str(remainingSeconds)
    end if

    return Str(minutes) + ":" + right(remainingSeconds, 2)
end sub

function MapRange(value, in_min, in_max, out_min, out_max)
    value1 = value - in_min
    value2 = out_max - out_min
    value3 = in_max - in_min
    final1 = value1 * value2
    final2 = value3 + out_min
    final = final1 / final2
    return final
    ' return (value - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
end function

sub controlvideoplay()
    if (m.video.state = "playing")
        m.albumfade.visible = false
    end if
    if (m.video.state = "finished") 
        ' m.video.control = "stop"
        ' m.video.visible = false
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press then
        if (m.noDeeplink = true)
            if key = "back"
                End
            endif
        elseif (m.overrideControls = true)
            if key = "play"
                if (m.video.state = "playing")
                    m.video.control = "pause"
                    m.albumstate.uri = "pkg:/images/pause.png"
                    m.albumfade.visible = true
                    m.seek = m.video.position
                elseif (m.video.state = "paused")
                    m.video.control = "resume"
                    m.seek = m.video.position
                endif
            endif
            if key = "replay" and m.live = false
                m.video.control = "play"
                m.seek = m.video.position
            endif
            if key = "fastforward" and m.live = false
                m.albumstate.uri = "pkg:/images/FF.png"
                m.albumfade.visible = true
                if (m.video.state = "playing")
                    m.seek = m.video.position
                    m.video.control = "pause"
                endif
                if(m.seek + 10 < m.video.duration)
                    m.seek = m.seek + 10
                else
                    m.seek = m.video.duration
                endif
                m.videotime.text = ConvertSec(m.seek)
                m.videoprogress.width = MapRange(m.seek, 0, m.video.duration, 0, 475)
                m.video.seek = m.seek
            endif
            if key = "rewind" and m.live = false
                m.albumstate.uri = "pkg:/images/RW.png"
                m.albumfade.visible = true
                if (m.video.state = "playing")
                    m.seek = m.video.position
                    m.video.control = "pause"
                endif
                if(m.seek - 10 > 10)
                    m.seek = m.seek - 10
                else
                    m.seek = 0
                endif
                m.videotime.text = ConvertSec(m.seek)
                m.videoprogress.width = MapRange(m.seek, 0, m.video.duration, 0, 475)
                m.video.seek = m.seek
            endif
        else
            if key = "back"
                if (m.video.state = "playing")
                    m.video.control = "stop"
                    ' m.video.visible = false
                End
                    return true
                end if
            end if
        endif
    end if

    return false
end function