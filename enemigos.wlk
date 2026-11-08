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

  method moverse() {
    const destino = self.destino()
    if(self.puedeIrA(destino)){
      position = destino
    } else {
      self.noPudeIrALaPosicion()
    }
   }

  method destino()
  method noPudeIrALaPosicion()

  method puedeIrA(pos) =
    self.estaDentroDelMapa(pos) &&
    self.todosLosObjetosPermitenPasarA(pos)

  method estaDentroDelMapa(pos) = 
    pos.y().between(0, game.height() - 1) &&
    pos.x().between(0, game.width() - 1)

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

    override method destino() = if (subiendo) position.up(1) else position.down(1)
    override method noPudeIrALaPosicion(){
      subiendo = !subiendo
    }
}

class EnemigoHorizontal inherits Enemigo {
  var moviendoseALaDerecha = true

  method image() = if(moviendoseALaDerecha) "imagenes/EnemigoBajando.png" else "imagenes/EnemigoSubiendo.png"

  override method destino() = if (moviendoseALaDerecha) position.right(1) else position.left(1)
  override method noPudeIrALaPosicion(){
      moviendoseALaDerecha = !moviendoseALaDerecha
  }

}

class EnemigoFantasma inherits Enemigo {
    override method puntos() = 800
    override method tiempoParaMoverse() = 1000
    method image() = "imagenes/Fantasma.png"

  override method todosLosObjetosPermitenPasarA(pos) = true

  override method destino() {
    const posJugador = jugador.position()
    const dx = posJugador.x() - position.x()
    const dy = posJugador.y() - position.y()

    const destino = if (dx.abs() > dy.abs()) {
      if (dx > 0) position.right(1) else position.left(1)
    } else {
      if (dy > 0) position.up(1) else position.down(1)
    }
    return destino
  } 
  override method noPudeIrALaPosicion() { }
}
