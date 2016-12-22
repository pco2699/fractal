import java.util.ArrayList;
import gifAnimation.*;

GifMaker gifExport;
float add, radius, a;
int n, poly, b;
ArrayList<Point> radList;

void setup(){
  radius = 150;
  poly = 3;
  n = 30;
  add = 0;
  a = 0.01;
  b = 1;
  
  size(300, 300);
  background(255);
  
  frameRate(50);

  gifExport = new GifMaker(this, "export.gif");
  gifExport.setRepeat(0);
  gifExport.setQuality(10);
  gifExport.setDelay(20);
}

void draw(){
  background(255);
  radList = new ArrayList<Point>();
  add += a;
  if(add > 1 || add < 0){
    poly += b;
    if(poly > 7)
      b = -1;
    else if(poly < 3)
      b = 1;
      
    if(add > 1){
      a = -0.01;
    }
    else if(add < 0)
      a = 0.01;
  }
      
  for(int rad = 0; rad < 360; rad++){
    float x, y, radians;
    if(rad % (360 / poly) == 0){
      radians = radians(rad);
      x = width/2 + radius * cos(radians);
      y = height/2 + radius * sin(radians);
      Point point = new Point(x, y);
      radList.add(point);
    }
  }
  drawTriangle(radList, n, add);
  if(frameCount <= 50*12){
    gifExport.addFrame();
  } else {
    gifExport.finish();
  }
}

void drawTriangle(ArrayList<Point> arList, int n, float add){
  float x, y, prevX = -999, prevY = -999, firstX = -999, firstY = -999;
  for(Point p : arList){
    x = p.getX();
    y = p.getY();
    if(prevX > -999){
      line(x, y, prevX, prevY);
    }
    else{
      firstX = x;
      firstY = y;
    }
    prevX = x;
    prevY = y;
  }
  line(prevX, prevY, firstX, firstY);
  if(n > 0){
    n--;
    ArrayList<Point> middleList = getIn(arList, add);
    drawTriangle(middleList, n, add); //<>//
  }
}

ArrayList<Point> getMiddle(ArrayList<Point> arList){
  float x, y, prevX = -999, prevY = -999, firstX = -999, firstY = -999;
  ArrayList<Point> middleList = new ArrayList<Point>();
  for(Point p : arList){
    x = p.getX();
    y = p.getY();
    if(prevX > -999){
      Point m = new Point((x + prevX) / 2, (prevY + y) / 2);
      middleList.add(m);
    }
    else{
      firstX = x;
      firstY = y;
    }
    prevX = x;
    prevY = y;
  }
  
  Point m = new Point((firstX + prevX) / 2, (firstY + prevY) / 2);
  middleList.add(m);
  
  return middleList;
}

ArrayList<Point> getIn(ArrayList<Point> arList, float add_x){
  float x = 0, y = 0, prevX = -999, prevY = -999, firstX = -999, firstY = -999;
  ArrayList<Point> middleList = new ArrayList<Point>();
  for(Point p : arList){
    x = p.getX();
    y = p.getY();
    if(prevX > -999){
      Point m = new Point(x + (prevX - x) * add_x,  y + add_x * (prevY - y));
      middleList.add(m);
    }
    else{
      firstX = x;
      firstY = y;
    }
    prevX = x;
    prevY = y;
  }
  
  Point m = new Point(firstX + (prevX - firstX) * add_x,  firstY + add_x * (prevY - firstY));
  middleList.add(m);
  
  return middleList;
}

class Point {
  float x, y;
  
  Point(float x, float y){
    this.x = x;
    this.y = y;
  }
  float getX(){
    return this.x;
  }
  float getY(){
    return this.y;
  }
}