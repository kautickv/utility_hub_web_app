import jwt from 'jsonwebtoken';

async function sendVerifyAPIToAuthenticationServer(jwtToken) {
  /*
    PURPOSE: Send an HTTP POST request to the verify endpoint to check if user is logged in.
    INPUT: JWT Token as string
    OUTPUT: returns the status code of the response. If error, returns 500 error
    */

  try {
    let response = await fetch(
      `${process.env.REACT_APP_API_GATEWAY_BASE_URL}/auth/verify`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwtToken?.trim() ?? "",
        },
      }
    );

    return response;
  } catch (err) {
    console.log(`An error occurred sending verify API. ${err}`);
    return 500;
  }
}

async function logout(jwtToken) {
  /*
    PURPOSE: Send an HTTP POST request to the backend server to logout user
    INPUT: JWT Token as string
    OUTPUT: returns the status code of the response. If error, returns 500 error
    */

  console.log(`JWTToken is ${jwtToken}`);
  try {
    let response = await fetch(
      `${process.env.REACT_APP_API_GATEWAY_BASE_URL}/auth/logout`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer " + jwtToken?.trim() ?? "",
        },
      }
    );

    return response.status;
  } catch (err) {
    console.log(`An error occurred sending logout API. ${err}`);
    return 500;
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


function decodeJWT(token) {
  try {
    const decoded = jwt.decode(token);
    return decoded;
  } catch (e) {
    console.error("Invalid JWT token:", e);
    return null;
  }
}


export { sendVerifyAPIToAuthenticationServer, logout, checkLocalStorageForJWTToken, decodeJWT};
