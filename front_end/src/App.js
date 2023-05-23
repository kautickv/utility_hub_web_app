import React from "react";
import Home from "./pages/home";
import Login from "./pages/login"
import { BrowserRouter, Routes, Route } from 'react-router-dom';

function App() {

  return (

    
    <div className="App" style={{backgroundColor: "#f2f2f2"}}>
      <BrowserRouter>
        <Routes>
          <Route exact path='/' element={<Login/>}/>
          <Route exact path='/login' element={<Login/>}/>
          <Route path='/home' element={<Home/>}/>
        </Routes>
     </BrowserRouter>
    </div>
  );
}

export default App;
