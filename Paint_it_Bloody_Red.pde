// VARIABLES

int enemies = 10;
int obstaculos = 15;
int lives = 100;
int vidas = 1;
int gameFinished;
//boosts
PImage boost_plus;
PImage boost_minus;
PImage boost_lives;
PImage portal;

boolean plusalive;
boolean minusalive;
boolean livesalive;

PVector[] boosts;

float [] xPNJ = new float[enemies];
float [] yPNJ = new float[enemies];
float [] alfa = new float[enemies];

float alfaFriend;
float radio;

//para distancia entre jugador y friend
float vxf, vyf, modulof;

//distancia entre friend y enemies
float [] vxef = new float[enemies];
float [] vyef = new float[enemies];
float [] moduloef = new float[enemies];
float [] vxep = new float[enemies];
float [] vyep = new float[enemies];
float [] moduloep = new float[enemies];
float [] vxpb = new float[3];
float [] vypb = new float[3];
float [] modulopb = new float[3];
float vxpp;
float vypp;
float modulopp;

float [] portalPos = new float[2];

float [] playerPos = new float[2];
float [] friendPos = new float[2];

//obstaculos
PVector [] cajas;
int ancho_caja;
int alto_caja;
color [] color_caja = new color[obstaculos];

//speed
int omega = 15;
//SETUP
void setup() {
  size(1300, 900);
  gameFinished = 0;

  boost_plus = loadImage("flecha_mas.png");
  boost_minus = loadImage("flecha_menos.png");
  boost_lives = loadImage("corazon.png");
  portal = loadImage("portal.png");

  boosts = new PVector[3];

  for (int i = 0; i < 3; i++)
  {
    float x = random(width-50);
    float y = random(height-50);
    boosts[i] = new PVector(x, y);
  }
  plusalive = true;
  minusalive = true;
  livesalive = true;

  radio = 17.5;
  cajas = new PVector[obstaculos];
  //inicializar jugador
  playerPos[0] = 50;
  playerPos[1] = height/2.0;
  //inicializar friend
  friendPos[0] = 780;
  friendPos[1] = height/2.0;
  alfaFriend = 0.13;

  //pedir valor enemies al jugador

  //inicializar enemies
  for (int i = 0; i<enemies; i++)
  {
    xPNJ[i] = random(0, width);
    yPNJ[i] = random(0, height);
    alfa[i] = random (0.015, 0.09);
  }
  //inicializar obstaculos
  ancho_caja = 50;
  alto_caja = 50;
  for (int i = 0; i < obstaculos; i++)
  {
    float x = random(ancho_caja, width-ancho_caja);
    float y = random(alto_caja, height-alto_caja);
    cajas[i] = new PVector(x, y);
    color_caja[i] = color(0, random(0, 255), 255);
  }
  portalPos[0] = random(width/8,width/2+width/4);
  portalPos[1] = random(height/8, height/2+height/4);
}

//temporizador
int startTime = millis();
int counter = 0;
int maxTime = 60000;
boolean timeOver = false;


