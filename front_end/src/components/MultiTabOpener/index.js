import React, { useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { sendVerifyAPIToAuthenticationServer } from "../../utils/util";

// Import components
import Navbar from "../common/Navbar";

function MultiTabOpener() {
  const navigate = useNavigate();

  useEffect(() => {
    // Check if JWT token exists

    const verifyIfUserLoggedIn = async () => {
      let jwtToken = checkLocalStorageForJWTToken();
      if (jwtToken) {
        // Check if JWT token is valid and if user is logged in
        let verifyResponse = await sendVerifyAPIToAuthenticationServer(
          jwtToken
        );

        if (verifyResponse === 200) {
          // User is already logged in
          // Do nothing
        } else if (verifyResponse === 401) {
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

    verifyIfUserLoggedIn();
  });

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

  return (
    <>
      <Navbar />
      Welcome to Multi Tab Opener
    </>
  );
}

export default MultiTabOpener;
