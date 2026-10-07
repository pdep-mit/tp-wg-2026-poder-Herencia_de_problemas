class MuroDestruible {
  const property position 
  method image() = "MuroDestruible.png"
  method permitePasar() = false
  method recibirExplosion() {
    game.removeVisual(self) //Se rompe
  }
}

class MuroIndestruible {
  const property position 
  method image() = "MuroIndestruible.png"
  method permitePasar() =  false
  method recibirExplosion() {} // no le pase nada
}

class Bomba {
  const property position 
  method image() = "Bomba.png"
  method permitePasar() {
    return false
  }
  method recibirExplosion() {
    self.explotar()
  }


  method activar() {
    game.schedule(3000,{self.explotar()}) // 3 segundos para que explote
  }

  method posicionesAfectadas() =
    [position, position.up(1), position.down(1), position.right(1), position.left(1)]

  method explotar() {
  game.removeVisual(self)
  self.posicionesAfectadas().forEach({ pos =>
    game.getObjectsIn(pos).forEach({ objeto => objeto.recibirExplosion() })
    const explosion = new Explosion(position = pos)
    game.addVisual(explosion)
    explosion.desaparecerLuego()
    })
  }  
}

class Explosion {
  const property position
  method image() = "Explosion.png" 
  method permitePasar() = true
  method recibirExplosion(){ }
  method desaparecerLuego (){
    game.schedule(500, { game.removeVisual(self) } )
  } 
}