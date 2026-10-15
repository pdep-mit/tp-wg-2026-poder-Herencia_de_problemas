class Sonido {
  const property sonido

  method reproducir(){
        sonido.play()
  }

  method bajarVolumen() {
      sonido.volume((sonido.volume() - 0.1).max(0))
  }
	
  method subirVolumen() {
      sonido.volume((sonido.volume() + 0.1).min(1))
  }
}


class SonidoPerder inherits Sonido
  (sonido = game.sound("perder.mp3")){
}

class SonidoGanar inherits Sonido
  (sonido = game.sound("ganador.mp3")){
}

class SonidoPlantarBomba inherits Sonido
  (sonido = game.sound("Plantar Bomba.ogg")){
}

class SonidoExplotarBomba inherits Sonido
  (sonido = game.sound("Explosion Bomba.ogg")){
}