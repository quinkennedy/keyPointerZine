//naming convention:
// descriptiveName[In | [Pdf | Print]Px]

class Foldable{
  ZinePageLayout[][][] layout;
  
  //sheet-of-paper/pdf page measurements
  float paperWidthIn;
  float paperHeightIn;
  int paperWidthPdfPx, paperHeightPdfPx;
  int paperWidthPrintPx, paperHeightPrintPx;
  public static final int pdfDPI = 72;
  public static final int printDPI = 300;
  
  //page-specific measurements
  //(zine pages, not pieces of paper/pdf pages)
  float pageMarginIn;
  float pageWidthIn, pageHeightIn;
  int pageWidthPrintPx, pageHeightPrintPx;
  int pageWidthPdfPx, pageHeightPdfPx;
  int pageMarginPrintPx, pageMarginPdfPx;
  
  int numCopies;
  PGraphics pdf;
  String pdfName;
  int currCopy = 0, currPaperSide = 0, currRow = 0, currColumn = 0, currPageIndex = 0;
  boolean endOfPdf = false;
  
  boolean forPrint = true;
  
  public Foldable(float paperWidth, float paperHeight, float pageMargin, int numCopies, String pdfName){
    this.paperWidthIn = paperWidth;
    this.paperHeightIn = paperHeight;
    this.pageMarginIn = pageMargin;
    this.numCopies = numCopies;
    paperWidthPdfPx = int(paperWidth * pdfDPI);
    paperHeightPdfPx = int(paperHeight * pdfDPI);
    pageMarginPdfPx = int(pageMargin * pdfDPI);
    paperWidthPrintPx = int(paperWidth * printDPI);
    paperHeightPrintPx = int(paperHeight * printDPI);
    pageMarginPrintPx = int(pageMargin * printDPI);
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
    pageWidthPrintPx = paperWidthPrintPx / layout[0][0].length - 2 * pageMarginPrintPx;
    pageHeightPrintPx = paperHeightPrintPx / layout[0].length - 2 * pageMarginPrintPx;
    pageWidthPdfPx = paperWidthPdfPx / layout[0][0].length - 2 * pageMarginPdfPx;
    pageHeightPdfPx = paperHeightPdfPx / layout[0].length - 2 * pageMarginPdfPx;
    if (forPrint){
      pdf = createGraphics(paperWidthPdfPx, paperHeightPdfPx, PDF, pdfName + ".pdf");
    } else {
      pdf = createGraphics(pageWidthPdfPx + 2 * pageMarginPdfPx, pageHeightPdfPx + 2 * pageMarginPdfPx, PDF, pdfName + ".pdf");
    }
    pageWidthIn = paperWidthIn / layout[0][0].length - 2 * pageMarginIn;
    pageHeightIn = paperHeightIn / layout[0].length - 2 * pageMarginIn;
  }
  
  /*
   * returns false if there are no more pages to render
   */
  public boolean renderNextPage(keyPointerZine p){
    if (!endOfPdf){
      ZinePageLayout layoutPage = layout[currPaperSide][currRow][currColumn];
      
      //initialize copy before first zine page
      if (currPaperSide == 0 && currRow == 0 && currColumn == 0){
        p.initCopy(currCopy, 
                   pageWidthPrintPx,
                   pageHeightPrintPx,
                   pageWidthIn,
                   pageHeightIn);
      }
      
      //prep next page to allow for pre-rendering to other graphics contexts
      p.prepPage(pageWidthPrintPx,
                 pageHeightPrintPx,
                 forPrint ? layoutPage.number : currPageIndex);
                 
      //arrange page for proper positioning
      pdf.beginDraw();
      pdf.pushMatrix();
      pdf.scale(float(pdfDPI) / printDPI);
      pdf.translate(pageMarginPrintPx, pageMarginPrintPx);
      if (forPrint){
        pdf.translate(paperWidthPrintPx * currColumn / layout[0][0].length,
                      paperHeightPrintPx * currRow / layout[0].length);
        if (layoutPage.hFlip){
          pdf.translate(pageWidthPrintPx,
                        pageHeightPrintPx);
          pdf.scale(-1, -1);
        }
      }
      p.renderPage(pdf,
                   pageWidthPrintPx,
                   pageHeightPrintPx,
                   forPrint ? layoutPage.number : currPageIndex);
      pdf.popMatrix();
      
      //update to next zine page
      currColumn++;
      currPageIndex++;
      if (currColumn >= layout[0][0].length){
        currColumn = 0;
        currRow++;
        if (currRow >= layout[0].length){
          currRow = 0;
          currPaperSide++;
          if (currPaperSide >= layout.length){
            currPaperSide = 0;
            currPageIndex = 0;
            currCopy++;
            if (currCopy >= numCopies){
              pdf.dispose();
              endOfPdf = true;
            } else {
              ((PGraphicsPDF)pdf).nextPage();
            }
          } else {
            ((PGraphicsPDF)pdf).nextPage();
          }
        } else {
          if (!forPrint){
            ((PGraphicsPDF)pdf).nextPage();
          }
        }
      } else {
        if (!forPrint){
          ((PGraphicsPDF)pdf).nextPage();
        }
      }
      if (!endOfPdf){
        pdf.endDraw();
      }
    }
    return !endOfPdf;
  }
}