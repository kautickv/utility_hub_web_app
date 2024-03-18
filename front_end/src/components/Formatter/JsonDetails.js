import React, { useState } from 'react';
import { Typography, Box, Paper, TextField, IconButton, Tooltip, Switch } from '@mui/material';
import ReactJson from 'react-json-view';
import ContentCopyIcon from '@mui/icons-material/ContentCopy';
import { useSnackbar } from 'notistack';

function JsonDetails({ json }) {
  const { enqueueSnackbar } = useSnackbar();
  const [searchText, setSearchText] = useState('');
  const [displayDataTypes, setDisplayDataTypes] = useState(true);

  // Function to filter JSON based on search text
  const filterJson = (json, searchText) => {
    const lowerSearchText = searchText.toLowerCase();
    if (!searchText) return json;

    return Object.keys(json).reduce((acc, key) => {
      const value = json[key];
      const matches = key.toLowerCase().includes(lowerSearchText) ||
                      JSON.stringify(value).toLowerCase().includes(lowerSearchText);

      if (matches) {
        acc[key] = value;
      }

      return acc;
    }, {});
  };

  const filteredJson = filterJson(json, searchText);

  // Function to copy JSON to clipboard
  const copyToClipboard = () => {
    navigator.clipboard.writeText(JSON.stringify(json, null, 2));
    enqueueSnackbar('JSON copied to clipboard!', { variant: 'success' });
  };

  return (
    <Paper elevation={3} sx={{ p: 2, minHeight: '400px', overflow: 'auto', backgroundColor: 'rgba(255, 255, 255, 0.7)' }}>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
        <TextField
          size="small"
          label="Search JSON"
          variant="outlined"
          value={searchText}
          onChange={(e) => setSearchText(e.target.value)}
          sx={{ width: '75%' }}
          />
          <Tooltip title="Toggle data types display">
            <Switch
              checked={displayDataTypes}
              onChange={() => setDisplayDataTypes(!displayDataTypes)}
              size="small"
            />
          </Tooltip>
          <Tooltip title="Copy JSON to clipboard">
            <IconButton onClick={copyToClipboard}>
              <ContentCopyIcon />
            </IconButton>
          </Tooltip>
        </Box>
        {json ? (
          <ReactJson
            src={filteredJson}
            name={null}
            theme="rjv-default"
            enableClipboard={true}
            collapsed={2}
            displayDataTypes={displayDataTypes}
            style={{ fontSize: '14px', backgroundColor: 'transparent' }}
          />
        ) : (
          <Typography variant="h6">Select a JSON entry to view details</Typography>
        )}
      </Paper>
      );
    }
    
    export default JsonDetails;