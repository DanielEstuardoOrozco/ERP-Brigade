// src/components/ForgotPassword.js
import React from 'react';

function ForgotPassword() {
  return (
    <div className="container mt-5">
      <h2>Forgot Password</h2>
      <form>
        <div className="mb-3">
          <label htmlFor="email" className="form-label">Email address</label>
          <input type="email" className="form-control" id="email" />
        </div>
        <button type="submit" className="btn btn-primary">Submit</button>
      </form>
    </div>
  );
}

export default ForgotPassword;
