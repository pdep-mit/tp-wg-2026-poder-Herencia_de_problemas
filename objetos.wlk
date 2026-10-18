import sonidos.*

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
}

class Explosion {
  const property position
  method image() = "imagenes/Explosion.png" 
  method permitePasar() = true
  method recibirExplosion(){ }
  method desaparecerLuego (){
    game.schedule(500, { game.removeVisual(self) } )
  } 
  method entrarEnPuerta(){}
}

class Puerta {
  const property position 
  method image() = "imagenes/Puerta.png"
  method permitePasar() = true
  method recibirExplosion(){ }
}

class Enemigo {
  var property position
  var subiendo = true

  method image() = "imagenes/Enemigo.png"
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
    game.removeTickEvent(self.nombreTick())
    game.removeVisual(self)
  }
}
