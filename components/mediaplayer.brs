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

    m.bg = m.top.findNode("Bg")

    m.albumname = m.top.findNode("AlbumName")
    m.songname = m.top.findNode("SongName")
    m.artistname = m.top.findNode("ArtistName")
    m.albumart = m.top.findNode("AlbumArt")

    m.landingpage = m.top.findNode("LandingPage")

    m.InputTask=createObject("roSgNode","inputTask")
    m.InputTask.observefield("inputData","handleInputEvent")
    m.InputTask.control="RUN"

    m.settingsDialog=createObject("roSgNode","settings")
    m.aboutDialog=createObject("roSgNode","about")

    m.video.observeField("state", "controlvideoplay")
    m.video.observeField("position", "trackvideoprogress")

    m.top.SignalBeacon("AppLaunchComplete")

    handleDeepLink(m.global.deeplink)
end sub

Function handleDeepLink(deeplink as object)
    m.overrideControls = false

    m.parsedDeeplink = Invalid
    m.queuedDeeplink = Invalid

    m.queueError = false

    m.seek = 0
    m.noSeeking = false

    if deeplink = Invalid
        m.debugtext.text = tr("Deeplink Error: An internal error has occurred while processing that Deeplink!")
        m.debuglabel.visible = true
        m.debuglabel.setFocus(true)
    elseif deeplink.t = "v" and deeplink.u <> Invalid and deeplink.u <> ""
        m.debuglabel.visible = false
        m.landingpage.visible = false
        m.parsedDeeplink = deeplink
        playvideo()
        m.debugtext.text = m.parsedDeeplink.u
    elseif deeplink.t = "a" and deeplink.u <> Invalid and deeplink.u <> ""
        m.debuglabel.visible = false
        m.landingpage.visible = false
        m.audioui.visible = true
        m.parsedDeeplink = deeplink
        playaudio()
        m.debugtext.text = m.parsedDeeplink.u
    else
        if deeplink.t = "m"
            m.debugtext.text = tr("Media Type Error: Metadata can only be used if media is already playing")
            m.debuglabel.visible = true
        elseif deeplink.enqueue = true
            m.debugtext.text = tr("Media Queue Error: There was an issue processing the queued media")
            m.debuglabel.visible = true
            m.queueError = true
        elseif deeplink.u = ""
            m.debugtext.text = tr("Media URL Error: There was no media URL provided")
            m.debuglabel.visible = true
        elseif deeplink.u = Invalid
            ' This is what shows the Landing Page
            m.debuglabel.visible = true
        elseif deeplink.t <> Invalid and deeplink.u <> Invalid
            m.debugtext.text = tr("Media Type Error: The Media Type provided is unknown")
            m.debuglabel.visible = true
        else
            m.debugtext.text = tr("Deeplink Error: The request didn't contain valid data")
            m.debuglabel.visible = true
        end if
        m.debuglabel.setFocus(true)
    end if
end Function

sub handleInputEvent(msg)
    ? "in handleInputEvent()"
    if type(msg) = "roSGNodeEvent" and msg.getField() = "inputData"
        deeplink = msg.getData()
        if deeplink <> invalid
            if (deeplink.enqueue = true)
                m.queuedDeeplink = deeplink
            elseif (deeplink.t = "m" and m.audioui.visible = true)
                if (deeplink.u = Invalid or deeplink.u = "")
                    updateMetadata(deeplink)
                else
                    if (deeplink.u <> Invalid and deeplink.u <> "")
                        deeplink.t = "a"
                        handleDeepLink(deeplink)
                    end if
                end if
            elseif (deeplink.u <> Invalid and deeplink.u <> "")
                handleDeepLink(deeplink)
            end if
        end if
    end if
end sub

sub updateMetadata(deeplink)
    ' Update Audio Metadata
    SetAlbumName(deeplink.albumName)
    m.songname.text = deeplink.songName
    m.artistname.text = deeplink.artistName
    if (deeplink.albumArt <> "")
        m.albumart.uri = deeplink.albumArt
        SetBg(deeplink.albumArt)
    else
        m.albumart.uri = "pkg:/images/record_full.png"
        SetBg("")
    end if
    m.parsedDeeplink.timeOffset = deeplink.timeOffset
    m.parsedDeeplink.duration = deeplink.duration
    m.parsedDeeplink.isLive = deeplink.isLive
end sub

sub playaudio()
    audiocontent = createObject("RoSGNode", "ContentNode")
    
    audiocontent.url = m.parsedDeeplink.u
    audiocontent.streamformat = m.parsedDeeplink.songFormat

    m.video.content = audiocontent

    SetAlbumName(m.parsedDeeplink.albumName)
    m.songname.text = m.parsedDeeplink.songName
    m.artistname.text = m.parsedDeeplink.artistName
    if (m.parsedDeeplink.albumArt <> "")
        m.albumart.uri = m.parsedDeeplink.albumArt
        SetBg(m.parsedDeeplink.albumArt)
    else
        m.albumart.uri = "pkg:/images/record_full.png"
        SetBg("")
    end if
    m.video.enableTrickPlay = false
    m.overrideControls = true

    m.video.control = "play"
    if (GetSettings("screenSaver", "false") = True)
        m.video.disableScreenSaver = false
    else
        m.video.disableScreenSaver = true
    end if
    m.video.visible = false
    m.video.setFocus(true)
