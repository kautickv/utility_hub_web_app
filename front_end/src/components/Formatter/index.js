import React, { useEffect, useState, useContext } from "react";
import { useNavigate } from "react-router-dom";
// Import scripts
import { checkLocalStorageForJWTToken } from "../../utils/util";
import { sendVerifyAPIToAuthenticationServer } from "../../utils/util";

// Import components
import LoadingSpinner from "../common/LoadingSpinner";
import Navbar from "../common/Navbar";
import { AuthContext } from "../../context/AuthContext";

function Home() {
  const navigate = useNavigate();
  const [userFirstName, setUserFirstName] = useState("");
  const [isLoading, setIsLoading] = useState(true);
  const { isAuthenticated, user, logoutUser, loginUser } =
    useContext(AuthContext);

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
              alert("An error has occurred. Please try again later");
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
        alert("An unexpected error occurred. Please try again later");
        setIsLoading(false);
      }
    };

    setIsLoading(true);
    verifyIfUserLoggedIn();
  }, [navigate, isAuthenticated, logoutUser, user, loginUser]);

  if (isLoading) {
    return <LoadingSpinner description="Please wait ..." />;
  }

  return (
    <>
      <Navbar />
      
    </>
  );
}

export default Home;
