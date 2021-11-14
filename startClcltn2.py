import os
import time
import datetime
import sys
from random import choice
from eternityII import Eternity

os.chdir(os.path.dirname(sys.argv[0]))
partRnd = int(sys.argv[1])
noParts = int(sys.argv[2])

now = datetime.datetime.now()
s = time.time()
mvNo = 5
movePath = "./mvs/move" + str(mvNo)
logFile = "./mvs/log/dayLog.csv"
finishHim = False

pth = ""
parts = []
for r, d, f in os.walk(movePath):
    for drctr in d:
        pth = os.path.join(r, drctr)

        if not(pth[-5:] == 'empty'):
            parts.append(pth)

        if "finito" in pth:
            finishHim = True
            break

file = ""
if not finishHim:
    part = choice(parts)
    states = []
    for r, d, f in os.walk(part):
        for file in f:
            if file[-4:] != '.fin' and file[-5:] != '.calc':
                pth = os.path.join(r, file)
                states.append(pth)

    if len(states) == 0:
        sys.exit()

    k, m = divmod(len(states), noParts)
    file = choice(states[((partRnd - 1) * k + min(partRnd - 1, m)):(partRnd * k + min(partRnd, m))])

    if not(os.path.exists(file)):
        sys.exit()
    else:
        os.rename(file, file.replace(".state", ".calc"))
        file = file.replace(".state", ".calc")

    e = Eternity(16, 16, file)
    e.fileNameState = e.fileNameState.replace(".state", "")
    e.loadState()
    e.bruteForce()
    e.fileNameState = e.fileNameState.replace(".calc", ".state")
    e.saveState()
    os.remove(file)

    t = time.time() - s
    if os.path.exists(logFile):
        f = open(logFile, "a")
    else:
        f = open(logFile, "a")
        f.write("FileName,TimeCalc,Time,Step,StepNo,StepMax,StepMin,StepQ50,StepQ100\n")

    f.write(os.path.basename(file) +
            "," + str(round(t, 2)) +
            "," + now.strftime("%y.%m.%d %H:%M:%S") +
            "," + str(e.step) +
            "," + str(e.stepNo) +
            "," + str(e.stepMax) +
            "," + str(e.stepMin()) +
            "," + str(e.stepQ(50)) +
            "," + str(e.stepQ(100)) + "\n")
    f.close()

    del e
