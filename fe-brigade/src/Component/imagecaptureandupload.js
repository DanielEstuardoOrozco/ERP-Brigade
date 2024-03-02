import React, { useState, useRef } from 'react';
import Webcam from 'react-webcam';
import axios from 'axios';

const ImageCaptureAndUpload = () => {
    const webcamRef = useRef(null);
    const [imgSrc, setImgSrc] = useState(null);
    const [ocrResult, setOcrResult] = useState(""); 
    const [imageCaptured, setImageCaptured] = useState(false);
    const [formData, setFormData] = useState(null); // Add formData state
    
    const capture = () => {
        const imageSrc = webcamRef.current.getScreenshot();
        setImgSrc(imageSrc);
        setImageCaptured(true);
    };

    const handleUpload = (event) => {
        const file = event.target.files[0];
        const reader = new FileReader();
        reader.onloadend = () => {
            setImgSrc(reader.result);
            setImageCaptured(true);
        };
        reader.readAsDataURL(file);
    };

    const handleImageUpload = async () => {
        if (!imgSrc) {
            console.error("No image to upload");
            return;
        }
    
        // Convert Base64 image back to File object to append to FormData
        const fetchFile = async (url) => fetch(url)
            .then(r => r.blob())
            .then(blobFile => new File([blobFile], "filename.jpg", { type: "image/jpeg" }));
    
        try {
            const file = await fetchFile(imgSrc);
            const newFormData = new FormData(); // Create new FormData
            newFormData.append('image', file);
            setFormData(newFormData); // Set formData state
            
            const response = await axios.post('http://localhost:8080/uploadImage', newFormData, {
                headers: {
                    'Content-Type': 'multipart/form-data',
                },
            });
    
            console.log('Upload response:', response.data);
            // Call storeOCRResult after successful image upload
            await storeOCRResult(newFormData); // Pass formData as parameter
        } catch (error) {
            console.error('Error uploading image:', error);
        }
    };

    const storeOCRResult = async (formData) => { // Add formData parameter
        try {
            const response = await axios.post('http://localhost:8080/storeOCRResult', formData, {
                headers: {
                    'Content-Type': 'multipart/form-data',
                },
            });
            console.log('OCR result:', response.data);
            setOcrResult(response.data.text);
        } catch (error) {
            console.error('Error storing OCR result:', error);
        }
    };

    const resetCapture = () => {
        setImgSrc(null);
        setImageCaptured(false);
        setOcrResult("");
        setFormData(null); // Reset formData state
    };

    return (
        <div className="container">
            <div className="row">
                <div className="col-md-6">
                    {!imageCaptured && (
                        <div className="webcam-container">
                            <button className="btn btn-primary" onClick={capture}>Capture</button>
                            <input type="file" onChange={handleUpload} />
                            <Webcam audio={false} ref={webcamRef} screenshotFormat="image/jpeg" />
                        </div>
                    )}
                    <div>
                        <button className="btn btn-primary" onClick={handleImageUpload}>Upload Image</button>
                        {imageCaptured && <button className="btn btn-danger" onClick={resetCapture}>Reset</button>}
                    </div>
                </div>
                <div className="col-md-6">
                    {imgSrc && (
                        <div className="image-preview-container">
                            <img src={imgSrc} alt="Captured or Uploaded" className="img-fluid" />
                            {ocrResult && <p>OCR Result: {ocrResult}</p>}
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
};

export default ImageCaptureAndUpload;
