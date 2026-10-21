import sonidos.*
import estadoDelJuego.*
import jugador.*

class MuroDestruible {
  const property position 
  method image() = "imagenes/MuroDestruible.png"
  method permitePasar() = false
  method recibirExplosion() {
    game.removeVisual(self) //Se rompe
  }
}

class MuroIndestruible {
  const property position 
  method image() = "imagenes/MuroIndestruible.png"
  method permitePasar() =  false
  method recibirExplosion() {} // no le pase nada
}

// --- Power-ups ---
class PowerUp {
  const property position
  method permitePasar() = true
  method recibirExplosion() {}
  method chocarConJugador() {
    jugador.agregarPowerUp(self)
    self.efectoVisual()
    game.removeVisual(self)
  }
  method efectoVisual() {
    game.say(jugador, "¡Power-up obtenido!")
  }
  method esEscudo() = false
  method esMultiplicador() = false
}

class MultiplicadorPowerUp inherits PowerUp {
  method image() = "imagenes/corazonRojo.png"
  override method esMultiplicador() = true
  override method efectoVisual() {
    game.say(jugador, "¡Multiplicador x2 obtenido!")
  }
}

class EscudoPowerUp inherits PowerUp {
  method image() = "imagenes/escudo.gif"
  override method esEscudo() = true
  override method efectoVisual() {
    game.say(jugador, "¡Escudo obtenido!")
  }
}


class Bomba {
  const property position 
  method image() = "imagenes/Bomba.png"
  method permitePasar() {
    return false
  }
  method recibirExplosion() {
    self.explotar()
  }

  method activar() {
    game.onTick(3000, self.identity(), {self.explotar()} ) // 3 segundos para que explote
  }

  method posicionesAfectadas() =
    [position, position.up(1), position.down(1), position.right(1), position.left(1)]

  method explotar() {
    game.removeTickEvent(self.identity())
    game.removeVisual(self)
    (new SonidoExplotarBomba()).reproducir()
    self.generarOndaExpansiva()
  }  

  method generarOndaExpansiva(){
    self.posicionesAfectadas().forEach({ pos =>
      const explosion = new Explosion(position = pos)
      game.addVisual(explosion)
      explosion.desaparecerLuego()
      game.onCollideDo(explosion, {elemento => elemento.recibirExplosion()})
    })
  }

  method chocarConJugador() { }
}

class Explosion {
  const property position
  method image() = "imagenes/Explosion.png" 
  method permitePasar() = true
  method recibirExplosion(){ }
 method desaparecerLuego() {
  game.schedule(500, {
    game.removeVisual(self)
    io.removeCollitionHandler(self.identity())
  })
}
  method entrarEnPuerta(puerta){}
  method chocarConJugador(){} // No hace nada porque la colision ya esta en generarOndaExpansiva de la Bomba.
}


class Puerta {
  const property position 
  method estaAbierta() = juego.nivelActual().cumpleCondicionDeVictoria()
  method image() = "imagenes/Puerta.png"
  method permitePasar() = true
  method recibirExplosion(){ }
  method chocarConJugador(){
    jugador.entrarEnPuerta(self)
  }
}

class Enemigo {
  var property position
  var subiendo = true
  const property puntos = 200

  method image() = if(subiendo) "imagenes/EnemigoSubiendo.png" else "imagenes/EnemigoBajando.png"

  method permitePasar() = true

  method nombreTick() = "enemigo" + self.identity()

  method activar() {
    game.onTick(600, self.nombreTick(), { self.moverse() })
  }

  method moverse() {
    const destino = if (subiendo) position.up(1) else position.down(1)
    if (self.puedeIrA(destino)) {
      position = destino
    } else {
      subiendo = !subiendo        // choca con algo y da la vuelta
    }
  }

  method puedeIrA(pos) =
    pos.y().between(0, game.height() - 1) &&
    game.getObjectsIn(pos).all({ objeto => objeto.permitePasar() })

  method recibirExplosion() {
    juego.nivelActual().eliminarEnemigoDeLaLista(self)
    game.removeTickEvent(self.nombreTick())
    game.removeVisual(self)
    jugador.sumarPuntosPor(self)
  }
  method chocarConJugador(){
    jugador.recibirDanio()
  }
}

class EnemigoHorizontal inherits Enemigo {
  var moviendoseALaDerecha = true

  override method image() = if(moviendoseALaDerecha) "imagenes/EnemigoBajando.png" else "imagenes/EnemigoSubiendo.png"

  override method moverse() {
    const destino = if (moviendoseALaDerecha) position.right(1) else position.left(1)
    if (self.puedeIrHorizontal(destino)) {
      position = destino
    } else {
      moviendoseALaDerecha = !moviendoseALaDerecha
    }
  }

  method puedeIrHorizontal(pos) =
    pos.x().between(0, game.width() - 1) &&
    game.getObjectsIn(pos).all({ objeto => objeto.permitePasar() })
}

class EnemigoFantasma inherits Enemigo {
  override method image() = "imagenes/EnemigoSubiendo.png"
  override method puntos() = 800 // El fantasma otorga 800 puntos

  override method activar() {
    game.onTick(800, self.nombreTick(), { self.moverse() })
  }

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
    pos.y().between(0, game.height() - 1) &&
    game.getObjectsIn(pos).all({ objeto => 
      not (objeto.isInstanceOf(MuroIndestruible) or objeto.isInstanceOf(Bomba)) 
    })
}
