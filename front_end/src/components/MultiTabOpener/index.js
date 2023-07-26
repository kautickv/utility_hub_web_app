import React, { useEffect, useState } from "react";
import TextField from "@mui/material/TextField";
import SearchIcon from "@mui/icons-material/Search";
import InputAdornment from "@mui/material/InputAdornment";
import Box from "@mui/material/Box";
import Grid from "@mui/material/Grid";
import Container from "@mui/material/Container";
import { useNavigate } from "react-router-dom";
import { sendVerifyAPIToAuthenticationServer } from "../../utils/util";
import {sendGETToMultitabBackend, sendPostToMultitabBackend} from "../../utils/multitabUtil";

// Import components
import Navbar from "../common/Navbar";
import Tile from "./Tile.js";
 
function MultiTabOpener() {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState("");
  const [tilesData, setTilesData] = useState([])

  useEffect(() => {
    // Check if JWT token exists

    const verifyIfUserLoggedIn = async () => {

      try{
        let jwtToken = checkLocalStorageForJWTToken();
        if (jwtToken) {
          // Check if JWT token is valid and if user is logged in
          let verifyResponse = await sendVerifyAPIToAuthenticationServer(
            jwtToken
          );

          if (verifyResponse === 200) {
            // User is already logged in
            // Fetch config data from backend
            let response = await sendGETToMultitabBackend(jwtToken)
            setTilesData(JSON.parse(JSON.parse(response)));
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
      }catch(err){
        console.log(`An error occurred: ${err}`)
        alert("An unexpected error occurred. Please try again later")
      }
    };

    verifyIfUserLoggedIn();
  }, [navigate]);

  useEffect(() => {
    console.log(tilesData)
  }, [tilesData])

  async function handleConfigureSave(index, newUrls){
    /**
     * PURPOSE: This function will add/delete URLs in the respective tile
     *          and make http request to save configuration in backend
     * INPUT: The index of the tile to update.
     * OUTPUT: None
     */

    // Change the url array for the given tile
    let copy = JSON.parse(JSON.stringify(tilesData));
    copy[index]["urls"] = newUrls;
    setTilesData(copy)

    // Save configuration
    postNewConfigToBackend(copy)
  }
  async function postNewConfigToBackend(newTileData) {
    // This function will perform an API call to backend to save current config
    try{
      // Get the JWTToken
      let jwtToken = checkLocalStorageForJWTToken();
      if (jwtToken !== null && jwtToken !== "undefined") {
        
        let httpCode = await sendPostToMultitabBackend(jwtToken, newTileData);
        if (httpCode === 200){
          //Pass
        }else if(httpCode === 401){
          alert('Credentials Expired. Please login again')
          navigate('/login')
        }else if(httpCode === 500){
          alert("AN error occurred while saving. Please try again later")
        }else{
          alert("An unknown error occurred. Please try again later.")
        }
      }else{
        // User JWT token is not valid or expired
        localStorage.removeItem("JWT_Token");
        navigate("/login");
      }
    }
    catch(err){
      console.log(err);
      alert('An error ocurred saving urls. Please try again later')
    }
  }

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
      <Box
        display="flex"
        justifyContent="center"
        alignItems="center"
        style={{ marginBottom: "20px", marginTop: "20px" }}
      >
        <TextField
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          variant="outlined"
          size="large" // You can adjust this to 'medium' if 'large' is too big.
          InputProps={{
            startAdornment: (
              <InputAdornment position="start">
                <SearchIcon />
              </InputAdornment>
            ),
          }}
          style={{ width: "50%" }} // Adjust the width of the search bar.
        />
      </Box>
      <Container style={{ marginTop: "10px", marginBottom: "10px" }}>
        <Grid container spacing={1}>
          {tilesData
            .filter((tile) =>
              tile.title.toLowerCase().includes(searchTerm.toLowerCase())
            )
            .map((tile, index) => (
              <Grid item xs={12} sm={6} md={4} lg={3} key={index}>
                <Tile
                  title={tile.title}
                  description={tile.description}
                  urls={tile.urls}
                  onSave={(newUrls) => handleConfigureSave(index, newUrls)}
                />
              </Grid>
            ))}
        </Grid>
      </Container>
    </>
  );
}

export default MultiTabOpener;
