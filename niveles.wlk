import sonidos.*
import jugador.*
import objetos.*
import estadoDelJuego.*
import enemigos.*
import pantalla.*


const muroIndestruible = "Muro Indestruible"
const muroDestruible = "Muro Destruible"

class Nivel{ 
    const property cantidadFilasDeMuros = 4
    const property cantidadColumnasDeMuros = 8 
    var property cancionDeFondo = new CancionFondo()
    var property cancionActiva = false 
    const property pantallaDeNivel 

    method cargarNivel(){
        self.cargarPantallaInicio()
        game.schedule(5000, {game.clear()
                            self.cargarMapa()})
    }

    method cargarPantallaInicio(){
        game.addVisual(pantallaDeNivel)
    }

    method cargarMapa(){
        self.cargarElementos()
        self.cargarEnemigos()
        self.cargarJugadorEn(game.at(2,8))
        self.cargarPowerUpsObtenidos()
        self.cargarControles()
        self.cargarMusica()
        self.cargarInterfaz()
    }

    method cargarFondo(){
	    game.boardGround("imagenes/Fondo.jpg")
    }

    method cargarInterfaz(){
     game.addVisual(marcadorDePuntaje)
     game.addVisual(new Corazon(numero = 1))
     game.addVisual(new Corazon(numero = 2))
     game.addVisual(new Corazon(numero = 3))
     game.addVisual(marcadorDeBombas)
}

    method cargarElementos()
    method cargarEnemigos(){}

    method cargarJugadorEn(posicion){
    jugador.prepararParaNivel(posicion)
    jugador.position(posicion)
    game.addVisual(jugador)
    game.onCollideDo(jugador, {objeto => objeto.chocarConJugador()})
}

    method cargarControles(){
        keyboard.up().onPressDo({ jugador.subir() })
        keyboard.down().onPressDo({ jugador.bajar() })
        keyboard.left().onPressDo({ jugador.irALaIzquierda() })
        keyboard.right().onPressDo({ jugador.irALaDerecha() })
        keyboard.w().onPressDo({ jugador.subir() })
        keyboard.s().onPressDo({ jugador.bajar() })
        keyboard.a().onPressDo({ jugador.irALaIzquierda() })
        keyboard.d().onPressDo({ jugador.irALaDerecha() })

        keyboard.q().onPressDo({ jugador.plantarBomba() })
    }

    method cargarMusica(){
        cancionDeFondo = new CancionFondo()
        cancionDeFondo.volumenEn(0.3)
        cancionDeFondo.sonido().shouldLoop(true)
        game.schedule(500, {cancionDeFondo.reproducir()
                            cancionActiva = true } )
    }

    method cargarPowerUpsObtenidos(){
        jugador.powerUps().forEach({ p => p.aniadirAlMapa()})
    }

    method terminar(){
    game.clear()
    cancionDeFondo.parar()
}

    method volverAEmpezar(){
        game.clear()
        cancionDeFondo.parar()
        self.cargarNivel()
    }

    method agregarMurosIndestruibles(){
        const inicioPrimerFila = game.at(1,1)
        const iniciosDeFilas = (0..cantidadFilasDeMuros-1).map({num => num*2}).map({x => inicioPrimerFila.up(x)})
        iniciosDeFilas.forEach({primerPosicion => self.crearFila(primerPosicion)})
    }

    method crearFila(posicion){
        self.agregar(muroIndestruible,self.calcularFila(posicion))
    }

    method calcularFila(inicioFila) {
        return (0..cantidadColumnasDeMuros-1).map({x => x*2}).map({columna => inicioFila.right(columna)})
    } 

    method agregar(clase, posiciones){
        if(clase == "Muro Destruible"){
            posiciones.forEach({ posicion => game.addVisual(new MuroDestruible(position = posicion))})
            }
        if(clase == "Muro Indestruible"){
            posiciones.forEach{ posicion => game.addVisual(new MuroIndestruible(position = posicion))}
            }
    } 
    method crearPuertaEn(posicion){
        const puerta = new Puerta(position = posicion, nivel = self)
        game.addVisual(puerta)
    }
    method eliminarEnemigoDeLaLista(enemigo){}

