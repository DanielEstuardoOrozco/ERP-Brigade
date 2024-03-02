import AliceCarousel from 'react-alice-carousel';
import 'react-alice-carousel/lib/alice-carousel.css';
import React, { useState, useEffect } from 'react';

const fetchBrigades = async () => {
  const response = await fetch('http://localhost:8080/ActiveBrigade');
  const data = await response.json();
  return data; // Ensure this is an array of items
};


const ActiveBrigadeCarousel = () => {
    const [brigades, setBrigades] = useState([]);
  
    useEffect(() => {
      fetchBrigades().then(data => {
        setBrigades(data); 
      });
    }, []);
  
    const items = brigades.map((brigade, index) => (
      <div className="item" key={index}>
        <img src={brigade.Picture.String} alt={`Brigade ${brigade.FirstName} ${brigade.LastName}`} />
        <p>{`${brigade.FirstName} ${brigade.LastName}`}</p>
      </div>
    ));
  
    <AliceCarousel
        autoPlay
        autoPlayInterval={3000}
        mouseTracking
        items={items}
        infinite
    />

    return <AliceCarousel mouseTracking items={items} />;
  };
  

 
