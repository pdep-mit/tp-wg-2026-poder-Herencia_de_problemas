class MuroDestruible {
  const property position 

  method image() = "MuroDestruible.png"

  method permitePasar() {
    return false
    
  }
}

class MuroIndestruible {
  const property position 

  method image() = "MuroIndestruible.png"
method permitePasar() {
    return false
    
  }
  
}

class Bomba {
  const property position 

  method image() = "Bomba.png"
method permitePasar() {
    return false
    
  }
}