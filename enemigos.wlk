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

class EnemigoLineal inherits Enemigo{
  var estaMirando
  method image() = self.nombreBase() + estaMirando.nombre() + ".png"
  method nombreBase()
  override method noPudisteIrALaPosicion(){
      estaMirando = estaMirando.opuesto()
    }
    override method siguienteDireccion() = estaMirando
}
class EnemigoVertical inherits EnemigoLineal(estaMirando = arriba) {
  override method nombreBase() = "imagenes/EnemigoVertical_"
}

class EnemigoHorizontal inherits EnemigoLineal(estaMirando = derecha) {
  override method nombreBase() = "imagenes/EnemigoHorizontal_"
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
