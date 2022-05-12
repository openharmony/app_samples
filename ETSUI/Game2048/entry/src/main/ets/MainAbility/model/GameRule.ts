/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//gameStatus
enum GameStatus {
    BEFORE = -1,
    RUNNING = 1,
    OVER = 0
}

export class GameRule {
    private row: number = 4
    private column: number = 4

    private index(i: number, j: number) {
        return i * this.row + j
    }

    dataNumbers: number[]
    status: number = GameStatus.BEFORE
    score: number = 0

    constructor(dataNumbers: number[]) {
        this.dataNumbers = dataNumbers
    }

    //random
    randomNum() {
        do {
            let a = Math.floor(Math.random() * this.dataNumbers.length)
            if (this.dataNumbers[a] === 0) {
                let num = Math.random() > 0.3 ? 2 : 4
                this.dataNumbers[a] = num
                break
            }
        } while (this.dataNumbers.some((val) => {
            return val === 0
        }))
    }

    //init
    init() {
        this.dataNumbers = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        this.status = GameStatus.RUNNING
        this.score = 0
        this.randomNum()
        this.randomNum()
    }

    //move
    move(direction: string) {
        let before = String(this.dataNumbers)
        let length = (direction === 'left' || direction === 'right') ? this.row : this.column
        for (let a = 0;a < length; a++) {
            this.moveInRow(direction, a)
        }
        let after = String(this.dataNumbers)
        if (before !== after) {
            this.randomNum()
            if (this.isGameOver()) {
                this.status = GameStatus.OVER
            }
        }
    }

    //prepare to move
    moveInRow(direction: string, a: number) {
        if (direction === 'left') {
            for (let b = 0;b < this.column - 1; b++) {
                let next = this.moveNext(a, b, direction)
                b = this.dataChange(a, b, next, direction).b
                if (next === -1) break
            }
        } else if (direction === 'right') {
            for (let b = this.column - 1;b > 0; b--) {
                let next = this.moveNext(a, b, direction)
                b = this.dataChange(a, b, next, direction).b
                if (next === -1) break
            }
        } else if (direction === 'up') {
            for (let b = 0;b < this.row - 1; b++) {
                let next = this.moveNext(b, a, direction)
                b = this.dataChange(b, a, next, direction).a
                if (next === -1) break
            }
        } else if (direction === 'down') {
            for (let b = this.row - 1;b > 0; b--) {
                let next = this.moveNext(b, a, direction)
                b = this.dataChange(b, a, next, direction).a
                if (next === -1) break
            }
        }
    }

    //new number moveStatus
    moveNext(a: number, b: number, direction: string) {
        if (direction === 'left') {
            for (let i = b + 1;i < this.column; i++) {
                if (this.dataNumbers[this.index(a, i)] !== 0) {
                    return i
                }
            }
        } else if (direction === 'right') {
            for (let i = b - 1;i >= 0; i--) {
                if (this.dataNumbers[this.index(a, i)] !== 0) {
                    return i
                }
            }
        } else if (direction === 'up') {
            for (let i = a + 1;i < 4; i++) {
                if (this.dataNumbers[this.index(i, b)] !== 0) {
                    return i
                }
            }
        } else if (direction === 'down') {
            for (let i = a - 1;i >= 0; i--) {
                if (this.dataNumbers[this.index(i, b)] !== 0) {
                    return i
                }
            }
        }
        return -1
    }

    //get gameStatus
    isGameOver() {
        for (let a = 0;a < this.row; a++) {
            for (let b = 0;b < this.column; b++) {
                let tempA = this.index(a, b)
                if (this.dataNumbers[tempA] === 0) {
                    return false
                }
                if (a < this.row - 1) {
                    if (this.dataNumbers[tempA] === this.dataNumbers[this.index(a + 1, b)]) {
                        return false
                    }
                }
                if (b < this.column - 1) {
                    if (this.dataNumbers[tempA] === this.dataNumbers[tempA+1]) {
                        return false
                    }
                }
            }
        }
        return true
    }

    //move and merge
    dataChange(a: number, b: number, next: number, direction: string) {
        let tempA = this.index(a, b)
        let tempB = 0
        if (direction === 'left' || direction === 'right') {
            tempB = this.index(a, next)
        } else {
            tempB = this.index(next, b)
        }
        if (next !== -1) {
            if (this.dataNumbers[tempA] === 0) {
                this.dataNumbers[tempA] = this.dataNumbers[tempB]
                this.dataNumbers[tempB] = 0
                direction === 'left' && b--
                direction === 'right' && b++
                direction === 'up' && a--
                direction === 'down' && a++
            } else if (this.dataNumbers[tempA] === this.dataNumbers[tempB]) {
                this.dataNumbers[tempA] *= 2
                this.score += this.dataNumbers[tempA]
                this.dataNumbers[tempB] = 0
            }
        }
        return {
            a, b
        }
    }
}