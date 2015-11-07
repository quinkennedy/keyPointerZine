import geomerative.*;

RShape titleShape;
RPoint[] titlePoints;
PGraphics titleImage;

void initCover(){
  RG.init(this);
  String title = "Key Point";
  String font = "SourceSansPro-Black.ttf";
  int titleSize = 200;
  titleShape = RG.getText(title, font, titleSize, CENTER);//magic numbers!
  int titleFidelity = 20;
  RG.setPolygonizer(RG.UNIFORMLENGTH);
  RG.setPolygonizerLength(titleFidelity);//magic numbers!
  titlePoints = titleShape.getPoints();
}

void prepCover(int pageWidthPx, int pageHeightPx, int pageNumber){
  titleImage = createGraphics(pageWidthPx, pageHeightPx, P2D);
  titleImage.beginDraw();
  titleImage.background(255);
  titleImage.translate(pageWidthPx / 2, pageHeightPx / 2);
  int targetX = this.targetX - pageWidthPx / 2;
  int targetY = this.targetY - pageHeightPx / 2;
  titleImage.noStroke();
  titleImage.fill(0);
  titleShape.draw(titleImage);
  titleImage.blendMode(LIGHTEST);
  titleImage.stroke(255);
  for(int i = 0; i < titlePoints.length; i++){
    titleImage.line(titlePoints[i].x, titlePoints[i].y, targetX, targetY);
  }
  titleImage.blendMode(BLEND);
  titleImage.ellipse(targetX, targetY, 10, 10);
  titleImage.endDraw();
}

void renderCover(PGraphics graphics, int pageWidthPx, int pageHeightPx, int pageNumber){
  graphics.image(titleImage, 0, 0);
}