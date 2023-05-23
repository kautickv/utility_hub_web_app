import React, { useState, useEffect } from "react";
import "bootstrap/dist/css/bootstrap.min.css";
import "./App.css";
function App() {

  const [client_id, setClient_id] = useState("");
  const [redirect_uri, setRedirect_uri] = useState("");

  useEffect(()=>{
    fetch(process.env.REACT_APP_API_GATEWAY_BASE_URL + "/auth/creds")
      .then(response => response.json())
      .then(data => {

        // Decode Client_id
        // Decode Base64 to ASCII for clientID
        let ascii = atob(data.client_id_base64);
        // Decode ASCII to UTF-8
        let utf8 = decodeURIComponent(escape(ascii));
        setClient_id(utf8);

        //Decode redirect_uri
        ascii = atob(data.redirect_uri_base64);
        utf8 = decodeURIComponent(escape(ascii));
        setRedirect_uri(utf8);
      })
      .catch(error => console.error('Error:', error));
  },[])

  function googleLogin(){
    console.log(process.env.REACT_APP_API_GATEWAY_BASE_URL)
    const googleAuthUrl = `https://accounts.google.com/o/oauth2/v2/auth?scope=profile email&access_type=offline&include_granted_scopes=true&state=state_parameter_passthrough_value&redirect_uri=${redirect_uri}&response_type=code&client_id=${client_id}`;
    window.location = googleAuthUrl;
  }

  return (
    <div className="App" style={{backgroundColor: "#f2f2f2"}}>
      <header className="App-header orange-header text-white text-center p-5">
        <h1>SOC Team</h1>
        <p>Welcome to our landing page!</p>
      </header>
      <div
        className="d-flex justify-content-center align-items-center"
        style={{ height: "100vh" }}
      >
        <button onClick={googleLogin} className="btn btn-custom btn-xl">Login</button>
      </div>
    </div>
  );
}

export default App;
