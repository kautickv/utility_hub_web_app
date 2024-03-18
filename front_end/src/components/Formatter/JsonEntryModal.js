import React, { useState } from 'react';
import { Dialog, DialogTitle, DialogContent, TextField, DialogActions, Button } from '@mui/material';

function JsonEntryModal({ open, onClose, handleAddJson }) {
    const [jsonString, setJsonString] = useState('');
    const [error, setError] = useState('');

    const handleClose = () => {
        setError('');
        setJsonString('');
        onClose();
    };

    const handleAdd = () => {
        try {
            // Attempt to parse JSON to ensure validity
            const json = JSON.parse(jsonString);
            // Assuming the JSON entries are objects with a name and json properties
            const newEntry = { name: `Entry ${new Date().getTime()}`, json }; // Simplistic entry name generation
            handleAddJson(newEntry);
            handleClose();
        } catch (err) {
            setError('Invalid JSON. Please correct and try again.');
        }
    };

    return (
        <Dialog open={open} onClose={handleClose}>
            <DialogTitle>Add JSON Entry</DialogTitle>
            <DialogContent>
                <TextField
                    autoFocus
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
                    rows={4}
                />
            </DialogContent>
            <DialogActions>
                <Button onClick={handleClose}>Cancel</Button>
                <Button onClick={handleAdd}>Add</Button>
            </DialogActions>
        </Dialog>
    );
}

export default JsonEntryModal;