//DRAW
void draw() {
  if (vidas > 0 || millis() > 60000)
  {
    background (0); //fondo negro

    //1.calcular
    vxpp = playerPos[0] - portalPos[0];
    vypp = playerPos[1] - portalPos[1];
    modulopp = sqrt(vxpp*vxpp+vypp*vypp);

    vxf = playerPos[0] - friendPos[0];
    vyf = playerPos[1] - friendPos[1];
    modulof = sqrt(vxf*vxf+vyf*vyf);
    for (int i = 0; i < enemies; i++)
    {
      //calcular la distancia friend enemy para saber si colisionan
      vxef[i] = friendPos[0] - xPNJ[i];
      vyef[i] = friendPos[1] - yPNJ[i];
      moduloef[i] = sqrt(vxef[i]*vxef[i]+vyef[i]*vyef[i]);
      //calcular la distancia player enemy para saber si colisionan
      vxep[i] = playerPos[0] - xPNJ[i];
      vyep[i] = playerPos[1] - yPNJ[i];
      moduloep[i] = sqrt(vxep[i]*vxep[i]+vyep[i]*vyep[i]);
    }
    //boost 1 = plus / boost 2 = minus / boost 3 = lives
    for (int i = 0; i < 3; i++)
    {
      vxpb[i] = playerPos[0] - boosts[i].x;
      vypb[i] = playerPos[1] - boosts[i].y;
      modulopb[i] = sqrt(vxpb[i]*vxpb[i]+vypb[i]*vypb[i]);
    }
    //plus
    if (modulopb[0] <= radio*2.0)
    {
      for (int i = 0; i < enemies; i++)
      {
        alfa[i] += 0.5;
      }
      plusalive = false;
      boosts[0].x = 3000;
      gameFinished++;
    }
    //minus
    if (modulopb[1] <= radio*2.0)
    {
      for (int i = 0; i < enemies; i++)
      {
        alfa[i] -=0.3;
      }
      minusalive = false;
      boosts[1].x = 3000;
            gameFinished++;

    }
    //lives
    if (modulopb[2] <= radio*2.0)
    {
      for (int i = 0; i < enemies; i++)
      {
        vidas += 1;
      }
      livesalive = false;
      boosts[2].x = 3000;
            gameFinished++;

    }
    // pintar
    if (plusalive)
    {
      image(boost_plus, boosts[0].x, boosts[0].y, radio*2.0, radio*4.0);
    }
    if (minusalive)
    {
      image(boost_minus, boosts[1].x, boosts[1].y, radio*2.0, radio*4.0);
    }
    if (livesalive)
    {
      image(boost_lives, boosts[2].x, boosts[2].y, radio*2.0, radio*4.0);
    }

    rectMode(CENTER);
    for (int i = 0; i<obstaculos; i++) {
      fill(color_caja[i]);
      rect(cajas[i].x, cajas[i].y, ancho_caja, alto_caja);
    }

    //calcular proximidad friend y player
    if (modulof <= radio*10.0) {
      friendPos[0] = friendPos[0] + alfaFriend*(playerPos[0] - friendPos[0]);
      friendPos[1] = friendPos[1] + alfaFriend*(playerPos[1] - friendPos[1]);
    } else if (modulof <= radio*5.0) {
      friendPos[0] = friendPos[0] - alfaFriend*(playerPos[0] - friendPos[0]);
      friendPos[1] = friendPos[1] - alfaFriend*(playerPos[1] - friendPos[1]);
    }

    for (int i = 0; i < enemies/2; i++)
    {
      //los que siguen al friend
      xPNJ[i] = xPNJ[i] + alfa[i]* (friendPos[0] - xPNJ[i]);
      yPNJ[i] = yPNJ[i] + alfa[i]* (friendPos[0] - yPNJ[i]);
      if (moduloep[i] <= radio*6.0)
      {
        xPNJ[i] = xPNJ[i] - alfa[i]* (playerPos[0] - xPNJ[i]);
        yPNJ[i] = yPNJ[i] - alfa[i]* (playerPos[1] - yPNJ[i]);
      }
    }
    for (int i = enemies/2; i < enemies; i++)
    {
      //los que son aleatorios
      xPNJ[i] = xPNJ[i] + alfa[i]* (random(0, width) - xPNJ[i]);
      yPNJ[i] = yPNJ[i] + alfa[i]* (random(0, height) - yPNJ[i]);
      if (moduloep[i] <= radio*6.0)
      {
        xPNJ[i] = xPNJ[i] - alfa[i]* (playerPos[0] - xPNJ[i]);
        yPNJ[i] = yPNJ[i] - alfa[i]* (playerPos[1] - yPNJ[i]);
      }
    }
    for (int i = 0; i < enemies; i++)
    {
      if (moduloef[i] <= radio*1.5)
      {
        lives--;
      }
    }
    if (lives <= 0)
    {
      lives = 100;
      vidas --;
    }
    // pintar jugador, friend y enemies
    fill(255, 0, 0);
    ellipse(playerPos[0], playerPos[1], radio*1.5, radio*1.5);
    fill(0, 255, 0);
    ellipse(friendPos[0], friendPos[1], radio*1.5, radio*1.5);
    for (int i = 0; i < enemies; i++)
    {
      fill(color(random(255), 0, 255));
      ellipse(xPNJ[i], yPNJ[i], radio*2.0, radio*2.0);
    }


    if (counter-startTime < maxTime) {
      counter=millis();
    } else {
      timeOver = true;
    }

    fill(0, 0, 255);
    noStroke();
    rect(120, 70, map((maxTime - (counter) - startTime), 0, maxTime, 0, 200), 20 );
    textSize(26);
    text("Tiempo restante: " + ((maxTime - (counter - startTime))/1000.0), 20, 55);
    noFill();

    //barra de vida

    fill(255, 128, 0);
    textSize(26);
    text("Life: " + lives, width-120, height-70);
    //noFill();

    //number of lives

    fill(255, 0, 255);
    textSize(26);
    text("Vidas: " + vidas, width-120, 70);
    if(gameFinished == 3)
    {
     image(portal, portalPos[0],portalPos[1], radio*2.0,radio*2.0); 
    }
  } else if(vidas <= 0 || millis() > 60000)
  {
    background(255);
    fill(255, 0, 0);
    textSize(138);
    //si lo hemos hecho a proposito
    text("GAME OVER", random(width/2, width/4), random(height/2, height/4));
  }
  else if(modulopp <= radio*2.0 && gameFinished == 3)
  {
   background(0); 
    fill(255, 0, 0);
    textSize(68);
    //si lo hemos hecho a proposito
    text("The boss is in vacation", width/2,height/2);
    text("Return when they pay us for this", (width/2)+20,height/2);

  }
  else
  {
    fill(255, 0, 0);
    textSize(68);
    //si lo hemos hecho a proposito
    text("I don't know how, but you broke this. Congratulations!", width/2,height/2);
  }
}


