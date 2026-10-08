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
  (sonido = game.sound("mario-kart-perder-1.mp3")){
}