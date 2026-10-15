import estadoDelJuego.*
import objetos.*
import sonidos.*

object jugador {
  var property position = game.center()
  var property estaVivo = true
  method image() = "player.png"

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

 method recibirExplosion() {
   estaVivo = false
   juego.perderJuego()
 }

  method plantarBomba() {
  const bomba = new Bomba(position = position)
  game.addVisual(bomba)
  (new SonidoPlantarBomba()).reproducir()
  bomba.activar()
}

method entrarEnPuerta(){
    juego.ganarJuego()
}
}
