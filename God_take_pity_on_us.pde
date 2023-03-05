// VARIABLES
int enemies;
int obstaculos;
int vidas;
PImage boost_plus;
PImage boost_minus;
PImage boost_lives;

// classes
player jugador;
friend amigo;

//vida y tiempo
int countdown;

//para distancia entre jugador y friend
float vxf, vyf, modulof;

//variables para el enemigo
int x;
int y;
enemy[] sistema_enemies;

//distancia entre friend y enemies
float []vxef = new float[enemies];
float []vyef = new float[enemies];
float []moduloef = new float [enemies];

//distancia entre player y enemies
float []vxep = new float[enemies];
float []vyep = new float[enemies];
float []moduloep = new float[enemies];

//obstaculos
PVector[] cajas;
int []alto_caja = new int[obstaculos];
int []ancho_caja = new int[obstaculos];

//temporizador
int startTime; 
int counter; 
int maxTime; 
boolean timeOver;


//CLASES

//Class Boost
class boost 
{
  float[] boostPos = new float [3];
  int anchura;
  int altura;
  
  boost(int a, int h)
  {
   anchura = a;
   altura = h;
  }

  void moreLives()
  {
    vidas ++;
  }

   void ralentize (enemy[] e, int time)
{
   int previousSeconds = second();
 
   
   for(int i = 0; i < enemies; i++)
   {
    e[i].alfa = e[i].alfa/2;
   }
   
   if (second() >= previousSeconds + time)
   {
    for(int i = 0; i < enemies; i++)
   {
    e[i].alfa = e[i].alfa*2;
   } 
   }
  
}
      void faster (enemy[] e, int time)
{
   int previousSeconds = second();
   
   
   for(int i = 0; i < enemies; i++)
   {
     
    e[i].alfa = e[i].alfa + e[i].alfa/2 ;
   }
   if (second() >= previousSeconds + time)
   {
     for(int i = 0; i < enemies; i++)
   {
    e[i].alfa = e[i].alfa - e[i].alfa/3;
   }
   }
   
}
}

//Clase player

class player
{
  float [] playerPos = new float[2];
  color color_p;
  int anchura;
  int altura;
  float speed = 5;
  player( float x, float y, color c, int a, int h)
  {
    playerPos[0] = x;
    playerPos[1] = y;
    color_p = c;
    anchura = a;
    altura = h;
  }


  void Movement(int x, int direction, enemy[] e)
  {
    if (speed > 0) {
      playerPos[x] += speed*direction;
    }
    else {
      playerPos[x] -= 10;
      speed = 0;
    }
   //Con enemies
   for (int i = 0; i < enemies; i++)
   {
    if (colisionRectRect(playerPos[0],playerPos[1], anchura, altura, e[i].xPNJ , e[i].yPNJ, e[i].anchura, e[i].altura))
    {
      e[i].alive = false;
    }
   }
   //Con obstaculos
   for (int i = 0; i < obstaculos; i ++)
   {
    if (colisionRectRect(playerPos[0],playerPos[1], anchura, altura, cajas[i].x , cajas[i].y, ancho_caja[i], alto_caja[i]))
    {
      vidas --;
    }
   }
   // boosts
   
   //el resto
 

  }
  void print_p()
  {
    fill(color_p);
   rectMode(CENTER);
   rect(playerPos[0], playerPos[1], anchura, altura);
  }
  
}


//Clase friend

class friend
{
  float[] friendPos = new float[2];
  color color_f;
  int anchura;
  int altura;
  float  alfaFriend;
  friend (float x, float y, color c, int a, int h, float deltaT)
  {
    friendPos[0] = x;
    friendPos[1] = y;
    color_f = c;
    anchura = a;
    altura = h;
    alfaFriend = deltaT;
  }

  void print_f()
  {
    fill(color_f);
    rectMode(CENTER);
    rect(friendPos[0], friendPos[1], anchura, altura);
  }
  void Movement(player p)
  {
  friendPos[0] = friendPos[0] + alfaFriend*(p.playerPos[0]-friendPos[0]);
  friendPos[1] = friendPos[1] + alfaFriend*(p.playerPos[1]-friendPos[1]);

  }

}


//clase enemy

