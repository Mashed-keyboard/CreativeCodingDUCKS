import processing.sound.*;

PImage duck_sprite;
PImage duck_left;
PImage rock_sprite;
PImage start_text;
PImage chair_sprite;
ArrayList<duck> DUCKS = new ArrayList();
ArrayList<prop> PROPS = new ArrayList();
SoundFile quiack,quack;
SoundFile[] sounds;
boolean start;
boolean lecture;
int students;
static String[] lectures;
String text;
color screen = color(55,170,55);

void scenery() {
  background(screen);
  for (prop objects: PROPS)  {
    //if (mouseX > PROPS.get(p).Posx && mouseX < PROPS.get(p).Posx + 50 && mouseY > PROPS.get(p).Posy && mouseY < PROPS.get(p).Posy + 50) {
      objects.appear();
  }
}

void setup() {
  noStroke();
  randomSeed(3);
  DUCKS.clear();
  PROPS.clear();
  text = "Main Menu";
  start=false;
  screen = color(55,170,55);
  lecture = false;
  lectures = loadStrings("Lecture_Data.csv");
  //size(500,500,P3D);
  size(500,500);
  frameRate(60);
  fill(255,255,255);
  
  duck_sprite = loadImage("duck.png"); //loading sprites
  duck_sprite.resize(40,40);
  duck_left = loadImage("duckleft.png");
  duck_left.resize(40,40); 
  chair_sprite = loadImage("chair.png");
  chair_sprite.resize(22,22);
  rock_sprite = loadImage("rock.png");
  rock_sprite.resize(50,50);
  start_text = loadImage("start.png");
  start_text.resize(250,150);
  

  quiack = new SoundFile(this,"quack-terraria.mp3");
  quack = new SoundFile(this,"quack_5.mp3");
  quiack.amp(10);
  sounds = new SoundFile[2];
  sounds[0] = quiack;
  sounds[1] = quack;
  
  
  //-----------
  
  for (int x=0 ; x<10; ++x) { //I made 10 test ducks to work with using a for loooop!!
    DUCKS.add(new duck());
  }  
    
  for (int i=0; i<15; ++i) { //4 testrocks
    PROPS.add(new prop(rock_sprite));
  }
  PROPS.add(new button(start_text,width/2-100,height/4));
}

void keyPressed() {
  if (keyCode == 10) { //10 is ASCII code for enter
    println("enter");
    start = true;
  }
  if (keyCode == 8) {//8 is ASCII code for backspace
    println("backspace");
    setup();
  }
}

void draw() {
  
  //------------
    //keep loop running and add items when neccessary
    scenery();
    for (duck bird: DUCKS) {
      bird.update();
    }
    for (prop objects:PROPS) {
      objects.update();
    }
    textSize(50);
    text(text,width/2-100,50);
    
    if (start == true) {
    //How should i represent lecture data
      DUCKS.clear();
      PROPS.clear();
      screen = color(55,170,55);
      text = "LECTURES";
      int line = 80;
      int distance = 20;
      
      for (String word : lectures)  { //map xPos to %width so it restarts at the front and increment height
        String[] info = split(word,",");
        if (distance>width-100) {
          line += 85;
          distance=20;
        }
        PROPS.add(new button(info,distance%width,line));
        distance += 150;
        //println(distance + " " + line);
        
     
    
      }
      start = false;
    }
    
    if (lecture == true) { //do we do lecture like this or do we make a 
        PROPS.clear();
        lecture(students);
        println(students);
        lecture = false;
    }
      
    }
// ------------------------------------------------------

class duck {
  //float xPos;
  //float yPos;
  PVector Pos;
  int period;
  int rest;
  PVector waypoint; //noise could be useful, around width and height perhaps
  PImage sprite=duck_sprite;
  
  duck() { // Maybe Add ducks can pop, makes ducks quack faster, spawns two smaller faster ducks
   //this.xPos = random(0,width);
   //this.yPos = random(0,height);
   
   this.period = int(random(300,1500)); //quack frequency, should decrease if you're adding more ducks
   this.rest = int(random(400,1000)); //Frequency they move around , can be hashed if using static positions
   this.Pos = new PVector(random(0,width-50),random(0,height-50)); 
   this.waypoint = Pos.copy();
   
  }
  
  duck(int X, int Y) {
   this.period = int(random(300,1500)); //quack frequency, should decrease if you're adding more ducks
   this.rest = int(random(400,1000)); //Frequency they move around , can be hashed if using static positions
   this.Pos = new PVector(X,Y); 
   this.waypoint = Pos.copy();
    
  }
  
  void quack() { 
   int rand = int(random(0,1.9));
   sounds[rand].rate(random(0.3,2)); //set to 1.9 because it rounds down
   sounds[rand].play();
 }
 
