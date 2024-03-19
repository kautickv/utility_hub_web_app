import React, { useState, useEffect } from 'react';
import { Typography, Box, Paper, TextField, IconButton, Tooltip, Select, MenuItem } from '@mui/material';
import { JSONTree } from 'react-json-tree';
import ContentCopyIcon from '@mui/icons-material/ContentCopy';
import SearchIcon from '@mui/icons-material/Search';
import DownloadIcon from '@mui/icons-material/Download';
import { useSnackbar } from 'notistack';

function JsonDetails({ json }) {
  const { enqueueSnackbar } = useSnackbar();
  const [filterText, setFilterText] = useState('');
  const [filteredJson, setFilteredJson] = useState(json)
  const [themeName, setThemeName] = useState('light');

  useEffect(() => {
    setFilteredJson(json); // Update filteredJson whenever json prop changes
  }, [json]);

  const filterJson = (json, filter) => {
    // Check for no filter case
    if (!filter) return json;

    const filterText = filter.toLowerCase();
    let isMatchFound = false; // Flag to detect if any match was found

    // Function to recursively search and reconstruct JSON based on match
    const search = (value) => {
      if (value && typeof value === 'object') {
        if (Array.isArray(value)) {
          // Process array elements
          const filteredArray = value.map(item => search(item)).filter(item => item !== null);
          if (filteredArray.length > 0) {
            isMatchFound = true;
            return filteredArray;
          }
        } else {
          // Process objects
          const filteredObject = Object.keys(value).reduce((acc, key) => {
            const result = search(value[key]);
            if (result !== null) {
              acc[key] = result;
              isMatchFound = true;
            }
            return acc;
          }, {});

          if (Object.keys(filteredObject).length > 0) {
            return filteredObject;
          }
        }
      } else {
        // Direct match with the filter text
        if (String(value).toLowerCase().includes(filterText)) {
          isMatchFound = true;
          return value;
        }
      }
      return null; // Return null to indicate no match was found at this path
    };

    const result = search(json);
    return isMatchFound ? result : 'No results found';
  };



  // Function to copy JSON to clipboard
  const copyToClipboard = () => {
    navigator.clipboard.writeText(JSON.stringify(json, null, 2));
    enqueueSnackbar('JSON copied to clipboard!', { variant: 'success' });
  };

  // JSON Tree customizations

  const theme = {
    extend: 'monokai', // Base it on Monokai but customize for a light background
    base00: 'rgba(0, 0, 0, 0)', // Very light grey background
    base01: '#e5e5e5', // Light grey (used for hover background)
    base02: '#d5d5d5', // Off grey (for borders, lines)
    base03: '#a0a0a0', // Dimmed text
    base04: '#666666', // Default text
    base05: '#444444', // Subtle text
    base06: '#2a2a2a', // Strong text
    base07: '#080808', // Almost black (for titles)
    base08: '#d33682', // Muted red
    base09: '#cb4b16', // Muted orange
    base0A: '#b58900', // Muted yellow
    base0B: '#859900', // Soft green
    base0C: '#2aa198', // Soft cyan
    base0D: '#268bd2', // Soft blue
    base0E: '#6c71c4', // Soft violet
    base0F: '#d33682', // Soft magenta
  };

  const customTheme = {
    extend: theme,
    valueLabel: {
      textDecoration: 'underline',
    },
    nestedNodeLabel: ({ style }, keyPath, nodeType, expanded) => ({
      style: {
        ...style,
        textTransform: expanded ? '1.2em' : "1em",
      },
    }),
  };

  const labelRenderer = ([key]) => <strong>{key}</strong>;
  const valueRenderer = (raw) => <em>{raw}</em>;

  const themes = {
    light: customTheme, // Your existing customTheme
    dark: { ...customTheme, base00: '#333', base05: '#fff' }, // Example dark theme
  };

  const downloadJson = () => {
    const blob = new Blob([JSON.stringify(json, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = 'json-data.json';
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  return (
    <Paper elevation={0} sx={{ p: 2, minHeight: '400px', overflow: 'auto' }}>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
        {/* Include theme switcher and download button */}
        <Select value={themeName} onChange={(e) => setThemeName(e.target.value)} size="small" sx={{ mr: 1 }}>
          {Object.keys(themes).map(themeKey => (
            <MenuItem key={themeKey} value={themeKey}>{themeKey.charAt(0).toUpperCase() + themeKey.slice(1)}</MenuItem>
          ))}
        </Select>
        <IconButton onClick={downloadJson} size="large" sx={{ mr: 1 }}>
          <DownloadIcon />
        </IconButton>
        <TextField
          size="small"
          label="Search JSON"
          variant="outlined"
          value={filterText}
          onChange={(e) => {
            setFilterText(e.target.value);
            const filtered = filterJson(json, e.target.value);
            setFilteredJson(filtered)
          }}
          sx={{ width: '75%' }}
          InputProps={{
            endAdornment: (
              <IconButton>
                <SearchIcon />
              </IconButton>
            ),
          }}
        />
        <Tooltip title="Copy JSON to clipboard">
          <IconButton onClick={copyToClipboard} size="large">
            <ContentCopyIcon />
          </IconButton>
        </Tooltip>
      </Box>
      {json ? (
        <JSONTree
          theme={themes[themeName]}
          data={filteredJson}
          invertTheme={false}
          shouldExpandNodeInitially={(keyPath, data, level) => level < 2} // Expand nodes only to the second level initially
          hideRoot={false}
          sortObjectKeys={true}
          collectionLimit={50}
          getItemString={(type, data, itemType, itemString) => <span>{type}: {itemString}</span>}
          labelRenderer={labelRenderer}
          valueRenderer={valueRenderer}
        />
      ) : (
        <Typography variant="h6">Select a JSON entry to view details</Typography>
      )}
    </Paper>
  );
}

export default JsonDetails;
