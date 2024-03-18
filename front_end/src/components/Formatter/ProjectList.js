import React, { useState } from 'react';
import { List, ListItem, ListItemText, Button, ListItemButton } from '@mui/material';
import ProjectItem from './ProjectItem';

function ProjectList({ setSelectedJson }) {
  const [projects, setProjects] = useState([]);

  const handleAddProject = () => {
    const projectName = prompt("Enter project name:");
    if (projectName) {
      setProjects([...projects, { name: projectName, jsonEntries: [] }]);
    }
  };

  return (
    <>
      <List>
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
      <Button variant="contained" onClick={handleAddProject}>Add Project</Button>
    </>
  );
}

export default ProjectList;
