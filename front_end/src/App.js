import React from "react";
import Home from "./pages/home";
import Login from "./pages/login"
import { HashRouter, Routes, Route} from 'react-router-dom';

function App() {

  return (


    <div className="App" style={{backgroundColor: "#f2f2f2"}}>
      <HashRouter>
        <Routes>
          <Route exact path='/' element={<Home/>}/>
          <Route exact path='/login' element={<Login/>}/>
          <Route path='/home' element={<Home/>}/>
        </Routes>
     </HashRouter>
    </div>
  );
}

export default App;
