import React from 'react';
import { Bar } from 'react-chartjs-2';

const data = {
  labels: ['January', 'February', 'March', 'April', 'May'],
  datasets: [{
    label: 'Scan Count',
    data: [65, 59, 80, 81, 56],
    backgroundColor: 'rgba(255, 99, 132, 0.2)',
    borderColor: 'rgba(255, 99, 132, 1)',
    borderWidth: 1,
  }],
};

const options = {
  scales: {
    y: {
      beginAtZero: true
    }
  }
};

const BarChart = () => (
  <Bar data={data} options={options} />
);

export default BarChart;
