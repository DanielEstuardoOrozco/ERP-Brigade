import React from 'react';
import { createRoot } from 'react-dom/client';
import { BrowserRouter } from 'react-router-dom';
import App from './App';
import 'bootstrap/dist/css/bootstrap.min.css';

const root = document.getElementById('root');
const rootElement = createRoot(root);

rootElement.render(
  <React.StrictMode>
    <BrowserRouter>
      <App />
    </BrowserRouter>
  </React.StrictMode>
);