import math

type
    Vec3 = tuple
        x : float64
        y : float64
        z : float64

proc `+`(a : Vec3, b : Vec3) : Vec3 {. inline noSideEffect .} =
    (a.x + b.x, a.y + b.y, a.z + b.z)

proc `-`(a : Vec3) : Vec3 {. inline noSideEffect .} =
    (-a.x, -a.y, -a.z)

proc `-`(a : Vec3, b : Vec3) : Vec3 {. inline noSideEffect .} =
    (a.x - b.x, a.y - b.y, a.z - b.z)

proc `*`(a : Vec3, n : float64) : Vec3 {. inline noSideEffect .} =
    (a.x * n, a.y * n, a.z * n)

proc `*`(n : float64, a : Vec3) : Vec3 {. inline noSideEffect .} =
    (a.x * n, a.y * n, a.z * n)
  
proc `*`(a : Vec3, b : Vec3) : float64 {. inline noSideEffect .} =
    a.x * b.x + a.y * b.y + a.z * b.z

proc `/`(a : Vec3, n : float64) : Vec3 {. inline noSideEffect .} =
    (a.x / n, a.y / n, a.z / n)

proc squaredNorm(a : Vec3) : float64 {. inline noSideEffect .} =
    a * a

proc norm(a : Vec3) : float64 {. inline .} =
    sqrt(squaredNorm(a))
  
export
   Vec3,
   `+`,
   `-`,
   `*`,
   `/`,
   squaredNorm,
   norm
