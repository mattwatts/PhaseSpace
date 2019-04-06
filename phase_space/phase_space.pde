// Plot 3d points
// keyboard keys control movement of perspective
// move perspective through x,y,z axis and zoom length
Table table;
float x_min, y_min, z_min,
      x_max, y_max, z_max,
      rotationX, rotationY, rotationZ,
      velocityX, velocityY, velocityZ,
      x_lo, x_hi, y_lo, y_hi, z_lo, z_hi, lo, hi,
      zoomChange, zoomLength, valueMax, valueMin;
int cValue = 14;
int elapsedSinceChange;
boolean[] keys = new boolean[255];
boolean zLeft = false, zRight = false, hIn = false, hOut = false,
        cPlus = false, cMinus = false;

//float acelerateConstant = 0.05;
//float zoomConstant = 0.5;
//int lineWidth = 50;
//float quenchConstant = 0.95;
//int toggleTableConstant = 30;
float acelerateConstant = 0.1;
float zoomConstant = 1;
int lineWidth = 25;
float quenchConstant = 0.95;
int toggleTableConstant = 30;
int pixelZoomConstant = 1000;

void readTable(){
  x_min = 100;
  y_min = 100;
  z_min = 100;
  x_max = -100;
  y_max = -100;
  z_max = -100;
  rotationX = 0;
  rotationY = 0;
  rotationZ = 0;
  velocityX = 0;
  velocityY = 0;
  velocityZ = 0;
  zoomChange = 0;
  valueMax = 0;
  valueMin = 10e20;
      
      
  table = loadTable(cValue + ".csv", "header");

  println(table.getRowCount() + " points"); 

  // find the max and min for x,y,z data
  // this info allows us to:
  //   maintain the aspect ratio
  //   maintain 0,0,0
  //   maintain the exact 3d dimensions
  for (TableRow row : table.rows()) {
    float x = row.getFloat("x");
    float y = row.getFloat("y");
    float z = row.getFloat("z");
    float value = row.getFloat("decimal");

    if (x < x_min) { x_min = x; }
    if (y < y_min) { y_min = y; }
    if (z < z_min) { z_min = z; }
    if (x > x_max) { x_max = x; }
    if (y > y_max) { y_max = y; }
    if (z > z_max) { z_max = z; }
    if (value > valueMax) { valueMax = value; }
    if (value < valueMin) { valueMin = value; }
  }
  println(x_min + "," + y_min + "," + z_min);
  println(x_max + "," + y_max + "," + z_max);
  // find lo,hi for each x,y,z
  x_lo = -1 * (max(abs(x_min),x_max));
  x_hi = max(abs(x_min),x_max);
  y_lo = -1 * (max(abs(y_min),y_max));
  y_hi = max(abs(y_min),y_max);
  z_lo = -1 * (max(abs(z_min),z_max));
  z_hi = max(abs(z_min),z_max);
  println(x_lo + "," + y_lo + "," + z_lo);
  println(x_hi + "," + y_hi + "," + z_hi);
  // find lo,hi for all
  hi = max(x_lo,y_lo,z_lo);
  hi = max(hi,x_hi,y_hi);
  hi = max(hi,z_hi);
  lo = -1 * hi;
  println(lo);
  println(hi);
  println(valueMin);
  println(valueMax);
}

void setup() {
  //size(1000, 850, P3D);
  //size(1300, 700, P3D);
  size(700, 700, P3D);
  background(0);
  lights();
  readTable();
  
  // zoom length 1000 - matches the pixel zoom
  zoomLength = pixelZoomConstant;
  //  zoomLength = 1000;
  
  mapPoints();
}

