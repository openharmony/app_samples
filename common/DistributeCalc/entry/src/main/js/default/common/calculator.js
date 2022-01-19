/*
 * Copyright (c) 2020 Huawei Device Co., Ltd.
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


const OperatorLevels = {
    '+': 0,
    '-': 0,
    '*': 1,
    '/': 1,
};

const OperatorHandlers = {
    '+': (one, other) => (one + other).toFixed(getFloatNum(one, other, '+')),
    '-': (one, other) => (one - other).toFixed(getFloatNum(one, other, '-')),
    '*': (one, other) => (one * other).toFixed(getFloatNum(one, other, '*')),
    '/': (one, other) => (one / other).toFixed(getFloatNum(one, other, '/')),
};

function getFloatNum(one, other, oprate) {
    let num = 0;
    let s1 = one.toString();
    let s2 = other.toString();
    let num1 = 0;
    if (s1.indexOf('.') !== -1) {
        num1 = s1.split('.')[1].length;
    }
    let num2 = 0;
    if (s2.indexOf('.') !== -1) {
        num2 = s2.split('.')[1].length;
    }
    if (oprate === '+' || oprate === '-') {
        num = Math.max(num1, num2);
    }
    if (oprate === '*') {
        num = num1 + num2;
    }
    if (oprate === '/') {
        num = (num1 + s2.length) > 3 ? (num1 + s2.length) : 3;
    }
    return num;
}


function calcSuffixExpression(expression) {
    const numberStack = [];

    while (expression.length) {
        let element = expression.shift();
        if (!isOperator(element)) {
            numberStack.push(Number(element));
        } else {
            const one = numberStack.pop();
            const other = numberStack.pop();
            const result = OperatorHandlers[element](other, one);
            numberStack.push(Number(result));
        }
    }
    return numberStack[0];
}

function toSuffixExpression(expression) {
    const operatorStack = [];
    const suffixExpression = [];
    let topOperator;
    for (let idx = 0, size = expression.length; idx < size; idx++) {
        const element = expression[idx];
        if (element === '(') {
            operatorStack.push(element);
            continue;
        }
        if (element === ')') {
            if (operatorStack.length) {
                let operator = operatorStack.pop();
                while (operator !== '(') {
                    suffixExpression.push(operator);
                    operator = operatorStack.pop();
                }
            }
            continue;
        }
        if (isOperator(element)) {
            if (!operatorStack.length) {
                operatorStack.push(element);
            } else {
                topOperator = operatorStack[operatorStack.length - 1];
                if (!isGrouping(topOperator) && !isPrioritized(element, topOperator)) {
                    suffixExpression.push(operatorStack.pop());
                }
                operatorStack.push(element);
            }
            continue;
        }
        suffixExpression.push(element);
    }
    while (operatorStack.length) {
        suffixExpression.push(operatorStack.pop());
    }
    return suffixExpression;
}

function parseInfixExpression(content) {
    const size = content.length;
    const lastIdx = size - 1;
    let number = '';
    const expression = [];
    for (let idx = 0; idx < size; idx++) {
        const element = content[idx];
        if (isGrouping(element)) {
            if (number !== '') {
                expression.push(number);
                number = '';
            }
            expression.push(element);
        } else if (isOperator(element)) {
            if (isSymbol(element) && (idx === 0 || content[idx - 1] === '(')) {
                number += element;
            } else {
                if (number !== '') {
                    expression.push(number);
                    number = '';
                }

                if (idx !== lastIdx) {
                    expression.push(element);
                }
            }
        } else {
            number += element;
        }

        if (idx === lastIdx && number !== '') {
            expression.push(number);
        }
    }
    return expression;
}

function isPrioritized(one, other) {
    return OperatorLevels[one] > OperatorLevels[other];
}

export function isOperator(operator) {
    return (
        operator === '+' || operator === '-' || operator === '*' || operator === '/'
    );
}

function isSymbol(symbol) {
    return symbol === '+' || symbol === '-';
}

function isGrouping(operator) {
    return operator === '(' || operator === ')';
}

export function calc(content) {
    const infixExpression = parseInfixExpression(content);
    const suffixExpression = toSuffixExpression(infixExpression);
    return calcSuffixExpression(suffixExpression);
}
