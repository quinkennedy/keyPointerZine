public class Rectangle{
  float x, y, w, h;
  
  public Rectangle(float x, float y, float width, float height){
    this.x = x;
    this.y = y;
    this.w = width;
    this.h = height;
  }
  
  public String toString(){
    return String.format("%1$f,%2$f,%3$f,%4$f",x,y,w,h);
  }
  
  public boolean overlapsWith(Rectangle other){
    if (other.x < this.x + this.w && other.x + other.w > this.x){
      if (other.y < this.y + this.h && other.y + other.h > this.y){
        return true;
      }
    }
    return false;
  }
  
  public Rectangle bloat(int pixels){
    return new Rectangle(x-pixels, y-pixels, w+2*pixels, h+2*pixels);
  }
}