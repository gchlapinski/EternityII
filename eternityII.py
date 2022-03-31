import csv
import pickle
import copy
import time
from random import choice
from os import path, rename

from errorException import DeadEnd, FinalSolution
from piece import Piece
from pieces import Pieces
from board import Board


class Eternity:
    def __init__(self, height=16, width=16, fileName='./state'):
        self.board = Board(height, width)
        self.pieces = Pieces()
        self.moves = []
        self.boardPath = []
        self.step = 0
        self.stepNo = 0
        self.stepMax = 0
        self.boardMax = []
        self.stepPath = []
        if fileName[-6:] == '.state':
            self.fileNameState = fileName
            self.fileNameBoard = fileName.replace('.state', '.board')
            self.fileNameMax = fileName.replace('.state', '.max')
        else:
            self.fileNameState = fileName + '.state'
            self.fileNameBoard = fileName + '.board'
            self.fileNameMax = fileName + '.max'

    @staticmethod
    def readPath(fileName='./path/path.csv'):
        with open(fileName) as csvfile:
            readCSV = csv.reader(csvfile, delimiter=',', quoting=csv.QUOTE_NONE)

            boardPath = []
            next(readCSV, None)
            for row in readCSV:
                boardPath.append([int(row[0]), int(row[1])])

        return boardPath

    def __repr__(self):
        r = len(self.board.board)
        c = len(self.board.board[0])
        rpr = ""

        for i in range(r):
            for j in range(c):
                if j == 0:
                    rpr += self.reprCell(i + 1, j + 1)
                else:
                    rpr += "|" + self.reprCell(i + 1, j + 1)

            rpr += "\n"

        return rpr

    def reprCell(self, r, c):
        cell = '{:>3}'.format(str(self.board.getPiece(r, c)))

        fnd = False
        i = 0
        for i in range(len(self.boardPath)):
            if self.boardPath[i] == [r, c]:
                fnd = True
                break

        if fnd:
            if i < len(self.moves):
                cell += ';' + '{:>2}'.format(str(len(self.moves[i])))
            else:
                cell += '; -'

            cell += ';' + '{:>3}'.format(str(i + 1))
        else:
            cell += '; -; - '

        return cell

    def initPiece(self):
        self.boardPath = self.readPath()

        r = len(self.board.board)
        c = len(self.board.board[0])

        if c == 16 and c == r:
            self.pieces[139].turn180()
            self.board.addPiece(9, 8, self.pieces[139].id)
            self.pieces[139].used = 1
            self.boardPath.remove([9, 8])
        else:
            raise Exception("Initial piece only for 16x16")

    def addClues(self, no=3):
        r = len(self.board.board)
        c = len(self.board.board[0])

        if c == 16 and c == r:
            if no >= 1:
                self.pieces[181].turn270()
                self.board.addPiece(14, 3, self.pieces[181].id)
                self.pieces[181].used = 1
                self.boardPath.remove([14, 3])

            if no >= 2:
                self.pieces[255].turn270()
                self.board.addPiece(3, 14, self.pieces[255].id)
                self.pieces[255].used = 1
                self.boardPath.remove([3, 14])

            if no >= 3:
                self.board.addPiece(14, 14, self.pieces[249].id)
                self.pieces[249].used = 1
                self.boardPath.remove([14, 14])
        else:
            raise Exception("Clues only for 16x16")

    def gnrtPattern(self, r, c):
        if c > 1:
            tmp = self.board.getPiece(r, c - 1)
            if tmp != 0:
                left = self.pieces[tmp].right
            else:
                left = -1
        else:
            left = 0

        if c < 16:
            tmp = self.board.getPiece(r, c + 1)
            if tmp != 0:
                right = self.pieces[tmp].left
            else:
                right = -1
        else:
            right = 0

        if r > 1:
            tmp = self.board.getPiece(r - 1, c)
            if tmp != 0:
                up = self.pieces[tmp].down
            else:
                up = -1
        else:
            up = 0

        if r < 16:
            tmp = self.board.getPiece(r + 1, c)
            if tmp != 0:
                down = self.pieces[tmp].up
            else:
                down = -1
        else:
            down = 0

        if c == 1 or c == 16:
            if r == 1 or r == 16:
                pType = 3
            else:
                pType = 2
        else:
            if r == 1 or r == 16:
                pType = 2
            else:
                pType = 1

        return Piece(0, up, right, down, left, pType, 0, 0)

    def cmprPieces(self, i, ptrn):
        if ptrn.type != self.pieces[i].type:
            return False

        if ptrn.up != -1 and ptrn.up != self.pieces[i].up:
            return False

        if ptrn.right != -1 and ptrn.right != self.pieces[i].right:
            return False

        if ptrn.down != -1 and ptrn.down != self.pieces[i].down:
            return False

        if ptrn.left != -1 and ptrn.left != self.pieces[i].left:
            return False

        return True

    def fndMoves(self, r, c):
        ptrn = self.gnrtPattern(r, c)
        mvs = []

        if ptrn.type == 1:
            pcs = self.pieces.getPieces()

            for i in pcs:
                if self.cmprPieces(i, ptrn):
                    mvs.append([i, self.pieces[i].rot])

                self.pieces[i].turn90()
                if self.cmprPieces(i, ptrn):
                    mvs.append([i, self.pieces[i].rot])

                self.pieces[i].turn90()
                if self.cmprPieces(i, ptrn):
                    mvs.append([i, self.pieces[i].rot])

                self.pieces[i].turn90()
                if self.cmprPieces(i, ptrn):
                    mvs.append([i, self.pieces[i].rot])
        elif ptrn.type == 2:
            pcs = self.pieces.getBorders()

            for i in pcs:
                if c == 1:
                    if self.pieces[i].up == 0:
                        self.pieces[i].turn270()
                    elif self.pieces[i].right == 0:
                        self.pieces[i].turn180()
                    elif self.pieces[i].down == 0:
                        self.pieces[i].turn90()
                elif c == 16:
                    if self.pieces[i].up == 0:
                        self.pieces[i].turn90()
                    elif self.pieces[i].left == 0:
                        self.pieces[i].turn180()
                    elif self.pieces[i].down == 0:
                        self.pieces[i].turn270()
                elif r == 1:
                    if self.pieces[i].right == 0:
                        self.pieces[i].turn270()
                    elif self.pieces[i].down == 0:
                        self.pieces[i].turn180()
                    elif self.pieces[i].left == 0:
                        self.pieces[i].turn90()
                else:
                    if self.pieces[i].right == 0:
                        self.pieces[i].turn90()
                    elif self.pieces[i].up == 0:
                        self.pieces[i].turn180()
                    elif self.pieces[i].left == 0:
                        self.pieces[i].turn270()

                if self.cmprPieces(i, ptrn):
                    mvs.append([i, self.pieces[i].rot])
        else:
            pcs = self.pieces.getCorners()

            for i in pcs:
                if c == 1:
                    if r == 1:
                        if self.pieces[i].up == 0 and self.pieces[i].right == 0:
                            self.pieces[i].turn270()
                        elif self.pieces[i].right == 0 and self.pieces[i].down == 0:
                            self.pieces[i].turn180()
                        elif self.pieces[i].down == 0 and self.pieces[i].left == 0:
                            self.pieces[i].turn90()
                    else:
                        if self.pieces[i].up == 0 and self.pieces[i].right == 0:
                            self.pieces[i].turn180()
                        elif self.pieces[i].right == 0 and self.pieces[i].down == 0:
                            self.pieces[i].turn90()
                        elif self.pieces[i].up == 0 and self.pieces[i].left == 0:
                            self.pieces[i].turn270()
                else:
                    if r == 1:
                        if self.pieces[i].up == 0 and self.pieces[i].left == 0:
                            self.pieces[i].turn90()
                        elif self.pieces[i].right == 0 and self.pieces[i].down == 0:
                            self.pieces[i].turn270()
                        elif self.pieces[i].down == 0 and self.pieces[i].left == 0:
                            self.pieces[i].turn180()
                    else:
                        if self.pieces[i].up == 0 and self.pieces[i].left == 0:
                            self.pieces[i].turn180()
                        elif self.pieces[i].right == 0 and self.pieces[i].up == 0:
                            self.pieces[i].turn90()
                        elif self.pieces[i].down == 0 and self.pieces[i].left == 0:
                            self.pieces[i].turn270()

                if self.cmprPieces(i, ptrn):
                    mvs.append([i, self.pieces[i].rot])

        return mvs

    def mkMove(self, moveNo=-1):
        r = self.boardPath[self.step][0]
        c = self.boardPath[self.step][1]
        self.addMoveNo(self.step)
        self.stepNo += 1

        if len(self.moves) < self.step + 1:
            mvs = self.fndMoves(r, c)
            self.moves.append(mvs)

        if len(self.moves[self.step]) > 0:
            if moveNo == -1:
                mv = choice(self.moves[self.step])
            else:
                mv = self.moves[self.step][moveNo]

            self.moves[self.step].remove(mv)

            self.pieces[mv[0]].rotate(mv[1])
            self.pieces[mv[0]].used = 1
            self.board.addPiece(r, c, mv[0])
            self.step += 1
        else:
            del self.moves[-1]
            self.step -= 1

            if self.step == -1:
                if path.exists(self.fileNameState):
                    rename(self.fileNameState, self.fileNameState.replace(".calc", ".fin"))

                raise DeadEnd

            r = self.boardPath[self.step][0]
            c = self.boardPath[self.step][1]

            self.pieces[self.board.getPiece(r, c)].used = 0
            self.board.rmPiece(r, c)

    def bruteForce(self, t=180):
        s = time.time()

        while time.time() - s < t:
            if self.step < len(self.boardPath):
                self.mkMove()
            else:
                self.saveState()
                rename(self.fileNameState, self.fileNameState.replace(".calc", ".fin"))
                finalDir = path.dirname(self.fileNameState)
                rename(finalDir, finalDir.replace("part", "finito"))

                raise FinalSolution

            if self.step > self.stepMax:
                self.stepMax = self.step
                self.boardMax = copy.deepcopy(self.board)
                # self.saveState(1)

    def addMoveNo(self, s):
        fnd = False

        for i in range(len(self.stepPath)):
            if s == self.stepPath[i][0]:
                self.stepPath[i][1] += 1
                fnd = True
                break

        if not fnd:
            self.stepPath.append([s, 1])

    def stepMin(self):
        minNo = self.step

        for i in range(len(self.stepPath)):
            if minNo > self.stepPath[i][0]:
                minNo = self.stepPath[i][0]

        return minNo

    def stepQ(self, q):
        q = q * 0.01 * self.stepNo

        qnt = 0
        minNo = self.stepMin()

        i = 0
        for i in range(len(self.stepPath)):
            qnt += self.stepQnt(minNo + i)

            if qnt >= q:
                break

        return minNo + i

    def stepQnt(self, n):
        i = 0
        for i in range(len(self.stepPath)):
            if n == self.stepPath[i][0]:
                break

        return self.stepPath[i][1]

    def board2file(self):
        fileObj = open(self.fileNameBoard, "w")
        fileObj.write(repr(self))
        fileObj.close()

    def saveState(self, fileType=0):
        if fileType == 0:
            with open(self.fileNameState, "wb") as f:
                pickle.dump(self, f, 4)
        else:
            with open(self.fileNameMax, "wb") as f:
                pickle.dump(self, f, 4)

    def loadState(self):
        with open(self.fileNameState, "rb") as f:
            tmp = pickle.load(f)

            self.board = tmp.board
            self.pieces = tmp.pieces
            self.moves = tmp.moves
            self.boardPath = tmp.boardPath
            self.step = tmp.step
            self.stepNo = 0
            self.stepMax = tmp.stepMax
            self.boardMax = tmp.boardMax
            self.stepPath = []
