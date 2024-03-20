async function sendPostToJsonViewerProjects(jwtToken, projectName, action) {
  /*
    PURPOSE: Send an HTTP POST request to the /json_view/projects endpoint to save new project
    INPUT: 
        1. JWT Token as string
    OUTPUT: returns the response. If error, returns 500 error
    */
  try {
    let response = await fetch(
      `${process.env.REACT_APP_API_GATEWAY_BASE_URL}/json_viewer/projects`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Bearer " + jwtToken?.trim() ?? "",
        },
        body: JSON.stringify({
          "project_name": projectName,
          "action": action
        })
      }
    );

    return response;
  } catch (err) {
    console.log(`An error occurred sending POST to multitab. ${err}`);
    return 500
  }
}

async function sendPostToJsonViewerProjectJson(jwtToken, projectName, action, jsonName, jsonContent) {
  /*
      PURPOSE: Send an HTTP POST request to the /json_view/projects/json endpoint to save/delete json files
              for a particular project
      INPUT: 
          1. JWT Token as string
      OUTPUT: returns the response. If error, returns 500 error
      */
  try {
    let response = await fetch(
      `${process.env.REACT_APP_API_GATEWAY_BASE_URL}/json_viewer/projects/json`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: "Bearer " + jwtToken?.trim() ?? "",
        },
        body: JSON.stringify({
          "project_name": projectName,
          "action": action,
          "json_object":{
            "name": jsonName,
            "content": JSON.stringify(jsonContent)
          }
        })
      }
    );

    return response;
  } catch (err) {
    console.log(`An error occurred sending POST to multitab. ${err}`);
    return 500
  }

}

export { sendPostToJsonViewerProjects, sendPostToJsonViewerProjectJson };