  void move() { //needs to do borders - random movement
    //this.xPos = map(random(0,6),0,20,0,width);
    //this.yPos = map(random(0,6),0,20,0,height);
    //PVector direction  = PVector.sub(Pos,waypoint);
    //if (Pos.x < width-200 || Pos.x > 0 && Pos.x != waypoint.x) {
    
    PVector direction = Pos.copy().sub(waypoint).limit(1.3);
    Pos.x -= direction.x;
    //}
    //if (Pos.y < height-200 || Pos.y > 0 && Pos.y != waypoint.y) {
    Pos.y -= direction.y;
    //}
    if (direction.x>0) { this.sprite=duck_left; } else { this.sprite=duck_sprite; }
  }
  
  void appear() { //Somehow make animation
    image(this.sprite,Pos.x,Pos.y);
  }
  
  void waypoint() { //generate a new waypoint every period
    //waypoint.limit(5); //Could encounter issues when running into border, maybe use mapping to take current position minus x and y to find next waypoint
    waypoint.x = random(50,width-50); //definitely going to run into out of bounds error.
    waypoint.y = random(50,height-50); // should set a waypoint somewhere on the screen, can worry about magnitude limits later
    //visual drawing of waypoint
    //circle(waypoint.x,waypoint.y,20); 
  }
  
  void waypoint(float x, float y) { //can manually set waypoint (setter) but needs to override period somehow
    this.rest = 0; // now disables waypoint generation.
    waypoint.x = x;
    waypoint.y = y;
  }
  
  void update() {
    this.move();
    this.appear();
    
    if ((frameCount+600) % this.period == 0) {
      this.quack();
    }
    if ((frameCount+600) % this.rest == 0 && period != 0) {
      this.waypoint(); //The idea is a new waypoint gets generated // need to disable generation in lecture hall
    }
    
  }
 } //How do we make a superclass for duck to say, make other animals

 // ------------------------------------------------------------
 
 class prop {
   int Posx;
   int Posy;
   PImage sprite;
   
   prop() { //default empty constructor for subclasses
     
   }
   
   prop(PImage image) {
     Posx = int(random(50,width-50));
     Posy = int(random(50,height-50));
     sprite = image;
   }
   
   prop(PImage image, int X, int Y) {
    Posx = X;
    Posy = Y;
    sprite = image;
   }
     
   
   
   void appear() {
     image(this.sprite,this.Posx,this.Posy);
   }
   
   void update() { //no changes
   }
   
   
 }
 
 class button extends prop {
   String[] info; //1 lecture name, 2 date, 3 day, 4 students, 5 time
   
   button(PImage image,int X,int Y) {
     this.Posx = X;
     this.Posy = Y;
     sprite = image;
   }
   
   button(String[] info, int X, int Y) {
    this.Posx = X;
    this.Posy = Y;
    this.info = info;
   }
   
   void appear() {
    tint(255,int(map(frameCount%20,0,20,172,220)));
    if (this.sprite == null) {
      rect(this.Posx,this.Posy,140,70);
      fill(0);
      textSize(20);
      text(this.info[0],this.Posx+5,this.Posy+30);
      text(this.info[1],this.Posx+5,this.Posy+50);
      textSize(10);
      text(this.info[2],this.Posx+5,this.Posy+60); //index 4 is a string
      fill(255);
    } else {image(this.sprite,this.Posx, this.Posy);}
    noTint();
   }
   
   void update() {
    if (mouseX > this.Posx && mouseX < this.Posx + 150 && mouseY > this.Posy && mouseY < this.Posy+70) {
      
    }
    if (mousePressed && mouseX > this.Posx && mouseX < this.Posx + 150 && mouseY > this.Posy && mouseY < this.Posy+70) {
      println("Pressed "+this.Posx+" "+this.Posy); //should make a funtion mapped to a button this.func(function)
      //lecture(int(this.info[3]));
      try {
      students = int(this.info[3]);
      lecture = true;
      } catch (Exception NullPointer) {
        start = true;
      }
    }
   }
 }
 
 void lecture(int people) {
  lecture = true;
  text = "";
  
  screen = color(255,255,255);
  int line = 20;
  int distance = 20;
  duck_sprite.resize(20,20);
  duck_left.resize(20,20);
  for (int i=1; i<int(people/2); ++i) {
    if (distance > width/2-40) {
      line += 20;
      distance = 20;
    }
    
     
    DUCKS.add(new duck(distance,line));
    PROPS.add(new prop(chair_sprite,distance,line)); //  ConcurrentModificationException interferes with for each loop
    distance += 20;
  }
  line = 20;
 for (int i=1; i<int(people/2); ++i) {
    if (distance > width-40) {
      line += 20;
      distance = width/2+40; //make it add 20 or 40 randomly so there are gaps in the seating
    }
    
    DUCKS.add(new duck(distance,line));
    PROPS.add(new prop(chair_sprite,distance,line));
    distance += 20;
  }
  
  DUCKS.add(new duck(width/2,height-50)); //nearly forgot the lecturer
 }
