import React from "react";
import AppBar from "@mui/material/AppBar";
import Toolbar from "@mui/material/Toolbar";
import Typography from "@mui/material/Typography";
import IconButton from "@mui/material/IconButton";
import SettingsIcon from "@mui/icons-material/Settings";
import MenuItem from "@mui/material/MenuItem";
import Menu from "@mui/material/Menu";
import { Box } from "@mui/system";
import { useTheme } from "@mui/material/styles";
import { useNavigate } from "react-router-dom";
import LogoutIcon from "@mui/icons-material/Logout";
import AccountCircle from "@mui/icons-material/AccountCircle";
import { logout } from '../../../utils/util';

const Navbar = () => {
  const navigate = useNavigate();
  const [anchorEl, setAnchorEl] = React.useState(null);
  const open = Boolean(anchorEl);
  // Import theme
  const theme = useTheme();

  const handleMenu = (event) => {
    setAnchorEl(event.currentTarget);
  };

  const handleClose = () => {
    setAnchorEl(null);
  };

  const handleNavigation = (path) => {
    navigate(path);
  };

  const handleLogout = async () =>{
    // When logout is clicked, navigate to settings page

    // Read JWTToken
    let jwtToken = localStorage.getItem("JWT_Token");

    if ((jwtToken === '') || (jwtToken === undefined)){
        navigate('/login')
    }else{
        let response = await logout(jwtToken);
        console.log(response);
        if(response !== 200){
            localStorage.setItem("JWT_Token", '');
            alert("An internal server error occurred. Please try again later.");
        }
        navigate('/login');
    }
  }

  return (
    <AppBar
      position="static"
      style={{ backgroundColor: theme.palette.primary.main }}
    >
      <Toolbar>
        <Typography
          variant="h6"
          component="div"
          sx={{ flexGrow: 1 }}
          style={{ color: theme.palette.primary.contrastText }}
        >
          Password Generator
        </Typography>
        <Box
          sx={{ flexGrow: 1, display: "flex", justifyContent: "center" }}
          style={{ color: theme.palette.primary.contrastText }}
        >
          <Typography
            variant="body1"
            component="div"
            style={{ cursor: "pointer", margin: "0 20px" }}
            onClick={() => handleNavigation("/home")}
          >
            Home
          </Typography>
          <Typography
            variant="body1"
            component="div"
            style={{ cursor: "pointer", margin: "0 20px" }}
            onClick={() => handleNavigation("/multitab-opener")}
          >
            MultiTab Opener
          </Typography>
          <Typography
            variant="body1"
            component="div"
            style={{ cursor: "pointer", margin: "0 20px" }}
            onClick={() => handleNavigation("/option3")}
          >
            Option 3
          </Typography>
          <Typography
            variant="body1"
            component="div"
            style={{ cursor: "pointer", margin: "0 20px" }}
            onClick={() => handleNavigation("/option4")}
          >
            Option 4
          </Typography>
        </Box>

        <IconButton
          edge="end"
          color="inherit"
          aria-label="settings"
          aria-controls="menu-appbar"
          aria-haspopup="true"
          onClick={handleMenu}
        >
          <SettingsIcon />
        </IconButton>
        <Menu
          id="menu-appbar"
          anchorEl={anchorEl}
          anchorOrigin={{
            vertical: "top",
            horizontal: "right",
          }}
          keepMounted
          transformOrigin={{
            vertical: "top",
            horizontal: "right",
          }}
          open={open}
          onClose={handleClose}
        >
          <MenuItem onClick={() => handleNavigation("/profile-setting")}>
            <AccountCircle style={{ marginRight: "8px" }} />
            Profile Setting
          </MenuItem>
          <MenuItem onClick={handleLogout}>
            <LogoutIcon style={{ marginRight: "8px" }} />
            Logout
          </MenuItem>
        </Menu>
      </Toolbar>
    </AppBar>
  );
};

export default Navbar;
