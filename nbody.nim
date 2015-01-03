import math
import vec3

type
    Body = tuple
        position : Vec3
        velocity : Vec3
        mass : float64

    System = array[1..5, Body]

const
    solarMass = 4 * Pi * Pi
    daysPerYear = 365.24

proc newSystem(s : var System) : var System =
    var
        a = (0.0, 0.0, 0.0)
    for b in s:
        a = a + b.velocity * b.mass
    s[1].velocity = -a / solarMass
    s

proc energy(s : System) : float64 =
    var e = 0.0
    for i in 1..s.len:
        e = e + 0.5 * s[i].mass * squaredNorm s[i].velocity
        var j = i + 1
        while j <= s.len:
            let R = s[i].position - s[j].position
            e = e - (s[i].mass * s[j].mass) / norm R
            j = j + 1
    e

proc advance(s : var System, dt : float64) =
    for i in 1..s.len:
        var j = i + 1
        while j <= s.len:
            let
                R = s[i].position - s[j].position
                dSquared = squaredNorm R
                distance = sqrt dSquared
                mag = dt / (dSquared * distance)

            s[i].velocity = s[i].velocity - (R * s[j].mass * mag)
            s[j].velocity = s[j].velocity + (R * s[i].mass * mag)

            j = j + 1

    for i in 1..s.len:
        s[i].position = s[i].position + (dt * s[i].velocity)

when isMainModule:
    var s : System

    s[1] = ((0.0, 0.0, 0.0),
            (0.0, 0.0, 0.0),
            solarMass)

    s[2] =
        ((4.84143144246472090e+00,
        -1.16032004402742839e+00,
        -1.03622044471123109e-01),
        (1.66007664274403694e-03 * daysPerYear,
        7.69901118419740425e-03 * daysPerYear,
        -6.90460016972063023e-05 * daysPerYear),
        9.54791938424326609e-04 * solarMass)
    
    s[3] =
        ((8.34336671824457987e+00,
        4.12479856412430479e+00,
        -4.03523417114321381e-01),
        (-2.76742510726862411e-03 * daysPerYear,
        4.99852801234917238e-03 * daysPerYear,
        2.30417297573763929e-05 * daysPerYear),
        2.85885980666130812e-04 * solarMass) 

    s[4] =
        ((1.28943695621391310e+01,
        -1.51111514016986312e+01,
        -2.23307578892655734e-01),
        (2.96460137564761618e-03 * daysPerYear,
        2.37847173959480950e-03 * daysPerYear,
        -2.96589568540237556e-05 * daysPerYear),
        4.36624404335156298e-05 * solarMass) 

    s[5] =
        ((1.53796971148509165e+01,
        -2.59193146099879641e+01,
        1.79258772950371181e-01),
        (2.68067772490389322e-03 * daysPerYear,
        1.62824170038242295e-03 * daysPerYear,
        -9.51592254519715870e-05 * daysPerYear),
        5.15138902046611451e-05 * solarMass)

    const
        n = 50_000_000
        dt = 0.01

    s = s.newSystem
    echo s.energy

    var k = 0
    while k < n:
        s.advance dt
        k = k + 1

    echo s.energy

# -0.16907516382852447
# elapsed time: 25.979763307 seconds (0 bytes allocated)
# -0.16905990681662628

# -0.1690751638285245
# -0.1690599068166263
# real    0m24.143s
# user    0m24.141s
# sys     0m0.000s
