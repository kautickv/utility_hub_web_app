import React, { useState } from 'react';
import { Accordion, AccordionSummary, AccordionDetails, Typography, Button, List, ListItem, ListItemText, IconButton, ListItemSecondaryAction } from '@mui/material';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import DeleteIcon from '@mui/icons-material/Delete';
import EditIcon from '@mui/icons-material/Edit';
import JsonEntryModal from './JsonEntryModal'; // Assume this component exists

function ProjectItem({ project, updateProjects, projects, setSelectedJson }) {
    const [openModal, setOpenModal] = useState(false);
    const [editingEntry, setEditingEntry] = useState(null); // To keep track of the entry being edited

    const handleAddOrEditJson = (jsonEntry) => {
        const updatedProjects = projects.map(p => {
            if (p.name === project.name) {
                if (editingEntry) {
                    // Replace the edited entry
                    return {
                        ...p,
                        jsonEntries: p.jsonEntries.map(entry => entry.name === editingEntry.name ? jsonEntry : entry),
                    };
                }
                return { ...p, jsonEntries: [...p.jsonEntries, jsonEntry] };
            }
            return p;
        });
        updateProjects(updatedProjects);
        setEditingEntry(null); // Reset editing state
        setOpenModal(false); // Close the modal
    };

    const handleDeleteJson = (entryName) => {
        const updatedProjects = projects.map(p => {
            if (p.name === project.name) {
                return {
                    ...p,
                    jsonEntries: p.jsonEntries.filter(entry => entry.name !== entryName),
                };
            }
            return p;
        });
        updateProjects(updatedProjects);
    };

    const handleEditJson = (entry) => {
        setEditingEntry(entry); // Set current entry for editing
        setOpenModal(true); // Open the modal
    };

    return (
        <Accordion>
            <AccordionSummary
                expandIcon={<ExpandMoreIcon />}
                aria-controls="panel1a-content"
                id="panel1a-header"
            >
                <Typography>{project.name}</Typography>
            </AccordionSummary>
            <AccordionDetails>
                <List>
                    {project.jsonEntries.map((entry, index) => (
                        <ListItem key={index} onClick={() => setSelectedJson(entry.json)} button>
                            <ListItemText
                                primary={entry.name}
                                primaryTypographyProps={{
                                    noWrap: true,
                                    style: {
                                        width: 'calc(100% - 96px)', // Adjust the width as necessary
                                        overflow: 'hidden',
                                        textOverflow: 'ellipsis',
                                        whiteSpace: 'nowrap'
                                    }
                                }}
                            />
                            <ListItemSecondaryAction>
                                <IconButton edge="end" aria-label="edit" onClick={(e) => { e.stopPropagation(); handleEditJson(entry); }}>
                                    <EditIcon />
                                </IconButton>
                                <IconButton edge="end" aria-label="delete" onClick={(e) => { e.stopPropagation(); handleDeleteJson(entry.name); }}>
                                    <DeleteIcon />
                                </IconButton>
                            </ListItemSecondaryAction>
                        </ListItem>
                    ))}
                </List>
                <Button variant="contained" onClick={() => { setEditingEntry(null); setOpenModal(true); }}>Add JSON</Button>
            </AccordionDetails>
            <JsonEntryModal
                open={openModal}
                onClose={() => setOpenModal(false)}
                handleAddJson={handleAddOrEditJson}
                existingNames={project.jsonEntries.map(entry => entry.name)}
                editingEntry={editingEntry}
            />
        </Accordion>
    );
}

export default ProjectItem;