end sub

sub SetBg(uri As String)
    if (GetSettings("artBg", true) = True and uri <> "")
        m.bg.visible = true
        m.bg.uri = uri
    else
        m.bg.visible = false
    end if
end sub

sub SetAlbumName(albumName As String)
    if (GetSettings("albumName", true) = True and albumName <> "")
        m.songName.translation = "[ 700, 175 ]" 
        m.artistName.translation = "[ 700, 225 ]" 
        m.albumName.text = albumName
        m.albumName.visible = true
    else
        m.albumName.visible = false
        m.songName.translation = "[ 700, 125 ]" 
        m.artistName.translation = "[ 700, 175 ]" 
    end if
end sub

sub playvideo()
    videocontent = createObject("RoSGNode", "ContentNode")

    videocontent.title = m.parsedDeeplink.videoName
    videocontent.url = m.parsedDeeplink.u
    videocontent.streamformat = m.parsedDeeplink.videoFormat

    m.video.content = videocontent

    m.video.enableTrickPlay = true
    m.video.trickPlayBar.filledBarBlendColor = "#662d91"

    m.video.control = "play"
    m.video.visible = true
    m.video.setFocus(true)
end sub

sub trackvideoprogress()
    TRY
        if (m.video.state = "playing")
            if (m.parsedDeeplink.isLive = true and m.parsedDeeplink.isLive <> Invalid)
                SetLive()
            ' If The file has a valid duration
            elseif (m.video.duration <> Invalid)

                m.videoprogress.color = "#662d91"

                curTime = m.video.position
                duration = m.video.duration

                if (m.parsedDeeplink.timeOffset <> Invalid)
                    ' Setting to live to disable seeking while using custom duration
                    m.noSeeking = true
                    curTime = m.video.position + m.parsedDeeplink.timeOffset
                else
                    m.noSeeking = false
                end if

                if (m.parsedDeeplink.duration <> Invalid)
                    ' Setting to live to disable seeking while using custom duration
                    m.noSeeking = true
                    duration = m.parsedDeeplink.duration
                else
                    m.noSeeking = false
                end if

                m.videototal.text = ConvertSec(duration)
                barWidth = MapRange(curTime, 0, duration, 0, 475)
                if (barWidth > 475)
                    m.videoprogress.width = 475
                else
                    m.videoprogress.width = barWidth
                endif

                m.videotime.text = ConvertSec(curTime)
            else
                SetLive()
            end if
        end if
    CATCH e
        print("Somthing failed during video progress track falling to live")
        SetLive()
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

sub SetLive()
    m.noSeeking = true
    m.videototal.text = ""
    m.videotime.text = tr("Live")
    m.videoprogress.width = 475
    m.videoprogress.color = "#cc0000"
    if (m.albumart.uri = "pkg:/images/record_full.png")
        m.albumart.uri = "pkg:/images/radio_full.png"
    end if
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

Function GetSettings(key As String, default) As Dynamic
     sec = CreateObject("roRegistrySection", "Settings")
     if sec.Exists(key)
        value = sec.Read(key)
        if (value = "true")
            return true
        elseif (value = "false")
            return false
        else
            return value
        end if
     end if
     return default
End Function

sub controlvideoplay()
    if (m.video.state = "playing")
        m.albumfade.visible = false
    end if
    if (m.video.state = "finished") 
        print("FINISHED PLAYBACK PRINTING QUEUE")
        print(m.queuedDeeplink)
        if (m.queuedDeeplink <> Invalid)
            m.video.control = "stop"
            handleDeepLink(m.queuedDeeplink)
        end if
        ' m.video.visible = false
    end if
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press then
        if (m.overrideControls = true)
            if key = "play"
                if (m.video.state = "playing")
                    m.video.control = "pause"
                    m.albumstate.uri = "pkg:/images/pause.png"
                    m.albumfade.visible = true
                    m.seek = m.video.position
                    m.video.disableScreenSaver = false
                elseif (m.video.state = "paused")
                    m.video.control = "resume"
                    m.seek = m.video.position
                    if (GetSettings("screenSaver", "false") = True)
                        m.video.disableScreenSaver = false
                    else
                        m.video.disableScreenSaver = true
                    end if
                endif
            endif
            if key = "replay" and m.noSeeking = false
                m.video.control = "play"
                m.seek = m.video.position
            endif
            if key = "fastforward" and m.noSeeking = false
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
            if key = "rewind" and m.noSeeking = false
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
            if key = "OK"
                m.top.dialog = m.settingsDialog
            end if
        elseif (m.landingpage.visible = true and key = "OK")
            m.top.dialog = m.aboutDialog
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