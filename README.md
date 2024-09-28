# Media Assistant

<img src="./docs/assets/logo_full.png" width="25%" border="2" align="right" />

Media Assistant is a Roku channel that allows you to stream/play media from a URL on your Roku device through Http Post Requests called Deeplinks. 

<!-- View the [Media Assiatant Website](https://medievalapple.net/Media-Assistant.html) for more info. -->

## Install Media Assistant

###  Roku Channel Store (Recommended):
- You can download Media Assistant from the offical Roku channel store with the link below:

    - [Install Media Assistant](https://channelstore.roku.com/details/625f8ef7740dff93df7d85fc510303b4/media-assistant)

### Sideload:
- To sideload Media Assistant on to your Roku Device follow the steps below:

1. Enable Devloper mode on your Roku by following the **Activating developer mode** section of the [Roku developer documentation](https://developer.roku.com/en-gb/docs/developer-program/getting-started/developer-setup.md).

2. Download the **Media-Assistant.zip** from the [Releases](https://github.com/MedievalApple/Media-Assistant/releases) page.

3. Then follow the Sideloading channels section of the [Roku developer documentation](https://developer.roku.com/en-gb/docs/developer-program/getting-started/developer-setup.md) in order to sideload the zip downloaded in step 2.

4. Launch Media Assistant and enjoy :D

> [!TIP]
> Dev mode is activated by hitting home three times, up twice, and then right, left, right, left, right.

## Using Media Assistant

- Media Assistant can work with any app/code that made use of the Play on Roku API since Media Assistant supports the same request structure that Play on Roku used. Though the app/code would have to be updated to send the requests to Media Assistants Channel Id instead of Play on Roku's.

- Media Assistant can be experimented with through using [Media Assistant Tester](https://ma.medievalapple.net/), a small website that allows you to test Media Assistant, or by using the code examples/API Docs provided below.

> [!IMPORTANT]
> If Media Assistant was installed through the Roku Channel Store, the Channel Id will be `782875`. If Media Assistant was sideloaded, the Channel Id will be `dev`.

## API

- Media Assistant makes use of Roku's Deeplink system which allows you to send commands to a Roku using URL Parameters sent as a Http Post Request with an empty body to the Roku's IP at `Port 8060`. The following examples will use cURL. Examples in different programming languages can be found below.

> [!Warning]
> The following examples use the Channel Id from the Roku Channel Store version of Media Assistant `782875`. If you sideloaded Media Assistant you will need to change the id's in the examples to `dev`.

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

    - `u` or `contentId` - takes a `URL` to a media source or stream
    - `t` - takes the media type `a` for audio or `v` for video (If the `t` parameter is left out it will default to video)

- Optional Parameters
    - Format Parameters are optional but need to be used to support certain media formats
        - `videoFormat` - takes a video format type like `mp4`,`hls`,`mkv`
        - `songFormat` - takes a audio format type like `mp3`,`aac`,`flac`
    - Media Information Parameters
        - `videoName` - takes the name of your video like `Big Buck Bunny`
        - `songName` - takes the name of your song like `Local Elevator`
        - `artistName` - takes the name of the song's artist like `Kevin MacLeod`
        - `albumArt` - takes a `URL` to a image file

> [!WARNING]
> All URLs and their URL Parameters must be encoded in order for the Post Request to succeed. Most Http Request libraries do this automatically, but some don't. For convience the cURL examples above have already had the URLs encoded. [Learn More](https://www.w3schools.com/tags/ref_urlencode.ASP)

> [!TIP] 
> Roku devices handle images 1080p and under the best. Higher quality images seem to take a little bit to load in, especially after resuming from the screen saver. On some older Roku devices they wont load at all.

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

The Python examples make use of the built-in requests library and follows the same URL Parameters as listed in the API section above.

- Launch Media Assistant on Roku with `/launch/[Channel Id]`
```python
import requests

rokuIP = '10.0.0.15'
channelID = '782875'

# Make deeplink request to Media Assistant
r = requests.post(f'http://{rokuIP}:8060/launch/{channelID}', data ={})

# Check status code to verify Media Assistant recieved the request
if r.status_code == requests.codes.ok:
    print('Media Assistant recieved deeplink Sucessfully')
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

# Check status code to verify Media Assistant recieved the request
if r.status_code == requests.codes.ok:
    print('Media Assistant recieved deeplink Sucessfully')
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

# Check status code to verify Media Assistant recieved the request
if r.status_code == requests.codes.ok:
    print('Media Assistant recieved deeplink Sucessfully')
else:
    print('Media Assistant responed with a error!')
```

</details>


## Road Map

- [x] Release! :tada:
- [ ] Add photo viewer/slideshow
- [ ] Add support for media queueing
- [ ] Add more customization

## Credits

### Test Media:

'Big Buck Bunny' licensed under CC 3.0 by the Blender foundation. Hosted by archive.org

Local Forecast - Elevator Kevin MacLeod (incompetech.com)
Licensed under Creative Commons: By Attribution 3.0 License
http://creativecommons.org/licenses/by/3.0/

### Media Assistant:

Copyright 2024 Joseph Friend

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
