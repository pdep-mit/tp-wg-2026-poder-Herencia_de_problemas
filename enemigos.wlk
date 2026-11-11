import movimiento.*
import jugador.*
import estadoDelJuego.*
import objetos.*

class Enemigo {
  var property position

  method tiempoParaMoverse() = 600

  method puntos() = 200

  method permitePasar() = true

  method nombreTick() = "enemigo" + self.identity()

  method activar() {
    game.onTick(self.tiempoParaMoverse(), self.nombreTick(), { self.moverse() })
  }

  method moverse(){
    const direccion = self.siguienteDireccion()
    movimiento.mover(self, direccion)
  }

  method siguienteDireccion()

  method noPudisteIrALaPosicion()

  method puedeIrA(pos) =
    self.todosLosObjetosPermitenPasarA(pos)

  method todosLosObjetosPermitenPasarA(pos) =  game.getObjectsIn(pos).all({ objeto => objeto.permitePasar() })

  method recibirExplosion() {
    juego.nivelActual().eliminarEnemigoDeLaLista(self) // Esto es para el nivel2 que es necesario eliminar a todos los enemigos
    game.removeTickEvent(self.nombreTick())
    game.removeVisual(self)
    jugador.sumarPuntosPor(self)
  }
  method chocarConJugador(){
    jugador.recibirDanio()
  }
}

class EnemigoVertical inherits Enemigo {
    var subiendo = true
    method image() = if(subiendo) "imagenes/EnemigoSubiendo.png" else "imagenes/EnemigoBajando.png"

    override method noPudisteIrALaPosicion(){
      subiendo = !subiendo
    }
    override method siguienteDireccion() = if(subiendo) arriba else abajo
}

class EnemigoHorizontal inherits Enemigo {
  var moviendoseALaDerecha = true

  method image() = if(moviendoseALaDerecha) "imagenes/EnemigoBajando.png" else "imagenes/EnemigoSubiendo.png"

  override method noPudisteIrALaPosicion(){
      moviendoseALaDerecha = !moviendoseALaDerecha
  }
  override method siguienteDireccion() = if(moviendoseALaDerecha) derecha else izquierda
}

class EnemigoFantasma inherits Enemigo {
    override method puntos() = 800
    override method tiempoParaMoverse() = 1000
    method image() = "imagenes/Fantasma.png"

    override method puedeIrA(pos) = true

  override method siguienteDireccion(){
    const posJugador = jugador.position()
    const dx = posJugador.x() - position.x()
    const dy = posJugador.y() - position.y()

    const destino = if (dx.abs() > dy.abs()) {
      if (dx > 0) derecha else izquierda
    } else {
      if (dy > 0) arriba else abajo
    }
    return destino
  }
  override method noPudisteIrALaPosicion() { }
}
