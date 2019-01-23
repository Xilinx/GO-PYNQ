#define BLYNK_PRINT Serial
#define BLYNK_GREEN "#23C48E"
#define BLYNK_RED "#D3435C"
#include <ESP8266WiFi.h>
#include <BlynkSimpleEsp8266.h>
#include<stdio.h>
#include<stdlib.h>
char auth[] = "89d16523c0514b6f98742ae3f6fb0767";
WidgetLED led1(V5);
char ssid[] = "AAALINK";
char pass[] = "aaa9502547922";
WidgetBridge bridge1(V20);
WidgetBridge bridge2(V21);
WidgetBridge bridge3(V22);
BlynkTimer timer;
bool acbflag=0;
uint8_t maintflag=0;
uint8_t resetflag=0;
int count=0;
int wait=0;
int fuseblows=0;
uint8_t p1=D0;
uint8_t p2=D1;
uint8_t fuse=D2;
uint8_t sc=D3;
uint8_t mail=D5;
uint8_t shunt=D8;
uint8_t motor =D6;
uint8_t maint =D4;
uint8_t powe = D7;
uint8_t current=A0;
int power;  int pole1,pole2,pole3;
int polenumber=0;
void setup() {
    pinMode(maint, OUTPUT);
    pinMode(motor, OUTPUT);
    pinMode(shunt, OUTPUT);
    pinMode (power, INPUT) ;
    pinMode (p1, OUTPUT) ;
    pinMode (p2, OUTPUT) ;   
    digitalWrite(maint,LOW);
    digitalWrite(motor, LOW);
    digitalWrite(shunt, LOW);
    Serial.begin(115200);
  Blynk.begin(auth, ssid, pass, IPAddress(192,168,0,107), 8082);
  
  // put your setup code here, to run once:

}
int getdata(int p)
{
  if(digitalRead(powe)==1)
         power=0;
   else
         power=1;
    int d1=(digitalRead(p1));
    int d2=(digitalRead(p2));
    int pole_number=d1*2 + d2*1;
    if(p==1)
    return power;
    if(p==2)
    return pole_number;
}
void checkcount()
{
  if(count==3)
      {
         delay(2000);
        Blynk.virtualWrite(V3,"\nShort circuit occured\n");
        Blynk.notify("Short circuit occured !\n");
        //maintfalg=1;
        count=0;
        //acbflag=0;
        while(getdata(1)!=0){digitalWrite(motor, HIGH);
      delay(1000);}
      digitalWrite(motor, LOW);
      delay(100);
      digitalWrite(maint, HIGH);
      maintflag=1;
      Blynk.virtualWrite(V3," \n");
      Blynk.virtualWrite(V3," GRID is OFF due to short circuit\n");
     // digitalWrite(fuse,HIGH);
      fuseblows++;
      Blynk.virtualWrite(V10,fuseblows);
      Blynk.virtualWrite(V3," Maintanence ON\n");
      Blynk.virtualWrite(V3," Start your repair work\n");
      Serial.println("Grid off due to shrt crct");
        //break;
      }    
}
void displayvolt_current()
{
  if(getdata(1)==1)
  {
    led1.setColor(BLYNK_GREEN);
   int voltage = 249+ (rand()%(260-249+1));                                              // generate a random number
  //Serial.println(randNumber);
   float current = static_cast<float>(rand())/(static_cast<float>(RAND_MAX));
    Blynk.virtualWrite(V2,voltage);
    Blynk.virtualWrite(V4,current);
    
  }
  else  if(getdata(1)==0){
    led1.setColor(BLYNK_RED);
   Blynk.virtualWrite(V2,0);
   Blynk.virtualWrite(V4,0);   
  }
}

BLYNK_WRITE(V1)  // button Maintenence
{ 
 int pinValue = param.asInt();
if(pinValue== 1) //maintancne ON
   {
    if(getdata(1)==1) //power HIGH
  {
      
      while(getdata(1)!=0){digitalWrite(motor, HIGH);
      delay(1000);}
      digitalWrite(motor, LOW);
      delay(100);
      digitalWrite(maint, HIGH);
      maintflag=1;
      Blynk.virtualWrite(V3," \n");
      Blynk.virtualWrite(V3," GRID is OFF \n");
      
      Blynk.virtualWrite(V3," Maintanence ON\n");
      Blynk.virtualWrite(V3," \n");
      Blynk.virtualWrite(V3," Start your repair work\n");
      Serial.println("Grid off");
    
    
  }
     else if(getdata(1)==0) //power LOW
  {
      digitalWrite(maint,HIGH);
      maintflag=1;
      Blynk.virtualWrite(V3," \n");
      Blynk.virtualWrite(V3," GRID is already OFF \n");
    
      Blynk.virtualWrite(V3," Maintanence ON\n");
      Blynk.virtualWrite(V3," \n");
      Blynk.virtualWrite(V3," Start your repair work\n");
      Serial.println("Grid already off");
  }
  
   
 
   }
 else if (pinValue==0)      //maintanance off
  {  
  digitalWrite(maint, LOW);
  maintflag=0;
  if(getdata(1)==0) //power LOW 
  { 
    digitalWrite(motor, HIGH);
//    Serial.print("hall value=");Serial.println(getdata(3));
    Serial.print("power value=");Serial.println(getdata(1));
   //delay(5500+);
  while(getdata(1)!=1 )
  {
    delay(200);
  Serial.println("inside the while");
  Serial.print("maintanance in while = ");
Serial.println(maintflag);
}
  //  if(getdata(1)==1 )
   
      
      digitalWrite(motor, LOW);
      Blynk.virtualWrite(V3," \n\n");
      Blynk.virtualWrite(V3," GRID is ON \n");
      Blynk.virtualWrite(V3," \n");
      Blynk.virtualWrite(V3," Maintanance OFF \n");
      Serial.println("Grid on");
     
    //}
   
    
  }
  else         //power HIGH
  {
    Serial.println(" normal condition \n");
  }
  
}
}
 BLYNK_WRITE(V21)
  {
    if(maintflag==0)
   pole1 = param.asInt();
  
  }
  BLYNK_WRITE(V22)
  {
     if(maintflag==0)
   pole2 = param.asInt();
   
  }
  BLYNK_WRITE(V23)
  {
     if(maintflag==0)
   pole3 = param.asInt();
  
  }
