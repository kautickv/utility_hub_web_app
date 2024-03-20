import React, { useState, useEffect } from 'react';
import { Typography, Box, Card, CardContent, Accordion, AccordionSummary, AccordionDetails, List, ListItem, ListItemIcon, Tooltip, IconButton } from '@mui/material';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import InfoOutlinedIcon from '@mui/icons-material/InfoOutlined';
import InsertDriveFileOutlinedIcon from '@mui/icons-material/InsertDriveFileOutlined';
import AccountTreeOutlinedIcon from '@mui/icons-material/AccountTreeOutlined';
import StorageOutlinedIcon from '@mui/icons-material/StorageOutlined';
import ViewListOutlinedIcon from '@mui/icons-material/ViewListOutlined';
import CategoryOutlinedIcon from '@mui/icons-material/CategoryOutlined';


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

const analyzeJson = (obj) => {
    let arrays = [], objects = [];

    const recurse = (value, path = '') => {
        if (Array.isArray(value)) {
            arrays.push(path);
            value.forEach((item, index) => recurse(item, `${path}[${index}]`));
        } else if (value !== null && typeof value === 'object') {
            objects.push(path);
            Object.entries(value).forEach(([key, val]) => {
                const newPath = path ? `${path}.${key}` : key;
                recurse(val, newPath);
            });
        }
    };

    recurse(obj);
    return { arrays, objects };
};

function JsonInfo({ json }) {
    const [dataInfo, setDataInfo] = useState({ arrays: [], objects: [] });
    const [depth, setDepth] = useState(0);
    const [size, setSize] = useState(0);

    useEffect(() => {
        if (json) {
            setDataInfo(analyzeJson(json));
            setDepth(calculateJsonDepth(json));
            setSize(calculateJsonSize(json));
        }
    }, [json]);

    const infoList = [
        { icon: <InsertDriveFileOutlinedIcon />, text: `Entries: ${Object.keys(json || {}).length}`, tooltip: "Total number of top-level key-value pairs in the JSON object." },
        { icon: <AccountTreeOutlinedIcon />, text: `Depth: ${depth}`, tooltip: "Maximum level of nesting within the JSON object." },
        { icon: <StorageOutlinedIcon />, text: `Size: ${size} bytes`, tooltip: "Total size of the JSON object when converted to a string." },
        { icon: <ViewListOutlinedIcon />, text: `Arrays: ${dataInfo.arrays.length}`, tooltip: "Total number of arrays within the JSON object." },
        { icon: <CategoryOutlinedIcon />, text: `Objects: ${dataInfo.objects.length}`, tooltip: "Total number of objects within the JSON object. This count excludes the top-level object." },
    ];

    return (
        <Card sx={{ m: 2 }}>
            <CardContent>
                <Typography variant="h6" gutterBottom>JSON Details</Typography>
                {infoList.map((item, index) => (
                    <Box key={index} sx={{ display: 'flex', alignItems: 'center', mt: 1 }}>
                        <ListItemIcon>
                            {item.icon}
                        </ListItemIcon>
                        <Typography variant="body1" sx={{ flexGrow: 1 }}>
                            {item.text}
                        </Typography>
                        <Tooltip title={item.tooltip}>
                            <IconButton size="small">
                                <InfoOutlinedIcon fontSize="small" />
                            </IconButton>
                        </Tooltip>
                    </Box>
                ))}
                <Accordion sx={{ mt: 2 }}>
                    <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                        <Typography>Arrays</Typography>
                    </AccordionSummary>
                    <AccordionDetails>
                        <List>
                            {dataInfo.arrays.map((name, index) => (
                                <ListItem key={index}>{name || 'Root'}</ListItem>
                            ))}
                        </List>
                    </AccordionDetails>
                </Accordion>
                <Accordion>
                    <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                        <Typography>Objects</Typography>
                    </AccordionSummary>
                    <AccordionDetails>
                        <List>
                            {dataInfo.objects.map((name, index) => (
                                <ListItem key={index}>{name || 'Root'}</ListItem>
                            ))}
                        </List>
                    </AccordionDetails>
                </Accordion>
            </CardContent>
        </Card>
    );
}

export default JsonInfo;