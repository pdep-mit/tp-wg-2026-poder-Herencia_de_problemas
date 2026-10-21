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

  method moverse() { }

  method puedeIrA(pos) =
    pos.y().between(0, game.height() - 1) &&
    pos.x().between(0, game.width() - 1) &&
    game.getObjectsIn(pos).all({ objeto => objeto.permitePasar() })

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

    override method moverse() {
        const destino = if (subiendo) position.up(1) else position.down(1)
        if (self.puedeIrA(destino)) {
        position = destino
        } else {
        subiendo = !subiendo        // choca con algo y da la vuelta
        }
    }
}

class EnemigoHorizontal inherits Enemigo {
  var moviendoseALaDerecha = true

  method image() = if(moviendoseALaDerecha) "imagenes/EnemigoBajando.png" else "imagenes/EnemigoSubiendo.png"

  override method moverse() {
    const destino = if (moviendoseALaDerecha) position.right(1) else position.left(1)
    if (self.puedeIrA(destino)) {
      position = destino
    } else {
      moviendoseALaDerecha = !moviendoseALaDerecha
    }
  }

}

class EnemigoFantasma inherits Enemigo {
    override method puntos() = 800
    override method tiempoParaMoverse() = 1000
    method image() = "imagenes/EnemigoSubiendo.png"

  override method moverse() {
    const posJugador = jugador.position()
    const dx = posJugador.x() - position.x()
    const dy = posJugador.y() - position.y()

    const destino = if (dx.abs() > dy.abs()) {
      if (dx > 0) position.right(1) else position.left(1)
    } else {
      if (dy > 0) position.up(1) else position.down(1)
    }

    if (self.puedeIrFantasma(destino)) {
      position = destino
    }
  }

  // Solución para que el fantasma traspase objetos sin modificar todas las demás clases:
  // Verificamos únicamente que la celda no contenga Muros Indestruibles ni Bombas.
  method puedeIrFantasma(pos) =
    pos.x().between(0, game.width() - 1) &&
    pos.y().between(0, game.height() - 1) // && 
    /* 
    game.getObjectsIn(pos).all({ objeto => 
      not (objeto.isInstanceOf(MuroIndestruible) or objeto.isInstanceOf(Bomba)) 
    })
    */
}
