//import processing.svg.*;
import gohai.simpletweet.*;
SimpleTweet simpletweet;

float sa, sw, rot;
int amount;
int aseed;
boolean newbackground, saveframe, tweetframe, savesingleframe;
// float   = 0.0;
float stepsrangeL, stepsrangeH;
float deviationrangeL, deviationrangeH;
float fillraterangeL, fillraterangeH;
int curframe, maxframes;
float roty;
float globalX, globalY;

void setup() {
  size (1500, 1500, P3D);
  background(255, 0, 0, 0);
  curframe = 0;
  maxframes = 60;
  frameRate(30);
  sa = 150;
  stroke(255, 255, 255, sa);
  sw = 1.3;
  rot = 0.2;
  roty = 0;
  globalX = 0;
  globalY = 0;
  amount = 100;
  aseed = int(random(42));
  resetparams();
  simpletweet = new SimpleTweet(this);
  tweetframe = false;  
  savesingleframe = false;

  tweetsecrets();


  noLoop();
}


void draw() {
  if (newbackground) {
    background(random(255), random(255), random(255));
    newbackground = false;
  }
  teowiap(sa, sw, rot, amount);
  if (saveframe) {
    if (curframe > maxframes) {
      saveframe = false;
      noLoop();
    } else {
      curframe = curframe + 1;
      updateteowiap();
      String name = "frame_" + str(stepsrangeL) + "_";
      // save(name+str(curframe)+".png");
      println(name+str(curframe)+".png");
      loop();
    }
  }
  if (savesingleframe) {
    print("saving frame");
    save("singleframe"+str(int(random(0,30000)))+".png");
    savesingleframe = false;
  }
  if (tweetframe) {
    String tweet = simpletweet.tweetImage(getFrame(), "dronedaytest");
    tweetframe = false;  
}
  // noLoop();
}





void teowiap(float sa, float sw, float rot, int amount) {

  fill(255, 255, 255, 0);
  strokeWeight(sw);
  pushMatrix();
  translate(width/2, height/2, 0);
  pushMatrix();
//   rotate(rot);
    translate(globalX,globalY);
  pushMatrix();
  for (int i = 0; i < amount; ++i) {
    int steps = int(random (stepsrangeL, stepsrangeH));
    float deviation = random(deviationrangeL, deviationrangeH);
    float fillrate = random(fillraterangeL, fillraterangeH);
    float x = random(-10, 10);
    float y = random(-10, 10);
    float z = random(50, 350) * i;
    float awidth = noise(random(0, 10))*1000 +500;
    // float awidth = random(500,1800);
    // float awidth = random(500,800);
    float aheight = awidth;
    arcseqs(aseed, steps, deviation, fillrate, x, y, z, awidth, aheight);
  }
  popMatrix();
  popMatrix();
  popMatrix();
}

void updateteowiap() {
  aseed = int(random(30000));
  amount =  int(random(10, 150));
  // stroke(random(0,255), 255, 255, sa);
  redraw();
}

void arcseqs(int seed, int steps, float deviation, float fillrate, float x, float y, float z, float width, float height) {
  if (0 != seed) {
    randomSeed(seed);
  }
  float step = steps/PI/2;
  ArrayList<float[]> arcseq = new ArrayList<float[]>();
  for (int i = 0; i < steps; ++i) {
    if (random(0, 1) < fillrate) {
      float[] arcseqarr = {(i*step), (i*step) + (random(deviation))};
      arcseq.add(arcseqarr);
    }
  }
  pushMatrix();
  // rotateZ(random(0,6.2830));
  for (float[] arcsq : arcseq) {
    pushMatrix();
    translate(x, y, z);

    rotateY(roty);
    arc(x, y, width, height, arcsq[0], arcsq[1]);
    popMatrix();
  }
  popMatrix();
}



void keyPressed() {
  println(key, keyCode);
  if (keyCode == 32 ) { //"Space"
    updateteowiap();
  }
  if (keyCode == 82) { //r
    resetparams() ;
    curframe = 0;
    maxframes = 60;
    redraw();
  }


  if (keyCode == 69) { //e
    resetbackground();
    redraw();
   
  }
  if (keyCode == 84){
    posttweet();
  }
  if (keyCode == 83){
    saveSingleFrame();
    redraw();

  }
  if (keyCode == 10) { //EnterR
    renderframes(60);
  }
}

void saveSingleFrame(){
    savesingleframe = true;
}


void resetbackground() {
  newbackground = true;
}


void resetparams() {
//   newbackground = true;
  stepsrangeL = random(10, 50);
  stepsrangeH = random(50, 100);
  deviationrangeL = random(0.01, 0.1);
  deviationrangeH = random(0.1, 0.5);
  fillraterangeL = random(0.1, 0.3);
  fillraterangeH = random(0.3, 0.5);
  globalX = random(-200,200);
  globalY = random(-200,200);
  roty = random(0,1.5);
  stroke(random(255), random(255), random(255), sa);
}


void renderframes(int frames) {
  maxframes = curframe + frames;
  saveframe = true;
}

PImage getFrame() {
  PImage img = new PImage(width, height);

  g.loadPixels();
  img.loadPixels();

  img.pixels = g.pixels;

  img.updatePixels();
  g.updatePixels();

  return img;
}

void posttweet() {
  tweetframe = true;  
  redraw();
  println("Posting " + "tweet");
}
