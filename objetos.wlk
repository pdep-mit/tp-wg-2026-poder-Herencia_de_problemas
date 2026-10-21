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
class Llave{
   const property position
  method image() = "imagenes/Llave.png"
  method permitePasar() = true
  method recibirExplosion() {}

  method chocarConJugador() {
  juego.nivelActual().encontrarLlave()
  game.removeVisual(self)
   game.say(jugador, "¡Encontraste la llave!")

  }
}