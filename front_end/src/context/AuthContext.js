import { createContext, useState, useCallback } from 'react';

export const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [user, setUser] = useState(null);

  const loginUser = useCallback((loggedInUser) => {
    setIsAuthenticated(true);
    setUser(loggedInUser);
  }, []);

  const logoutUser = useCallback(() => {
    setIsAuthenticated(false);
    setUser(null);
    localStorage.removeItem('JWT_Token');
  }, []);

  return (
    <AuthContext.Provider value={{ isAuthenticated, user, loginUser, logoutUser }}>
      {children}
    </AuthContext.Provider>
  );
};
