import React, { useState, useEffect } from "react";
import Card from "@mui/material/Card";
import CardContent from "@mui/material/CardContent";
import Button from "@mui/material/Button";
import Typography from "@mui/material/Typography";
import CardActions from "@mui/material/CardActions";
import Dialog from "@mui/material/Dialog";
import DialogTitle from "@mui/material/DialogTitle";
import DialogContent from "@mui/material/DialogContent";
import DialogContentText from "@mui/material/DialogContentText";
import DialogActions from "@mui/material/DialogActions";
import List from "@mui/material/List";
import ListItem from "@mui/material/ListItem";
import Link from "@mui/material/Link";
import TextField from "@mui/material/TextField";
import AddBoxIcon from "@mui/icons-material/AddBox";
import DeleteIcon from "@mui/icons-material/Delete";
import IconButton from "@mui/material/IconButton";
import Grid from "@mui/material/Grid";
import Divider from "@mui/material/Divider";
import Badge from "@mui/material/Badge";
import Tooltip from "@mui/material/Tooltip";
import Box from "@mui/material/Box";
import Paper from "@mui/material/Paper";
import { styled } from "@mui/system";

const StyledCard = styled(Card)({
  maxWidth: 345,
  "& .MuiCardContent-root": {
    "& .MuiTypography-root": {
      // ⚠️ object-fit is not supported by IE11.
      objectFit: "cover",
    },
  },
});



function Tile(props) {
  const [configureOpen, setConfigureOpen] = useState(false);
  const [deleteOpen, setDeleteOpen] = useState(false);

  const [urls, setUrls] = useState(props.urls);
  const [newUrl, setNewUrl] = useState({ urlTitle: "", url: "" });

  useEffect(() => {
    console.log("Use effect fired");
    //console.log(urls)
  }, [urls]);

  function handleConfigureOpen() {
    setConfigureOpen(true);
  }

  function handleConfigureClose() {
    setConfigureOpen(false);
  }

  function handleDeleteOpen() {
    setDeleteOpen(true);
  }

  function handleDeleteClose() {
    setDeleteOpen(false);
  }

  function handleDelete() {
    props.onDelete();

    handleConfigureClose();
  }

  function handleOpenAll() {
    urls.forEach((urlObj) => {
      window.open(urlObj.url, "_blank");
    });
  }
  function handleUrlChange(e) {
    setNewUrl({ ...newUrl, [e.target.name]: e.target.value });
  }

  function handleAddUrl() {
    // Only add new URL if newURL is not empty is not empty
    if (newUrl.urlTitle.trim() !== "" && newUrl.url.trim() !== "") {
      setUrls([...urls, newUrl]);
      setNewUrl({ urlTitle: "", url: "" });
    }
  }

  function handleDeleteUrl(index) {
    // This function gets triggered when a URL gets deleted.
    const newUrls = [...urls];
    newUrls.splice(index, 1);
    setUrls(newUrls);
  }

  function handleConfigureSave() {
    props.onSave(urls);

    handleConfigureClose();
  }

  return (
    <StyledCard>
      <CardContent>
        <Typography gutterBottom variant="h5" component="div">
          <Box
            component="span"
            style={{ display: "flex", alignItems: "center" }}
          >
            {props.title}
            <Tooltip title={`${urls.length} link(s) in this card`} arrow>
              <Badge
                badgeContent={urls.length}
                color="primary"
                overlap="circular"
                max={999}
                style={{ marginLeft: "15px" }}
              >
                <Box
                  component="span"
                  style={{
                    width: "20px",
                    height: "20px",
                    borderRadius: "50%",
                    backgroundColor: "#f50057",
                    color: "white",
                    display: "flex",
                    justifyContent: "center",
                    alignItems: "center",
                    fontSize: "0.8em",
                  }}
                />
              </Badge>
            </Tooltip>
          </Box>
        </Typography>
        <Typography variant="body2" color="text.secondary">
          {props.description}
        </Typography>
      </CardContent>
      <CardActions>
        <Button size="small" onClick={handleConfigureOpen}>
          Configure
        </Button>
        <Button size="small" onClick={handleDeleteOpen}>
          Delete
        </Button>
        <Button size="medium" onClick={handleOpenAll}>
          Open All
        </Button>
      </CardActions>

      <Dialog
        open={configureOpen}
        onClose={handleConfigureClose}
        fullWidth
        maxWidth="md"
      >
        <DialogTitle>{props.title}</DialogTitle>
        <DialogContent>
          <List>
            {urls.map((item, index) => (
              <ListItem key={index}>
                <Grid container spacing={2}>
                  <Grid item xs={12} md={5}>
                    <Paper elevation={1} style={{ padding: "10px" }}>
                      <Typography variant="subtitle1">
                        {item.urlTitle}
                      </Typography>
                    </Paper>
                  </Grid>
                  <Grid item xs={12} md={5}>
                    <Paper elevation={1} style={{ padding: "10px" }}>
                      <Link href={item.url} target="_blank" rel="noopener">
                        {item.url}
                      </Link>
                    </Paper>
                  </Grid>
                  <Grid item xs={12} md={2}>
                    <IconButton
                      edge="end"
                      aria-label="delete"
                      onClick={() => handleDeleteUrl(index)}
                    >
                      <DeleteIcon />
                    </IconButton>
                  </Grid>
                </Grid>
                <Divider style={{ margin: "10px 0" }} />
              </ListItem>
            ))}
            <ListItem>
              <Grid container spacing={2}>
                <Grid item xs={12} md={5}>
                  <TextField
                    label="Title"
                    variant="outlined"
                    name="urlTitle"
                    value={newUrl.urlTitle}
                    onChange={handleUrlChange}
                    fullWidth
                  />
                </Grid>
                <Grid item xs={12} md={5}>
                  <TextField
                    label="URL"
                    variant="outlined"
                    name="url"
                    value={newUrl.url}
                    onChange={handleUrlChange}
                    fullWidth
                  />
                </Grid>
                <Grid item xs={12} md={2}>
                  <IconButton
                    edge="end"
                    aria-label="add"
                    onClick={handleAddUrl}
                  >
                    <AddBoxIcon />
                  </IconButton>
                </Grid>
              </Grid>
            </ListItem>
          </List>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleConfigureClose}>Cancel</Button>
          <Button onClick={handleConfigureSave}>Save</Button>
        </DialogActions>
      </Dialog>

      <Dialog open={deleteOpen} onClose={handleDeleteClose}>
        <DialogTitle>{'Delete "' + props.title + '"'}</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Are you sure you want to delete this tile?
          </DialogContentText>
        </DialogContent>
        <DialogActions>
          <Button onClick={handleDeleteClose}>Cancel</Button>
          <Button onClick={handleDelete}>Delete</Button>
        </DialogActions>
      </Dialog>
    </StyledCard>
  );
}

export default Tile;
