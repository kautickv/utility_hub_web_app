import React from "react";
import Alert from "@mui/lab/Alert";
import Snackbar from "@mui/material/Snackbar";
import IconButton from "@mui/material/IconButton";
import CloseIcon from "@mui/icons-material/Close";

function AlertComponent({ open, handleClose, severity, message }) {
  return (
    <Snackbar
      open={open}
      autoHideDuration={6000}
      onClose={handleClose}
      anchorOrigin={{ vertical: "bottom", horizontal: "right" }}
      style={{ marginTop: "10px" }} // Small margin from the top for aesthetics
    >
      <Alert
        action={
          <IconButton
            aria-label="close"
            color="inherit"
            size="small"
            onClick={handleClose}
          >
            <CloseIcon fontSize="inherit" />
          </IconButton>
        }
        onClose={handleClose}
        severity={severity}
        variant="filled"
        elevation={6}
        style={{ fontSize: "1.1em" }} // Increase the font size for more prominence
      >
        {message}
      </Alert>
    </Snackbar>
  );
}

export default AlertComponent;