class enemy
{
  float xPNJ;
  float yPNJ;
  float alfa;
  int anchura;
  int altura;
  color color_e;
  boolean alive = true;
  enemy(float x, float y, color c, int a, int h, float deltaT)
  {
    xPNJ = x;
    yPNJ = y;
    color_e = c;
    anchura = a;
    altura = h;
    alfa = deltaT;
  }

  void print_e()
  {
    if(alive)
    {
    fill(color_e);
    rectMode(CENTER);
    rect(xPNJ, yPNJ, anchura, altura);
    }
  }
  //friend
  
}

//Events
boolean colisionRectRect(float x1, float y1, int ancho1, int alto1, float x2, float y2, int ancho2, int alto2) {
  // Calcula la mitad de los anchos y altos
  float mitadAncho1 = ancho1 / 2;
  float mitadAlto1 = alto1 / 2;
  float mitadAncho2 = ancho2 / 2;
  float mitadAlto2 = alto2 / 2;

  // Calcula los centros de los rectángulos
  float centroX1 = x1 + mitadAncho1;
  float centroY1 = y1 + mitadAlto1;
  float centroX2 = x2 + mitadAncho2;
  float centroY2 = y2 + mitadAlto2;

  // Calcula las distancias entre los centros de los rectángulos en cada eje
  float distanciaX = abs(centroX1 - centroX2);
  float distanciaY = abs(centroY1 - centroY2);

  // Comprueba si hay colisión en cada eje
  if (distanciaX <= mitadAncho1 + mitadAncho2 && distanciaY <= mitadAlto1 + mitadAlto2) {
    return true;
  }
  else {
    return false;
  }
}



//CÓDIGO


//SETUP

void setup() {
  size(1300, 900);
  countdown = 60;

  enemies = 10;
  obstaculos = 10;

  jugador = new player(50.0, height/2.0, color(255, 0, 0), 15, 15) ;
  amigo = new friend(width/2.0, height/2.0, color(0, 255, 0), 15, 15, 0.13) ;
  sistema_enemies = new enemy[enemies];


  boost_plus = loadImage("flecha_mas.png");
  boost_minus = loadImage("flecha_menos.png");
  boost_lives = loadImage("corazon.png");

  //posiciones iniciales

  for (int i = 0; i < enemies; i++)
  {
    float posicion = random(0, 4);
    if (0 <= posicion || posicion < 1)
    {
      x = 325;
      y = 225;
    } else if (1 <= posicion || posicion < 2)
    {
      x= 975;
      y= 225;
    } else if (2<= posicion || posicion <3)
    {
      x = 325;
      y = 675;
    } else if (3<=posicion|| posicion <=4)
    {
      x = 975;
      y = 675;
    }
    sistema_enemies[i] = new enemy(x, y, color(0, 0, 255), 15, 15, random(0.015, 0.08));
  }
  
  //cajas/obstaculos

  cajas = new PVector[obstaculos];
  alto_caja = new int[obstaculos];
  ancho_caja = new int[obstaculos];
  for (int i = 0; i < obstaculos; i++)
  {
    alto_caja[i] = (int)random (50, 150);
    ancho_caja[i] = (int)random (50, 150);
    float x = random(ancho_caja[i], width - ancho_caja[i]);
    float y = random(alto_caja[i], height - alto_caja[i]);
    cajas[i] = new PVector(x, y);
  }
  
  //temporizador
  startTime = millis();
  counter = 0;
  maxTime = 60000; 
  timeOver = false;
  if(millis() == 60000)
  {
      size(1300, 900);
      background(255);
      println("Game Over");
  }
  
}



//DRAW


