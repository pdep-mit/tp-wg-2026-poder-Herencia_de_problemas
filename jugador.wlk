import estadoDelJuego.*
import objetos.*
import sonidos.*

object jugador {
  var property position = game.center()
  var property estaVivo = true
  method image() = "imagenes/Personaje.png" //if (self.tieneEscudo()) "imagenes/Personaje.png" else "imagenes/Personaje.png"

  const maxBombas = 3
  const tiempoRecarga = 5000       // 5 segundos
  var bombasLanzadas = 0
  var property vidas = 3
  var recargando = false

  // Colección única para almacenar los power-ups obtenidos
  const property powerUps = []

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
  
  method recibirDanio() {
    if(estaVivo){
      if(self.tieneEscudo()) {
        const escudo = powerUps.find({ p => p.esEscudo() })
        powerUps.remove(escudo) // Se consume el escudo y la imagen vuelve a la normalidad
        game.say(self, "¡Escudo bloqueó el daño!")
      } else {
        vidas = vidas - 1
        if(vidas == 0){
          estaVivo = false
          juego.perderJuego()
        }
      }
    }
  }

  method recibirExplosion() {
    self.recibirDanio()
  }
  
  method reiniciar() {
    estaVivo = true
    bombasLanzadas = 0
    recargando = false
    vidas = 3
    powerUps.clear()
  }

  method prepararParaNivel(nuevaPosicion) {
    position = nuevaPosicion
    estaVivo = true
    bombasLanzadas = 0
    recargando = false
  }

  method entrarEnPuerta(puerta){
    if(puerta.estaAbierta()){ 
      juego.nivelActual().alEntrarApuerta() 
    } else {
        game.say(self, "La puerta está cerrada")
      }
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

// Gestión de power-ups mediante la colección
method agregarPowerUp(powerUp) {
  powerUps.add(powerUp)
}

method tieneEscudo() = powerUps.any({ p => p.esEscudo() })

method tieneMultiplicador() = powerUps.any({ p => p.esMultiplicador() })


method sumarPuntosPor(enemigo) {
  const puntosBase = enemigo.puntos()
  const puntosFinales = if(self.tieneMultiplicador()) puntosBase * 2 else puntosBase
  marcadorDePuntaje.sumar(puntosFinales)
}

}
