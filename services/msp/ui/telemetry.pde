int size_x = 640;
int size_y = 480;
int center_x = size_x / 2;
int center_y = size_y / 2;
float scaleFactor = 1;
float aligmentAngle = 92;
bool relative = true;
float GM = 50e8; 
bool debug=false;

void setup() {  // this is run once.   
    
    // set the background color
    background(0);
    
    // canvas size (Integers only, please.)
    size(size_x, size_y); 
      
    // smooth edges
    smooth();
    
    // limit the number of frames per second
    frameRate(30);
    
    // disable stroke
    noStroke();
} 

void keyPressed() {

  if (keyCode == 'A') {
    aligmentAngle += 1;
  }

  if (keyCode == 'D') {
    aligmentAngle -= 1;
  }

  if (aligmentAngle >= 360) {
    aligmentAngle -= 360;
  }

  if (aligmentAngle < -360) {
    aligmentAngle += 360;
  }

  if (keyCode == ' ') {
    fetch_data();
  }

  if (keyCode == 'Z') {
    scaleFactor += 0.1;
  }

  if (keyCode == 'X') {
    scaleFactor -= 0.1;
  }

  if (keyCode == 'P') {
    relative = !relative;
  }

  if (keyCode == 'J') {
    cycle_source();
  }

  if (keyCode == 'L') {
    cycle_target();
  }

  if (keyCode == 'B') {
    debug = !debug;
  }

  if (keyCode == 'K') {
    if (source_id() != "" && target_id() != "" && source_id() != target_id()) {
      beam_request(source_id(), target_angle());
    }
  }
}

float get_scale() {
  return pow(10, scaleFactor);
}

int last_update = 0;

void draw() {  // this is run repeatedly.  

    if (second() != last_update) {
      fetch_data();
      last_update = second();
    }

    // draw settings
    background(0);

    draw_info();
    draw_aligment_indicator();

    // translate to center
    translate(center_x, center_y);

    // draw relative from center
    draw_sun();
    draw_tracked_objects();
}

void draw_aligment_indicator() {

  bool targetMode = source_id() != "" && target_id() != "" && source_id() != target_id();

  float drawAngle;
  if (targetMode) {
    drawAngle = target_angle();
  } else {
    drawAngle = aligmentAngle + 180;
  }

  int s = 100;
  int hs = s/2;

  pushMatrix();
  stroke(200, 200, 0);
  strokeWeight(2);
  noFill();

  translate(size_x-s/2-20, size_y-hs-20);
  ellipse(0, 0, s, s);

  if (relative && !targetMode) {
    textAlign(LEFT);
    text("Prograde +", -hs, -hs-10);
  } else if (targetMode) {
    textAlign(LEFT);
    text("source->target", -hs-20, -hs-10);
  }

  textAlign(RIGHT);
  text(nf(drawAngle, 3, 2), hs, -hs-10);

  // draw line from center to the angle
  line(0, 0, sin(radians(drawAngle))*hs, cos(radians(drawAngle))*hs);

  noStroke();
  popMatrix();
}

void draw_info() {
    pushMatrix();
    textAlign(LEFT);
    fill(200, 200, 0);
    text("Scale: " + get_scale(), 15, 15);
    text("Press Z and X to change scale", 15, 25);
    text("Press space to refresh", 15, size_y-15);
    popMatrix();
}

void draw_sun() {
  pushMatrix();
  fill(200 + random(50), 200 + random(50), 0);
  ellipse(0, 0, 10, 10)
  popMatrix();
}

void draw_tracked_objects() {
  // white shit
  fill(255);

  for (int i=0; i<window.trackedObjects.length; i++) {

    objectKey = window.trackedObjects[i];
    o = window.serverState[objectKey];

    if (o != undefined) {
      draw_object(o.object);
    }
  }
}

int target=-1;
int source=-1;

void cycle_target() {
  target = target + 1;
  if (source == target) {
    target += 1;
  }
  if (target >= window.trackedObjects.length) {
    target = -1;
  }
}

void cycle_source() {
  source = source + 1;
  if (source == target) {
    source += 1;
  }
  if (source >= window.trackedObjects.length) {
    source = -1;
  }
}

String source_id() {
  if (source < 0 || source >= window.trackedObjects.length) {
    return "";
  }
  return window.serverState[window.trackedObjects[source]].object.idx;
}

