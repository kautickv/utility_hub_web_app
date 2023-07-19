import React from "react";
import Home from "./components/Home";
import Login from "./components/Login"
import { BrowserRouter, Routes, Route} from 'react-router-dom';
import { ThemeProvider, createTheme } from '@mui/material/styles';

// Create the theme
const theme = createTheme({
  palette: {
    primary: {
      main: '#ef6c00',
    },
    secondary: {
      main: '#ffe0b2',
    },
  },
});

function App() {

  return (


    <ThemeProvider theme={theme}>
      <BrowserRouter>
        <Routes>
          <Route exact path='/' element={<Home/>}/>
          <Route exact path='/login' element={<Login/>}/>
          <Route path='/home' element={<Home/>}/>
        </Routes>
     </BrowserRouter>
    </ThemeProvider>
  );
}

export default App;
