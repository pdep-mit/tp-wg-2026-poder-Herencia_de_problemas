import sonidos.*

object juego{
	method perderJuego() {
		game.schedule(5, {game.clear() 
						 game.addVisual(new MenuMuerte())
						 (new SonidoPerder()).reproducir()
						 }) 	
	}

	method ganarJuego() {
	  game.schedule(5, {game.clear() 
						 game.addVisual(new MenuDeVictoria())
						 (new SonidoGanar()).reproducir()
						 }) 
	}
}

class MenuMuerte{
	const property image = "HasMuerto.png" 
	
	method position() = game.at(1, 3)
}

class MenuDeVictoria{
	const property image = "Ganaste.png"
	method position() = game.at(1, 3)
}