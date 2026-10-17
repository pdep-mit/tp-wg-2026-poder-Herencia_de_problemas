import sonidos.*
import niveles.*

object juego{
	var property nivelActual = nivel1 

	method cargarNivel() { nivelActual.cargarNivel() }

	method recargarNivel() { nivelActual.volverAEmpezar() }


	method perderJuego() {
		game.schedule(5, {game.clear()
						 self.cargarControlesPantalla()
						 game.addVisual(new MenuMuerte())
						 (new SonidoPerder()).reproducir()
						 }) 	
	}

	method ganarJuego() {
	  game.schedule(5, {game.clear() 
	  					 self.cargarControlesPantalla()
						 game.addVisual(new MenuDeVictoria())
						 (new SonidoGanar()).reproducir()
						 }) 
	}

	method cargarControlesPantalla(){
        // Proximamente hay que agregar que con una tecla puedas volver al menu principal y que con otra puedas avanzar al siguiente nivel
        // Solo se deberia estar disponible avanzar de nivel si ganaste el juego, pero si lo perdiste no
        keyboard.r().onPressDo({ self.recargarNivel() })
    }
}

class MenuMuerte{
	const property image = "imagenes/HasMuerto.png" 
	method position() = game.at(3.4, 2.75)
}

class MenuDeVictoria{
	const property image = "imagenes/Ganaste.png"
	method position() = game.at(3.4, 2.75)
}