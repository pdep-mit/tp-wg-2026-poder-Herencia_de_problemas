import estadoDelJuego.*
import objetos.*
import sonidos.*
import movimiento.*

object jugador {
  var property position = game.center()
  var property estaMirando = abajo
  method image() = "imagenes/Personaje_" + estaMirando.nombre() + ".png" 

  method maxBombas() = 3 + self.bombasExtras()
  const tiempoRecarga = 5000       // 5 segundos
  var property bombasLanzadas = 0
  var property vidas = 3
  var recargando = false

  method estaVivo() = vidas > 0

  // Colección única para almacenar los power-ups obtenidos
  const property powerUps = []

  method subir() {
    movimiento.mover(self,arriba)
    estaMirando = arriba 
  }
  method bajar() {
    movimiento.mover(self,abajo)
    estaMirando = abajo 
  }
  method irALaDerecha() {
    movimiento.mover(self,derecha)
    estaMirando = derecha 
  }
  method irALaIzquierda() {
    movimiento.mover(self,izquierda)
    estaMirando = izquierda 
  }
 
  method puedeIrA(nuevaPosicion) { 
    return game.getObjectsIn(nuevaPosicion).all{objeto => objeto.permitePasar()} 
  }
  method noPudisteIrALaPosicion() {}

  method permitePasar() = true
  
  method recibirDanio() {
    if(self.estaVivo()){
      // Polimorfismo: Preguntamos a los power-ups si alguno puede bloquear el daño.
      // Si ninguno lo bloquea, el jugador recibe daño de forma estándar.
      if(not powerUps.any({ p => p.bloquearDanio() })) {
        vidas = vidas - 1
        if(vidas == 0){
          juego.perderJuego()
        }
      } else {
        game.say(self, "¡Escudo bloqueó el daño!")
      }
    }
  }

  method recibirExplosion() {
    self.recibirDanio()
  }
  
  method reiniciar() {
    bombasLanzadas = 0
    recargando = false
    vidas = 3
    powerUps.clear()
  }

  method prepararParaNivel(nuevaPosicion) {
    position = nuevaPosicion
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
      if (bombasLanzadas == self.maxBombas()) {
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

  method bombasDisponibles() = self.maxBombas() - bombasLanzadas

  // Gestión de power-ups mediante la colección
  method agregarPowerUp(powerUp) {
    powerUps.add(powerUp)
  }

  method removerPowerUp(powerUp) {
    powerUps.remove(powerUp)
  }

  method sumarPuntosPor(enemigo) {
    const puntosBase = enemigo.puntos()
    // Polimorfismo: Cada power-up modifica los puntos acumulados (ej. Multiplicador los duplica, otros los dejan igual)
    const puntosFinales = powerUps.fold(puntosBase, { acumulado, p => p.modificarPuntos(acumulado) })
    marcadorDePuntaje.sumar(puntosFinales)
  }

  method bombasExtras() = powerUps.sum({ p => p.bombasExtras() })
}