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
  method esMasBombas() = false
}

class MultiplicadorPowerUp inherits PowerUp {
   method image() = if(estaEnElPiso) "imagenes/x2_Piso.png" else "imagenes/x2_HUD.png"
  override method esMultiplicador() = true
  override method efectoVisual() {
    game.say(jugador, "¡Multiplicador x2 obtenido!")
  }
  override method position() = if(estaEnElPiso) position else game.at(3,game.height()-1)
  var estaEnElPiso = true
  override method chocarConJugador() {
    if(estaEnElPiso){
    jugador.agregarPowerUp(self)
    self.efectoVisual()
    estaEnElPiso = false    
    juego.llevarHastaAdelante(self)
    }
  }
}

class EscudoPowerUp inherits PowerUp {
  const nombreBase = "imagenes/Burbuja_"
  var property frame = 1
  var property framesMaximos = 3
  method image() = if (estaEnElPiso) "imagenes/Burbuja_Piso.png" else animacion.nombreDeFrame(nombreBase,frame) // "imagenes/Burbuja_3.png"
  override method esEscudo() = true
  override method efectoVisual() {
    game.say(jugador, "¡Escudo obtenido!")
  }
  override method chocarConJugador() {
    jugador.agregarPowerUp(self)
    self.efectoVisual()
    estaEnElPiso = false
    juego.llevarHastaAdelante(self)
    self.animacionEntrada()
  }
  override method position() = if (estaEnElPiso) position else jugador.position()
  var estaEnElPiso = true
  method animacionEntrada() {
    animacion.empezarAnimacion(self)
  }
  method nombreAnimacion() = "Escudo_Animacion" + self.identity()
}

class MasBomba inherits PowerUp {
  method image() = "imagenes/PowerUp_MasBombas.png"
  override method esMasBombas() = true
  override method efectoVisual() {
    game.say(jugador, "¡Tengo más Bombas!")
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
      animacion.empezarAnimacion(explosion)
      explosion.desaparecerLuego()
      game.onCollideDo(explosion, {elemento => elemento.recibirExplosion()})
    })
  }

  method chocarConJugador() { }
}

class Explosion {
  const property position
  var property frame = 1 
  method nombreBaseAnimacion() = "imagenes/Explosion_"
  method framesMaximos() = 6
  method image() = animacion.nombreDeFrame(self.nombreBaseAnimacion() , frame)
  method permitePasar() = true
  method recibirExplosion(){ }
 method desaparecerLuego() {
  game.schedule(500, {
    game.removeTickEvent(self.nombreAnimacion())
    game.removeVisual(self)
    io.removeCollitionHandler(self.identity())
  })
}
  method entrarEnPuerta(puerta){}
  method chocarConJugador(){} // No hace nada porque la colision ya esta en generarOndaExpansiva de la Bomba.

  method nombreAnimacion() = "Animacion_Explosion" + self.identity()
}


class Puerta {
  const property position 
  method estaAbierta() = juego.nivelActual().cumpleCondicionDeVictoria()
  method image() = if (self.estaAbierta())"imagenes/Puerta.png" else "imagenes/PuertaCerrada.png"
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

object animacion{
  method nombreDeFrame(nombreBase,frame) = nombreBase + frame.toString() + ".png"
  method tiempoPorFrame() = 100
  method tiempoDeAnimacion(objeto) = self.tiempoPorFrame() * objeto.framesMaximos() - 1
  method empezarAnimacion(objeto){
    game.onTick(self.tiempoPorFrame(), objeto.nombreAnimacion() , { self.avanzar(objeto)})
    game.schedule(self.tiempoDeAnimacion(objeto), {game.removeTickEvent(objeto.nombreAnimacion())})
    }
  method avanzar(objeto){
    const frameActual = objeto.frame()
      if(frameActual == objeto.framesMaximos()){
        objeto.frame(1)
      } else{
        objeto.frame(frameActual + 1)}
      }

  }

