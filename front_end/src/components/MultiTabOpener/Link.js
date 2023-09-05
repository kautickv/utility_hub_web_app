import React from 'react';
import {
  TableCell,
  TableRow,
  Tooltip,
  IconButton,
  Link as MUILink,
  Paper,
  Typography
} from '@mui/material';
import OpenInNewIcon from '@mui/icons-material/OpenInNew';
import StarIcon from '@mui/icons-material/Star';


function Link({ title, url, cardTitle, defaultUrl}) {

  return (
    <TableRow hover>
      <TableCell>
        <Typography variant="body1" color="textPrimary">
          {title}
          {defaultUrl === 'Yes' && (
              <Tooltip title="From Default Card">
                <StarIcon style={{ marginLeft: "3px", color: "gold" , fontSize:"10px"}} />
              </Tooltip>)}
          </Typography>
      </TableCell>
      <TableCell>
        <Paper elevation={0} style={{ padding: '8px 16px', borderRadius: '10px' }}>
          <MUILink href={url} target="_blank" rel="noopener noreferrer" color="primary">
            {url}
          </MUILink>
        </Paper>
      </TableCell>
      <TableCell>
        <Typography variant="body1" color="textPrimary">{cardTitle}</Typography>
      </TableCell>
      <TableCell align="centre">
        <Tooltip title="Open link">
          <IconButton href={url} target="_blank" rel="noopener noreferrer">
            <OpenInNewIcon />
          </IconButton>
        </Tooltip>
      </TableCell>
    </TableRow>
  );
}

export default Link;
