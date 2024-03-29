import { BeatLoader } from "react-spinners";
import Box from "@mui/material/Box";
import Typography from "@mui/material/Typography";

function LoadingSpinner(props) {
  return (
    <Box
      display="flex"
      flexDirection="column"
      justifyContent="center"
      alignItems="center"
      style={{ height: "100vh" }} // adjust as needed
    >
      <Typography variant="h6" gutterBottom>
        {props.description}
      </Typography>
      <BeatLoader color={"#123abc"} loading={true} size={20} margin={2} />
    </Box>
  );
}

export default LoadingSpinner;
