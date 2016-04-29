#include <Servo.h>

Servo S;
const int tempPin = A0;
const int humidityPin = A1;

const int Pelt1 = 6;
const int Pelt2 = 5;
const int Neb = 3;
const int Dehum_fan = 2;
const int Pelt_fan = 4;
const int Dehum_servo = 13;

int temp_r1 = 22;
int temp_r2 = 22;

int humi_r1 = 27;
int humi_r2 = 28;
char stream[10];

float Temp_prev[10], Humi_prev[10];
int buff = 5;
void setup() {

  pinMode(tempPin, INPUT);
  pinMode(humidityPin, INPUT);

  pinMode(Pelt1, OUTPUT);
  pinMode(Pelt2, OUTPUT);
  pinMode(Neb, OUTPUT);
  pinMode(Dehum_fan, OUTPUT);
  pinMode(Pelt_fan, OUTPUT);

  S.attach(Dehum_servo);
  S.write(10);

  Serial.begin(9600);
}
int bytes_buffered = 0;
void loop() {

  Buffer();

  double temperature = (5.0 * analogRead(tempPin) * 100.0) / 1024.0;
  double humidity = (analogRead(humidityPin) ) / 6.7;


  /*double temp_tot = 0, humi_tot = 0;
    for (int i = 0; i < buff; i++)
    {
    temp_tot += Temp_prev[i];
    humi_tot += Humi_prev[i];
    Temp_prev[i] = Temp_prev[i + 1];
    Humi_prev[i] = Humi_prev[i + 1];
    }
    Temp_prev[buff] = temperature;
    Humi_prev[buff] = humidity;
    temp_tot += temperature;
    humi_tot += humidity;
    temperature /= buff;
    humidity /= buff;
  */

  //Serial.print("Temp: ");Serial.print(temperature,2);Serial.print(" / ");Serial.print(temp_r1);
  //Serial.print("\tHumi: ");Serial.print(humidity,2);Serial.print(" / ");Serial.println(humi_r1);

  Serial.print("T0"); Serial.println(temperature, 2);
  Serial.print("H0"); Serial.println(humidity, 2);
  if (temperature > temp_r1)
  {
    digitalWrite(Pelt1, 1);
    digitalWrite(Pelt2, 0);
    digitalWrite(Pelt_fan, 1);
  }
  else if (temperature < temp_r1)
  {
    digitalWrite(Pelt1, 0);
    digitalWrite(Pelt2, 1);
    digitalWrite(Pelt_fan, 1);
  }
  else
  {
    digitalWrite(Pelt1, 0);
    digitalWrite(Pelt2, 0);
    digitalWrite(Pelt_fan, 0);
  }
  if (humidity < humi_r1)
  {
    digitalWrite(Neb, 1);
    digitalWrite(Pelt_fan, 1);
    digitalWrite(Dehum_fan, 0);
    S.write(10);
  }
  else if (humidity > humi_r2)
  { digitalWrite(Neb, 0);
    digitalWrite(Pelt_fan, 0);
    digitalWrite(Dehum_fan, 1);
    S.write(170);
  }
}
void Buffer()
{
  if (Serial.available())
  {
    if (Serial.peek() != '\n')
    {
      stream[bytes_buffered++] = Serial.read();
    }
    else
    {
      Serial.read();
      Execute(stream);
      bytes_buffered = 0;
      stream[0] = 0;
    }
  }
}
void Execute(String stream)
{
  //T445
  float val = (stream[1] - '0') * 10 + stream[2] - '0' + ((stream[3]) - '0') * 0.1;
  if (stream[0] == 'T')
    temp_r1 = val;
  else if (stream[0] == 'H')
    humi_r1 = val;
  //Serial.println(stream);
  //Serial.println(val);
}

