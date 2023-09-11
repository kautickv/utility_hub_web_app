import React from "react";
import ReactDOM from "react-dom";
import ExtensionLogin from "./extensionComponent/ExtensionLogin";
function ExtensionApp() {
  return (
    <ExtensionLogin
      onLoggedIn={(status) => {
        // Handle post-login actions
        if (status) {
          console.log("User is logged in!");
          // You can trigger other actions or set states here
        }
      }}
    />
  );
}

// Render the app into the root div of extension.html
ReactDOM.render(<ExtensionApp />, document.getElementById("root"));
