import React, {useState} from 'react';
import './App.css';

function App() {

  const [password, setPassword] = useState('');
  const [length, setLength] = useState(8);

  function generatePassword(){

    setPassword('wedbvjkswvjkewbvbjdfskwvsdvsdvdsvdsavsdavdsavvkdfsvbsfjkdvbjksfdabv');
    console.log("Password has been generated");
  }

  function copytoClipboard(){
    console.log('copied');
  }
  return (
    <div className='App'>
      <label>Length:</label>
      <input type="number" min="1" max="100" value={length} onChange={e => setLength(e.target.value)} />
      <br />
      <button onClick={generatePassword}>Generate</button>
      <br />
      <label>Generated Password: </label>
      <label style={{ fontWeight: 'bold' }}>{password}  </label>
      <button onClick={copytoClipboard}>Copy</button>
    </div>
  );
}

export default App;
