import React from 'react';
import { Routes, Route } from 'react-router-dom';
import Login from './Pages/login';
import SignUp from './Pages/signup';
import { AuthProvider } from './Admin/authcontext';
import ImageCaptureAndUpload from './Component/imagecaptureandupload';


function App() {
  return (
    <AuthProvider>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/signup" element={<SignUp />} />
        <Route path="/scan" element={<ImageCaptureAndUpload />} />
      </Routes>
    </AuthProvider>
  );
}

export default App;