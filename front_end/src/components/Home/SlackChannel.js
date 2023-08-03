import React, { useState } from "react";
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, Legend } from 'recharts';
import Typography from "@mui/material/Typography";
import Button from "@mui/material/Button";
import Box from "@mui/material/Box";

function SlackChannel({ channel, messages }) {
  const [isOpen, setIsOpen] = useState(false);

  const handleClick = () => {
    setIsOpen(!isOpen);
  };

  const data = messages.map((_, index) => ({
    name: `Message ${index + 1}`,
    messages: 1
  }));

  return (
    <Box sx={{ mt: 2 }}>
      <Typography variant="h6">{channel}</Typography>
      <Typography variant="body1">
        Number of messages: {messages.length}
      </Typography>
      <Button onClick={handleClick} variant="contained">
        {isOpen ? "Hide" : "Show"} Chart
      </Button>
      {isOpen && (
        <BarChart width={500} height={300} data={data}>
          <CartesianGrid strokeDasharray="3 3" />
          <XAxis dataKey="name" />
          <YAxis />
          <Tooltip />
          <Legend />
          <Bar dataKey="messages" fill="#8884d8" />
        </BarChart>
      )}
    </Box>
  );
}

export default SlackChannel;
