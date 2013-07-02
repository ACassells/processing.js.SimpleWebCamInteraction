processing.js.SimpleWebCamInteraction
=====================================

Example of using the webcam with processing.js

These are some examples that allow you to use webcam data in a processing sketch. Requires a browser that supports webRTC getUserMedia (I have only got it really working in chrome).

SimpleWebcamInteraction simply renders the input from a webcam in a processing sketch.

SimpleMotionDetectionWebcamInteractionImage builds on SimpleWebcamInteraction, renders the webcam image, and in the top left hand of the sketch renders a black and white image which represents the 'motion' in the image.  Black indicating no motion detected and white indicating that there has been some "motion" (change in the pixel colour - yes that's colour with a u because that is how you spell it!)

SimpleMotionDetectionSinglePointWebcamInteraction builds on SimpleWebcamInteraction, aggregates the position of the motion and draws a point to screen which should be tracking the motion.


