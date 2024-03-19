import React, { useState } from 'react';
import { List, Button, Dialog, DialogTitle, DialogContent, TextField, DialogActions, Typography, Box, Tooltip, IconButton } from '@mui/material';
import InfoIcon from '@mui/icons-material/Info';
import ProjectItem from './ProjectItem';

function ProjectList({ setSelectedJson }) {
  const [projects, setProjects] = useState([]);
  const [openModal, setOpenModal] = useState(false);
  const [newProjectName, setNewProjectName] = useState("");

  const handleAddProject = () => {
    if (newProjectName.trim()) {
      setProjects([...projects, { name: newProjectName, jsonEntries: [] }]);
      setOpenModal(false); // Close the modal
      setNewProjectName(""); // Reset the input field
    }
  };

  const handleOpenModal = () => {
    setOpenModal(true);
  };

  const handleCloseModal = () => {
    setOpenModal(false);
  };

  return (
    <Box sx={{ width: '100%', textAlign: 'center', mb: 2 }}>
      <List sx={{ margin: 'auto', maxWidth: 360, bgcolor: 'background.paper' }}>
        {projects.map((project, index) => (
          <ProjectItem
            key={index}
            project={project}
            updateProjects={setProjects}
            projects={projects}
            setSelectedJson={setSelectedJson}
          />
        ))}
      </List>
      <Button variant="contained" onClick={handleOpenModal} sx={{ mt: 2 }}>Add Project</Button>

      {/* Modal for adding a new project */}
      <Dialog open={openModal} onClose={handleCloseModal}>
        <DialogTitle>Add New Project</DialogTitle>
        <DialogContent>
          <TextField
            autoFocus
            margin="dense"
            id="name"
            label="Project Name"
            type="text"
            fullWidth
            variant="outlined"
            value={newProjectName}
            onChange={(e) => setNewProjectName(e.target.value)}
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseModal}>Cancel</Button>
          <Button onClick={handleAddProject}>Add</Button>
        </DialogActions>
      </Dialog>
    </Box>
  );
}

export default ProjectList;

