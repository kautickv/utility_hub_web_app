import React, { useEffect, useState } from "react";
import TextField from "@mui/material/TextField";
import SearchIcon from "@mui/icons-material/Search";
import InputAdornment from "@mui/material/InputAdornment";
import Box from "@mui/material/Box";
import Grid from "@mui/material/Grid";
import Container from "@mui/material/Container";
import { useNavigate } from "react-router-dom";
import { sendVerifyAPIToAuthenticationServer } from "../../utils/util";

// Import components
import Navbar from "../common/Navbar";
import Tile from "./Tile.js";

// Define tiles
const tilesData = [
  {
    title: "Tile 1",
    description: "This is the first tile.",
    urls: [
      {
        urlTitle: "Google",
        url: "https://www.google.com",
      },
      {
        urlTitle: "coinmarket Cap",
        url: "https://coinmarketcap.com/coins",
      },
    ],
  },
  {
    title: "Tile 2",
    description: "This is the second tile.",
    urls: [
      {
        urlTitle: "Google",
        url: "https://www.google.com",
      },
      {
        urlTitle: "coinmarket Cap",
        url: "https://coinmarketcap.com/coins",
      },
    ],
  },
];

function MultiTabOpener() {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState("");

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
                />
              </Grid>
            ))}
        </Grid>
      </Container>
    </>
  );
}

export default MultiTabOpener;
