const form = document.querySelector("#form");

form.addEventListener("change", (event) => {
    RefreshCURL()
})

function RefreshCURL() {
    const formData = new FormData(form);
    let editedData = new FormData(form);

    editedData.delete("ip")
    editedData.delete("id")
    editedData.delete("launched")

    if (editedData.get("enqueue") == "on") {
        editedData.set("enqueue", "true")
    }
    else {
        editedData.delete("enqueue")
    }

    if (editedData.get("isLive") == "on") {
        editedData.set("isLive", "true")
    }
    else {
        editedData.delete("isLive")
    }

    for (let data of formData.entries()) {
        console.log(data[0], data[1])
        if (data[1] == "" & data[0] != "u") {
            editedData.delete(data[0])
        }
    }

    const searchParams = new URLSearchParams(editedData).toString()
    try {
        if (document.getElementById("launched").checked) {
            document.getElementById('curl').value = `curl -d '' 'http://${formData.get("ip")}:8060/input?` + searchParams + `'`
        }
        else {
            document.getElementById('curl').value = `curl -d '' 'http://${formData.get("ip")}:8060/launch/${formData.get("id")}?` + searchParams + `'`
        }
    } catch (e) {
        console.error(e);
    }
}

//Launch Request
async function postData(url = "", data = {}) {
    const response = await fetch(url, {
        method: "POST",
        mode: "no-cors",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify(data),
    });
    return response.json();
}

async function sendData() {
    // Associate the FormData object with the form element
    const formData = new FormData(form);
    let editedData = new FormData(form);
    editedData.delete("ip")
    editedData.delete("id")
    editedData.delete("launched")

    if (editedData.get("enqueue") == "on") {
        editedData.set("enqueue", "true")
    }
    else {
        editedData.delete("enqueue")
    }

    if (editedData.get("isLive") == "on") {
        editedData.set("isLive", "true")
    }
    else {
        editedData.delete("isLive")
    }

    for (let data of formData.entries()) {
        // console.log(data[0], data[1])
        if (data[1] == "" & data[0] != "u") {
            editedData.delete(data[0])
        }
    }

    const searchParams = new URLSearchParams(editedData).toString()
    try {
        console.log(searchParams)
        if (document.getElementById("launched").checked) {
            postData(`http://${formData.get("ip")}:8060/input?` + searchParams)
        }
        else {
            postData(`http://${formData.get("ip")}:8060/launch/${formData.get("id")}?` + searchParams)
        }
    } catch (e) {
        console.error(e);
    }
}

// Take over form submission
form.addEventListener("submit", (event) => {
    event.preventDefault();
    sendData();
});