    method alEntrarApuerta() {
        juego.ganarJuego()
    }

    method encontrarLlave(){}
}

object mapaPruebas inherits Nivel (pantallaDeNivel = pantallaNivel1){
  override method cargarElementos(){
	game.addVisual(new MuroDestruible(position = game.center().right(1)))
	game.addVisual(new MuroIndestruible(position = game.at(3,3)))
	self.crearPuertaEn(game.at(8,8))
  }
}

object nivel1 inherits Nivel (pantallaDeNivel = pantallaNivel1){
  const columnaEnemigo = 10
  var llaveEncontrada = false

  override method cargarElementos() {
    llaveEncontrada = false
    const fila1 = self.calcularFila(game.at(0, 7))
    const fila2 = self.calcularFila(game.at(0, 3))

    const muros = (fila1 + fila2 + [game.at(3, 0), game.at(3, 2), game.at(8, 5)])
      .filter({ pos => pos.x() != columnaEnemigo })
    
    // Colocamos los power-ups detrás de muros destruibles específicos en el nivel 1
    game.addVisual(new EscudoPowerUp(position = game.at(2, 3)))
    game.addVisual(new MultiplicadorPowerUp(position = game.at(4, 3)))
    game.addVisual(new Llave(position = game.at(8, 5), nivel = self))   
    game.addVisual(new MasBomba(position = game.at(3, 2)))  

    self.agregar(muroDestruible, muros)
    self.agregarMurosIndestruibles()
    self.crearPuertaEn(game.at(12, 9))
  }

  override method cargarEnemigos() {
    const enemigoV = new EnemigoVertical(position = game.at(columnaEnemigo, 4))
    game.addVisual(enemigoV)
    enemigoV.activar()

    const enemigoH1 = new EnemigoHorizontal(position = game.at(4, 2))
    game.addVisual(enemigoH1)
    enemigoH1.activar()

    const enemigoH2 = new EnemigoHorizontal(position = game.at(6, 4))
    game.addVisual(enemigoH2)
    enemigoH2.activar()
  }
    override method agregarMurosIndestruibles(){
        super()
        self.agregar(muroIndestruible, [game.at(7,9),game.at(7,8),game.at(7,6),game.at(7,4)])
    }
    override method encontrarLlave() {
      llaveEncontrada = true
    }
    method cumpleCondicionDeVictoria() = llaveEncontrada
    
    override method alEntrarApuerta() {
    juego.pasarANivel2()
  }

}

object nivel2 inherits Nivel (pantallaDeNivel = pantallaNivel2){
    const property enemigos = []

    override method cargarElementos() {
         // Colocamos los power-ups detrás de muros destruibles específicos en el nivel 1
        game.addVisual(new EscudoPowerUp(position = game.at(2, 3)))
        game.addVisual(new MultiplicadorPowerUp(position = game.at(4, 3)))
        game.addVisual(new MasBomba(position = game.at(3, 2)))  

        const fila1 = self.calcularFila(game.at(0, 7))
        const fila2 = self.calcularFila(game.at(0, 3))

        const muros = (fila1 + fila2 + [game.at(3, 0), game.at(3, 2), game.at(8, 5)])

        self.agregar(muroDestruible, muros)
        self.agregarMurosIndestruibles()
        self.crearPuertaEn(game.at(12, 9))
    }

    override method cargarEnemigos() {
        enemigos.clear()
        
        const fantasma = new EnemigoFantasma(position = game.at(4, 4))
        game.addVisual(fantasma)
        fantasma.activar()
        enemigos.add(fantasma)

        const normal = new EnemigoVertical(position = game.at(2, 2))
        game.addVisual(normal)
        normal.activar()
        enemigos.add(normal)
    }

   // borre crearEnemigo

    method cumpleCondicionDeVictoria() = enemigos.isEmpty()

    override method eliminarEnemigoDeLaLista(enemigo){
        enemigos.remove(enemigo)
    }

 }
