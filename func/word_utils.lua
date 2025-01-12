scrabble_distribution = {
    a = 9, b = 2, c = 2, d = 4, e = 12, f = 2, g = 3, h = 2, i = 9, j = 1, 
    k = 1, l = 4, m = 2, n = 6, o = 8, p = 2, q = 1, r = 6, s = 4, t = 6, 
    u = 4, v = 2, w = 2, x = 1, y = 2, z = 1, ["#"] = 2
}

scrabble_letters = {}

for letter, count in pairs(scrabble_distribution) do
    for i = 1, count do
        table.insert(scrabble_letters, letter)
    end
end


aiko_alphabets = {}
aiko_alphabets_no_wilds = {}
aiko_alphabets_to_num = {}
for i = 97, 122 do
    table.insert(aiko_alphabets, string.char(i))
    table.insert(aiko_alphabets_no_wilds, string.char(i))
    aiko_alphabets_to_num[string.char(i)] = i - 96
end
table.insert(aiko_alphabets,"#")
aiko_alphabets_to_num["#"] = 27

function alphabet_delta(alpha, delta) 
    local numero = aiko_alphabets_to_num[alpha] + delta
    while numero < 1 do
        numero = numero + #aiko_alphabets
    end
    if numero > #aiko_alphabets then
        numero = math.fmod(numero, #aiko_alphabets)
    end
    --print(aiko_alphabets[numero])
    return aiko_alphabets[numero]
end


function check_word(str_arr_in, length)
    local wild_count = 0
    local word_composite = ""
    for _, val in ipairs(str_arr_in) do
        if val == "#" then
            wild_count = wild_count + 1
        end
        word_composite = word_composite..val
    end
    --print("CHECKING "..word_composite.." WITH "..wild_count)
    if wild_count == 0 then
        if words[word_composite] and #str_arr_in == length then
            return true
        else
            return false
        end
    end
    for i, v in ipairs(str_arr_in) do
        if v == "#" then
            for k, v2 in ipairs(aiko_alphabets_no_wilds)do
                local new_arr = {}
                for m, v3 in ipairs(str_arr_in) do
                    if i == m then
                        table.insert(new_arr,v2)
                    else
                        table.insert(new_arr,v3)
                    end
                end
                if check_word(new_arr,length) then
                    return true
                end
            end 
        end 
    end
    return false
    
end