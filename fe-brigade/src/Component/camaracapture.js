import React, { useState } from 'react';
import Webcam from 'react-webcam';

const CameraCapture = () => {
    const webcamRef = React.useRef(null);
    const [imgSrc, setImgSrc] = useState(null);

    const capture = React.useCallback(() => {
        const imageSrc = webcamRef.current.getScreenshot();
        setImgSrc(imageSrc);
        sendImageToServer(imageSrc);
    }, [webcamRef, setImgSrc]);

    const sendImageToServer = async (imageSrc) => {
        try {
            const response = await fetch('http://localhost:8080/upload', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ image: imageSrc }),
            });
            const data = await response.json();
            console.log('Server response:', data);
        } catch (error) {
            console.error('Error sending image to server:', error);
        }
    };

    return (
        <>
            <Webcam
                audio={false}
                ref={webcamRef}
                screenshotFormat="image/jpeg"
                style={{ width: '100%' }}
            />
            <button onClick={capture}>Capture photo</button>
            {imgSrc && (
                <img
                    src={imgSrc}
                    alt="Captured"
                    style={{ width: '100%' }}
                />
            )}
        </>
    );
};

export default CameraCapture;
