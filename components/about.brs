function init()
    print "Creating About Menu"

    setUpPalette()

    m.buttonArea = m.top.findNode("buttonArea")
    m.top.observeFieldScoped("buttonFocused", "printFocusButton")
    m.top.observeFieldScoped("buttonSelected", "printSelectedButtonAndClose")
    m.top.observeFieldScoped("wasClosed", "wasClosedChanged")
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
end sub

sub printFocusButton()
    print "m.buttonArea button ";m.buttonArea.getChild(m.top.buttonFocused).text;" focused"
end sub

sub printSelectedButtonAndClose()
    print "m.buttonArea button ";m.buttonArea.getChild(m.top.buttonSelected).text;" selected"
    m.top.close = true
end sub

sub wasClosedChanged()
    print "About Closed"
end sub