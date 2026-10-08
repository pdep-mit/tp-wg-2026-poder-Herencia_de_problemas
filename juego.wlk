import sonidos.*

object juego{
	method perderJuego() {
		game.schedule(5, {game.clear() 
						 game.addVisual(new MenuMuerte())
						 (new SonidoPerder()).reproducir()
						 }) 	
	}
}

class MenuMuerte{
	var property image = "HasMuerto.png" 
	
	method position() = game.at(1, 2.5)
}