void doDrawing(PGraphics graphics, int num, int targetX, int targetY){
  int options = 0;
  switch(num){
    case 0:
      options = int(random(8));
      drawLines(graphics, targetX, targetY, 
          ((options & 1) == 1), ((options & 2) == 2), ((options & 4) == 4));
      break;
    case 1:
      options = int(random(16));
      drawCenteredCircles(graphics, targetX, targetY,
          ((options & 1) == 1), ((options & 2) == 2), ((options & 4) == 4),
          ((options & 8) == 8));
      break;
    case 2:
      options = int(random(16));
      drawTriangles(graphics, targetX, targetY, 
          ((options & 1) == 1), ((options & 2) == 2), ((options & 4) == 4),
          ((options & 8) == 8));
      break;
    case 3:
      options = int(random(16));
      drawPerpendicularLines(graphics, targetX, targetY, 
          ((options & 1) == 1), ((options & 2) == 2), false,//((options & 4) == 4),
          ((options & 8) == 8));
      break;
    case 4:
      options = int(random(16));
      drawFannedCircles(graphics, targetX, targetY, 
          ((options & 1) == 1), ((options & 2) == 2), ((options & 4) == 4),
          ((options & 8) == 8));
      break;
  }
}

void drawFannedCircles(PGraphics graphics, int targetX, int targetY,
    boolean changeColor, boolean enableFill, boolean changeWeight, boolean regularSpacing){
  float maxSpaceRad = .4;
  float minSpaceRad = .03;
  float space = random(minSpaceRad, maxSpaceRad);
  float distances[] = new float[]{
      dist(targetX, targetY, 0, 0),
      dist(targetX, targetY, graphics.width, 0),
      dist(targetX, targetY, graphics.width, graphics.height),
      dist(targetX, targetY, 0, graphics.height)};
  float maxDistance = max(distances);
  float minDistance = min(distances);
  graphics.pushMatrix();
  graphics.translate(targetX, targetY);
  for(float rad = 0; rad < TWO_PI; ){
    int brightness = 0;
    int alpha = 255;
    if (changeColor){
      brightness = int(random(255));
      alpha = int(random(255));
    }
    graphics.stroke(brightness, alpha);
    graphics.fill(brightness, alpha);
    if (enableFill){
      graphics.noStroke();
    } else {
      graphics.noFill();
      if (changeWeight){
        graphics.strokeWeight(random(20));
      } else {
        graphics.strokeWeight(1);
      }
    }
    float centerDistance = (maxDistance + minDistance) / 2;
    float diameter = maxDistance - minDistance;
    if (!regularSpacing){
      space = random(maxSpaceRad);
    }
    graphics.rotate(space);
    graphics.ellipse(0, -centerDistance, diameter, diameter);
    rad += space;
  }
  graphics.popMatrix();
}

void drawPerpendicularLines(PGraphics graphics, int targetX, int targetY, 
    boolean changeColor, boolean changeWeight, boolean changeDistance, boolean regularSpacing){
  float maxSpaceRad = .4;
  float minSpaceRad = .03;
  float space = random(minSpaceRad, maxSpaceRad);
  float distances[] = new float[]{
      dist(targetX, targetY, 0, 0),
      dist(targetX, targetY, graphics.width, 0),
      dist(targetX, targetY, graphics.width, graphics.height),
      dist(targetX, targetY, 0, graphics.height)};
  float maxDistance = max(distances);
  float minDistance = min(distances);
  float lineLength = 1000;
  graphics.pushMatrix();
  graphics.translate(targetX, targetY);
  for(float rad = 0; rad < TWO_PI; ){
    int brightness = 0;
    int alpha = 255;
    if (changeColor){
      brightness = int(random(255));
      alpha = int(random(255));
    }
    graphics.stroke(brightness, alpha);
    if (changeWeight){
      graphics.strokeWeight(random(20));
    } else {
      graphics.strokeWeight(1);
    }
    float currDistance = (maxDistance + minDistance) / 2;
    if (changeDistance){
      currDistance = random(maxDistance - minDistance) + minDistance;
    }
    if (!regularSpacing){
      space = random(maxSpaceRad);
    }
    graphics.rotate(space);
    graphics.line(-lineLength/2, -currDistance, lineLength/2, -currDistance);
    rad += space;
  }
  graphics.popMatrix();
}

