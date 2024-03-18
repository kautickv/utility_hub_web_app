import React, { useState, useEffect } from 'react';
import { Dialog, DialogTitle, DialogContent, TextField, DialogActions, Button, DialogContentText } from '@mui/material';

function JsonEntryModal({ open, onClose, handleAddJson, existingNames, editingEntry }) {
    const [jsonString, setJsonString] = useState('');
    const [jsonTitle, setJsonTitle] = useState('');
    const [error, setError] = useState('');
    const [titleError, setTitleError] = useState('');

    useEffect(() => {
        if (editingEntry) {
            setJsonString(JSON.stringify(editingEntry.json, null, 2)); // Pretty print the JSON
            setJsonTitle(editingEntry.name);
        } else {
            setJsonString('');
            setJsonTitle('');
        }
        setError('');
        setTitleError(''); // Clear title error when modal opens or editingEntry changes
    }, [editingEntry, open]);

    // Also, clear the title error when the user modifies the title
    const handleTitleChange = (e) => {
        setJsonTitle(e.target.value);
        if (titleError) setTitleError(''); // Clear the title error when the user starts typing
    };

    const handleAddOrEdit = () => {
        // Check if the title is empty and set an error message if it is
        if (!jsonTitle.trim()) {
            setTitleError('Title cannot be empty.');
            return;
        }

        if (existingNames.includes(jsonTitle.trim()) && (!editingEntry || editingEntry.name !== jsonTitle.trim())) {
            setTitleError('Title already exists. Please use a different title.');
            return;
        }

        try {
            const json = JSON.parse(jsonString);
            const newEntry = { name: jsonTitle.trim(), json };
            handleAddJson(newEntry);
            onClose(); // Close modal on success
        } catch (err) {
            setError('Invalid JSON. Please correct and try again.');
        }
    };


    return (
        <Dialog
            open={open}
            onClose={onClose}
            fullWidth={true}
            maxWidth="lg" // Adjust the max width to "md", "lg" or "xl" for larger sizes
        >
            <DialogTitle>{editingEntry ? 'Edit JSON Entry' : 'Add JSON Entry'}</DialogTitle>
            <DialogContent>
                <TextField
                    autoFocus
                    margin="dense"
                    id="jsonTitle"
                    label="JSON Title"
                    type="text"
                    fullWidth
                    variant="outlined"
                    value={jsonTitle}
                    onChange={handleTitleChange}
                    helperText={titleError}
                    error={!!titleError}
                />
                <TextField
                    margin="dense"
                    id="jsonString"
                    label="JSON String"
                    type="text"
                    fullWidth
                    variant="outlined"
                    value={jsonString}
                    onChange={(e) => setJsonString(e.target.value)}
                    helperText={error}
                    error={!!error}
                    multiline
                    rows={20} // Increase the number of rows to expand the text field
                    sx={{ mt: 2 }} // Add spacing at the top
                />
            </DialogContent>
            <DialogActions>
                <Button onClick={onClose}>Cancel</Button>
                <Button onClick={handleAddOrEdit}>{editingEntry ? 'Save Changes' : 'Add'}</Button>
            </DialogActions>
        </Dialog>
    );
}

export default JsonEntryModal;
