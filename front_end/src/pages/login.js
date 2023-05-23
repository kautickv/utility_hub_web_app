import React, { useState, useEffect } from "react";
import "bootstrap/dist/css/bootstrap.min.css";
import "./login.css";
import { useNavigate  } from 'react-router-dom';


function Login() {
  const [client_id, setClient_id] = useState("");
  const [redirect_uri, setRedirect_uri] = useState("");
  const navigate = useNavigate();


  // Run this function once every time loads
  useEffect(() => {
    // Check if url already contains code
    const url = window.location.href;
    const hasCode = url.includes("code=");

    if (hasCode) {
      // Extract code from URL
      const newURL = url.split("code=");
      const code = newURL[1].split("&")[0];

      // Send POST api call to login endpoint to exchange code for token.
      let payload = {
        code: code,
      };
      fetch(`${process.env.REACT_APP_API_GATEWAY_BASE_URL}/auth/login`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
        },
        body: JSON.stringify(payload),
      })
        .then((response) => {
          console.log(response.status);
          if (response.status === 200) {
            // Redirect user to main application
            navigate('/home');
          } else {
            if (response.status === 503) {
              console.log("Server error. Please try again later");
            }
          }
        })
        .catch((error) => console.error("Error:", error));
    } else {
      console.log("Code not found in URL");
      const fetchCreds = async () => {
        try {
          const response = await fetch(
            process.env.REACT_APP_API_GATEWAY_BASE_URL + "/auth/creds"
          );
          const data = await response.json();
          // Decode client_id
          let ascii = atob(data.client_id_base64);
          let utf8 = decodeURIComponent(escape(ascii));
          setClient_id(utf8);

          // Decode redirect_uri
          ascii = atob(data.redirect_uri_base64);
          utf8 = decodeURIComponent(escape(ascii));
          //setRedirect_uri(utf8);
          setRedirect_uri("http://localhost:3000");
        } catch (error) {
          // Handle any errors that may occur during the fetch or decoding process
          console.error("Error fetching data:", error);
        }
      };

      fetchCreds();
    }
  }, []);

  function googleLogin() {
    const googleAuthUrl = `https://accounts.google.com/o/oauth2/v2/auth?scope=profile email&access_type=offline&include_granted_scopes=true&state=state_parameter_passthrough_value&redirect_uri=${redirect_uri}&response_type=code&client_id=${client_id}`;
    console.log(googleAuthUrl);
    window.location = googleAuthUrl;
  }

  return (
    <div className="App" style={{ backgroundColor: "#f2f2f2" }}>
      <header className="App-header orange-header text-white text-center p-5">
        <h1>SOC Team</h1>
        <p>Welcome to our landing page!</p>
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
