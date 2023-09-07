import React from "react";
import ReactDOM from 'react-dom';
import Login from "./components/Login"
function ExtensionApp(){

    return <p>Hello World</p>
}

// Render the app into the root div of extension.html
ReactDOM.render(<ExtensionApp />, document.getElementById('root'));