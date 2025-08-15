const field = document.querySelector("#media-type")

field.addEventListener("change", (event) => {
    RefreshFields()
})

function RefreshFields() {
    ResetFields()
    if (document.querySelector("#media-type").value == "v") {
        for (let element = 0; element < document.getElementsByClassName("video").length; element++) {
            const div = document.getElementsByClassName("video")[element];
            div.style.display = ""
        }
    }
    else if (document.querySelector("#media-type").value == "a") {
        for (let element = 0; element < document.getElementsByClassName("audio").length; element++) {
            const div = document.getElementsByClassName("audio")[element];
            div.style.display = ""
        }
    }
    else if (document.querySelector("#media-type").value == "m") {
        for (let element = 0; element < document.getElementsByClassName("metadata").length; element++) {
            const div = document.getElementsByClassName("metadata")[element];
            div.style.display = ""
        }
    }
}

function ClearFields() {
    for (let element = 0; element < document.getElementsByClassName("clear").length; element++) {
            const input = document.getElementsByClassName("clear")[element];
            input.value = ""
        }
    for (let element = 0; element < document.getElementsByClassName("clearBox").length; element++) {
            const checkBox = document.getElementsByClassName("clearBox")[element];
            checkBox.checked = false
        }
}

function ResetFields() {
    for (let element = 0; element < document.getElementsByClassName("metadata").length; element++) {
        const div = document.getElementsByClassName("metadata")[element];
        div.style.display = "none"
    }
    for (let element = 0; element < document.getElementsByClassName("audio").length; element++) {
        const div = document.getElementsByClassName("audio")[element];
        div.style.display = "none"
    }
    for (let element = 0; element < document.getElementsByClassName("video").length; element++) {
        const div = document.getElementsByClassName("video")[element];
        div.style.display = "none"
    }
}