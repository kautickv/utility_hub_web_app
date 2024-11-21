import React, { useEffect, useState, useContext } from "react";
import { useNavigate } from "react-router-dom";
import Grid from "@mui/material/Grid";
import Paper from "@mui/material/Paper";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";
import Avatar from "@mui/material/Avatar";
import Stack from "@mui/material/Stack";
// Import scripts
import { checkLocalStorageForJWTToken } from "../../utils/util";
import { sendVerifyAPIToAuthenticationServer } from "../../utils/util";

// Import components
import LoadingSpinner from "../common/LoadingSpinner";
import AlertComponent from "../common/AlertComponent";
import Navbar from "../common/Navbar";
import { AuthContext } from "../../context/AuthContext";

function Home() {
  const navigate = useNavigate();
  const [userFirstName, setUserFirstName] = useState("");
  const [isLoading, setIsLoading] = useState(true);
  const { isAuthenticated, user, logoutUser, loginUser } =
    useContext(AuthContext);
      // Alerts state
  const [alerts, setAlerts] = React.useState([]);

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
              // Display alerts on screen
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
  }, [navigate, isAuthenticated, logoutUser, user, loginUser]);


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
      <Box sx={{ flexGrow: 1, m: 2 }}>
        <Grid container spacing={2}>
          <Grid item xs={12}>
            <Paper elevation={2} sx={{ padding: 1, marginBottom: 2 }}>
              <Stack
                direction="row"
                justifyContent="flex-start"
                alignItems="center"
                spacing={2}
              >
                <Avatar sx={{ width: 30, height: 30, fontSize: "1rem" }}>
                  {userFirstName.charAt(0)}
                </Avatar>
                <Typography variant="h6" component="div">
                  Hello, {userFirstName}
                </Typography>
              </Stack>
            </Paper>
          </Grid>
          <Grid item xs={12} sm={6}>
            <Paper>{/* Insert Jira tickets component here */}</Paper>
          </Grid>
          <Grid item xs={12} sm={6}>
            <Paper>
              {/*Insert Components here*/}
            </Paper>
          </Grid>
          {/* More grid items as needed */}
        </Grid>
      </Box>
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

export default Home;
