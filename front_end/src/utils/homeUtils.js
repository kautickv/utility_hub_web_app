async function getSlackData(jwtToken){
    /**
     * PURPOSE: This function will send a GET HTTP response to the backend to request
     *          the information from slack.
     * 
     * INPUT: JWT token for authentication
     * OUTPUT: A json object containing all the slack information for each channels.
     */
    let numberOfDays = 2;
    let fromApp = "slack"
    try {
        let response = await fetch(
          `${process.env.REACT_APP_API_GATEWAY_BASE_URL}/home?from=${fromApp}&number_days=${numberOfDays}`,
          {
            method: "GET",
            headers: {
              "Content-Type": "application/json",
              Authorization: "Bearer " + jwtToken?.trim() ?? "",
            },
          }
        );
      
        if (!response.ok) {
          throw new Error('Error fetching Slack data');
        }
        const responseBody = await response.json();
        return responseBody;
      } catch (err) {
        console.log(`An error occurred getting slack data. ${err}`);
        throw new Error(err);
      }
}

function checkLocalStorageForJWTToken() {
    /**
     * This function checks if a JWT token exists in local storage.
     * If yes, it returns the token.
     * If it does not exist, returns an empty string
     */
    const token = localStorage.getItem("JWT_Token");
    if (token) {
      return token;
    } else {
      // No token found, return empty string
      return "";
    }
  }

export {getSlackData, checkLocalStorageForJWTToken};