var ctx;

PImage currentImage;
PImage previousImage;
final int cameraWidth = 960;
final int cameraHeight = 640;
final int shrinkFactor = 8;               // sort of arbitary, the amount the image will be shrunk for for motion detection
final float colorChangeThreshold = 50.0;  // again arbitary, the "amount" of color a pixel needs to change to be regarded as motion 


void setup() { 
    size(cameraWidth,cameraHeight);
    ctx = externals.context;    
}

void draw() {
  
    // I want 2 images in memory, the current and previous image and the differences between these two things is motion!
    previousImage = currentImage;  
    
    pushMatrix();
    translate(width,0);
    scale(-1,1);                                            //mirror the video so it is like looking in a mirror
    ctx.drawImage(video, 0, 0, cameraWidth, cameraHeight);  //video is defined outside processing code
    popMatrix();
    
    currentImage=get(0,0,cameraWidth,cameraHeight);
    
    
    PImage motionDetectionImage = createImage(cameraWidth/shrinkFactor, cameraHeight/shrinkFactor, RGB);
    if (currentImage != null && previousImage != null) {    
        j = 0;
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
        image(motionDetectionImage, 0, 0);
          
    }
}


private int nextI(int i) {
  if ( (int)( (int)(i+shrinkFactor) / (int)(cameraWidth) ) % (int) shrinkFactor == 0){
    return i + shrinkFactor;
  } else {
    return i + shrinkFactor + cameraWidth % shrinkFactor + (cameraWidth*(shrinkFactor-1));
  }
}
