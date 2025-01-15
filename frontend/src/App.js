import React from 'react';
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import Home from './pages/Home/home'
import Calculator from './pages/Calculator/calculator'
import Log from './pages/Log/log'
import Navbar from './components/navbar';

function App() {
  return (
    <Router>
      <Navbar />
      <div>
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/calculator" element={<Calculator />} />
          <Route path="/log" element={<Log />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
