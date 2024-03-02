// src/components/SignUp.js
import React from 'react';

function SignUp() {
  return (
    <div className="container mt-5">
      <h2>Sign Up</h2>
      <form>
        <div className="mb-3">
          <label htmlFor="email" className="form-label">Email address</label>
          <input type="email" className="form-control" id="email" />
        </div>
        <div className="mb-3">
          <label htmlFor="password" className="form-label">Password</label>
          <input type="password" className="form-control" id="password" />
        </div>
        <div className="mb-3">
          <label htmlFor="confirmPassword" className="form-label">Confirm Password</label>
          <input type="password" className="form-control" id="confirmPassword" />
        </div>
        <button type="submit" className="btn btn-primary">Sign Up</button>
      </form>
    </div>
  );
}

export default SignUp;
