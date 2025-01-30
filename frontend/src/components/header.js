import React from 'react';
import { Link } from 'react-router-dom';

const Header = () => {
  return (
    <header>
      <nav>
          <Link to="/">Home</Link>
      </nav>

      <nav>
        <Link to="/calculator">Calculate</Link>
      </nav>

      <nav>
        <Link to="/log">log tehee</Link>
    </nav>
    </header>
  );
}

export default Header;