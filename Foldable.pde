class Foldable{
  ZinePageLayout[][][] layout;
  float paperWidth;
  float paperHeight;
  public static final int paperDPI = 72;
  public static final int printDPI = 300;
  int PDFPixelWidth;
  int PDFPixelHeight;
  int printPixelWidth, printPixelHeight;
  PGraphics pdf;
  String pdfName;
  int currPage = 0, currRow = 0, currColumn = 0;
  boolean endOfPdf = false;
  
  public Foldable(float paperWidth, float paperHeight, String pdfName){
    this.paperWidth = paperWidth;
    this.paperHeight = paperHeight;
    PDFPixelWidth = int(paperWidth * paperDPI);
    PDFPixelHeight = int(paperHeight * paperDPI);
    printPixelWidth = int(paperWidth * printDPI);
    printPixelHeight = int(paperHeight * printDPI);
    this.pdfName = pdfName;
    int pageSides = 2;//because double-sided
    //just hard-code it since getLayout doesn't handle thirds yet
    layout = new ZinePageLayout[][][]{
        //paper side A
        {{new ZinePageLayout(11, false, false),new ZinePageLayout(0, false, false)},
         {new ZinePageLayout(6, true, false),new ZinePageLayout(5, true, false)},
         {new ZinePageLayout(9, false, false),new ZinePageLayout(2, false, false)}},
        //paper side B
        {{new ZinePageLayout(1, false, false),new ZinePageLayout(10, false, false)},
         {new ZinePageLayout(4, true, false),new ZinePageLayout(7, true, false)},
         {new ZinePageLayout(3, false, false),new ZinePageLayout(8, false, false)}}};
    pdf = createGraphics(PDFPixelWidth, PDFPixelHeight, PDF, pdfName + ".pdf");
  }
  
  /*
   * returns false if there are no more pages to render
   */
  public boolean renderNextPage(keyPointerZine p){
    if (!endOfPdf){
      ZinePageLayout layoutPage = layout[currPage][currRow][currColumn];
      
      //arrange page for proper positioning
      pdf.beginDraw();
      pdf.pushMatrix();
      pdf.translate(PDFPixelWidth * currColumn / layout[0][0].length,
                    PDFPixelHeight * currRow / layout[0].length);
      if (layoutPage.hFlip){
        pdf.translate(PDFPixelWidth / layout[0][0].length,
                      PDFPixelHeight / layout[0].length);
        pdf.scale(-1, -1);
      }
      pdf.scale(float(paperDPI) / printDPI);
      p.renderPage(pdf, 
                   printPixelWidth / layout[0][0].length, 
                   printPixelHeight / layout[0].length,
                   layoutPage.number);
      pdf.popMatrix();
      
      //update to next zine page
      currColumn++;
      if (currColumn >= layout[0][0].length){
        currColumn = 0;
        currRow++;
        if (currRow >= layout[0].length){
          currRow = 0;
          currPage++;
          if (currPage >= layout.length){
            pdf.dispose();
            endOfPdf = true;
            return false;
          } else {
            ((PGraphicsPDF)pdf).nextPage();
          }
        }
      }
      pdf.endDraw();
    }
    return !endOfPdf;
  }
  
  /**
   * pageNo is 0-indexed (0 is the front cover)
   */
  public PGraphics getPage(int pageNo){
    for(int page = 0 ; page < layout.length; page++){
      for(int row = 0; row < layout[0].length; row++){
        for(int column = 0; column < layout[0][0].length; column++){
          //find the correctly-numbered cell
          if (layout[page][row][column].number == pageNo){
            
          }
        }
      }
    }
    //cell number doesn't exist!
    return null;
  }
}