void draw() {
  background (0); //fondo negro

  //1.calcular

  //colisiones player
keyPressed();
  if(colisionRectRect(amigo.friendPos[0], amigo.friendPos[1], amigo.anchura*50, amigo.altura*50,
  jugador.playerPos[0], jugador.playerPos[1], jugador.anchura, jugador.altura))
  {
amigo.Movement(jugador);
  }
  
  for (int i = 0; i < enemies/2; i++)
  {
    sistema_enemies[i].xPNJ = sistema_enemies[i].xPNJ + sistema_enemies[i].alfa * (amigo.friendPos[0] - sistema_enemies[i].xPNJ);
    sistema_enemies[i].yPNJ = sistema_enemies[i].yPNJ + sistema_enemies[i].alfa * (amigo.friendPos[1] - sistema_enemies[i].yPNJ);
    sistema_enemies[i].xPNJ = sistema_enemies[i].xPNJ - sistema_enemies[i].alfa * (jugador.playerPos[0] - sistema_enemies[i].xPNJ)*0.3;
    sistema_enemies[i].yPNJ = sistema_enemies[i].yPNJ - sistema_enemies[i].alfa * (jugador.playerPos[1] - sistema_enemies[i].yPNJ)*0.3;
      if (colisionRectRect(sistema_enemies[i].xPNJ, sistema_enemies[i].yPNJ, sistema_enemies[i].anchura, sistema_enemies[i].altura, 
  amigo.friendPos[0], amigo.friendPos[1], amigo.anchura, amigo.altura))
  {
   vidas--; 
  }
  }
  for(int i = enemies/2; i < enemies; i++)
  {
    //intento de randoms
    sistema_enemies[i].xPNJ = sistema_enemies[i].xPNJ + sistema_enemies[i].alfa * (random(width) - sistema_enemies[i].xPNJ);
    sistema_enemies[i].yPNJ = sistema_enemies[i].yPNJ + sistema_enemies[i].alfa * (random(height) - sistema_enemies[i].yPNJ);
    sistema_enemies[i].xPNJ = sistema_enemies[i].xPNJ - sistema_enemies[i].alfa * (jugador.playerPos[0] - sistema_enemies[i].xPNJ)*0.3;
    sistema_enemies[i].yPNJ = sistema_enemies[i].yPNJ - sistema_enemies[i].alfa * (jugador.playerPos[1] - sistema_enemies[i].yPNJ)*0.3;
      if (colisionRectRect(sistema_enemies[i].xPNJ, sistema_enemies[i].yPNJ, sistema_enemies[i].anchura, sistema_enemies[i].altura, 
  amigo.friendPos[0], amigo.friendPos[1], amigo.anchura, amigo.altura))
  {
   vidas--; 
  }
  }

  
  

  //2.pintar
  
  //Jugador
  
  jugador.print_p();
  amigo.print_f();
  for (int i = 0; i < enemies; i++)
  {
    sistema_enemies[i].print_e();
  }
  fill(255);
  rectMode(CENTER);

  for (int i = 0; i < obstaculos; i++)
  {
    rect(cajas[i].x, cajas[i].y, ancho_caja[i], alto_caja[i]);
  }

  fill(255);
  textSize(24);
  text("Vidas: " + vidas, 20, 30);
  
  if (counter-startTime < maxTime) {
    counter=millis();
  }
  else{
  timeOver = true;
  }
  
  fill(244,3,3);
  noStroke();
  rect(120,70,map((maxTime - (counter) - startTime),0,maxTime,0,200), 20 );
  text("Tiempo restante: " + ((maxTime - (counter - startTime))/1000.0), 20, 55);
  noFill();
}



//EVENTOS


//Movimiento teclado

void keyPressed() {
  switch(key)
  {
  case 'w':
    jugador.Movement(1, -1, sistema_enemies);
    break;
  case 'a':
    jugador.Movement(0, -1, sistema_enemies);
    break;
  case 's':
    jugador.Movement(1, 1, sistema_enemies);
    break;
  case 'd':
    jugador.Movement(0, 1, sistema_enemies);
    break;
  default:
    break;
  }
}


/*void mouseMoved()
 {
 playerPos[0] = mouseX;
 playerPos[1] = mouseY;
 
 }*/

//clase player

//clase friend

//clase enemigo


/*void print_p()
  {
    if ((playerPos[0] > 10.0) && (playerPos[0] < width -10.0)
      &&(playerPos[1] > 10.0) && (playerPos[1] < height-10.0)) {
      fill(color_p);
      ellipse(playerPos[0], playerPos[1], radio*2.0, radio*2.0);
    } else {
      if (playerPos[0] < 10.0)
      {
        playerPos[0] = width - 11.0;
      } else if (playerPos[0] > width -10.0)
      {
        playerPos[0] = 11.0;
      } else if (playerPos[1] < 10.0)
      {
        playerPos[1] = height -11.0;
      } else if (playerPos[1] < height-10.0)
      {
        playerPos[1] = 11.0;
      }
    }
  }*/
