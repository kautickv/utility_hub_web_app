import React from 'react';
import {
  TableCell,
  TableRow,
  Tooltip,
  IconButton,
  Link as MUILink
} from '@mui/material';
import OpenInNewIcon from '@mui/icons-material/OpenInNew';

function Link({ title, url }) {
  return (
    <TableRow hover>
      <TableCell>{title}</TableCell>
      <TableCell>
        <MUILink href={url} target="_blank" rel="noopener noreferrer" color="primary">
          {url}
        </MUILink>
      </TableCell>
      <TableCell align="right">
        <Tooltip title="Open link">
          <IconButton href={url} target="_blank" rel="noopener noreferrer" size="small" edge="end">
            <OpenInNewIcon fontSize="small" />
          </IconButton>
        </Tooltip>
      </TableCell>
    </TableRow>
  );
}

export default Link;
