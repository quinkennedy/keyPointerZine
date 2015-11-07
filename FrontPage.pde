import geomerative.*;

RShape titleShape;
RPoint[] titlePoints;
PGraphics titleImage;

void initCover(){
  RG.init(this);
  String title = "Key Point";
  String font = "SourceSansPro-Black.ttf";
  int titleSize = 250;
  titleShape = RG.getText(title, font, titleSize, CENTER);//magic numbers!
  int titleFidelity = 25;
  RG.setPolygonizer(RG.UNIFORMLENGTH);
  RG.setPolygonizerLength(titleFidelity);//magic numbers!
  titlePoints = titleShape.getPoints();
}

void prepCover(int pageWidthPx, int pageHeightPx, int pageNumber){
  //create local target points to account for centered text
  int targetX = this.targetX - pageWidthPx / 2;
  int targetY = this.targetY - pageHeightPx / 2;
  
  //create letter and point mask
  PGraphics titleMask = createGraphics(pageWidthPx, pageHeightPx, P2D);
  titleMask.beginDraw();
  titleMask.background(0);
  titleMask.fill(255);
  titleMask.noStroke();
  titleMask.translate(pageWidthPx / 2, pageHeightPx / 2);
  titleShape.draw(titleMask);
  titleMask.ellipse(targetX, targetY, 10, 10);
  titleMask.endDraw();
  
  //create letter lines and point
  titleImage = createGraphics(pageWidthPx, pageHeightPx, P2D);
  titleImage.beginDraw();
  titleImage.background(255);
  titleImage.translate(pageWidthPx / 2, pageHeightPx / 2);
  titleImage.stroke(0);
  for(int i = 0; i < titlePoints.length; i++){
    titleImage.line(titlePoints[i].x, titlePoints[i].y, targetX, targetY);
  }
  titleImage.fill(0);
  titleImage.noStroke();
  titleImage.ellipse(targetX, targetY, 10, 10);
  titleImage.endDraw();
  
  //mask lines with letters (and point)
  titleImage.mask(titleMask);
}

void renderCover(PGraphics graphics, int pageWidthPx, int pageHeightPx, int pageNumber){
  graphics.image(titleImage, 0, 0);
}