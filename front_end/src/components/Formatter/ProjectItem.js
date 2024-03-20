import React, { useState } from 'react';
import { Accordion, AccordionSummary, AccordionDetails, Typography, Button, List, ListItem, ListItemSecondaryAction, ListItemText, IconButton, Dialog, DialogActions, DialogContent, DialogContentText, DialogTitle, Box } from '@mui/material';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import DeleteIcon from '@mui/icons-material/Delete';
import EditIcon from '@mui/icons-material/Edit';
import { useSnackbar } from 'notistack';
// Import components
import JsonEntryModal from './JsonEntryModal';

// Import scripts
import { sendPostToJsonViewerProjects } from "../../utils/json_viewer_utils"
import { checkLocalStorageForJWTToken } from "../../utils/util"

function ProjectItem({ project, updateProjects, projects, setSelectedJson }) {
    const { enqueueSnackbar } = useSnackbar();
    const [openModal, setOpenModal] = useState(false);
    const [editingEntry, setEditingEntry] = useState(null); // To keep track of the entry being edited
    const [openConfirmDialog, setOpenConfirmDialog] = useState(false);

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

    const handleOpenConfirmDialog = () => {
        setOpenConfirmDialog(true);
    };

    const handleCloseConfirmDialog = () => {
        setOpenConfirmDialog(false);
    };

    const handleConfirmDeleteProject = async () => {
        // Logic to delete the entire project
        setOpenConfirmDialog(false); // Close the confirmation dialog
        // Save project to backend
        let jwtToken = checkLocalStorageForJWTToken();
        if (jwtToken !== "") {
            let response = await sendPostToJsonViewerProjects(jwtToken, project.name.trim(), "delete");
            if (response.status === 200) {
                const updatedProjects = projects.filter(p => p.name !== project.name);
                updateProjects(updatedProjects);
                enqueueSnackbar('Project Deleted', { variant: 'success' });
            } else if (response === 500) {
                enqueueSnackbar("An error occurred. Please try again later", { variant: 'error' });
            }
            else {
                enqueueSnackbar(response.json(), { variant: 'error' });
            }
        } else {
            enqueueSnackbar("Authentication expired. Please login again", { variant: 'error' });
        }
    };

    return (
        <>
            <Accordion>
                <AccordionSummary
                    expandIcon={<ExpandMoreIcon />}
                    aria-controls="panel1a-content"
                    id="panel1a-header"
                >
                    {/* Wrap in a Box with flex display for better control over spacing */}
                    <Box display="flex" alignItems="center" justifyContent="space-between" width="100%">
                        <Typography flex={1} mr={2}>{project.name}</Typography> {/* Add right margin to Typography */}
                        <IconButton
                            edge="end"
                            aria-label="delete"
                            onClick={(e) => { e.stopPropagation(); handleOpenConfirmDialog(); }}
                            size="large">
                            <DeleteIcon />
                        </IconButton>
                    </Box>
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
            {/* Confirmation Dialog */}
            <Dialog
                open={openConfirmDialog}
                onClose={handleCloseConfirmDialog}
                aria-labelledby="alert-dialog-title"
                aria-describedby="alert-dialog-description"
            >
                <DialogTitle id="alert-dialog-title">{"Delete Project?"}</DialogTitle>
                <DialogContent>
                    <DialogContentText id="alert-dialog-description">
                        Are you sure you want to delete this project and all its contents? This action cannot be undone.
                    </DialogContentText>
                </DialogContent>
                <DialogActions>
                    <Button onClick={handleCloseConfirmDialog}>Cancel</Button>
                    <Button onClick={handleConfirmDeleteProject} autoFocus>
                        Confirm
                    </Button>
                </DialogActions>
            </Dialog>
        </>
    );
}

export default ProjectItem;
