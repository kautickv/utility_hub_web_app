import React from "react";
import Home from "./components/Home";
import Login from "./components/Login"
import MultiTabOpener from "./components/MultiTabOpener"
import { AuthProvider } from './context/AuthContext';
import Trading from "./components/Trading"
import CssBaseline from '@mui/material/CssBaseline';
import { BrowserRouter, Routes, Route } from 'react-router-dom';
import { ThemeProvider, createTheme } from '@mui/material/styles';

// Create the theme
const theme = createTheme({
  breakpoints: {
    values: {
      xs: 0,
      sm: 600,
      md: 900,
      lg: 1200,
      xl: 1536,
    },
  },
  palette: {
    primary: {
      main: '#ef6c00',
    },
    secondary: {
      main: '#ffe0b2',
    },
    third:{
      main: '#fdfbe2'
    }
  },
});

function App() {

  return (

    <>
      <CssBaseline />
      <ThemeProvider theme={theme}>
        <AuthProvider>
          <BrowserRouter>
            <Routes>
              <Route exact path='/login' element={<Login />} />
              <Route path='/home' element={<Home />} />
              <Route path='/link-manager' element={<MultiTabOpener />} />
              <Route path='/trading' element={<Trading />} />
              <Route exact path='/' element={<Home />} />
            </Routes>
          </BrowserRouter>
        </AuthProvider>
      </ThemeProvider>
    </>
  );
}

export default App;
