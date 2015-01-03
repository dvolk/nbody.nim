import math

type
  Body = tuple
    x : float64
    y : float64
    z : float64
    vx : float64
    vy : float64
    vz : float64
    mass : float64

  System = array[1..5, Body]

const
  solarMass = 4 * pi * pi
  daysPerYear = 365.24

var s : System

s[1] = (0.0, 0.0, 0.0, 0.0, 0.0, 0.0, solarMass)

s[2] =
  (4.84143144246472090e+00,
  -1.16032004402742839e+00,
  -1.03622044471123109e-01,
  1.66007664274403694e-03 * daysPerYear,
  7.69901118419740425e-03 * daysPerYear,
  -6.90460016972063023e-05 * daysPerYear,
  9.54791938424326609e-04 * solarMass)
    
s[3] =
  (8.34336671824457987e+00,
  4.12479856412430479e+00,
  -4.03523417114321381e-01,
  -2.76742510726862411e-03 * daysPerYear,
  4.99852801234917238e-03 * daysPerYear,
  2.30417297573763929e-05 * daysPerYear,
  2.85885980666130812e-04 * solarMass) 

s[4] =
  (1.28943695621391310e+01,
  -1.51111514016986312e+01,
  -2.23307578892655734e-01,
  2.96460137564761618e-03 * daysPerYear,
  2.37847173959480950e-03 * daysPerYear,
  -2.96589568540237556e-05 * daysPerYear,
  4.36624404335156298e-05 * solarMass) 

s[5] =
  (1.53796971148509165e+01,
  -2.59193146099879641e+01,
  1.79258772950371181e-01,
  2.68067772490389322e-03 * daysPerYear,
  1.62824170038242295e-03 * daysPerYear,
  -9.51592254519715870e-05 * daysPerYear,
  5.15138902046611451e-05 * solarMass)

proc offsetMomentum(p : var Body, x, y, z : float64) : Body =
  p.vx = -x / solarMass
  p.vy = -y / solarMass
  p.vz = -z / solarMass
  p

proc newSystem(s : var System) : var System =
  var
    ax, ay, az : float64
  for b in s:
    ax = ax + b.vx * b.mass
    ay = ay + b.vy * b.mass
    az = az + b.vz * b.mass
  s[1] = offsetMomentum(s[1], ax, ay, az)
  s
  
proc energy(s : var System) : float64 =
  var e = 0.0

  for i in 1..len(s):
    let b = s[i]
    e = e + 0.5 * b.mass * (b.vx * b.vx + b.vy * b.vy + b.vz * b.vz)
    var j = i + 1
    while j <= 5:
      let
        b2 = s[j]
        dx = b.x - b2.x
        dy = b.y - b2.y
        dz = b.z - b2.z
        distance = sqrt(dx * dx + dy * dy + dz * dz)
      e = e - (b.mass * b2.mass) / distance
      j = j + 1
  e

proc advance(s : var System, dt : float64) =
  for i in 1..len(s):
    var
      j = i + 1
    while j <= 5:
      let
        dx = s[i].x - s[j].x
        dy = s[i].y - s[j].y
        dz = s[i].z - s[j].z
        dSquared = dx * dx + dy * dy + dz * dz
        distance = sqrt(dSquared)
        mag = dt / (dSquared * distance)

      s[i].vx = s[i].vx - (dx * s[j].mass * mag)
      s[i].vy = s[i].vy - (dy * s[j].mass * mag)
      s[i].vz = s[i].vz - (dz * s[j].mass * mag)

      s[j].vx = s[j].vx + (dx * s[i].mass * mag)
      s[j].vy = s[j].vy + (dy * s[i].mass * mag)
      s[j].vz = s[j].vz + (dz * s[i].mass * mag)

      j = j + 1

  for i in 1..len(s):
    s[i].x = s[i].x + (dt * s[i].vx)
    s[i].y = s[i].y + (dt * s[i].vy)
    s[i].z = s[i].z + (dt * s[i].vz)

s = newSystem(s)
    
echo energy(s)

let n = 50_000_000
var i = 0

while i < n:
  advance(s, 0.01)
  i = i + 1

echo energy(s)

# -0.16907516382852447
# elapsed time: 25.979763307 seconds (0 bytes allocated)
# -0.16905990681662628
