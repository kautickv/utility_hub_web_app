import React, {useState} from 'react';

function App() {

  const [password, setPassword] = useState('');
  const [length, setLength] = useState(8);

  function generatePassword(){

    setPassword('wedbvjkswvjkewbvbjdfskwvsdvsdvdsvdsavsdavdsavvkdfsvbsfjkdvbjksfdabv');
    console.log("Password has been generated");
  }

  async function copytoClipboard(){
    console.log(process.env.REACT_APP_API_GATEWAY_BASE_URL + "/home")
    try {
      const response = await fetch(process.env.REACT_APP_API_GATEWAY_BASE_URL + "/home");
      const jsonData = await response.json();
      console.log(jsonData);
    } catch (error) {
      console.error('Error fetching data:', error);
    }
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
