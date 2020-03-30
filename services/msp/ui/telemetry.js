window.serverState = {}

window.trackedObjects = [
"a00cb030-4d7b-4e2f-bdfa-bdab27927202",
 "a00cb030-4d7b-4e2f-bdfa-bdab27927201",
]

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

  let angleParam = encodeURI(String(angle))

  const endpoint = `/beam/${from}?angle=${angleParam}`

  fetch(endpoint)
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
}
