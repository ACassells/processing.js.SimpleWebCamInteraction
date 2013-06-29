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
    scale(-1,1);//mirror t
    ctx.drawImage(video, 0, 0, cameraWidth, cameraHeight); //video is defined outside processing code
    popMatrix();
}
