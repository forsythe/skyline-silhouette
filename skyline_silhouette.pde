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
};

int randInt(int min, int max) {
  return (int)(Math.random() * (max - min) + min);
}

final int NUM_BUILDINGS = 10;
Building[] Arr = new Building[NUM_BUILDINGS];

void setup() {
  size(1500, 500);
  fill(0);
  rect(0, 0, width, height);

  strokeWeight(1);
  noFill();
  for (int k = 0; k < NUM_BUILDINGS; k++) {
    int w = randInt(1, 5)*100;
    int leftX = randInt(1, 100)*10;     
    Arr[k] = new Building(leftX, leftX+w, randInt(1, 30)*15);
    //drawCritPoint(leftX, Arr[k].h);
    //drawCritPoint(leftX+w, 0);
    stroke(randInt(100, 255), randInt(100, 255), randInt(100, 255));
    rect(leftX, height-Arr[k].h, w, Arr[k].h);
  }
  
  Queue<Point> temp = SIL(0, NUM_BUILDINGS-1, 0);
  while (temp.size() > 0){
    System.out.println("draw");
    drawCritPoint(temp.element().x, temp.element().y);
    temp.remove();
  }

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
     drawCritPoint(Arr[start].left_x, Arr[start].h));
     ans_queue.add(new Point(Arr[start].right_x, 0));
     return ans_queue;
  }
  int m = (start+end)/2;
  Queue<Point> sil1_q = SIL(start, m, ++depth);
  Queue<Point> sil2_q = SIL(m+1, end, ++depth);
 
  depthPrint(depth, sil1_q.size() + " " + sil2_q.size());
  int height1 = 0, height2 = 0, cur_height = 0;
  
  while (sil1_q.size() > 0 && sil2_q.size() > 0){
     depthPrint(depth, "in while");
     int cur_x = 0;
     if (sil1_q.element().x < sil2_q.element().x){
        height1 = sil1_q.element().y;
        cur_x = sil1_q.element().x;
        sil1_q.remove();
        depthPrint(depth, "added element from sil1");
     } else if (sil1_q.element().x > sil2_q.element().x){
        height2 = sil2_q.element().y;
        cur_x = sil2_q.element().x;
        sil2_q.remove();
        depthPrint(depth, "added element from sil2");        
     } else {
        height1 = sil1_q.element().y;
        height2 = sil2_q.element().y;
        cur_x = sil1_q.element().x;
        sil1_q.remove();
        sil2_q.remove();  
        depthPrint(depth, "added element from both sil1 and sil2");        
     }
     
     if (max(height1, height2) != cur_height){
        cur_height = max(height1, height2);
        ans_queue.add(new Point(cur_x, cur_height));
     }
  }
  
  while (sil1_q.size() > 0){
     if (sil1_q.element().y != cur_height){
        cur_height = sil1_q.element().y;
        ans_queue.add(new Point(sil1_q.element().x, cur_height));
     }
  }
  while (sil2_q.size() > 0){
     if (sil2_q.element().y != cur_height){
        cur_height = sil2_q.element().y;
        ans_queue.add(new Point(sil2_q.element().x, cur_height));
     }
  }  
  System.out.println("in ans queue, ");
  for (Point element : ans_queue) {
  System.out.println("("+element.x + ", "+element.y+")");
}
  return ans_queue;
}

void drawCritPoint(int x, int y) {
  stroke(255, 0, 0);
  ellipse(x, height-y, 10, 10);
}

void draw() {
}