//Movimiento PJ1 función void
void keyPressed() {
  boolean colision;
  switch(key)
  {
  case 'w':
    colision = CollisionPlayer('w');
    if (!colision) {
      playerPos[1] = playerPos[1] - omega;
    }
    break;
  case 'a':
    colision = CollisionPlayer('a');
    if (!colision) {
      playerPos[0] = playerPos[0] - omega;
    }
    break;
  case 's':
    colision = CollisionPlayer('s');
    if (!colision) {
      playerPos[1] = playerPos[1] + omega;
    }
    break;
  case 'd':
    colision = CollisionPlayer('d');
    if (!colision) {
      playerPos[0] = playerPos[0] + omega;
    }
    break;
  default :
    break;
  }
}
boolean CollisionPlayer(char blacky)
{

  PVector punto_min_2, punto_max_2;
  punto_min_2 = new PVector(0, 0); //esquina min caja
  punto_max_2 = new PVector(0, 0); //esquina max caja

  //Todo el proceso tiene que hacerse para las 10 cajas
  for (int i = 0; i < obstaculos; i++) {
    //Primero sacar las coord de la caja actual, la "i"
    punto_max_2.x = cajas[i].x +ancho_caja/2.0; //Xmin
    punto_max_2.y = cajas[i].y +alto_caja/2.0; //Ymin
    punto_min_2.x = cajas[i].x -ancho_caja/2.0; //Xmax
    punto_min_2.y = cajas[i].y -alto_caja/2.0; //Ymax
    //Hacemos el test Min Max
    switch(blacky)
    {
    case'w':
      if ((playerPos[0]+radio*0.75 > punto_min_2.x) &&
        (playerPos[1]+radio*0.75-omega > punto_min_2.y) &&
        (punto_max_2.x > playerPos[0]+radio*0.75) &&
        (punto_max_2.y > playerPos[1]+radio*0.75-omega))return true;
      else
      return false;

    case'a':
      if ((playerPos[0]+radio*0.75-omega > punto_min_2.x) &&
        (playerPos[1]+radio*0.75 > punto_min_2.y) &&
        (punto_max_2.x > playerPos[0]+radio*0.75-omega) &&
        (punto_max_2.y > playerPos[1]+radio*0.75))return true;
      else
      return false;

    case's':
      if ((playerPos[0]+radio*0.75 > punto_min_2.x) &&
        (playerPos[1]+radio*0.75+omega > punto_min_2.y) &&
        (punto_max_2.x > playerPos[0]+radio*0.75) &&
        (punto_max_2.y > playerPos[1]+radio*0.75+omega)) return true;
      else
      return false;


    case'd':
      if ((playerPos[0]+radio*0.75+omega > punto_min_2.x) &&
        (playerPos[1]+radio*0.75 > punto_min_2.y) &&
        (punto_max_2.x > playerPos[0]+radio*0.75+omega) &&
        (punto_max_2.y > playerPos[1]+radio*0.75))return true;
      else
      return false;
    default:
      return false;
    }
  }
  return false;
}
void InverseMovement()
{
  switch(keyCode)
  {
  case 'w':
    playerPos[1] += 15;
    break;
  case 'a':
    playerPos[0] += 15;
    break;
  case 's':
    playerPos[1] -= 15;
    break;
  case 'd':
    playerPos[0] -= 15;
    break;
  default :
    break;
  }
}
