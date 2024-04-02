import React, { useEffect, useState, useContext } from "react";
import { useNavigate } from "react-router-dom";
// MUI elements
import { Container, Grid, Card, CardContent, Typography, Paper, Tooltip, IconButton, Box } from '@mui/material';
import InfoIcon from '@mui/icons-material/Info';
// Import scripts
import { checkLocalStorageForJWTToken } from "../../utils/util";
import { sendVerifyAPIToAuthenticationServer } from "../../utils/util";

// Import components
import LoadingSpinner from "../common/LoadingSpinner";
import Navbar from "../common/Navbar";
import { AuthContext } from "../../context/AuthContext";
import ProjectList from './ProjectList';
import JsonDetails from './JsonDetails';
import JsonInfo from './JsonInfo';


function Formatter() {
    const navigate = useNavigate();
    const [userFirstName, setUserFirstName] = useState("");
    const [selectedJson, setSelectedJson] = useState(null);
    const [isLoading, setIsLoading] = useState(true);
    const { isAuthenticated, user, logoutUser, loginUser } =
        useContext(AuthContext);

    useEffect(() => {
        // Check if JWT token exists
        const verifyIfUserLoggedIn = async () => {
            try {
                let jwtToken = checkLocalStorageForJWTToken();
                if (jwtToken) {
                    // Check context if user is logged in
                    if (isAuthenticated) {
                        // User is already logged in
                        let userName = user["token_details"]["username"];
                        setUserFirstName(userName.split(" ")[0]); // Get the first Name
                        console.log(userFirstName)
                        setIsLoading(false);
                    } else {
                        // User is not authenticated in context. Needs to send verify User auth
                        // Check if JWT token is valid and if user is logged in
                        let verifyResponse = await sendVerifyAPIToAuthenticationServer(
                            jwtToken
                        );

                        if (verifyResponse.status === 200) {
                            // User is already logged in
                            let userInfo = await verifyResponse.json();
                            let userName = userInfo["token_details"]["username"];
                            setUserFirstName(userName.split(" ")[0]); // Get the first Name
                            // Set user context
                            loginUser(userInfo);
                        } else if (verifyResponse.status === 401) {
                            // User JWT token is not valid or expired
                            // Logout user from context
                            logoutUser();
                            navigate("/login");
                        } else {
                            console(
                                `An error has occurred. Verify Path returns ${verifyResponse}`
                            );
                            alert("An error has occurred. Please try again later");
                        }
                        setIsLoading(false);
                        navigate("/login");
                    }
                } else {
                    //Token not found.
                    logoutUser();
                    navigate("/login");
                    return;
                }
            } catch (err) {
                console.log(`An error occurred: ${err}`);
                alert("An unexpected error occurred. Please try again later");
                setIsLoading(false);
            }
        };

        setIsLoading(true);
        verifyIfUserLoggedIn();
    }, [navigate, isAuthenticated, logoutUser, user, loginUser, userFirstName]);

    if (isLoading) {
        return <LoadingSpinner description="Please wait ..." />;
    }

    return (
        <>
            <Navbar />
            <Container maxWidth="xl" component={Paper} elevation={0} sx={{ p: 3, mt: 2, borderRadius: 2 }}>
                <Typography variant="h4" gutterBottom>Formatter Dashboard</Typography>
                <Grid container spacing={3}>
                    <Grid item xs={12} md={3}>
                        <Card elevation={4}>
                            <CardContent>
                                <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'left', mb: 2 }}>
                                    <Typography variant="h6" sx={{ mr: -1 }}>
                                        Projects
                                    </Typography>
                                    <Tooltip title="Add and manage your projects. Click on a project to see its JSON entries.">
                                        <IconButton>
                                            <InfoIcon fontSize="small" />
                                        </IconButton>
                                    </Tooltip>
                                </Box>
                                <ProjectList setSelectedJson={setSelectedJson} />
                            </CardContent>
                        </Card>
                    </Grid>
                    <Grid item xs={12} md={6}>
                        <Card elevation={4}>
                            <CardContent>
                                <Typography variant="h6" gutterBottom>JSON Details</Typography>
                                <JsonDetails json={selectedJson} />
                            </CardContent>
                        </Card>
                    </Grid>
                    <Grid item xs={12} md={3}>
                        <Card elevation={4}>
                            <CardContent>
                                <Typography variant="h6" gutterBottom>JSON Info</Typography>
                                <JsonInfo json={selectedJson} />
                            </CardContent>
                        </Card>
                    </Grid>
                </Grid>
            </Container>
        </>
    );
}

export default Formatter;
