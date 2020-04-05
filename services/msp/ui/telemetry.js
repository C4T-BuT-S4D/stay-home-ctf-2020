window.serverState = {};

window.trackedObjects = [];

window.aligmentAngle = 0.0;

function fetch_data() {

  trackedObjects.forEach(objectID => {

    const endpoint = `/telemetry/${objectID}`

    fetch(endpoint)
      .then((response) => {
        return response.json()
      })
      .then((data) => {
        if (data.error) {
          console.error(`object ${objectID} is not received: ${data.error}`);
          trackedObjects = trackedObjects.filter(el => el != objectID);
          return;
        }
        window.serverState[objectID] = data
      })
  })
}

window.beam_request = (from, angle) => {

  const endpoint = `/beam/${from}`

  let data = {
    'angle': angle,
  }

  fetch(endpoint, {
    method: 'POST',
    body: JSON.stringify(data),
  })
    .then((response) => {
      return response.json()
    })
    .then((data) => {
      if (data.error) {
        console.error(`beam from ${from} failed: ${data.error}`);
        return;
      }
      console.log(`beam response`, data)
    })
}

window.launch_request = (height, radioResp, on_success) => {

  const endpoint = `/launch/`

  let data = {
    phase: window.aligmentAngle + 180,
    height: height,
    narrow_beam_response: radioResp,
    antenna_focus: 1,
    mass: 100,
  }

  fetch(endpoint, {
    method: 'POST',
    body: JSON.stringify(data),
  })
    .then((response) => {
      return response.json()
    })
    .then((data) => {
      if (data.error) {
        console.error(`launch failed: ${data.error}`);
        return;
      }

      console.error(`launch ok, result id: ${data.id}`);
      on_success(data);
    })
}

window.onload = () => {
  let trackingRequest = document.getElementById("tracking-request")
  trackingRequest.addEventListener("keyup", event => {
    event.preventDefault();
    if (event.keyCode == 13) {
      if (!trackedObjects.includes(trackingRequest.value)) {
        trackedObjects.push(trackingRequest.value);
      }
    }
  })

  let launchRequest = document.getElementById("launch-request")
  let radioResponse = document.getElementById("radio-response")
  launchRequest.addEventListener("keyup", event => {
    event.preventDefault();
    if (event.keyCode == 13) {
      const orbit = parseFloat(launchRequest.value);
      const radioResp = radioResponse.value;
      launch_request(orbit, radioResp, resp => {
        trackedObjects.push(resp.id);
      });
    }
  })
}
