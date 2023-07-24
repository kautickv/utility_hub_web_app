import React, { useEffect, useState } from "react";
import TextField from "@mui/material/TextField";
import SearchIcon from "@mui/icons-material/Search";
import InputAdornment from "@mui/material/InputAdornment";
import Box from "@mui/material/Box";
import Grid from "@mui/material/Grid";
import Container from "@mui/material/Container";
import { useNavigate } from "react-router-dom";
import { sendVerifyAPIToAuthenticationServer } from "../../utils/util";
import {sendGETToMultitabBackend} from "../../utils/multitabUtil";

// Import components
import Navbar from "../common/Navbar";
import Tile from "./Tile.js";

const tilesData = [
  {
    title: "Delco Operations",
    description: "Grafana Dashboard to monitor during Delco Ops",
    urls: [
      {
        urlTitle: "SOC :: Delco :: Business Metrics",
        url: "https://grafana.je-labs.com/d/NA80nq-Zk/soc-delco-business-metrics?orgId=1&refresh=1m",
      },
      {
        urlTitle: "SOC :: Delco :: Message Queues",
        url: "https://grafana.je-labs.com/d/ODEHK4EZz/soc-delco-message-queues?orgId=1&refresh=30s",
      },
      {
        urlTitle: "SOC :: Delco :: Payments",
        url: "https://grafana.je-labs.com/d/DtA1pkOGk/ca-payments-and-fraud-business-metrics?orgId=1&from=now-1h&to=now&refresh=30s",
      },
      {
        urlTitle: "SOC :: Delco :: RabbitMQ Metrics",
        url: "https://grafana.je-labs.com/d/b-fXG-PZz/rabbitmq-metrics?orgId=1&refresh=1m&from=now-1h&to=now",
      },
    ],
  },
  {
    title: "Marketplace Operations",
    description: "Grafana dashboard to monitor during marketplace ops",
    urls: [
      {
        urlTitle: "Escalations-UK",
        url: "https://grafana.je-labs.com/d/000000651/escalations-uk?orgId=1&refresh=30s",
      },
      {
        urlTitle: "Escalations-INT",
        url: "https://grafana.je-labs.com/d/000001527/escalations-int?orgId=1&refresh=1m",
      },
      {
        urlTitle: "SOC - Deployments, Errors & Alerts",
        url: "https://grafana.je-labs.com/d/000001550/soc-deployments-errors-and-alerts?refresh=1m&orgId=1&var-Filters=JobFeature%7C%3D%7Cpublicweb&var-Filters=JobFeatureVersion%7C!%3D%7C1.0.0.554&from=now-1h&to=now&set_by_plugin=true",
      },
      {
        urlTitle: "SOC :: UK Highlevel",
        url: "https://grafana.je-labs.com/d/ZwvDCFgWz/soc-uk-highlevel?refresh=1m&orgId=1",
      },
      {
        urlTitle: "SOC-Order Rate Dashboard",
        url: "https://grafana.je-labs.com/d/000001951/soc-order-rate-dashboard?orgId=1&refresh=1m",
      },
      {
        urlTitle: "Authentication-Combined",
        url: "https://grafana.je-labs.com/d/LLf1LNi4z/authentication-combined?orgId=1&refresh=10s",
      },
    ]
  },
  {
    title: "UK, INT, ANZ - Toggle CDN Provider- Web / Apps (INT/ANZ Only) CDN Failover test Instructions",
    description: "Links to open when performing test to toggle CDN Provider",
    urls: [
        {
            urlTitle: "Confluence Test instruction",
            url: "https://justeattakeaway.atlassian.net/wiki/spaces/SOC/pages/52742683/UK+INT+ANZ+-+Toggle+CDN+Provider-+Web+Apps+INT+ANZ+Only+CDN+Failover+test+Instructions",
        },
        {
            urlTitle: "AWS Account",
            url: "https://aws.just-eat.com/",
        },
        {
            urlTitle: "Global Watch Tower",
            url: "https://watchtower.eu-west-1.production.jet-internal.com/#/templates?template.name__icontains=toggle",
        },
        {
            urlTitle: "CDN check - Blackbox Exporter",
            url: "https://grafana.je-labs.com/d/pS6ZuGV7z34/cdn-check-blackbox-exporter?orgId=1&refresh=30s",
        },
        {
            urlTitle: "Operational Tech Tests Dashboard",
            url: "https://grafana.je-labs.com/d/JS4KpK3Zz/soc-operational-tech-tests?orgId=1&refresh=10s",
        },
    ]
  },
];

function MultiTabOpener() {
  const navigate = useNavigate();
  const [searchTerm, setSearchTerm] = useState("");

  useEffect(() => {
    // Check if JWT token exists

    const verifyIfUserLoggedIn = async () => {
      let jwtToken = checkLocalStorageForJWTToken();
      if (jwtToken) {
        // Check if JWT token is valid and if user is logged in
        let verifyResponse = await sendVerifyAPIToAuthenticationServer(
          jwtToken
        );

        if (verifyResponse === 200) {
          // User is already logged in
          // Fetch config data from backend
          let response = await sendGETToMultitabBackend(jwtToken)
          console.log(response);
        } else if (verifyResponse === 401) {
          // User JWT token is not valid or expired
          localStorage.removeItem("JWT_Token");
          navigate("/login");
        } else {
          console(
            `An error has occurred. Verify Path returns ${verifyResponse}`
          );
          alert("An error has occurred. Please try again later");
        }
      } else {
        //Token not found.
        localStorage.removeItem("JWT_Token");
        navigate("/login");
      }
    };

    verifyIfUserLoggedIn();
  });

  function checkLocalStorageForJWTToken() {
    /**
     * This function checks if a JWT token exists in local storage.
     * If yes, it returns the token.
     * If it does not exist, returns an empty string
     */
    const token = localStorage.getItem("JWT_Token");
    if (token) {
      return token;
    } else {
      // No token found, return empty string
      return "";
    }
  }

  return (
    <>
      <Navbar />
      <Box
        display="flex"
        justifyContent="center"
        alignItems="center"
        style={{ marginBottom: "20px", marginTop: "20px" }}
      >
        <TextField
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          variant="outlined"
          size="large" // You can adjust this to 'medium' if 'large' is too big.
          InputProps={{
            startAdornment: (
              <InputAdornment position="start">
                <SearchIcon />
              </InputAdornment>
            ),
          }}
          style={{ width: "50%" }} // Adjust the width of the search bar.
        />
      </Box>
      <Container style={{ marginTop: "10px", marginBottom: "10px" }}>
        <Grid container spacing={1}>
          {tilesData
            .filter((tile) =>
              tile.title.toLowerCase().includes(searchTerm.toLowerCase())
            )
            .map((tile, index) => (
              <Grid item xs={12} sm={6} md={4} lg={3} key={index}>
                <Tile
                  title={tile.title}
                  description={tile.description}
                  urls={tile.urls}
                />
              </Grid>
            ))}
        </Grid>
      </Container>
    </>
  );
}

export default MultiTabOpener;
