import java.util.LinkedList;
import java.util.Queue;


class Building {
  int left_x, right_x, h; 
  Building(int a, int b, int c) {
    left_x = a;
    right_x = b;
    h = c;
  }
};

class Point {
  int x, y;
  Point(int a, int b) {
    x = a;
    y = b;
  }
  void print(){
     System.out.println("("+x +", " + y + ")"); 
  }
};

int randInt(int min, int max) {
  return (int)(Math.random() * (max - min) + min);
}

Building[] Arr;

void setup() {
  size(1500, 500);
  fill(0);
  rect(0, 0, width, height);

  strokeWeight(1);
  noFill();
  drawSkyline();

}

void depthPrint(int depth, String s){
  for (int k = 0; k < depth; k++){
     System.out.print("\t"); 
  }
  System.out.println(s);
}

Queue<Point> SIL(int start, int end, int depth){
  
  depthPrint(depth, "Called on " + start + " to " + end);  
  
  Queue<Point> ans_queue = new LinkedList<Point>();
  if (start == end){
     ans_queue.add(new Point(Arr[start].left_x, Arr[start].h));
     ans_queue.add(new Point(Arr[start].right_x, 0));
     return ans_queue;
  }
  int m = (start+end)/2;
  Queue<Point> sil1_q = SIL(start, m, depth+1);
  Queue<Point> sil2_q = SIL(m+1, end, depth+1);
 
  int height1 = 0, height2 = 0, cur_height = 0;
  
  while (sil1_q.size() > 0 && sil2_q.size() > 0){
     int cur_x = 0;
     if (sil1_q.element().x < sil2_q.element().x){
        height1 = sil1_q.element().y;
        cur_x = sil1_q.element().x;
        sil1_q.remove();
     } else if (sil1_q.element().x > sil2_q.element().x){
        height2 = sil2_q.element().y;
        cur_x = sil2_q.element().x;
        sil2_q.remove();
     } else {
        height1 = sil1_q.element().y;
        height2 = sil2_q.element().y;
        cur_x = sil1_q.element().x;
        sil1_q.remove();
        sil2_q.remove();  
     }
     
     if (max(height1, height2) != cur_height){
        cur_height = max(height1, height2);
        ans_queue.add(new Point(cur_x, cur_height));
     }
  }
  
  while (sil1_q.size() > 0){
     //if (sil1_q.element().y != cur_height){
        cur_height = sil1_q.element().y;
        ans_queue.add(new Point(sil1_q.element().x, cur_height));
        sil1_q.remove();
     //}
  }
  while (sil2_q.size() > 0){
     //if (sil2_q.element().y != cur_height){
        cur_height = sil2_q.element().y;
        ans_queue.add(new Point(sil2_q.element().x, cur_height));
        sil2_q.remove();
     //}
  }  
 

  return ans_queue;
}

void drawCritPoint(int x, int y) {
  stroke(255, 0, 0);
  ellipse(x, height-y, 10, 10);
}

void draw() {
}

void mouseReleased(){
  drawSkyline();
}

int[][] data = {{9,10,11},
    {0,6,6},
    {8,11,6},
    {0,2,3},
    {10,13,9},
    {4,6,2},
    {4,7,2}};

Building[] buildFromInput(int[][] arr, int size){
  Building ans[] = new Building[size];
  for (int k = 0; k < size; k++){
    ans[k] = new Building(10*arr[k][0], 10*arr[k][1], 10*arr[k][2]); //scaled by 10 to cuz we're plotting by pixel value
  }
  return ans;
}

void drawSkyline(){
  fill(0);
  rect(0, 0, width, height);
  noFill();
  stroke(200, 200, 200);

  
  int num_buildings = randInt(5, 20);
  Arr = new Building[num_buildings];
  for (int k = 0; k < num_buildings; k++) {
    int w = randInt(1, 5)*100;
    int leftX = randInt(1, 100)*10;     
    Arr[k] = new Building(leftX, leftX+w, randInt(1, 30)*15);
    System.out.println("{"+Arr[k].left_x+", "+Arr[k].right_x+", " + Arr[k].h + "}" + ", ");
    //drawCritPoint(leftX, Arr[k].h);
    //drawCritPoint(leftX+w, 0);
    //stroke(randInt(100, 255), randInt(100, 255), randInt(100, 255));
    rect(leftX, height-Arr[k].h, w, Arr[k].h);
  }
  
  
  /*uncomment this part if you want to build custom buildings
  Arr = buildFromInput(data, data.length);
  for (int k = 0; k < Arr.length; k++){
    rect(Arr[k].left_x, height-Arr[k].h, Arr[k].right_x-Arr[k].left_x, Arr[k].h);    
  }
  */
  
  Queue<Point> temp = SIL(0, Arr.length-1, 0);
  depthPrint(0, "solution has size: " + temp.size() + ", with " +Arr.length + " buildings");
  int full = temp.size();
  while (temp.size() > 0){
    drawCritPoint(temp.element().x, temp.element().y);
    temp.element().print();
    
    fill(255);
    text(full-temp.size()+1, temp.element().x, height-temp.element().y);
    noFill();
    temp.remove();
  }
  
}