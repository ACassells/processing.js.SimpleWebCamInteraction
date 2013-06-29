var ctx;

final int cameraWidth = 960;
final int cameraHeight = 640;

void setup() { 
    size(cameraWidth,cameraHeight);
    ctx = externals.context;    
}

void draw() {
    pushMatrix();  
    translate(width,0);  
    scale(-1,1);  //flip the image on x axis so the video is like you are in a mirror
    ctx.drawImage(video, 0, 0, cameraWidth, cameraHeight);  //video is defined outside processing code in video.js
    popMatrix();
}
