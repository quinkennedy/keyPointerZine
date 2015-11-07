int numberDrawings = 5;
int targetX, targetY;
boolean newCopy = true;
import processing.pdf.*;

Section[] subsections;
int margin = 10;
Foldable foldable;

void setup(){
  size(400, 400, P2D);
  foldable = new Foldable(8.5, 11, .25, 2, "test");
  subsections = new Section[3];
  for(int i = 0; i < subsections.length; i++){
    subsections[i] = new Section();
  }
}

void prepPage(int pageWidthPx, int pageHeightPx, int pageNumber){
  layoutSubsections(pageWidthPx, pageHeightPx);
  for(int i = 0; i < subsections.length; i++){
    Section subsection = subsections[i];
    chooseDrawings(subsection);
    subsection.graphic = createGraphics((int)subsection.placement.w, 
                                        (int)subsection.placement.h, 
                                        P2D);
    subsection.graphic.beginDraw();
    for(int j = 0; j < subsection.selectedDrawings.length; j++){
      int relativeTargetX = int(targetX - subsection.placement.x);
      int relativeTargetY = int(targetY - subsection.placement.y);
      doDrawing(subsection.graphic, 
                subsection.selectedDrawings[j], 
                relativeTargetX, 
                relativeTargetY);
    }
    subsection.graphic.endDraw();
  }
}

void renderPage(PGraphics graphics, int pageWidthPx, int pageHeightPx, int pageNumber){
  //to be able to see pages while debugging
  graphics.stroke(150);
  graphics.noFill();
  graphics.rect(0, 0, pageWidthPx, pageHeightPx);
  println("rendering page " + pageNumber);
  
  if (pageNumber == 0){
    //drawing content
    println("page: " + new Rectangle(0, 0, pageWidthPx, pageHeightPx).toString());
    for(int i = 0; i < subsections.length; i++){
      Section subsection = subsections[i];
      println("s" + i + ":"+ subsection.selectedDrawings[0]+": " + subsection.placement.toString());
      graphics.image(subsection.graphic, subsection.placement.x, subsection.placement.y);
    }
  }
  
  //to be able to see page number while debugging
  graphics.fill(0, 100);
  graphics.textSize(200);
  graphics.text(pageNumber, pageWidthPx/2, pageHeightPx/2);
}

void initCopy(int copyNumber, int pageWidthPx, int pageHeightPx, float pageWidthIn, float pageHeightIn){
  println("prep copy " + copyNumber);
  targetX = int(random(pageWidthPx));
  targetY = int(random(pageHeightPx));
  newCopy = true;
}

void draw(){
  if (newCopy){
    newCopy = false;
    //order matters-ish
    while(!newCopy && foldable.renderNextPage(this));
  } else {
    background(255);
    fill(0);
    text("done?", 20, 20);
  }
}

void chooseDrawings(Section section){
  int numDrawings = 1;
  section.selectedDrawings = new int[numDrawings];
  for(int i = 0; i < numDrawings; i++){
    section.selectedDrawings[i] = int(random(0, numberDrawings));
  }
}

void layoutSubsections(int maxX, int maxY){
  //layoutSubsectionsRandom();
  layoutSubsectionsNonOverlap(maxX, maxY);
}

Rectangle getRandomRect(int maxX, int maxY){//maxX = 1275, maxY = 1100
  int canvasArea = maxX*maxY;//1402500
  int rectMaxArea = canvasArea/3;//467500
  int rectMinArea = canvasArea/10;//140250
  int rectWidth = int(random(rectMinArea/maxY, maxX));//127.5 <-> 1275 = 128
  int rectHeight = int(random(rectMinArea/rectWidth, min(rectMaxArea/rectWidth, maxY)));//1095.703125 <-> min(3652.34375, 1100) = 1099
  int rectX = int(random(maxX - rectWidth));
  int rectY = int(random(maxY - rectHeight));
  return new Rectangle(rectX, rectY, rectWidth, rectHeight);
}

void layoutSubsectionsRandom(int maxX, int maxY){
  for(int i = 0; i < subsections.length; i++){
    subsections[i].placement = getRandomRect(maxX, maxY);
  }
}

void layoutSubsectionsNonOverlap(int maxX, int maxY){
  for(int i = 0; i < subsections.length; i++){
    boolean fit = false;
    while(!fit){
      subsections[i].placement = getRandomRect(maxX, maxY);
      Rectangle bloated = subsections[i].placement.bloat(margin);
      fit = true;
      for(int j = 0; j < i && fit; j++){
        if(bloated.overlapsWith(subsections[j].placement)){
          fit = false;
        }
      }
    }
  }
}

class Section{
  Rectangle placement;
  int[] selectedDrawings;
  PGraphics graphic;
}