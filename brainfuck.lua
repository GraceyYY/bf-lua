bfValidCommands = "><+-.,[]"

function bfLua(code, inputs)

    array = {0}
    pointerIndex = 1
    codeIndex = 1
    leftBrackets = {}
    result = {}
    inputIndex = 0

    processedInputs = convertInputToAscii(inputs)
    processedCode = convertCode(code)

    while (codeIndex <= #processedCode)
    do
      command = processedCode[codeIndex]
        if(command == ">") then
            pointerIndex = pointerIndex == 30000 and 1 or (pointerIndex + 1)
            array[pointerIndex] = array[pointerIndex] == nil and 0 or array[pointerIndex]
            codeIndex = codeIndex + 1
        elseif(command == "<") then
            pointerIndex = pointerIndex == 1 and 29999 or (pointerIndex - 1)
            array[pointerIndex] = array[pointerIndex] == nil and 0 or array[pointerIndex]
            codeIndex = codeIndex + 1
        elseif(command == "+") then
            array[pointerIndex] = array[pointerIndex] == 255 and 0 or (array[pointerIndex] + 1)
            codeIndex = codeIndex + 1
        elseif(command == "-") then
            array[pointerIndex] = array[pointerIndex] == 0 and 255 or (array[pointerIndex] - 1)
            codeIndex = codeIndex + 1
        elseif(command == ".") then
            table.insert(result, string.char(array[pointerIndex]))
            codeIndex = codeIndex + 1
        elseif(command == ",") then
            if(processedInputs[inputIndex + 1] ~= nil) then
                array[pointerIndex] = processedInputs[inputIndex + 1]
                inputIndex = inputIndex + 1
            else
                error("Miss input at: ".."position "..index.." of commands")
            end
            codeIndex = codeIndex + 1
        elseif(command == "[") then
          if(array[pointerIndex] == 0) then
            codeIndex = jumpToTheMatchingBracket(codeIndex,processedCode) + 1;
          else
            table.insert(leftBrackets, codeIndex);
            codeIndex = codeIndex + 1
          end
        elseif(command == "]") then
          if(array[pointerIndex] == 0) then
            codeIndex = codeIndex + 1
            leftBrackets[#leftBrackets] = nil
          else
             codeIndex = leftBrackets[#leftBrackets] + 1
          end
        end
    end
    print(table.concat(result))
    printArray(result)
    return result
end


function convertCode(code)
    local result = {}
    if ((string.find(code, "%[") or string.find(code, "%]")) and (not isBracketMatching(code))) then
        error("Brackets not matching")
    end
    for i = 1, #code, 1 do
        char = string.sub(code, i, i)
        if(isValidCommand(char) and isBracketMatching(code)) then
            table.insert(result, i, char)
        end
    end
    return result
end

function isValidCommand(command)
    if(string.match(command, "%w") or nil == string.find(bfValidCommands, "%"..command)) then
        error("Invalid commands")
    end
    return true
end

function convertInputToAscii(input)
    local result = {}
    if(#input == 0) then
        return nil
    else
        for i,v in ipairs(input) do
            inputType = type(v)
            if(inputType == "number" and v >= 0 and v <256) then
                result[i] = v
            elseif(inputType == "string" and string.len(v) == 1) then
                result[i] = string.byte(v)
            else
                error("Invalid input")
            end
        end
    end
    return result
end

function getMatchingBracket(code, index)
    if(code[index] ~= "[") then
        error("Cannot find matching bracket")
    else
        leftBracketCount = 0
        rightBracketCount = 0
        for i,v in ipairs(processedCode) do
            if(i > index) then
                if (v == "[") then
                    leftBracketCount = leftBracketCount + 1
                elseif (v == ']') then
                    if(leftBracketCount == rightBracketCount) then
                        return i
                    else
                        rightBracketCount = rightBracketCount + 1
                    end
                end
            end
        end
    end
end

function isBracketMatching(code)
    return countCharacter(code, "%[") == countCharacter(code, "%]")
end

function countCharacter(code, char)
    local init = 0
    local counter = 0

    while (nil ~= init and init >= 0) do
        init = string.find(code, char, init+1)
        if(init ~= nil) then
            counter = counter + 1
        end
    end
    return counter
end

function jumpToTheMatchingBracket(index,commands)
  nbLeftBracket = 0
  for i = index + 1, #commands, 1 do
    if(commands[i] == '[') then
      nbLeftBracket = nbLeftBracket + 1
    elseif(commands[i] == ']') then
      if(nbLeftBracket == 0) then
        return i
      else
        nbLeftBracket = nbLeftBracket - 1
      end
    end
  end
end

function printArray(array)
    if(array ~= nil and #array > 0 and type(array) == "table") then
        for i,v in ipairs(array) do
        print(i.." => "..v)
        end
    else
        print(array)
    end
end
bfLua("++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+.>++.", {})
-- printArray(test)