String target_id() {
  if (target < 0 || target >= window.trackedObjects.length) {
    return "";
  }
  return window.serverState[window.trackedObjects[target]].object.idx;
}

float target_angle() {

  String sid = source_id();
  String tid = target_id();

  if (sid == "" || tid == "") {
    return -0;
  }

  float source_pos_x = window.serverState[sid].object.position[0];
  float source_pos_y = window.serverState[sid].object.position[1];

  float target_pos_x = window.serverState[tid].object.position[0];
  float target_pos_y = window.serverState[tid].object.position[1];

  return degrees(atan2(source_pos_x-target_pos_x, source_pos_y-target_pos_y) + PI);
}

void draw_object(Object obj) {

    int pos_x = obj.position[0];
    int pos_y = obj.position[1];
    int vel_x = obj.velocity[0];
    int vel_y = obj.velocity[1];
    float velocity = dist(0, 0, vel_x, vel_y) ;
    float height = dist(0, 0, pos_x, pos_y);
    float ta = atan2(pos_x, pos_y) - atan2(vel_x, vel_y);
    float a = semi_major_axis(velocity, height);
    float e = calc_ecc(height, velocity, ta);
    float b = semi_minor_axis(a, e);
    float Ra = (1 - e) * a;
    float Rb = (1 + e) * a;
    if (Ra < Rb) {
      float tmp = Ra;
      Ra = Rb;
      Rb = tmp;
    }
    float center_offset = ((Ra+Rb)/2-Ra);
    float mx = height * velocity * velocity / GM;
    float tanU = mx * sin(ta) * cos(ta) / ( mx * sin(ta) * sin(ta) - 1);
    float flatAngle = atan2(pos_x, pos_y) + PI/2;
    float orbitAngle = -atan(tanU)-flatAngle;

    // auto-scale
    while (abs(pos_x * get_scale()) > size_x / 2) {
      scaleFactor -= 0.5;
    }
    while (abs(pos_y * get_scale()) > size_y / 2) {
      scaleFactor -= 0.5;
    }

    pushMatrix();

    // translate to object
    translate(
        pos_x * get_scale(), 
        pos_y * get_scale()
    );

    // draw the object
    fill(255);
    strokeWeight(1);
    ellipse(0, 0, 10, 10);

    textAlign(CENTER);
    text(obj.idx, 0, 15);

    if (debug) {
      text("v=" + nf(velocity, 0, 2), 0, -15);
      text("H=" + nf(height, 0, 2), 0, -25);
      text("a=" + a, 0, -35);
      text("Ah=" + Ra, 0, -45);
      text("Ph=" + Rb, 0, -55);
      text("e=" + e, 0, -65);
      text("oa=" + degrees(orbitAngle), 0, -75);
    }

    if (source_id() == obj.idx) {
      text("[source]", 0, 25);
    } else if (target_id() == obj.idx) {
      text("[target]", 0, 25);
    }

    if (source_id() == obj.idx && target_id() != "") {

      float ant_A = obj.antenna_a;
      float ant_B = obj.antenna_b;
      float ant_alig = radians(target_angle());

      // draw antenna triangle;

      stroke(255);
      strokeWeight(1);
      noFill();

      triangle(
        0,
        0,
        (ant_A * sin(ant_alig) - ant_B * cos(ant_alig)) * get_scale(),
        (ant_A * cos(ant_alig) + ant_B * sin(ant_alig)) * get_scale(),
        (ant_A * sin(ant_alig) + ant_B * cos(ant_alig)) * get_scale(),
        (ant_A * cos(ant_alig) - ant_B * sin(ant_alig)) * get_scale(),
      );
    }

    popMatrix();

    pushMatrix();
    rotate(orbitAngle);
    translate((center_offset)*get_scale(), 0);
    noFill();
    stroke(255, 255, 255, 16);
    strokeWeight(5);
    ellipse(0, 0, (Ra+Rb)*get_scale(), b * 2 * get_scale());
    popMatrix();


}


float semi_major_axis(float v, float dist) {
  return (1/((2/dist) - (v*v/GM)));
}

float semi_minor_axis(float a, float e) {
  return a * sqrt(1-e*e);
}

float calc_ecc(float rx, float vx, float gamma) {

  return sqrt( pow(rx*vx*vx/GM - 1, 2) * pow(sin(gamma), 2) + pow(cos(gamma), 2) )

}