void drawTriangles(PGraphics graphics, int targetX, int targetY, 
    boolean changeColor, boolean enableFill, boolean regularSpacing, boolean regularLength){
  float maxWidth = 100;
  float maxSpaceRad = .4;
  float minSpaceRad = .03;
  float space = random(minSpaceRad, maxSpaceRad);
  float distances[] = new float[]{
      dist(targetX, targetY, 0, 0),
      dist(targetX, targetY, graphics.width, 0),
      dist(targetX, targetY, graphics.width, graphics.height),
      dist(targetX, targetY, 0, graphics.height)};
  float maxLength = max(distances);
  maxLength -= 10;
  float minLength = min(distances);
  minLength += 10;
  float length = (maxLength + minLength) / 2;
  graphics.pushMatrix();
  graphics.translate(targetX, targetY);
  for(float rad = 0; rad < TWO_PI; ){
    int brightness = 0;
    int alpha = 255;
    if (changeColor){
      brightness = int(random(255));
      alpha = int(random(255));
    }
    graphics.fill(brightness, alpha);
    graphics.stroke(brightness, alpha);
    if (enableFill){
      graphics.noStroke();
    } else {
      graphics.noFill();
    }
    if (!regularSpacing){
      space = random(maxSpaceRad);
    }
    float width = random(maxWidth);
    if (!regularLength){
      length = random(maxLength - minLength) + minLength;
    }
    graphics.rotate(space);
    graphics.triangle(0, 0, -width/2, -length, width/2, -length);
    rad += space;
  }
  graphics.popMatrix();
}

void drawCenteredCircles(PGraphics graphics, int targetX, int targetY,
    boolean changeColor, boolean enableFill, boolean changeWeight, boolean allowSpace){
  int radius = int(max(new float[]{
      dist(targetX, targetY, 0, 0),
      dist(targetX, targetY, graphics.width, 0),
      dist(targetX, targetY, graphics.width, graphics.height),
      dist(targetX, targetY, 0, graphics.height)}));
  int origRad = radius;
  graphics.noStroke();
  while (radius > 0){
    int diff = int(random(origRad/2));
    int alpha = 255;
    int brightness = 0;
    if (changeColor){
      alpha = int(random(255));
      brightness = int(random(255));
    }
    graphics.fill(brightness, alpha);
    graphics.stroke(brightness, alpha);
    if (enableFill && changeColor){
      graphics.noStroke();
    } else {
      graphics.noFill();
      if (changeWeight){
        if (allowSpace || !changeColor){
          graphics.strokeWeight(random(diff));
        } else {
          graphics.strokeWeight(diff);
        }
      } else {
        graphics.strokeWeight(1);
      }
    }
    graphics.ellipse(targetX, targetY, radius*2, radius*2);
    radius -= diff;
  }
}

void drawLines(PGraphics graphics, int targetX, int targetY, boolean changeColor, boolean changeWeight, boolean fromOuter){
  graphics.stroke(0);
  graphics.strokeWeight(1);
  for(int i = 0; i < 20; i++){
    if (changeColor){
      graphics.stroke(0, int(random(255)));
    }
    if (changeWeight){
      graphics.strokeWeight(max(1, pow(random(7), 2)));//7 = sqrt(50);
    }
    
    float startX = 0, startY = 0;
    if (fromOuter){
      int side = int(random(4));
      switch(side){
        case 0://top
          startX = int(random(graphics.width));
          startY = -1;
          break;
        case 1://right
          startX = graphics.width+1;
          startY = int(random(graphics.height));
          break;
        case 2://bottom
          startX = int(random(graphics.width));
          startY = graphics.height + 1;
          break;
        case 3://left
          startX = -1;
          startY = int(random(graphics.height));
          break;
      }
    } else {
      startX = random(graphics.width);
      startY = random(graphics.height);
    }
    graphics.line(startX, startY, targetX, targetY);
  }
}