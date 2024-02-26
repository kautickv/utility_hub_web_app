async function sendGETToMultitabBackend(jwtToken) {
    /*
      PURPOSE: Send an HTTP POST request to the multitab endpoint to save user configurations.
      INPUT: 
          1. JWT Token as string
      OUTPUT: returns the response. If error, returns 500 error
      */
    try {
      let response = await fetch(
        `${process.env.REACT_APP_API_GATEWAY_BASE_URL}/bookmarkmanager`,
        {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
            Authorization: "Bearer " + jwtToken?.trim() ?? "",
          },
        }
      );
    
      if (!response.ok) {
        throw new Error('Error fetching config from backend');
      }
      const responseBody = await response.json();
      return responseBody;
    } catch (err) {
      console.log(`An error occurred sending GET to multitab. ${err}`);
      throw new Error(err);
    }
  }


async function sendPostToMultitabBackend(jwtToken, config) {
  /*
    PURPOSE: Send an HTTP POST request to the multitab endpoint to save user configurations.
    INPUT: 
        1. JWT Token as string
        2. The configuration as a JSON Obj
    OUTPUT: returns the status code of the response. If error, returns 500 error
    */
  try {
    let response = await fetch(
      `${process.env.REACT_APP_API_GATEWAY_BASE_URL}/bookmarkmanager`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Bearer " + jwtToken?.trim() ?? "",
        },
        body: JSON.stringify({"config_json": JSON.stringify(config)})
      }
    );

    return response.status;
  } catch (err) {
    console.log(`An error occurred sending POST to multitab. ${err}`);
    throw new Error(`Error saving config to backend: ${err}`);
  }
}

export { sendPostToMultitabBackend, sendGETToMultitabBackend};