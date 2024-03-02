import React, { useState } from 'react';
import axios from 'axios';

const ImageUploader = () => {
    const [image, setImage] = useState(null);

    const handleImageChange = (e) => {
        setImage(e.target.files[0]);
    };

    const handleImageUpload = async () => {
        try {
            const formData = new FormData();
            formData.append('image', image);

            const response = await axios.post('http://localhost:8080/upload', formData, {
                headers: {
                    'Content-Type': 'multipart/form-data',
                },
            });

            console.log('OCR result:', response.data);
        } catch (error) {
            console.error('Error uploading image:', error);
        }
    };

    return (
        <div>
            <input type="file" onChange={handleImageChange} />
            <button onClick={handleImageUpload}>Upload Image</button>
        </div>
    );
};

export default ImageUploader;
