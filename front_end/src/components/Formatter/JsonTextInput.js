import React from 'react';

const JsonTextInput = ({ value, onChange, placeholder = "Paste JSON text here..." }) => {
  return (
    <textarea
      value={value}
      onChange={onChange}
      style={{ width: '100%', height: '200px' }}
      placeholder={placeholder}
    />
  );
};

export default JsonTextInput;
