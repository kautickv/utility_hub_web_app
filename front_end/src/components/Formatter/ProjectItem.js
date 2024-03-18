import React, { useState } from 'react';
import { Accordion, AccordionSummary, AccordionDetails, Typography, Button, List, ListItem, ListItemText } from '@mui/material';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import JsonEntryModal from './JsonEntryModal'; // Assume this component exists

function ProjectItem({ project, updateProjects, projects, setSelectedJson }) {
  const [openModal, setOpenModal] = useState(false);

  const handleAddJson = (newJson) => {
    const updatedProjects = projects.map(p => {
      if (p.name === project.name) {
        return { ...p, jsonEntries: [...p.jsonEntries, newJson] };
      }
      return p;
    });
    updateProjects(updatedProjects);
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
            <ListItem button key={index} onClick={() => setSelectedJson(entry.json)}>
              <ListItemText primary={entry.name} />
            </ListItem>
          ))}
        </List>
        <Button variant="contained" onClick={() => setOpenModal(true)}>Add JSON</Button>
      </AccordionDetails>
      <JsonEntryModal open={openModal} onClose={() => setOpenModal(false)} handleAddJson={handleAddJson} />
    </Accordion>
  );
}

export default ProjectItem;
