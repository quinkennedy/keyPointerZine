int numberDrawings = 5;
int selectedDrawings[];
int iteration = 0;
int activeSubsection = 0;
int targetX, targetY;
PGraphics currGraphics;
import processing.pdf.*;

Rectangle[] subsections;
int margin = 10;
Foldable foldable;

void setup(){
  size(800, 800);
  init();
  foldable = new Foldable(8.5, 11, "test");
}

void renderPage(PGraphics graphics, int pageWidth, int pageHeight, int pageNumber){
  graphics.stroke(150);
  graphics.noFill();
  graphics.rect(0, 0, pageWidth, pageHeight);
  println("rendering page " + pageNumber);
  graphics.fill(0);
  graphics.stroke(0);
  graphics.textSize(100);
  graphics.text(pageNumber, pageWidth/2, pageHeight/2);
}

void draw(){
  if (iteration == 0){
    background(255);
    while(foldable.renderNextPage(this));
  }
  if (activeSubsection < subsections.length){
    chooseDrawings();
    Rectangle subsection = subsections[activeSubsection];
    currGraphics = createGraphics((int)subsection.w, (int)subsection.h);
    currGraphics.beginDraw();
    for(int i = 0; i < selectedDrawings.length; i++){
      doDrawing(currGraphics, selectedDrawings[i], int(targetX - subsection.x), int(targetY - subsection.y));
    }
    currGraphics.endDraw();
    image(currGraphics, subsection.x, subsection.y);
    activeSubsection++;
  }
  iteration++;
}

void keyPressed(){
  if (key == ENTER){
    init();
  }
}

void chooseDrawings(){
  int numDrawings = 1;
  selectedDrawings = new int[numDrawings];
  for(int i = 0; i < numDrawings; i++){
    selectedDrawings[i] = int(random(0, numberDrawings));
  }
}

void init(){
  iteration = 0;
  activeSubsection = 0;
  targetX = int(random(width));// int(random(0, width*2)-width/2);
  targetY = int(random(height));//int(random(0, height*2)-height/2);
  layoutSubsections();
}

void layoutSubsections(){
  //layoutSubsectionsRandom();
  layoutSubsectionsNonOverlap();
}

Rectangle getRandomRect(){
  int canvasArea = width*height;
  int rectMaxArea = canvasArea/3;
  int rectMinArea = canvasArea/10;
  int rectWidth = int(random(width - rectMinArea/height) + rectMinArea/height);
  int rectHeight = int(random(rectMaxArea/rectWidth - rectMinArea/rectWidth) + rectMinArea/rectWidth);
  int rectX = int(random(width - rectWidth - margin));
  int rectY = int(random(height - rectHeight - margin));
  return new Rectangle(rectX, rectY, rectWidth, rectHeight);
}

void layoutSubsectionsRandom(){
  subsections = new Rectangle[3];
  for(int i = 0; i < subsections.length; i++){
    subsections[i] = getRandomRect();
  }
}



void layoutSubsectionsNonOverlap(){
  subsections = new Rectangle[3];
  for(int i = 0; i < subsections.length; i++){
    boolean fit = false;
    while(!fit){
      subsections[i] = getRandomRect();
      Rectangle bloated = subsections[i].bloat(margin);
      fit = true;
      for(int j = 0; j < i && fit; j++){
        if(bloated.overlapsWith(subsections[j])){
          fit = false;
        }
      }
    }
  }
}