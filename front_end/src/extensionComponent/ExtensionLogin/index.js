import React, { useState, useEffect } from "react";
import { Button, Typography } from '@mui/material';
import { sendVerifyAPIToAuthenticationServer } from "../../utils/util";
import LoadingSpinner from "../../components/common/LoadingSpinner"; 

function ExtensionLogin({ onLoggedIn }) {
  const [loading, setLoading] = useState(true);
  const [loggedIn, setLoggedIn] = useState(false);
  const [client_id, setClient_id] = useState("");

  useEffect(() => {
    async function verifyLoginStatus() {
      let jwtToken = localStorage.getItem("JWT_Token");
      if (jwtToken) {
        setLoading(true);
        let verifyResponse = await sendVerifyAPIToAuthenticationServer(jwtToken);
        setLoading(false);
        if (verifyResponse.status === 200) {
          setLoggedIn(true);
          onLoggedIn(true); // Notify parent
        }
      } else {
        // Fetch client_id for Google login if not logged in
        const fetchCreds = async () => {
          try {
            const response = await fetch(
              `${process.env.REACT_APP_API_GATEWAY_BASE_URL}/auth/creds`
            );
            const data = await response.json();
            let ascii = atob(data.client_id_base64);
            let utf8 = decodeURIComponent(escape(ascii));
            setClient_id(utf8);
          } catch (error) {
            console.error("Error fetching data:", error);
          }
        };
        fetchCreds();
      }
      setLoading(false);
    }
    verifyLoginStatus();
  }, []);

  function googleLogin() {
    const redirectUrl = window.location.origin; // Assuming this works for extensions
    const googleAuthUrl = `https://accounts.google.com/o/oauth2/v2/auth?scope=profile email&prompt=consent&access_type=offline&include_granted_scopes=true&state=state_parameter_passthrough_value&redirect_uri=${redirectUrl}&response_type=code&client_id=${client_id}`;
    window.location = googleAuthUrl;
  }

  if (loading) {
    return <LoadingSpinner description="Checking login status..."/>
  }

  if (loggedIn) {
    return (
      <div>
        {/* You can add your options here */}
        <Typography>Your Extension Options Here</Typography>
      </div>
    );
  }

  return (
    <div>
      <Typography>You are not logged in.</Typography>
      <Button onClick={googleLogin}>Login with Google</Button>
    </div>
  );
}

export default ExtensionLogin;
