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
import { sendPostToJsonViewerProjectJson } from "../../utils/json_viewer_utils"

function ProjectItem({ project, updateProjects, projects, setSelectedJson }) {
    const { enqueueSnackbar } = useSnackbar();
    const [openModal, setOpenModal] = useState(false);
    const [editingEntry, setEditingEntry] = useState(null); // To keep track of the entry being edited
    const [openConfirmDialog, setOpenConfirmDialog] = useState(false);
    const [deleteEntryName, setDeleteEntryName] = useState("");
    const [openDeleteEntryConfirmDialog, setOpenDeleteEntryConfirmDialog] = useState(false);


    const handleAddOrEditJson = async (jsonEntry) => {
        // Check for JWT token from local storage
        let jwtToken = checkLocalStorageForJWTToken();
        if (jwtToken === "") {
            enqueueSnackbar("Authentication expired. Please login again", { variant: 'error' });
            return;
        }

        // Determine if this is an add or edit operation
        const isEditOperation = editingEntry != null;

        // Prepare data for backend call
        const projectName = project.name.trim();
        const jsonName = jsonEntry.name.trim();
        const jsonContent = jsonEntry.json; // Assuming jsonEntry.json contains the JSON content

        // Send to backend
        try {
            let response = await sendPostToJsonViewerProjectJson(jwtToken, projectName, "create", jsonName, jsonContent);
            if (response.status === 200) {
                // Backend update successful, now update UI
                const updatedProjects = projects.map(p => {
                    if (p.name === projectName) {
                        if (isEditOperation) {
                            // Replace the edited entry
                            return {
                                ...p,
                                jsonEntries: p.jsonEntries.map(entry => entry.name === editingEntry.name ? jsonEntry : entry),
                            };
                        }
                        // Add new entry
                        return { ...p, jsonEntries: [...p.jsonEntries, jsonEntry] };
                    }
                    return p;
                });
                updateProjects(updatedProjects);
                enqueueSnackbar(isEditOperation ? 'JSON Edited Successfully' : 'JSON Added Successfully', { variant: 'success' });
            } else {
                // Handle non-200 responses
                const errorText = await response.text();
                enqueueSnackbar(errorText, { variant: 'error' });
            }
        } catch (error) {
            // Handle network or other unexpected errors
            console.error("Failed to save JSON entry:", error);
            enqueueSnackbar("An error occurred while saving JSON. Please try again.", { variant: 'error' });
        } finally {
            // Reset states regardless of outcome
            setEditingEntry(null);
            setOpenModal(false);
        }
    };

    // Function to open the delete confirmation dialog for a JSON entry
    const handleOpenDeleteEntryConfirmDialog = (entryName) => {
        setDeleteEntryName(entryName);
        setOpenDeleteEntryConfirmDialog(true);
    };

    // Function to close the delete confirmation dialog
    const handleCloseDeleteEntryConfirmDialog = () => {
        setOpenDeleteEntryConfirmDialog(false);
        setDeleteEntryName(""); // Reset selected entry for deletion
    };


    // Adjusted handleDeleteJson to include confirmation logic
    const handleDeleteJsonConfirmed = async () => {
        // Assume deleteEntryName has the name of the entry to be deleted
        const jwtToken = checkLocalStorageForJWTToken();
        if (!jwtToken) {
            enqueueSnackbar("Authentication expired. Please login again", { variant: 'error' });
            return;
        }

        let response = await sendPostToJsonViewerProjectJson(jwtToken, project.name,"delete", deleteEntryName, "");
        if (response.status === 200) {
            // Update UI after successful deletion
            const updatedProjects = projects.map(p => {
                if (p.name === project.name) {
                    return {
                        ...p,
                        jsonEntries: p.jsonEntries.filter(entry => entry.name !== deleteEntryName),
                    };
                }
                return p;
            });
            updateProjects(updatedProjects);
            enqueueSnackbar('JSON Entry Deleted Successfully', { variant: 'success' });
        } else {
            enqueueSnackbar('Failed to delete JSON Entry', { variant: 'error' });
        }
        handleCloseDeleteEntryConfirmDialog();
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
                                    <IconButton edge="end" aria-label="delete" onClick={(e) => { e.stopPropagation(); handleOpenDeleteEntryConfirmDialog(entry.name); }}>
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
            <Dialog
                open={openDeleteEntryConfirmDialog}
                onClose={handleCloseDeleteEntryConfirmDialog}
                aria-labelledby="delete-entry-dialog-title"
                aria-describedby="delete-entry-dialog-description"
            >
                <DialogTitle id="delete-entry-dialog-title">{"Delete JSON Entry?"}</DialogTitle>
                <DialogContent>
                    <DialogContentText id="delete-entry-dialog-description">
                        Are you sure you want to delete this JSON entry? This action cannot be undone.
                    </DialogContentText>
                </DialogContent>
                <DialogActions>
                    <Button onClick={handleCloseDeleteEntryConfirmDialog}>Cancel</Button>
                    <Button onClick={handleDeleteJsonConfirmed} autoFocus>
                        Delete
                    </Button>
                </DialogActions>
            </Dialog>
        </>
    );
}

export default ProjectItem;
