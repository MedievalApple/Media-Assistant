function init()
    print "Creating Settings Menu"

    setUpPalette()

    m.buttonArea = m.top.findNode("buttonArea")
    m.top.observeFieldScoped("buttonFocused", "printFocusButton")
    m.top.observeFieldScoped("buttonSelected", "printSelectedButtonAndClose")
    m.top.observeFieldScoped("wasClosed", "wasClosedChanged")

    m.top.findNode("checkBox").observeField("selected", "handleCheckBox")
    m.top.findNode("checkBox1").observeField("selected", "handleCheckBox1")
    m.top.findNode("checkBox2").observeField("selected", "handleCheckBox2")

    m.top.findNode("checkBox").iconStatus = GetSettings("artBg", "true")
    m.top.findNode("checkBox1").iconStatus = GetSettings("albumName", "true")
    m.top.findNode("checkBox2").iconStatus = GetSettings("screenSaver", "false")
end function

sub setUpPalette()
    m.top.palette = createObject("roSGNode", "RSGPalette")

    m.top.palette.colors = {    DialogBackgroundColor: "#232323FF",
                                DialogTextColor: "#ffffffff",
                                DialogFocusColor: "#ffffffff",
                                DialogFocusItemColor: "#000000ff",
                                DialogSecondaryItemColor: "#c4c4c4ff",
                                DialogFootprintColor: "#1e1e1eff" }

    dialogTextColor = m.top.palette.colors["DialogTextColor"]

    m.top.findNode("checkboxLabel").color = dialogTextColor
    m.top.findNode("checkboxLabel1").color = dialogTextColor
    m.top.findNode("checkboxLabel2").color = dialogTextColor
end sub

sub printFocusButton()
    print "m.buttonArea button ";m.buttonArea.getChild(m.top.buttonFocused).text;" focused"
end sub

sub printSelectedButtonAndClose()
    print "m.buttonArea button ";m.buttonArea.getChild(m.top.buttonSelected).text;" selected"
    m.top.close = true
end sub

sub wasClosedChanged()
    print "Settings Closed"
    print("Saving Settings")
    SetSettings("artBg", BoolStr(m.top.findNode("checkBox").iconStatus))
    SetSettings("albumName", BoolStr(m.top.findNode("checkBox1").iconStatus))
    SetSettings("screenSaver", BoolStr(m.top.findNode("checkBox2").iconStatus))
end sub

sub handleCheckBox()
    actionCard = m.top.findNode("checkBox")
    actionCard.iconStatus = not actionCard.iconStatus
end sub

sub handleCheckBox1()
    actionCard = m.top.findNode("checkBox1")
    actionCard.iconStatus = not actionCard.iconStatus
end sub

sub handleCheckBox2()
    actionCard = m.top.findNode("checkBox2")
    actionCard.iconStatus = not actionCard.iconStatus
end sub

Function GetSettings(key As String, default As String) As Dynamic
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
     SetSettings(key, default)
     return default
End Function

Function BoolStr(bool) As String
    if (bool = true)
        return "true"
    else
        return "false"
    end if
End Function

Function SetSettings(key As String, value As String) As Void
    sec = CreateObject("roRegistrySection", "Settings")
    sec.Write(key, value)
    sec.Flush()
End Function