import React, { useState } from 'react';
import Webcam from 'react-webcam';

const CameraCapture = () => {
    const webcamRef = React.useRef(null);
    const [imgSrc, setImgSrc] = useState(null);

    const capture = React.useCallback(() => {
        const imageSrc = webcamRef.current.getScreenshot();
        setImgSrc(imageSrc);
        // Here, you can also send the imageSrc to the backend for processing
    }, [webcamRef, setImgSrc]);

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