void poledata()
{

  Serial.println("detecting problems at pole");
 
   if(pole1==1)
    {
      polenumber=1;
      digitalWrite(p1,LOW);
      digitalWrite(p2,HIGH);
      Blynk.virtualWrite(V3," \n\n");
      Blynk.virtualWrite(V3," problem at pole 1\n");
      Blynk.virtualWrite(V3," locating pole 1\n");
      Blynk.virtualWrite(V7,0,16.069444444444,80.543055555," Pole 1");
      Blynk.notify("problem at pole 1 !");    
      delay(1000);
    }
    else if(pole2==1)
    {
      polenumber=2;
      digitalWrite(p1,HIGH);
      digitalWrite(p2,LOW);
      Blynk.virtualWrite(V3," \n");
      Blynk.virtualWrite(V3," problem at pole 2\n");
      Blynk.virtualWrite(V3," locating pole 2\n");
      Blynk.virtualWrite(V7,0,16.309444444444,80.436555555," Pole 2");
      Blynk.notify("problem at pole 2 !");
      delay(1000);
    }
    else if(pole3==1)
    {
      polenumber=3;
      digitalWrite(p1,HIGH);
      digitalWrite(p2,HIGH);
      Blynk.virtualWrite(V3," \n");
      Blynk.virtualWrite(V3," \nproblem at pole 3\n");
      Blynk.virtualWrite(V3," locating pole 3\n\n");
      Blynk.virtualWrite(V7,0,16.506224444444,80.648055555," Pole 3");
      Blynk.notify("Problem at pole 3 !");
    }
    if(polenumber){
      Serial.print("Grid off due to problem at pole=");
      Serial.println(polenumber); 
       Serial.println(pole1);
       Serial.println(pole2);
       Serial.println(pole3);
      delay(1000);
    if(getdata(1)==1) //power HIGH
  {
       while(getdata(1)!=0){digitalWrite(motor, HIGH);
      delay(1000);}
      digitalWrite(motor, LOW);
      delay(100);
      digitalWrite(maint, HIGH);
      maintflag=1;

     // Serial.println("receiver reset");// arduino reset
      Blynk.virtualWrite(V3," \n");
      Blynk.virtualWrite(V3," GRID is OFF due to problem at pole\n");
       Blynk.virtualWrite(V3,polenumber);
        Blynk.notify("grid off pole error");
       // Blynk.virtualWrite(V3,polenumber);
      Blynk.virtualWrite(V3," Maintanence ON\n");
      Blynk.virtualWrite(V3," Start your repair work immediately\n");
      delay(2000);
      pole1=0;
      pole2=0;
      pole3=0;
      polenumber=0;
      delay(2000);
  }}
 else
    {
      digitalWrite(p1,LOW);
      digitalWrite(p2,LOW);
      Serial.println("no problms at poles");
    }
}
void ACB()
{
  int wait=0;

  while(1)
  { 
    
    if(getdata(1)==0) //reading the no power 
    { 
      delay(2000);
      digitalWrite(motor,HIGH);
      while(getdata(1)!=1)
      {   
        delay(100);   
      Serial.println("Activating ACB");   
      }
      
      Serial.println("ACB Activated");  
      digitalWrite(motor, LOW);
      count++;
    }
  //  delay(1000);
    
      
    wait++;
      if(wait>5)
      {
        wait=0;
      //  count=0;
        //Blynk.virtualWrite(V3,"\n\n\nNormal condion of ACB !\n\n");
        break;
      }
  }

}

void loop() {
  Blynk.run();
  Serial.print ("maintanance state=");
  Serial.println(maintflag);
  Serial.print ("power state=");
  Serial.println(getdata(1));
  delay(1000);
  if(maintflag==0 && getdata(1)==1)
  { 
    poledata();
  }
  else if(maintflag==0 && getdata(1)==0)
  {
     digitalWrite(fuse,HIGH);
    ACB(); 
     digitalWrite(fuse,LOW);
    Blynk.virtualWrite(V3," ACB restarted\n");
  }
  checkcount();
  delay(100);
  displayvolt_current();
  // put your main code here, to run repeatedly:

}
