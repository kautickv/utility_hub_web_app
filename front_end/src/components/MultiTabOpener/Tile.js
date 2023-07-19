import React, { useState } from "react";
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

  function handleConfigureOpen(){
    setConfigureOpen(true);
  }

  function handleConfigureClose(){
    setConfigureOpen(false);
  }

  function handleDeleteOpen(){
    setDeleteOpen(true);
  }

  function handleDeleteClose(){
    setDeleteOpen(false);
  }

  function handleConfigureSave(){
    console.log("Configuration saved");

    handleConfigureClose()
  }

  function handleDelete(){
    console.log("Tile has been deleted.")

    handleDeleteClose();
  }

  function handleOpenAll(){
    console.log(props.urls)
    props.urls.forEach(urlObj => {
        window.open(urlObj.url, '_blank');
      });
  }

  return (
    <StyledCard>
      <CardContent>
        <Typography gutterBottom variant="h5" component="div">
          {props.title}
        </Typography>
        <Typography variant="body2" color="text.secondary">
          {props.description}
        </Typography>
      </CardContent>
      <CardActions>
        <Button size="small" onClick={handleConfigureOpen}>Configure</Button>
        <Button size="small" onClick={handleDeleteOpen}>Delete</Button>
        <Button size="medium" onClick={handleOpenAll}>Open All</Button>
      </CardActions>

      <Dialog open={configureOpen} onClose={handleConfigureClose}>
        <DialogTitle>{"Links"}</DialogTitle>
        <DialogContent>
          <List>
            {props.urls.map((item, index) => (
              <ListItem key={index}>
                {item.urlTitle} -{" "}
                <Link href={item.url} target="_blank" rel="noopener">
                  {item.url}
                </Link>
              </ListItem>
            ))}
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
