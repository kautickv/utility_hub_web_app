import React, { useEffect, useState } from "react";
import TextField from "@mui/material/TextField";
import SearchIcon from "@mui/icons-material/Search";
import InputAdornment from "@mui/material/InputAdornment";
import Box from "@mui/material/Box";
import Grid from "@mui/material/Grid";
import Container from "@mui/material/Container";
import Fab from "@mui/material/Fab";
import AddIcon from "@mui/icons-material/Add";
import Dialog from "@mui/material/Dialog";
import DialogActions from "@mui/material/DialogActions";
import DialogContent from "@mui/material/DialogContent";
import DialogContentText from "@mui/material/DialogContentText";
import DialogTitle from "@mui/material/DialogTitle";
import Button from "@mui/material/Button";
import Divider from "@mui/material/Divider";
import { useNavigate } from "react-router-dom";
import { sendVerifyAPIToAuthenticationServer } from "../../utils/util";
import {
  sendGETToMultitabBackend,
  sendPostToMultitabBackend,
} from "../../utils/multitabUtil";

// Import components
import Navbar from "../common/Navbar";
import LoadingSpinner from "../common/LoadingSpinner"
import Tile from "./Tile.js";

function MultiTabOpener() {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState("");
  const [tilesData, setTilesData] = useState([]);
  const [dialogOpen, setDialogOpen] = useState(false);
  const [isLoading, setIsLoading] = useState(true)  // Set to loading initially
  const [newTile, setNewTile] = useState({
    title: "",
    description: "",
    urls: [{ urlTitle: "", url: "" }],
  });

  useEffect(() => {
    // Check if JWT token exists

    const verifyIfUserLoggedIn = async () => {
      try {
        let jwtToken = checkLocalStorageForJWTToken();
        if (jwtToken) {
          // Check if JWT token is valid and if user is logged in
          let verifyResponse = await sendVerifyAPIToAuthenticationServer(
            jwtToken
          );

          if (verifyResponse === 200) {
            // User is already logged in
            // Fetch config data from backend
            let response = await sendGETToMultitabBackend(jwtToken);
            setTilesData(JSON.parse(JSON.parse(response)));
            setIsLoading(false);
          } else if (verifyResponse === 401) {
            // User JWT token is not valid or expired
            localStorage.removeItem("JWT_Token");
            setIsLoading(false);
            navigate("/login");
          } else {
            console(
              `An error has occurred. Verify Path returns ${verifyResponse}`
            );
            alert("An error has occurred. Please try again later");
            setIsLoading(false);
          }
        } else {
          //Token not found.
          localStorage.removeItem("JWT_Token");
          setIsLoading(false);
          navigate("/login");
        }
      } catch (err) {
        console.log(`An error occurred: ${err}`);
        alert("An unexpected error occurred. Please try again later");
        setIsLoading(false);
      }
    };

    verifyIfUserLoggedIn();
  }, [navigate]);

  useEffect(() => {
    console.log(tilesData);
  }, [tilesData]);

  async function handleDeleteTile(index) {
    /**
     * PURPOSE: This function will a specific tile in the global configuration
     *          and make http request to save configuration in backend
     * INPUT: The index of the tile to delete.
     * OUTPUT: None
     */

    // Delete tile at position index
    let copy = JSON.parse(JSON.stringify(tilesData));
    copy.splice(index, 1);
    setTilesData(copy);

    // Save configuration
    postNewConfigToBackend(copy);

  }
  async function handleConfigureSave(index, newUrls) {
    /**
     * PURPOSE: This function will add/delete URLs in the respective tile
     *          and make http request to save configuration in backend
     * INPUT: The index of the tile to update.
     * OUTPUT: None
     */

    // Change the url array for the given tile
    let copy = JSON.parse(JSON.stringify(tilesData));
    copy[index]["urls"] = newUrls;
    setTilesData(copy);

    // Save configuration
    postNewConfigToBackend(copy);
  }
  async function postNewConfigToBackend(newTileData) {
    // This function will perform an API call to backend to save current config
    try {
      // Get the JWTToken
      let jwtToken = checkLocalStorageForJWTToken();
      if (jwtToken !== null && jwtToken !== "undefined") {
        let httpCode = await sendPostToMultitabBackend(jwtToken, newTileData);
        if (httpCode === 200) {
          //Pass
        } else if (httpCode === 401) {
          alert("Credentials Expired. Please login again");
          navigate("/login");
        } else if (httpCode === 500) {
          alert("AN error occurred while saving. Please try again later");
        } else {
          alert("An unknown error occurred. Please try again later.");
        }
      } else {
        // User JWT token is not valid or expired
        localStorage.removeItem("JWT_Token");
        navigate("/login");
      }
    } catch (err) {
      console.log(err);
      alert("An error ocurred saving urls. Please try again later");
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

  function handleOpenDialog() {
    setDialogOpen(true);
  }

  function handleCloseDialog() {
    setDialogOpen(false);
  }

  function handleTitleChange(event) {
    setNewTile((prevState) => ({ ...prevState, title: event.target.value }));
  }

  function handleDescriptionChange(event) {
    setNewTile((prevState) => ({
      ...prevState,
      description: event.target.value,
    }));
  }

  function handleUrlTitleChange(index, event) {
    const newUrls = newTile.urls.map((url, urlIndex) => {
      if (index !== urlIndex) return url;
      return { ...url, urlTitle: event.target.value };
    });
    setNewTile((prevState) => ({ ...prevState, urls: newUrls }));
  }

  function handleUrlChange(index, event) {
    const newUrls = newTile.urls.map((url, urlIndex) => {
      if (index !== urlIndex) return url;
      return { ...url, url: event.target.value };
    });
    setNewTile((prevState) => ({ ...prevState, urls: newUrls }));
  }

  function addNewUrl() {
    setNewTile((prevState) => ({
      ...prevState,
      urls: [...prevState.urls, { urlTitle: "", url: "" }],
    }));
  }

  async function handleAddTile() {

    if (!newTile.title.trim() || !newTile.description.trim()) {
      alert("Title and description cannot be empty.");
      return;
    }

    const validUrls = newTile.urls.filter(
      (url) => url.urlTitle.trim() && url.url.trim()
    );

    if (validUrls.length === 0) {
      alert("At least one URL with a title is required.");
      return;
    }

    let copy = JSON.parse(JSON.stringify(tilesData));
    const newTileCopy = { ...newTile, urls: validUrls };
    copy.push(newTileCopy);
    setTilesData(copy);
    setNewTile({
      title: "",
      description: "",
      urls: [{ urlTitle: "", url: "" }],
    });

    // All good. Let's close the dialog
    handleCloseDialog()

    // Save configuration
    // postNewConfigToBackend(copy)
  }

  return (
    <>
      {isLoading ? (<LoadingSpinner />) : (
        <>
          <Navbar />
          <Fab
            color="primary"
            aria-label="add"
            style={{ position: "fixed", bottom: 16, right: 16 }}
            onClick={handleOpenDialog}
          >
            <AddIcon />
          </Fab>
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
                      onDelete={() => handleDeleteTile(index)}
                    />
                  </Grid>
                ))}
            </Grid>
          </Container>
          <Dialog
            open={dialogOpen}
            onClose={handleCloseDialog}
            aria-labelledby="form-dialog-title"
          >
            <DialogTitle id="form-dialog-title">Add New Card</DialogTitle>
            <DialogContent>
              <DialogContentText>
                Please fill in the details below:
              </DialogContentText>
              <TextField
                autoFocus
                margin="dense"
                id="title"
                label="Title"
                type="text"
                fullWidth
                value={newTile.title}
                onChange={handleTitleChange}
              />
              <TextField
                margin="dense"
                id="description"
                label="Description"
                type="text"
                fullWidth
                value={newTile.description}
                onChange={handleDescriptionChange}
              />
              <Divider style={{ marginTop: "10px", marginBottom: "10px" }} />{"Input URL below:"}
              {newTile.urls.map((url, index) => (
                <Grid container spacing={2} key={index}>
                  <Grid item xs={12} sm={6}>
                    <TextField
                      margin="dense"
                      id={"urlTitle" + index}
                      label="URL Title"
                      type="text"
                      fullWidth
                      value={url.urlTitle}
                      onChange={(event) => handleUrlTitleChange(index, event)}
                    />
                  </Grid>
                  <Grid item xs={12} sm={6}>
                    <TextField
                      margin="dense"
                      id={"url" + index}
                      label="URL"
                      type="text"
                      fullWidth
                      value={url.url}
                      onChange={(event) => handleUrlChange(index, event)}
                    />
                  </Grid>
                </Grid>
              ))}
              <Button
                onClick={addNewUrl}
                color="primary"
                style={{ marginTop: "10px" }}
              >
                Add More URL
              </Button>
            </DialogContent>

            <DialogActions>
              <Button onClick={handleCloseDialog} color="primary">
                Cancel
              </Button>
              <Button onClick={handleAddTile} color="primary">
                Create
              </Button>
            </DialogActions>
          </Dialog>
        </>
      )}
    </>
  );
}

export default MultiTabOpener;
