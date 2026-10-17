class Sonido {
  const property sonido
  var property sonidoActivo = false 

  method reproducir(){
    if(not sonidoActivo){
      sonido.play()
      sonidoActivo = true
      }
  }

  method parar(){
    if(sonidoActivo){
      sonido.stop()
      sonidoActivo = false
    }
  }

  method volumenEn(nivelDeVolumen) {
    sonido.volume(nivelDeVolumen)
  }

  method bajarVolumen() {
      sonido.volume((sonido.volume() - 0.1).max(0))
  }
	
  method subirVolumen() {
      sonido.volume((sonido.volume() + 0.1).min(1))
  }
}


class CancionFondo inherits Sonido
  (sonido = game.sound("audio/Tema de Fondo - Zelda Song of Storms.mp3")){
}

class SonidoPerder inherits Sonido
  (sonido = game.sound("audio/perder.mp3")){
}

class SonidoGanar inherits Sonido
  (sonido = game.sound("audio/ganador.mp3")){
}

class SonidoPlantarBomba inherits Sonido
  (sonido = game.sound("audio/Plantar Bomba.ogg")){
}

class SonidoExplotarBomba inherits Sonido
  (sonido = game.sound("audio/Explosion Bomba.ogg")){
}