import React, { useState, useEffect, useRef } from "react";
import { Button, Box, Container, Typography, Paper } from '@mui/material';
import { styled, keyframes } from '@mui/system';
import { useNavigate } from "react-router-dom";
import { sendVerifyAPIToAuthenticationServer } from "../../utils/util";
import LoadingSpinner from "../common/LoadingSpinner"; 

// Styled components
// Define keyframes for background animation
const gradientAnimation = keyframes`
  0% {background-position: 0% 50%;}
  50% {background-position: 100% 50%;}
  100% {background-position: 0% 50%;}
`;

// Create a Styled Container component
const StyledContainer = styled(Container)(({ theme }) => ({
  display: 'flex',
  alignItems: 'center',
  justifyContent: 'center',
  height: '100vh',
  // Add gradient background
  background: `linear-gradient(45deg, ${theme.palette.primary.main} 10%, ${theme.palette.secondary.main} 90%)`,
  backgroundSize: '200% 200%',
  animation: `${gradientAnimation} 3s ease infinite`,
}));


function Login() {
  const [client_id, setClient_id] = useState("");
  const navigate = useNavigate();
  let url = useRef(null);
  let redirectUrl = useRef(null);
  const [loading, setLoading] = useState(false)

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

    setLoading(true);
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

    setLoading(false)
  }

  function handleURLHasNoCode() {
    /**
     * This function will be triggered if the URL has no code and no JWT token is saved
     * locally. Will ask user to login again.
     */

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

    setLoading(true)
    fetchCreds();
    setLoading(false)
  }

  function handleURLHasCode() {
    /**
     * This function will be triggered if the URL has the google code as parameter
     */
    // Extract code from URL
    setLoading(true)
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

        setLoading(false)
      })
      .catch((error) => {
        setLoading(false)
        console.error("Error:", error)
      });
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

  if (loading){
    return <LoadingSpinner description="Please wait ..."/>
  }

  return (
    <StyledContainer component="main" maxWidth="xl">
      <Box
        display="flex"
        flexDirection="column"
        alignItems="center"
        justifyContent="center"
        minHeight="100vh"
        sx={{
          '& .MuiPaper-root': {
            padding: '24px',
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
          },
          '& .MuiButton-root': {
            margin: '24px 0 16px',
            padding: '12px 24px',
          },
        }}
      >
        <Paper>
          <Typography component="h1" variant="h5" align="center">
            Password Generator
          </Typography>
          <Typography component="p" align="center">
            Welcome to your password generator App!
          </Typography>
          <Button
            type="submit"
            fullWidth
            variant="contained"
            color="primary"
            onClick={googleLogin}
          >
            Login
          </Button>
        </Paper>
      </Box>
    </StyledContainer>
  );
}

export default Login;
