from eternityII import Eternity

e = Eternity(16, 16)
e.initPiece()
e.addClues()
e.bruteForce(15000)
#e.saveState()