void mapPoints() {
  for (TableRow row : table.rows()) {
    // zoom 1000x on the pixels - matches the zoom length
    // multiplying x 1000 would do the same thing
    //row.setFloat("x",map(row.getFloat("x"),lo,hi,lo*1000,hi*1000));
    //row.setFloat("y",map(row.getFloat("y"),lo,hi,lo*1000,hi*1000));
    //row.setFloat("z",map(row.getFloat("z"),lo,hi,lo*1000,hi*1000));
    //pixelZoomConstant
    float lowValue = lo*pixelZoomConstant;
    float hiValue = hi*pixelZoomConstant;
    row.setFloat("x",map(row.getFloat("x"),lo,hi,lowValue,hiValue));
    row.setFloat("y",map(row.getFloat("y"),lo,hi,lowValue,hiValue));
    row.setFloat("z",map(row.getFloat("z"),lo,hi,lowValue,hiValue));
    
  }
}

void drawPoints() {
  for (TableRow row : table.rows()) {
    
    strokeWeight(2);
    int value = int(map(row.getFloat("decimal"),valueMin,valueMax,0,255));
    
    stroke(0,(255-value),value);
    point(row.getFloat("x"),
          row.getFloat("y"),
          row.getFloat("z"));
  }
}

void drawColourLines(){
  for (int i=0;i<256;i++) {
    // draw line i 0 to 255
    stroke(0,i,(255-i));
    line(width-lineWidth,i+20,width,i+20);
  }
  
  // lineWidth was 50 now 25
  // dashes need to move right 25 pixels
  
  // draw little black dashes next to max and min
  stroke(0,0,0);
  //line(width-56,20,width-50,20);
  //line(width-56,276,width-50,276);
  line(width-6-lineWidth,20,width-lineWidth,20);
  line(width-6-lineWidth,276,width-lineWidth,276);
  
  // show 0 and max on axis
  // set text colour red
  fill(255,0,0);
  textSize(20);
  
  // write the low value
  //text("0",width-80,286);
  text("0",width-30-lineWidth,286);
  // write the high value
  //text((table.getRowCount()-1),width-135,30);
  text((table.getRowCount()-1),width-85-lineWidth,30);
}

void drawRotateAxes(){
  // set text colour red
  // fill circle white
  fill(255,255,255);
  // circle ring red
  stroke(255,0,0);
  
  // draw 3 circles
  int radius = 13;
  for (int i=0;i<3;i++) {
    float xCentre = 28+radius;
    float yCentre = 7+radius+(i*2*radius)+(i*4);
    float diameter = radius*2;
    // draw a circle
    ellipse(xCentre,yCentre,diameter,diameter);
    // draw a line from centre of circle upwards
    pushMatrix();
    translate(xCentre, yCentre);
    // rotate the line in 360 detrees
    if (i==0) { rotate(radians(rotationX)); }
    if (i==1) { rotate(radians(rotationY)); }
    if (i==2) { rotate(radians(rotationZ)); }
    // draw red line rotated
    stroke(255,0,0);
    line(0,0,0,-radius);
    popMatrix();
  }

}

void drawParameters() {
// Purpose: draw the coordinates

  // set text colour red
  fill(255,0,0);
  textSize(20);
  
  // write the co-ordinates
  text("X",10,30);
  text(rotationX,53,30);
  text("Y",10,60);
  text(rotationY,53,60);
  text("Z",10,90);
  text(rotationZ,53,90);
  text("L " + (zoomLength/pixelZoomConstant),10,120);
  // text("L " + (zoomLength/1000),10,120);
}

void drawUsage() {
// Purpose: draw the coordinates

  // set text colour red
  fill(255,0,0);
  textSize(20);
  
  // write the co-ordinates
  text("D - =",10,height-120);
  text("X UP DOWN",10,height-95);
  text("Y LEFT RIGHT",10,height-70);
  text("Z , .",10,height-45);
  text("L ; /",10,height-20);
}

void drawScale() {
// Purpose: draw the scale

  // set text colour red
  fill(255,0,0);
  textSize(20);
  
  // write the co-ordinates
  text("Points",width-250,height-70);
  text(table.getRowCount(),width-160,height-70);
  text("Dim",width-250,height-45);
  text(cValue,width-160,height-45);
  text("Scale",width-250,height-20);
  text(""+hi,width-160,height-20);
}

