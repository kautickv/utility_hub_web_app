import React, { useEffect} from "react";
import { useNavigate } from "react-router-dom";

// Import scripts
import { sendVerifyAPIToAuthenticationServer } from "../../utils/util";
import {checkLocalStorageForJWTToken} from "../../utils/util"

// Import components
//import LoadingSpinner from "../common/LoadingSpinner";
import Navbar from "../common/Navbar";


function Trading() {
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

        if (verifyResponse.status === 200) {
          // User is already logged in
          let userInfo = await verifyResponse.json();
          console.log(userInfo)

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
    verifyIfUserLoggedIn();
  }, [navigate]);


  return (
    <>
      <Navbar />
      Trading Page
    </>
  );
}

export default Trading;
