import React from 'react';
import { Typography, Box } from '@mui/material';

const calculateJsonDepth = (obj) => {
  if (typeof obj !== 'object' || obj === null) return 0;
  let depth = 0;
  for (let key in obj) {
    if (typeof obj[key] === 'object') {
      depth = Math.max(depth, calculateJsonDepth(obj[key]));
    }
  }
  return 1 + depth;
};

const calculateJsonSize = (obj) => new Blob([JSON.stringify(obj)]).size;

function JsonInfo({ json }) {
  if (!json) return <Box><Typography variant="subtitle1">Select a JSON entry to see details</Typography></Box>;

  const entries = Object.keys(json).length;
  const depth = calculateJsonDepth(json);
  const size = calculateJsonSize(json);

  return (
    <Box>
      <Typography variant="h6">JSON Details</Typography>
      <Typography variant="body1">Entries: {entries}</Typography>
      <Typography variant="body1">Depth: {depth}</Typography>
      <Typography variant="body1">Size: {size} bytes</Typography>
    </Box>
  );
}

export default JsonInfo;
