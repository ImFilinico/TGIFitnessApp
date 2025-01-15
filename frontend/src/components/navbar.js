import React from 'react';
import { Link } from 'react-router-dom';

const Navbar = () => {
  return (
    <nav>
      <ul>
        <li><Link to="/">Home</Link></li>
        <li><Link to="/calculator">Calculate</Link></li>
        <li><Link to="/log">log</Link></li>
      </ul>
    </nav>
  );
};

export default Navbar;