import os
import time
import numpy as np
from shutil import copy, rmtree
from math import ceil
from eternityII import Eternity

printMsg = True
checkMoves = True
mvMax = 5
maxFilesInFolder = 10000
pathPtrn = './mvs/move'


def timeStr():
    t = time.localtime()
    tStr = time.strftime("%Y/%m/%d, %H:%M:%S", t) + " - "

    return tStr


if printMsg:
    print(timeStr() + "start")

for mvNo in range(mvMax):
    if mvNo == 0:
        pathDstn = pathPtrn + str(mvNo + 1) + "/part1"

        if not(os.path.exists(pathDstn)):
            os.makedirs(pathDstn)
        else:
            rmtree(pathPtrn + str(mvNo + 1))
            os.makedirs(pathDstn)

        if printMsg:
            print(timeStr() + "move" + str(mvNo + 1) + " folder initiated")

        eTmp = Eternity(16, 16)
        eTmp.initPiece()
        eTmp.addClues()

        n = len(eTmp.fndMoves(eTmp.boardPath[eTmp.step][0], eTmp.boardPath[eTmp.step][1]))

        if printMsg:
            print(timeStr() + "move" + str(mvNo + 1) + " generating " + str(n) + " moves")

        for i in range(n):
            e = Eternity(16, 16, pathDstn + '/p' + str(i))

            e.initPiece()
            e.addClues()
            e.mkMove(i)
            e.moves[mvNo] = []
            e.stepMax = e.step
            e.saveState()
            # e.board2file()
            del e

        if printMsg:
            print(timeStr() + "move" + str(mvNo + 1) + " generated")

        if checkMoves:
            if printMsg:
                print(timeStr() + "move" + str(mvNo + 1) + " are being checked")

            newMoves = 0
            finMoves = 0
            newMovesPssblts = []

            for r, d, f in os.walk(pathDstn):
                for file in f:
                    newMoves += 1
                    pth = os.path.join(r, file)

                    eTmp = Eternity(16, 16, pth)
                    eTmp.loadState()
                    step = eTmp.step
                    row = eTmp.boardPath[step][0]
                    col = eTmp.boardPath[step][1]
                    noMvs = len(eTmp.fndMoves(row, col))
                    del eTmp

                    if noMvs == 0:
                        finMoves += 1
                        os.renames(pth, pth.replace(".state", ".fin"))
                    else:
                        newMovesPssblts.append(noMvs)

            print(timeStr() + "move" + str(mvNo + 1) + " summary")
            print("move " + str(mvNo + 1) + " valid moves " + str(newMoves - finMoves))
            print("move " + str(mvNo + 1) + " finished moves " + str(finMoves))

            if len(newMovesPssblts) > 0:
                statQty = np.array(newMovesPssblts)
                print("new moves distribution")
                print("Min: " + str(np.min(statQty))
                      + ", Q05: " + str(ceil(np.quantile(statQty, 0.05)))
                      + ", Q25: " + str(ceil(np.quantile(statQty, 0.25)))
                      + ", Q50: " + str(ceil(np.quantile(statQty, 0.50)))
                      + ", Q75: " + str(ceil(np.quantile(statQty, 0.75)))
                      + ", Q95: " + str(ceil(np.quantile(statQty, 0.95)))
                      + ", Max: " + str(np.max(statQty)))
                del newMovesPssblts, statQty

    else:
        prt = 1
        noFiles = 0
        pathSrc = pathPtrn + str(mvNo)
        pathDstn = pathPtrn + str(mvNo + 1) + '/part' + str(prt)

        if not(os.path.exists(pathDstn)):
            os.makedirs(pathDstn)
        else:
            rmtree(pathPtrn + str(mvNo + 1))
            os.makedirs(pathDstn)

        if printMsg:
            print(timeStr() + "move" + str(mvNo + 1) + " folder initiated")

        files = []
        for r, d, f in os.walk(pathSrc):
            for file in f:
                pth = os.path.join(r, file)

                if '.state' in pth:
                    files.append(pth)

        for fileSrc in files:
            f = os.path.basename(fileSrc)

            eTmp = Eternity(16, 16, fileSrc)
            eTmp.loadState()
            step = eTmp.step
            row = eTmp.boardPath[step][0]
            col = eTmp.boardPath[step][1]
            noMvs = len(eTmp.fndMoves(row, col))
            del eTmp

            for i in range(noMvs):
                fileDst = pathDstn + '/' + f.replace('.state', '_' + str(i))
                copy(fileSrc, fileDst + '.state')

                e = Eternity(16, 16, fileDst)
                e.loadState()
                e.mkMove(i)
                e.moves[mvNo] = []
                e.stepMax = e.step
                e.saveState()
                noFiles += 1
                # e.board2file()
                del e

            if noFiles >= maxFilesInFolder:
                noFiles = 0

                if printMsg:
                    print(timeStr() + "move" + str(mvNo + 1) + ": " + str(maxFilesInFolder * prt) + " moves generated")

                prt += 1
                pathDstn = pathPtrn + str(mvNo + 1) + '/part' + str(prt)

                if not (os.path.exists(pathDstn)):
                    os.mkdir(pathDstn)

        if printMsg:
            print(timeStr() + "move" + str(mvNo + 1) + " generated")

        if checkMoves:
            if printMsg:
                print(timeStr() + "move" + str(mvNo + 1) + " are being checked")

            pathDstn = pathPtrn + str(mvNo + 1)
            newMoves = 0
            finMoves = 0
            newMovesPssblts = []

            for r, d, f in os.walk(pathDstn):
                for file in f:
                    newMoves += 1
                    pth = os.path.join(r, file)

                    eTmp = Eternity(16, 16, pth)
                    eTmp.loadState()
                    step = eTmp.step
                    row = eTmp.boardPath[step][0]
                    col = eTmp.boardPath[step][1]
                    noMvs = len(eTmp.fndMoves(row, col))
                    del eTmp

                    if noMvs == 0:
                        finMoves += 1
                        os.renames(pth, pth.replace(".state", ".fin"))
                    else:
                        newMovesPssblts.append(noMvs)

            print(timeStr() + "move" + str(mvNo + 1) + " summary")
            print("move " + str(mvNo + 1) + " valid moves " + str(newMoves - finMoves))
            print("move " + str(mvNo + 1) + " finished moves " + str(finMoves))

            if len(newMovesPssblts) > 0:
                statQty = np.array(newMovesPssblts)
                print("new moves distribution")
                print("Min: " + str(np.min(statQty))
                      + ", Q05: " + str(ceil(np.quantile(statQty, 0.05)))
                      + ", Q25: " + str(ceil(np.quantile(statQty, 0.25)))
                      + ", Q50: " + str(ceil(np.quantile(statQty, 0.50)))
                      + ", Q75: " + str(ceil(np.quantile(statQty, 0.75)))
                      + ", Q95: " + str(ceil(np.quantile(statQty, 0.95)))
                      + ", Max: " + str(np.max(statQty)))
                del newMovesPssblts, statQty
