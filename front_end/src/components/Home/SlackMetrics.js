import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";
import LinearProgress from "@mui/material/LinearProgress";
import SlackChannel from './SlackChannel';
// Import scripts
import {
  getSlackData,
  checkLocalStorageForJWTToken
} from "../../utils/homeUtils";

function SlackMetrics() {
  const navigate = useNavigate();
  const [slackData, setSlackData] = useState(null);
  const [isError, setIsError] = useState(false);

  useEffect(() => {
    // Fetch slack data
    async function fetchSlackData() {
      try {
        let jwtToken = checkLocalStorageForJWTToken();
        if (jwtToken !== "") {
          let response = await getSlackData(jwtToken);
          response = JSON.parse(response)
          for (let key in response) {
            for (let msg in response[key]) {
                console.log(response[key][msg]['text'])
            }
          }
          setSlackData(response);
        } else {
          // User credentials not valid
          navigate("/login");
        }
      } catch (err) {
        setIsError(true);
        console.log(`Error fetching slack data: ${err}`);
        alert(
          "An error occurred while getting slack data. Please try again later."
        );
      }
    }

    // Trigger fetch data
    fetchSlackData();
  }, [navigate]);

  if (!slackData) {
    return <LinearProgress />;
  }

  if (isError) {
    return "Error";
  }

  return (
    <Box sx={{ p: 2 }}>
      <Typography variant="h6" gutterBottom>
        Slack Metrics
      </Typography>
      
      {Object.entries(slackData).map(([channel, messages]) => (
        <SlackChannel key={channel} channel={channel} messages={messages} />
      ))}
      
    </Box>
  );
}

export default SlackMetrics;