void acceleratePerspective(){
  
  //float acelerateConstant = 0.05;
  //float zoomConstant = 0.5;
  
  // accelerate perspective
  if (keys[LEFT])  { velocityY -= acelerateConstant; }
  if (keys[RIGHT]) { velocityY += acelerateConstant; }
  if (keys[UP])    { velocityX += acelerateConstant; }
  if (keys[DOWN])  { velocityX -= acelerateConstant; }
  if (zLeft)       { velocityZ -= acelerateConstant; }
  if (zRight)      { velocityZ += acelerateConstant; }
  if (hIn)         { zoomChange += zoomConstant; }
  if (hOut)        { zoomChange -= zoomConstant; }
}

void togglePointsTable(){
  elapsedSinceChange++;
  
  // toggle points table plus
  if (cPlus || cMinus) {
    if (cPlus) {
      if (elapsedSinceChange > toggleTableConstant) {
        cValue++;
        if (cValue > 14) { cValue = 8; }
      }
    }
    // toggle points table minus
    if (cMinus) {
      if (elapsedSinceChange > toggleTableConstant) {
        cValue--;
        if (cValue < 8) { cValue = 14; }
      }
    }
    readTable();
    mapPoints();
    elapsedSinceChange = 0;
  }
}

void processKeyPress(){
  acceleratePerspective();
  
  togglePointsTable();
}

void movePerspective(){
  rotationX += velocityX;
  rotationY += velocityY;
  rotationZ += velocityZ;
  zoomLength += zoomChange;
}

void quenchAcceleration(){
  velocityX *= quenchConstant;
  velocityY *= quenchConstant;
  velocityZ *= quenchConstant;
  zoomChange *= quenchConstant;
}

void wrapXYZ(){
  // map x,y,z around 0 to 360
  if (rotationX > 360) { rotationX = rotationX - 360; }
  if (rotationX < 0)   { rotationX = rotationX + 360; }
  if (rotationY > 360) { rotationY = rotationY - 360; }
  if (rotationY < 0)   { rotationY = rotationY + 360; }
  if (rotationZ > 360) { rotationZ = rotationZ - 360; }
  if (rotationZ < 0)   { rotationZ = rotationZ + 360; }
}

void draw() {
  background(255);
 
  drawParameters();
  drawUsage();
  drawScale();
  drawColourLines();
  drawRotateAxes();
  processKeyPress();
  
  translate(width/2, height/2, -1*zoomLength);
  rotateX( radians(-rotationX) );
  rotateY( radians(-rotationY) );
  rotateZ( radians(-rotationZ) );
  
  drawPoints();

  movePerspective();
  
  quenchAcceleration();
  
  wrapXYZ();
}
 
void keyPressed() {
  keys[keyCode] = true;
  if (key == ',') {
    zLeft = true;
  }
  if (key == '.') {
    zRight = true;
  }
  if (key == ';') {
    hIn = true;
  }
  if (key == '/') {
    hOut = true;
  }
  if (key == '=') {
    cPlus = true;
  }
  if (key == '-') {
    cMinus = true;
  }
  
}
 
void keyReleased() {
  keys[keyCode] = false;
  if (key == ',') {
    zLeft = false;
    // damp z
    velocityZ = 0;
  }
  if (key == '.') {
    zRight = false;
    // damp z
    velocityZ = 0;
  }
  if (key == ';') {
    hIn = false;
    // damp l
    zoomChange = 0;
  }
  if (key == '/') {
    hOut = false;
    // damp l
    zoomChange = 0;
  }
  if (key == '=') {
    cPlus = false;
    // damp l
    zoomChange = 0;
  }
  if (key == '-') {
    cMinus = false;
    // damp l
    zoomChange = 0;
  }
  if (keyCode == LEFT) {velocityY = 0;}
  if (keyCode == RIGHT) {velocityY = 0;}
  if (keyCode == UP) {velocityX = 0;}
  if (keyCode == DOWN) {velocityX = 0;}
}
