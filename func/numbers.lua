local DIGITS_WORDS = {"zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}
local TEENS_WORDS = {"", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"}
local TENTHS_WORDS = {"", "ten", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"}
local TEN_POWERS = {"", "thousand", "million", "billion", "trillion", "quadrillion", "quintillion", "sextillion", "septillion", "octillion", "nonillion", "decillion", "undecillion", "duodecillion", "tredecillion", "quattuordecillion", "quindecillion", "sexdecillion", "septendecillion", "octodecillion", "novemdecillion", "vigintillion"}
local PLE_WORDS = {"", "Double", "Triple", "Quadruple", "Quintuple", "Sextuple", "Septuple", "Octuple", "Nonuple", "Decuple"}
local function capitalize(str)
    return (str:gsub("^%l", string.upper))
end

function getPleWord(i)
    return PLE_WORDS[i]
end


function aiko_numberToWords(n)
    if n < 10 then
        return capitalize(DIGITS_WORDS[n + 1])
    elseif n == 10 then
        return capitalize(TENTHS_WORDS[2])
    elseif n < 20 then
        return capitalize(TEENS_WORDS[n - 10 + 1])
    elseif n < 100 then
        local tens = math.floor(n / 10)
        local units = n % 10
        if units == 0 then
            return capitalize(TENTHS_WORDS[tens + 1])
        else
            return capitalize(TENTHS_WORDS[tens + 1]) .. "-" .. capitalize(DIGITS_WORDS[units + 1])
        end
    elseif n < 1000 then
        local hundreds = math.floor(n / 100)
        local rest = n % 100
        if rest == 0 then
            return capitalize(DIGITS_WORDS[hundreds + 1]) .. " Hundred"
        else
            return capitalize(DIGITS_WORDS[hundreds + 1]) .. " Hundred And " .. aiko_numberToWords(rest)
        end
    else
        local words = {}
        local power = math.floor(math.log(n, 1000))
        for i = power, 0, -1 do
            local part = math.floor(n / (1000 ^ i))
            if part > 0 then
                table.insert(words, capitalize(aiko_numberToWords(part)) .. " " .. capitalize(TEN_POWERS[i + 1]))
                n = n % (1000 ^ i)
            end
        end
        return table.concat(words, " ")

    end
end