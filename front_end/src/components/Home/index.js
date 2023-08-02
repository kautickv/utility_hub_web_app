import React, { useEffect, useState} from "react";
import { useNavigate } from "react-router-dom";
import { sendVerifyAPIToAuthenticationServer } from "../../utils/util";
import LoadingSpinner from "../common/LoadingSpinner"; 
import "./home.css";

// Import components
import Navbar from "../common/Navbar";

function Home() {
  const navigate = useNavigate();
  const [userFirstName, setUserFirstName] = useState("")
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    // Check if JWT token exists
    const verifyIfUserLoggedIn = async () => {
      let jwtToken = checkLocalStorageForJWTToken();
      if (jwtToken) {
        // Check if JWT token is valid and if user is logged in
        let verifyResponse = await sendVerifyAPIToAuthenticationServer(
          jwtToken
        );

        if (verifyResponse.status === 200) {
          // User is already logged in
          let userInfo = await verifyResponse.json();
          let userName = userInfo["token_details"]["username"];
          setUserFirstName(userName.split(" ")[0]) // Get the first Name

          setIsLoading(false)

        } else if (verifyResponse.status === 401) {
          // User JWT token is not valid or expired
          localStorage.removeItem("JWT_Token");
          navigate("/login");
        } else {
          console(
            `An error has occurred. Verify Path returns ${verifyResponse}`
          );
          alert("An error has occurred. Please try again later");
        }
      } else {
        //Token not found.
        localStorage.removeItem("JWT_Token");
        navigate("/login");
      }
    };

    setIsLoading(true)
    verifyIfUserLoggedIn();
  }, [navigate]);

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
  if (isLoading){
    return <LoadingSpinner description="Please wait ..."/>
  }

  return (
    <>
      <Navbar />
      Hello {userFirstName}, Welcome to the Home Page
    </>
  );
}

export default Home;
