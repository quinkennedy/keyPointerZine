import processing.pdf.*;

int numberDrawings = 5;
int targetX, targetY;
boolean newCopy = true;

Section[] subsections;
int margin = 10;
Foldable foldable;
boolean debug = false;
boolean alternatePointSide = true;
PFont backCoverFont;
int backCoverFontSize = 35;

void setup(){
  size(400, 400, P2D);
  initCover();
  backCoverFont = createFont("SourceCodePro-Medium.ttf", backCoverFontSize);
  foldable = new Foldable(8.5, 11, .25, 1, "demo");
  subsections = new Section[3];
  for(int i = 0; i < subsections.length; i++){
    subsections[i] = new Section();
  }
}

void prepPage(int pageWidthPx, int pageHeightPx, int pageNumber){
  if (pageNumber == 0){
    //front cover
    prepCover(pageWidthPx, pageHeightPx, pageNumber);
  } else if (pageNumber == 11){
    //back cover (nothing to prep, draws directly on PDF)
  } else {
    layoutSubsections(pageWidthPx, pageHeightPx);
    for(int i = 0; i < subsections.length; i++){
      Section subsection = subsections[i];
      chooseDrawings(subsection);
      subsection.graphic = createGraphics((int)subsection.placement.w, 
                                          (int)subsection.placement.h, 
                                          P2D);
      subsection.graphic.beginDraw();
      boolean oddPage = (pageNumber % 2 == 1);
      int targetX = (oddPage && alternatePointSide ? (pageWidthPx - this.targetX) : this.targetX);
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
}

void renderPage(PGraphics graphics, int pageWidthPx, int pageHeightPx, int pageNumber){
  if (debug){
    //to be able to see pages while debugging
    graphics.stroke(150);
    graphics.noFill();
    graphics.rect(0, 0, pageWidthPx, pageHeightPx);
    println("rendering page " + pageNumber);
  }
  
  if (pageNumber == 0){
    //front cover
    renderCover(graphics, pageWidthPx, pageHeightPx, pageNumber);
  } else if (pageNumber == 11){
    //back cover
    graphics.textFont(backCoverFont);
    String text = "a generative zine\n";
    //text += "printed for C.A.B. 2015\n";
    text += "produced by PaperBon.net\n";
    text += "code available at\n";
    text += "https://github.com/quinkennedy/keyPointerZine/\n";
    graphics.fill(0);
    graphics.textSize(backCoverFontSize);
    float textY = graphics.textAscent() + 50;
    if (targetY < pageHeightPx / 2){
      textY += pageHeightPx / 2;
    }
    graphics.text(text, 50, textY);
    boolean oddPage = (pageNumber % 2 == 1);
    int targetX = (oddPage && alternatePointSide ? (pageWidthPx - this.targetX) : this.targetX);
    graphics.ellipse(targetX, targetY, 10, 10);
  } else {
    //drawing content
    for(int i = 0; i < subsections.length; i++){
      Section subsection = subsections[i];
      graphics.image(subsection.graphic, subsection.placement.x, subsection.placement.y);
    }
  }
  
  if (debug){
    //to be able to see page number while debugging
    graphics.fill(0, 100);
    graphics.textSize(200);
    graphics.text(pageNumber, pageWidthPx/2, pageHeightPx/2);
  }
}

//with large copy numbers (> 80) the render was failing
// possibly due to memory leak
// so this helps graph the memory over time
void showMemory(){
  // The amount of memory allocated so far (usually the -Xms setting)
  long allocated = Runtime.getRuntime().totalMemory();
  
  // Free memory out of the amount allocated (value above minus used)
  long free = Runtime.getRuntime().freeMemory();
  
  // The maximum amount of memory that can eventually be consumed
  // by this application. This is the value set by the Preferences
  // dialog box to increase the memory settings for an application.
  long maximum = Runtime.getRuntime().maxMemory();
  
  long used = allocated - free;
  long points = 20;
  long fullPoints = used * points / maximum;
  print("mem: ");
  int i = 0;
  for(; i < fullPoints && i < points; i++){
    print("#");
  }
  for(; i < points; i++){
    print("_");
  }
  
  println(" " + used + " / " + maximum);
}

void initCopy(int copyNumber, int pageWidthPx, int pageHeightPx, float pageWidthIn, float pageHeightIn){
  println("prep copy " + copyNumber);
  showMemory();
    
  targetX = int(random(10, pageWidthPx - 10));
  targetY = int(random(10, pageHeightPx - 10));
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

Rectangle getRandomRect(int maxX, int maxY){
  int canvasArea = maxX*maxY;
  int rectMaxArea = canvasArea/3;
  int rectMinArea = canvasArea/10;
  int rectWidth = int(random(rectMinArea/maxY, maxX));
  int rectHeight = int(random(rectMinArea/rectWidth, min(rectMaxArea/rectWidth, maxY)));
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