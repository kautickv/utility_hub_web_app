import React, { useEffect, useState, useContext } from "react";
import { useNavigate } from "react-router-dom";
// Import scripts
import { checkLocalStorageForJWTToken } from "../../utils/util";
import { sendVerifyAPIToAuthenticationServer } from "../../utils/util";

// MUI elements
import {
    Container,
    Typography,
    Paper,
  } from "@mui/material";

// Import components
import LoadingSpinner from "../common/LoadingSpinner";
import AlertComponent from "../common/AlertComponent";
import Navbar from "../common/Navbar";
import { AuthContext } from "../../context/AuthContext";

function Formatter() {
  const navigate = useNavigate();
  const [userFirstName, setUserFirstName] = useState("");
  const [isLoading, setIsLoading] = useState(true);
  const { isAuthenticated, user, logoutUser, loginUser } =
    useContext(AuthContext);
  const [alerts, setAlerts] = React.useState([]);

  // FUNCTIONS
  useEffect(() => {
    // Check if JWT token exists
    const verifyIfUserLoggedIn = async () => {
      try {
        let jwtToken = checkLocalStorageForJWTToken();
        if (jwtToken) {
          // Check context if user is logged in
          if (isAuthenticated) {
            // User is already logged in
            let userName = user["token_details"]["username"];
            setUserFirstName(userName.split(" ")[0]); // Get the first Name
            console.log(userFirstName);
            setIsLoading(false);
          } else {
            // User is not authenticated in context. Needs to send verify User auth
            // Check if JWT token is valid and if user is logged in
            let verifyResponse = await sendVerifyAPIToAuthenticationServer(
              jwtToken
            );

            if (verifyResponse.status === 200) {
              // User is already logged in
              let userInfo = await verifyResponse.json();
              let userName = userInfo["token_details"]["username"];
              setUserFirstName(userName.split(" ")[0]); // Get the first Name
              // Set user context
              loginUser(userInfo);
            } else if (verifyResponse.status === 401) {
              // User JWT token is not valid or expired
              // Logout user from context
              logoutUser();
              navigate("/login");
            } else {
              console(
                `An error has occurred. Verify Path returns ${verifyResponse}`
              );
              addAlert("error","An error has occurred. Please try again later");
            }
            setIsLoading(false);
            navigate("/login");
          }
        } else {
          //Token not found.
          logoutUser();
          navigate("/login");
          return;
        }
      } catch (err) {
        console.log(`An error occurred: ${err}`);
        addAlert("error", "An unexpected error occurred. Please try again later");
        setIsLoading(false);
      }
    };

    setIsLoading(true);
    verifyIfUserLoggedIn();
  }, [navigate, isAuthenticated, logoutUser, user, loginUser, userFirstName]);

  if (isLoading) {
    return <LoadingSpinner description="Please wait ..." />;
  }

  function addAlert(severity, message) {
    const newAlert = {
      id: new Date().getTime(),
      severity,
      message,
    };
    setAlerts(function (prevAlerts) {
      return [...prevAlerts, newAlert];
    });
  }

  function handleClose(id) {
    setAlerts(function (prevAlerts) {
      return prevAlerts.filter(function (alert) {
        return alert.id !== id;
      });
    });
  }

  return (
    <>
      <Navbar />
      <Container
        maxWidth="xl"
        component={Paper}
        elevation={0}
        sx={{ p: 3, mt: 2, borderRadius: 2 }}
      >
        <Typography variant="h4" gutterBottom>
          Crypto Dashboard
        </Typography>
      </Container>
      {alerts.map((alert) => (
        <AlertComponent
          key={alert.id}
          open={true}
          severity={alert.severity}
          message={alert.message}
          handleClose={() => handleClose(alert.id)}
        />
      ))}
    </>
  );
}

export default Formatter;
