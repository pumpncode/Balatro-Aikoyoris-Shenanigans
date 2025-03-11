AKYRS.scrabble_distribution = {
    a = 9, b = 2, c = 2, d = 4, e = 12, f = 2, g = 3, h = 2, i = 9, j = 1, 
    k = 1, l = 4, m = 2, n = 6, o = 8, p = 2, q = 1, r = 6, s = 4, t = 6, 
    u = 4, v = 2, w = 2, x = 1, y = 2, z = 1, ["#"] = 2
}

AKYRS.scrabble_scores = {
    a = 1, b = 3, c = 3, d = 2, e = 1, f = 4, g = 2, h = 4, i = 1, j = 8, 
    k = 5, l = 1, m = 3, n = 1, o = 1, p = 3, q = 10, r = 1, s = 1, t = 1, 
    u = 1, v = 4, w = 4, x = 8, y = 4, z = 10, ["#"] = 0
}


AKYRS.scrabble_letters = {}

for letter, count in pairs(AKYRS.scrabble_distribution) do
    for i = 1, count do
        table.insert(AKYRS.scrabble_letters, letter)
    end
end

AKYRS.get_scrabble_score = function(letter)

    if AKYRS.scrabble_scores[letter] then
        return AKYRS.scrabble_scores[letter]
    end
    if AKYRS.scrabble_scores[letter:lower()] then
        return AKYRS.scrabble_scores[letter:lower()]
    end
    return 0
end