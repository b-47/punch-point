// Punch Point test rig: fire the solenoids with set pulse lengths.
//
// Wiring, once per solenoid (diagram: ../../media/circuit.svg):
//   GPIO -> 100 ohm -> MOSFET gate (IRLB8721 or IRLZ44N), 10 kohm gate to GND
//   +12 V -> solenoid -> MOSFET drain; MOSFET source -> GND
//   1N4007 across the solenoid, cathode (stripe) to +12 V
// One 1000 uF / 25 V capacitor across the 12 V supply next to the solenoids,
// and the ESP32 GND tied to the supply GND.
// Solenoid 1 is on GPIO 4, solenoid 2 on GPIO 13. Those pins and the BOOT
// button (GPIO 0) are the same on ESP32 and ESP32-S3 boards.
//
// Serial at 115200, one command per line. [s] picks solenoid 1 or 2 and stays picked:
//   f 25            fire one 25 ms pulse
//   f 25 2          the same on solenoid 2
//   r 20 25 500     20 pulses of 25 ms, one every 500 ms
//   w 5 40 5        sweep: each BOOT press fires the next length, 5, 10 ... 40 ms
//   s               stop a run or a sweep
// Outside a sweep, the BOOT button fires the last pulse length again.
// Every pulse prints "pulse,<count>,<solenoid>,<ms>" so a session pastes straight into a sheet.

const int SOL_PINS[] = {4, 13};
constexpr int NUM_SOL = sizeof(SOL_PINS) / sizeof(SOL_PINS[0]);
const int BTN_PIN = 0;
const uint32_t MAX_PULSE_MS = 100;  // past this the plunger has long seated; the coil only heats
const uint32_t DUTY_DIV = 4;        // a solenoid fires no sooner than 4x its last pulse: duty <= 25 %
const char *HELP = "? f <ms> [s] | r <count> <ms> <period_ms> [s] | w <from> <to> <step> [s] | s";

uint32_t lastStart[NUM_SOL], lastLen[NUM_SOL];
uint32_t count = 0;
int sol = 0;                        // selected solenoid, 0-based
uint32_t pulseMs = 25;
uint32_t runLeft = 0, runPeriod = 0, nextAt = 0;
uint32_t sweepAt = 0, sweepTo = 0, sweepStep = 0;   // sweepStep 0 means no sweep

static uint32_t umax(uint32_t a, uint32_t b) { return a > b ? a : b; }

void fire(int s, uint32_t ms) {
  if (ms > MAX_PULSE_MS) ms = MAX_PULSE_MS;
  while (millis() - lastStart[s] < lastLen[s] * DUTY_DIV) delay(1);
  lastStart[s] = millis();
  lastLen[s] = ms;
  digitalWrite(SOL_PINS[s], HIGH);
  delay(ms);
  digitalWrite(SOL_PINS[s], LOW);
  Serial.printf("pulse,%lu,%d,%lu\n", (unsigned long)++count, s + 1, (unsigned long)ms);
}

// Takes a 1-based solenoid number from a command.
bool pickSolenoid(unsigned long n) {
  if (n < 1 || n > (unsigned long)NUM_SOL) {
    Serial.printf("no solenoid %lu: use 1 to %d\n", n, NUM_SOL);
    return false;
  }
  sol = (int)n - 1;
  return true;
}

void handle(const String &line) {
  unsigned long a, b, c, d;
  int n;
  if ((n = sscanf(line.c_str(), "f %lu %lu", &a, &b)) >= 1) {
    if (n == 2 && !pickSolenoid(b)) return;
    pulseMs = a;
    fire(sol, pulseMs);
  } else if ((n = sscanf(line.c_str(), "r %lu %lu %lu %lu", &a, &b, &c, &d)) >= 3) {
    if (n == 4 && !pickSolenoid(d)) return;
    sweepStep = 0;
    pulseMs = b;
    runLeft = a;
    runPeriod = umax(c, b * DUTY_DIV);
    nextAt = millis();
  } else if ((n = sscanf(line.c_str(), "w %lu %lu %lu %lu", &a, &b, &c, &d)) >= 3) {
    if (n == 4 && !pickSolenoid(d)) return;
    if (c == 0 || b < a) {
      Serial.println("a sweep needs from <= to and a step above 0");
      return;
    }
    runLeft = 0;
    sweepAt = a;
    sweepTo = b;
    sweepStep = c;
    Serial.printf("sweep on solenoid %d: press BOOT to fire %lu ms\n", sol + 1, (unsigned long)sweepAt);
  } else if (line == "s") {
    runLeft = 0;
    sweepStep = 0;
    Serial.println("stopped");
  } else if (line.length()) {
    Serial.println(HELP);
  }
}

void pressed() {
  if (!sweepStep) {
    fire(sol, pulseMs);
    return;
  }
  pulseMs = sweepAt;
  fire(sol, pulseMs);
  sweepAt += sweepStep;
  if (sweepAt > sweepTo) {
    sweepStep = 0;
    Serial.println("sweep done");
  } else {
    Serial.printf("next: %lu ms\n", (unsigned long)sweepAt);
  }
}

void setup() {
  for (int i = 0; i < NUM_SOL; i++) {
    pinMode(SOL_PINS[i], OUTPUT);
    digitalWrite(SOL_PINS[i], LOW);
  }
  pinMode(BTN_PIN, INPUT_PULLUP);
  Serial.begin(115200);
  Serial.println("punch_test ready");
  Serial.println(HELP);
}

void loop() {
  if (Serial.available()) {
    String line = Serial.readStringUntil('\n');
    line.trim();
    handle(line);
  }

  if (runLeft && (int32_t)(millis() - nextAt) >= 0) {
    fire(sol, pulseMs);
    runLeft--;
    nextAt += runPeriod;
  }

  // BOOT button, debounced
  static bool wasDown = false;
  static uint32_t lastEdge = 0;
  bool down = digitalRead(BTN_PIN) == LOW;
  if (down != wasDown && millis() - lastEdge > 50) {
    lastEdge = millis();
    wasDown = down;
    if (down) pressed();
  }
}
