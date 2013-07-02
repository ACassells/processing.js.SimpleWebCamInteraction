var ctx;

final int cameraWidth = 960;
final int cameraHeight = 640;

void setup() { 
    size(960,640);
    ctx = externals.context;    
}

void draw() { 
    
    if (!video.available) return;
   
    pushMatrix();
    translate(width,0);
    scale(-1,1);//mirror the video so that it looks like me looing back at me (not just a raw video feed)
    ctx.drawImage(video, 0, 0, cameraWidth, cameraHeight); //video is defined with video.js
    popMatrix();
}
