import React, { useState, useEffect } from 'react';
import { List, Button, Dialog, DialogTitle, DialogContent, TextField, DialogActions, Box } from '@mui/material';
import { useSnackbar } from 'notistack';

// Import components
import ProjectItem from './ProjectItem';

// Import scripts
import { sendPostToJsonViewerProjects } from "../../utils/json_viewer_utils"
import { checkLocalStorageForJWTToken } from "../../utils/util"
import { sendGetJsonViewerProjects } from "../../utils/json_viewer_utils"

function ProjectList({ setSelectedJson }) {
  const { enqueueSnackbar } = useSnackbar();
  const [projects, setProjects] = useState([]);
  const [openModal, setOpenModal] = useState(false);
  const [newProjectName, setNewProjectName] = useState("");

  useEffect(() => {

    const initializeProjects = async () => {
      try {
        let jwtToken = checkLocalStorageForJWTToken();
        if (jwtToken !== "") { 
          const response = await sendGetJsonViewerProjects(jwtToken);
          const fetchedProjects = await response.json()
          console.log(fetchedProjects)
          const formattedProjects = fetchedProjects.map(proj => ({
            name: proj.project_name,
            jsonEntries: proj.files.map(file => ({
              name: file.json_file_name,
              json: JSON.parse(file.json_content)
            }))
          }));
          setProjects(formattedProjects);
        }
      }
      catch (e) {
        console.log(`An error occurred while fetching projects: ${e}`)
        enqueueSnackbar("Failed to load projects: " + e.message, { variant: 'error' });
      }
    }
    initializeProjects();
  }, [enqueueSnackbar])

  const handleAddProject = async () => {
    if (newProjectName.trim()) {
      setOpenModal(false); // Close the modal
      setNewProjectName(""); // Reset the input field
      // Save project to backend
      let jwtToken = checkLocalStorageForJWTToken();
      if (jwtToken !== "") {
        let response = await sendPostToJsonViewerProjects(jwtToken, newProjectName.trim(), "create");
        if (response.status === 200) {
          setProjects([...projects, { name: newProjectName, jsonEntries: [] }]);
          enqueueSnackbar('Project Created', { variant: 'success' });
        } else if (response === 500) {
          enqueueSnackbar("An error occurred. Please try again later", { variant: 'error' });
        }
        else {
          enqueueSnackbar(response.json(), { variant: 'error' });
        }
      } else {
        enqueueSnackbar("Authentication expired. Please login again", { variant: 'error' });
      }
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

