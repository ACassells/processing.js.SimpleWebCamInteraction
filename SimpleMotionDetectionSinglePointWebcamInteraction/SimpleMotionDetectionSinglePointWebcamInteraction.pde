final int cameraWidth = 960;
final int cameraHeight = 640;
final int shrinkFactor = 8;                // sort of arbitary, the amount the image will be shrunk for for motion detection
final float colorChangeThreshold = 75.0;   // again arbitary, the "amount" of color a pixel needs to change to be regarded as motion 
final int motionChangeThreshold = 20;      // again arbitary, the amount of pixels that need to change for there to be regarded as motion 

var ctx;

PImage currentImage;
PImage previousImage;
PVector motionDetectionPoint = new PVector(cameraWidth/2, cameraHeight/2);


void setup() { 
    size(960,640);
    ctx = externals.context;    
}


void draw() {
    
    // don't do anything if I have no access to the web cam (this is defined in video.js)
    if (!video.available) return;
    
    // I want 2 images in memory, the current and previous image and the differences between these two things is motion!
    previousImage = currentImage;
    
    // draw mirrored feed to full image
    drawMirroredCameraFeed();
    
    currentImage= get(0,0,cameraWidth,cameraHeight);
    
    if (currentImage != null && previousImage != null) {    
      
        PImage motionDetectionImage = createMotionDetectionImage();
        setMotionDetectionPoint(motionDetectionImage);
        
        ellipseMode(CENTER);
        fill(0);
        ellipse(motionDetectionPoint.x,  motionDetectionPoint.y, 30, 30);
        fill(255);
        ellipse(motionDetectionPoint.x, motionDetectionPoint.y, 20, 20);
        image(motionDetectionImage, 0, 0);          
    }
}


private void setMotionDetectionPoint(PImage motionDetectionImage) {
  
   int motionPointSumX = 0, motionPointSumY = 0, motionPixelCount = 0;
   
   /// loop through the motion detection image and create a running total of x and y
   /// values for the points
   for (int i = 0; i < motionDetectionImage.pixels.length; i++) {
     color p1 = motionDetectionImage.pixels[i];
     if (p1 == color(255)) { 
        motionPointSumX += i % ((cameraWidth) / shrinkFactor);
        motionPointSumY += i / ((cameraWidth) / shrinkFactor);
        motionPixelCount = motionPixelCount + 1;
      }         
   }
   
   /// if enough motion is detected then work out the average position of the motion and set the
   /// global motion detection point based on this value.  If not enough motion is detected don't
   /// do anything!
   if (motionPixelCount > motionChangeThreshold) {
     motionPointX = ((motionPointSumX/motionPixelCount) * width/((cameraWidth)/(shrinkFactor)));
     motionPointY = ((motionPointSumY/motionPixelCount) * height/(cameraHeight/(shrinkFactor)));
     motionDetectionPoint = new PVector((int)motionPointX, (int)motionPointY); 
   }
}


private void drawMirroredCameraFeed() {
    pushMatrix();
    translate(width,0);
    scale(-1,1);                                            //mirror the video so it is like looking in a mirror
    ctx.drawImage(video, 0, 0, cameraWidth, cameraHeight);  //video is defined in video.js
    popMatrix();
}



private PImage createMotionDetectionImage() {
  j = 0;
  PImage motionDetectionImage = createImage(cameraWidth/shrinkFactor, cameraHeight/shrinkFactor, RGB);
  int motionPointSumX = 0, motionPointSumY = 0, motionPixelCount = 0;
  for (int i = 0 ; i <  previousImage.pixels.length; i=nextI(i)) {
     color p1 = previousImage.pixels[i];
     color p2 = currentImage.pixels[i];
           
     float totalDiff =  abs(red(p1) - red(p2)) + abs( green(p1) - green(p2)) + abs(blue(p1) - blue(p2));
           
     if (totalDiff > colorChangeThreshold) { 
        motionDetectionImage.pixels[j] = color(255);             
      } else {
         motionDetectionImage.pixels[j] = color(0);
      }           
      j = j + 1;
  }
  return motionDetectionImage;
}



/// weird function that is going to look for every nth colum pixel in everyt nth row pixel
/// this helps create a smaller data set to check for motion rather than a large array
private int nextI(int i) {
  if ( (int)( (int)(i+shrinkFactor) / (int)(cameraWidth) ) % (int) shrinkFactor == 0){
    return i + shrinkFactor;
  } else {
    return i + shrinkFactor + cameraWidth % shrinkFactor + (cameraWidth*(shrinkFactor-1));
  }
}
