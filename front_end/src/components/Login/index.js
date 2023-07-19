import React, { useState, useEffect, useRef } from "react";
import "bootstrap/dist/css/bootstrap.min.css";
import "./login.css";
import { useNavigate } from "react-router-dom";
import { sendVerifyAPIToAuthenticationServer } from "../../utils/util";

function Login() {
  const [client_id, setClient_id] = useState("");
  const navigate = useNavigate();
  let url = useRef(null);
  let redirectUrl = useRef(null);

  // Run this function once every time loads
  useEffect(() => {
    // Check if url already contains code
    url.current = window.location.href;
    redirectUrl.current = extractDomainFromURL(url.current);
    const hasCode = url.current.includes("code=");

    if (hasCode) {
      handleURLHasCode();
    } else {
      let jwtToken = localStorage.getItem("JWT_Token");
      if (jwtToken !== null && jwtToken !== "undefined") {
        handleVerifyJWTToken(jwtToken);
      } else {
        if (redirectUrl.current !== null && redirectUrl.current !== undefined) {
          handleURLHasNoCode();
        } else {
          // You may want to handle the case when redirectUrl.current is not properly set.
          console.error("redirectUrl.current is not set");
        }
      }
    }
  });

  async function handleVerifyJWTToken(jwtToken) {
    /**
     * This function will be triggered if a JWTToken is already stored on localStorage.
     * This function will send an api call to verify endpoint to check if the jwtToken is valid
     * If Valid, it redirects user to /home page
     * if not, asks user to sign in again.
     */
    // Check if user is already signed in

    let verifyResponse = await sendVerifyAPIToAuthenticationServer(jwtToken);
    if (verifyResponse === 200) {
      // User is already logged in
      // Redirect user to main application
      navigate("/home");
    } else if (verifyResponse === 401) {
      // User JWT token is not valid
      localStorage.removeItem("JWT_Token");
      navigate("/login");
    } else {
      // An error occurred while verifying
      console.log("An error occurred while verifying user credentials");
      alert(
        "An error occurred while verifying your login credentials. Please login again."
      );
      // User JWT token is not valid
      localStorage.removeItem("JWT_Token");
      navigate("/login");
    }

    console.log("Has JWT Token");
  }

  function handleURLHasNoCode() {
    /**
     * This function will be triggered if the URL has no code and no JWT token is saved
     * locally. Will ask user to login again.
     */

    console.log("Code not found in URL");
    const fetchCreds = async () => {
      try {
        const response = await fetch(
          `${process.env.REACT_APP_API_GATEWAY_BASE_URL}/auth/creds`
        );
        const data = await response.json();
        // Decode client_id
        let ascii = atob(data.client_id_base64);
        let utf8 = decodeURIComponent(escape(ascii));
        setClient_id(utf8);
      } catch (error) {
        // Handle any errors that may occur during the fetch or decoding process
        console.error("Error fetching data:", error);
      }
    };

    fetchCreds();
  }

  function handleURLHasCode() {
    /**
     * This function will be triggered if the URL has the google code as parameter
     */
    // Extract code from URL
    const code = extractGoogleCodeFromURL(url.current);

    // Send POST api call to login endpoint to exchange code for token.
    let payload = {
      code: code,
      redirectUrl: redirectUrl.current,
    };
    fetch(`${process.env.REACT_APP_API_GATEWAY_BASE_URL}/auth/login`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    })
      .then((response) => {
        if (response.status === 200) {
          // Authentication success. Save JWT token.
          response.json().then((data) => {
            console.log(data);
            localStorage.setItem("JWT_Token", data.JWT_Token);
          });
          // Redirect user to main application
          navigate("/home");
        } else {
          if (response.status === 503) {
            console.log("Server error. Please try again later");
          }
        }
      })
      .catch((error) => console.error("Error:", error));
  }

  function extractGoogleCodeFromURL(newURL) {
    // Create new url object
    const parsedURL = new URL(newURL);
    return parsedURL.searchParams.get("code");
  }

  function extractDomainFromURL(newURL) {
    // Create new url object
    let url = new URL(newURL);
    // Get the full domain with the HTTP protocol
    let fullDomain = url.protocol + "//" + url.hostname;
    if (url.port) {
      fullDomain += ":" + url.port;
    }
    if (url.pathname !== "/") {
      fullDomain += url.pathname;
    }
    return fullDomain;
  }

  function googleLogin() {
    const googleAuthUrl = `https://accounts.google.com/o/oauth2/v2/auth?scope=profile email&prompt=consent&access_type=offline&include_granted_scopes=true&state=state_parameter_passthrough_value&redirect_uri=${redirectUrl.current}&response_type=code&client_id=${client_id}`;
    console.log(redirectUrl.current);
    window.location = googleAuthUrl;
  }

  return (
    <div className="App" style={{ backgroundColor: "#f2f2f2" }}>
      <header className="App-header orange-header text-white text-center p-5">
        <h1>Password Generator</h1>
        <p>Welcome to your password generator App!</p>
      </header>
      <div
        className="d-flex justify-content-center align-items-center"
        style={{ height: "100vh" }}
      >
        <button onClick={googleLogin} className="btn btn-custom btn-xl">
          Login
        </button>
      </div>
    </div>
  );
}

export default Login;
