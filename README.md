# Media Assistant

<img src="./docs/assets/logo_full.png" width="25%" border="2" align="right" />

Media Assistant is a Roku channel that allows you to stream/play media from a URL on your Roku device through Http Post Requests called Deeplinks. 

<!-- View the [Media Assiatant Website](https://medievalapple.net/Media-Assistant.html) for more info. -->

## Install Media Assistant

###  Roku Channel Store (Recommended):
- You can download Media Assistant from the official Roku channel store with the link below:

    - [Install Media Assistant](https://channelstore.roku.com/details/625f8ef7740dff93df7d85fc510303b4/media-assistant)

### Sideload:
- To sideload Media Assistant onto your Roku Device, follow the steps below:

1. Enable Developer mode on your Roku by following the **Activating developer mode** section of the [Roku developer documentation](https://developer.roku.com/en-gb/docs/developer-program/getting-started/developer-setup.md).

2. Download the **Media-Assistant.zip** from the [Releases](https://github.com/MedievalApple/Media-Assistant/releases) page.

3. Then follow the Sideloading channels section of the [Roku developer documentation](https://developer.roku.com/en-gb/docs/developer-program/getting-started/developer-setup.md) in order to sideload the zip downloaded in step 2.

4. Launch Media Assistant and enjoy :D

> [!TIP]
> Dev mode is activated by hitting home three times, up twice, and then right, left, right, left, right.

## Using Media Assistant

### Quick Setup:
- If you would like to setup Media Assistant and find compatible apps, check out the [Media Assistant Setup](https://medievalapple.net/media-assistant/setup.html) page.
- To learn more about Media Assistant and find developer information, check out the docs below.

### More Information:
> [!IMPORTANT]
> Before using Media Assistant, in order for apps to talk/send media to Media Assistant you must ensure **Control by mobile apps** is **Enabled**.

- To check if Control by mobile apps is enabled, go to your Roku's settings and navigate to 

    - `Settings -> System -> Advanced system settings -> Control by mobile apps -> Network access`

- Media Assistant can work with any app/code that made use of the Play on Roku API since Media Assistant supports the same request structure that Play on Roku used. Though the app/code would have to be updated to send the requests to Media Assistants Channel Id instead of Play on Roku's.

- Media Assistant can be experimented with through using [Media Assistant Tester](https://ma.medievalapple.net/), a small website that allows you to test Media Assistant, or by using the code examples/API Docs provided below.

> [!IMPORTANT]
> If Media Assistant was installed through the Roku Channel Store, the Channel Id will be `782875`. If Media Assistant was sideloaded, the Channel Id will be `dev`.

## Settings

- You can access settings when in the **Audio UI** mode by pressing **OK** on the remote.

- Available Settings
    - Album Art Background
        - When enabled, this sets the background to the current album art.
        - If the album art isn't available, it will show the normal background.
    - Show Album Name If Available
        - When enabled, if an album name is available it will be shown above the song name.
    - Enable Screen Saver During Playback
        - When enabled, this will allow the screen saver to start during audio playback.
        - When disabled, the screen saver can only start if audio is stopped or paused.

> [!WARNING]
> If Enable Screen Saver During Playback is on, this will stop enqueued media from playing after the current media. This will also stop `/input?` commands from going through, but `/launch` commands will still go through.

> [!IMPORTANT] 
> These settings will not take effect until the next media starts or Media Assistant restarts.

## API

- Media Assistant makes use of Roku's Deeplink system which allows you to send commands to a Roku using URL Parameters sent as a Http Post Request with an empty body to the Roku's IP at `Port 8060`. The following examples will use cURL. Examples in different programming languages can be found below.

> [!Warning]
> The following examples use the Channel Id from the Roku Channel Store version of Media Assistant `782875`. If you sideloaded Media Assistant, you will need to change the id's in the examples to `dev`.

- Launch Media Assistant on Roku with `/launch/[Channel Id]`
```cURL
curl -d '' 'http://10.0.0.15:8060/launch/782875'
```

- Launch and play media on Media Assistant with `/launch/[Channel Id]?u='[Media URL]'&t=[Media Type]`
```cURL
curl -d '' 'http://10.0.0.15:8060/launch/782875?u=https%3A%2F%2Farchive.org%2Fdownload%2FBigBuckBunny_124%2FContent%2Fbig_buck_bunny_720p_surround.mp4&t=v'
```

- Play media on Media Assistant with `/input?u='[Media URL]'&t=[Media Type]`
```cURL
curl -d '' 'http://10.0.0.15:8060/input?u=https%3A%2F%2Farchive.org%2Fdownload%2FBigBuckBunny_124%2FContent%2Fbig_buck_bunny_720p_surround.mp4&t=v'
```

- You can also add additional URL Parameters with `&[param]=''`

### Supported URL Parameters

- Required Parameters

    - `u` or `contentId` - takes a `URL` to a media source or stream (This can be left out if using media type `m`)
    - `t` - takes the media type (If the `t` parameter is left out, it will default to video)
        - `a` for audio (This sets Media Assistant to the Audio UI)
        - `v` for video (This sets Media Assistant to the Video UI)
        - `m` for metadata update (This is an advanced parameter, more info below)

- Optional Parameters
    - Format Parameters are optional but need to be used to support certain media formats
        - `videoFormat` - takes a video format type like `mp4`,`hls`,`mkv`
        - `songFormat` - takes a audio format type like `mp3`,`aac`,`flac`
    - Media Information Parameters
        - Audio
            - `songName` - takes the name of your song, like `Local Elevator`
            - `artistName` - takes the name of the song's artist, like `Kevin MacLeod`
            - `albumName` - takes the name of your song's album, like `Epic Elevator Tunes!`
            - `albumArt` - takes a `URL` to an image file (Images that are square work best)
            - `timeOffset` - Offsets display time (This is an advanced parameter, more info below)
            - `duration` - Sets the display duration (This is an advanced parameter, more info below)
            - `isLive` - if set to `true` a red live bar will be shown instead of song progress
                - This can be overridden by certain things, see advanced parameters below
        - Video
            - `videoName` - takes the name of your video, like `Big Buck Bunny`
    - Enqueueing
        - `enqueue` - if set to `true` the request will be queued to play after the current item
            - You can only have **one item** queued. If you send this parameter while an item is in queue, it will be overridden

- Advanced Parameters Info
    - Media Type: `m`
        - The Metadata type works only if Media Assistant is in the Audio UI.
        - This allows you to update the currently displayed metadata without stopping or restarting the current audio playback.
        - For example, if you are playing back an Internet Radio Stream and want to update the `songName` each time a new song starts without restarting/sending the audio stream.
        - The following parameters cannot be sent with a metadata request `u`,`contentId`,`songFormat`,`videoFormat`,`videoName`,`enqueue`
    - Audio: `timeOffset`
        - timeOffset takes an `int` as a `string` and allows you to push forward the displayed time by seconds
        - This does not affect actual playback, only what you see in the Audio UI
        - This will disable the ability to seek using fast-forward and rewind
    - Audio: `duration`
        - duration takes an `int` as a `string` and allows you to set the displayed duration time in seconds
        - This does not affect actual playback, only what you see in the Audio UI
        - This will disable the ability to seek using fast-forward and rewind
    - Audio: `isLive`
        - isLive will be set `true` automatically if the audio is detected to be a stream (This doesn't always work)
        - This will be disabled if the parameters `timeOffset` or `duration` are set

> [!WARNING]
> All URLs and their URL Parameters must be encoded in order for the Post Request to succeed. Most Http Request libraries do this automatically, but some don't. For convience, the cURL examples above have already had the URLs encoded. [Learn More](https://www.w3schools.com/tags/ref_urlencode.ASP)

> [!TIP] 
> Roku devices handle images 1080p and under the best. Higher quality images seem to take a little bit to load in, especially after resuming from the screen saver. On some older Roku devices, they won't load at all.

> [!IMPORTANT] 
> Roku supports a lot more media formats then mentioned above. The full list can be found in [Roku's video player docs](https://developer.roku.com/en-gb/docs/references/scenegraph/media-playback-nodes/video.md).



## Code Examples

<details>

<summary>JavaScript Examples</summary>

<br>

The JavaScript examples make use of the built-in fetch library and follows the same URL Parameters as listed in the API section above.

- Launch Media Assistant on Roku with `/launch/[Channel Id]`
```javascript
const rokuIP = '10.0.0.15'
const channelID = '782875'

async function sendDeeplink() {

    // Make deeplink request to Media Assistant
    await fetch(`http://${rokuIP}:8060/launch/${channelID}`, {
        method: "POST",
        mode: "no-cors",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify({}),
    })

    console.log("Deeplink sent to Media Assistant")
}

sendDeeplink()
```

- Launch and play media on Media Assistant with `/launch/[Channel Id]?u='[Media URL]'&t=[Media Type]`
```javascript
const rokuIP = '10.0.0.15'
const channelID = '782875'

async function sendDeeplink(urlParams) {

    // Encode URL Parameters
    const params = new URLSearchParams(urlParams).toString()

    // Make deeplink request to Media Assistant
    await fetch(`http://${rokuIP}:8060/launch/${channelID}?` + params, {
        method: "POST",
        mode: "no-cors",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify({}),
    })

    console.log("Deeplink sent to Media Assistant")
}

sendDeeplink({'u': 'https://archive.org/download/BigBuckBunny_124/Content/big_buck_bunny_720p_surround.mp4', 't': 'v'})
```

- Play media on Media Assistant with `/input?u='[Media URL]'&t=[Media Type]`
```javascript
const rokuIP = '10.0.0.15'

async function sendDeeplink(urlParams) {

    // Encode URL Parameters
    const params = new URLSearchParams(urlParams).toString()

    // Make deeplink request to Media Assistant
    await fetch(`http://${rokuIP}:8060/input?` + params, {
        method: "POST",
        mode: "no-cors",
        headers: {
            "Content-Type": "application/json",
        },
        body: JSON.stringify({}),
    })

    console.log("Deeplink sent to Media Assistant")
}

sendDeeplink({'u': 'https://archive.org/download/BigBuckBunny_124/Content/big_buck_bunny_720p_surround.mp4', 't': 'v'})
```

</details>

<details>

<summary>Python Examples</summary>

<br>

The Python examples make use of the requests library and follows the same URL Parameters as listed in the API section above.

- Launch Media Assistant on Roku with `/launch/[Channel Id]`
```python
import requests

rokuIP = '10.0.0.15'
channelID = '782875'

# Make deeplink request to Media Assistant
r = requests.post(f'http://{rokuIP}:8060/launch/{channelID}', data ={})

# Check status code to verify Media Assistant received the request
if r.status_code == requests.codes.ok:
    print('Media Assistant received deeplink Sucessfully')
else:
    print('Media Assistant responed with a error!')
```

- Launch and play media on Media Assistant with `/launch/[Channel Id]?u='[Media URL]'&t=[Media Type]`
```python
import requests

rokuIP = '10.0.0.15'
channelID = '782875'

# Make deeplink request to Media Assistant
urlParams = {'u': 'https://archive.org/download/BigBuckBunny_124/Content/big_buck_bunny_720p_surround.mp4', 't': 'v'}
r = requests.post(f'http://{rokuIP}:8060/launch/{channelID}', params=urlParams, data ={})

# Check status code to verify Media Assistant received the request
if r.status_code == requests.codes.ok:
    print('Media Assistant received deeplink Sucessfully')
else:
    print('Media Assistant responed with a error!')
```

- Play media on Media Assistant with `/input?u='[Media URL]'&t=[Media Type]`
```python
import requests

rokuIP = '10.0.0.15'

# Make deeplink request to Media Assistant
urlParams = {'u': 'https://archive.org/download/BigBuckBunny_124/Content/big_buck_bunny_720p_surround.mp4', 't': 'v'}
r = requests.post(f'http://{rokuIP}:8060/input', params=urlParams, data ={})

# Check status code to verify Media Assistant received the request
if r.status_code == requests.codes.ok:
    print('Media Assistant received deeplink Sucessfully')
else:
    print('Media Assistant responed with a error!')
```

</details>


## Road Map

- [x] Release! :tada:
- [x] Add support for media queueing
- [ ] Add more customization

## Translating

### You can help translate Media Assistant :tada:

<details>

<summary>How to translate Media Assistant</summary>

<br>

1. To add a translation, duplicate the `en_US` folder inside `/locale`.
2. Rename the folder to the language code below you wish to translate to.
    - Unfortunately, Roku only supports a small number of languages
    - Roku Language Codes
        - "en_US" -	US English
        - "en_GB" -	British English
        - "en_CA" -	Canadian English
        - "en_AU" -	Australian English
        - "fr_CA" -	Canadian French
        - "es_ES" -	International Spanish
        - "es_MX" -	Mexican Spanish
        - "de_DE" -	German
        - "it_IT" -	Italian
        - "pt_BR" -	Brazilian Portuguese
3. Open the `translation.xml` and change the `target-language` to the language code from before.
    ```xml
    <?xml version="1.0" encoding="UTF-8"?>
    <xliff version="1.2" xmlns="urn:oasis:names:tc:xliff:document:1.2">
    <file source-language="en-US" target-language="en-US" >
    ```
4. In the `translation.xml` for each `source` string, change the `target` to the translation of the `source` phrase
    ```xml
    <trans-unit id="10">
        <source>Enable Screen Saver During Playback</source>
        <target>Enable Screen Saver During Playback</target>
    </trans-unit>
    ```
5. Once completed submit a Pull Request with your translation, to request to get it added to the project.

> Roku's supported languages list. [Language Codes](https://developer.roku.com/en-gb/docs/references/brightscript/interfaces/ifdeviceinfo.md#getcurrentlocale-as-string)

> Roku's full translation documentation. [Roku's Translation docs](https://developer.roku.com/en-gb/docs/developer-program/core-concepts/localization.md)

</details>
    


## Credits

### Test Media:

'Big Buck Bunny' licensed under CC 3.0 by the Blender foundation. Hosted by archive.org

Local Forecast - Elevator Kevin MacLeod (incompetech.com)
Licensed under Creative Commons: By Attribution 3.0 License
http://creativecommons.org/licenses/by/3.0/

### Media Assistant:

Copyright 2025 Joseph Friend

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

### Fonts:

M PLUS Rounded 1c:

Designed by Coji Morishita, M+ Fonts Project

This Font Software is licensed under the SIL Open Font License, Version 1.1. This license is available with a FAQ at: https://openfontlicense.org
