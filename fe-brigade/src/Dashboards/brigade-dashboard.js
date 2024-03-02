import React, { useState, useEffect } from 'react';
import AliceCarousel from 'react-alice-carousel';
import 'react-alice-carousel/lib/alice-carousel.css';

const ActiveBrigadeCarousel = () => {
  const [brigades, setBrigades] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await fetch('http://localhost:8080/ActiveBrigade');
        const data = await response.json();
        setBrigades(Array.isArray(data) ? data : [data]); // Ensure this is an array
      } catch (error) {
        console.error('Error fetching data:', error);
      }
    };

    fetchData();
  }, []);

  const items = brigades.map((brigade, index) => (
    <div className="item" key={index}>
      {brigade.Picture && brigade.Picture.Valid ? (
        <img src={brigade.Picture.String} alt={`Brigade ${brigade.FirstName} ${brigade.LastName}`} />
      ) : (
        <div>No image available</div>
      )}
      <p>{`${brigade.FirstName} ${brigade.LastName}`}</p>
    </div>
  ));

  return (
    <AliceCarousel 
      autoPlay 
      autoPlayInterval={3000} 
      mouseTracking 
      items={items} 
      infinite 
      responsive={{
        0: {
          items: 1,
        },
        1024: {
          items: 3,
        },
      }} 
    />
  );
};

function App() {
  return (
    <div className="App">
      <ActiveBrigadeCarousel />
    </div>
  );
}

export default App;
