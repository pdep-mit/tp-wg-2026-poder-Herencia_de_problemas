import estadoDelJuego.*
import objetos.*
import sonidos.*

object jugador {
  var property position = game.center()
  var property estaVivo = true
  method image() = "imagenes/Personaje.png"

  const maxBombas = 3
  const tiempoRecarga = 5000       // 5 segundos
  var bombasLanzadas = 0
  var property vidas = 3
  var recargando = false

  method subir() {
    if (position.y() < game.height() - 1 && self.puedeIrA(position.up(1))){
      position = position.up(1) // si puede ir a es true, permito subir un casillero 
    } 
  }

  method bajar() {
    if (position.y() > 0 && self.puedeIrA(position.down(1))){
      position = position.down(1)
    }
  }

  method irALaDerecha() {
    if (position.x() < game.width() -1 && self.puedeIrA(position.right(1))){
      position = position.right(1)
    } 
  }
  
  method irALaIzquierda() {
    if (position.x() > 0 && self.puedeIrA(position.left(1))){
      position = position.left(1)
    } 
  }
 method puedeIrA(nuevaPosicion) { // consulta si el jugador puede pasar a esa celda
   return game.getObjectsIn(nuevaPosicion).all{objeto => objeto.permitePasar()} // retorna un booleano si el objeto puede pasar o no
 }

  method permitePasar() = true

 method recibirExplosion() {
   estaVivo = false
   juego.perderJuego()
 }
 method recibirDanio() {
  if(estaVivo){
  vidas = vidas -1

  
  if(vidas == 0){
    estaVivo = false
    juego.perderJuego()
}
  }
}

method reiniciar() {
  estaVivo = true
  bombasLanzadas = 0
  recargando = false
  vidas = 3
}

method entrarEnPuerta(){
    juego.ganarJuego()
}

method plantarBomba() {
  if (recargando) {
    game.say(self, "Recargando...")
  } else {
    const bomba = new Bomba(position = position)
    game.addVisual(bomba)
    bomba.activar()
    bombasLanzadas += 1
    if (bombasLanzadas == maxBombas) {
      self.empezarRecarga()
    }
  }
}

method empezarRecarga() {
  recargando = true
  game.schedule(tiempoRecarga, { self.terminarRecarga() })
}

method terminarRecarga() {
  bombasLanzadas = 0
  recargando = false
}
}
