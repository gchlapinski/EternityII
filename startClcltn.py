import os.path
import time
from random import choice
from eternityII import Eternity

s = time.time()

no = choice(range(42))
fileName = './states/p' + str(no)

if os.path.exists(fileName + '.state'):
    e = Eternity(16, 16, "./p0_9.state")
    e.loadState()
    t = choice(range(30, 100, 10))
    e.bruteForce(30)
    e.saveState()
    e.board2file()
    e.thUpdate(round(time.time() - s, 2), no)
