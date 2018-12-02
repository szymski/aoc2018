import std.stdio;
import std.array;
import std.algorithm;
import std.conv;
import std.typecons;

void main()
{
    auto f = File("input.txt", "r");
    auto lines = f.byLineCopy.array;

    // Level 1

    int twoTimes, threeTimes;
    foreach(line; lines) {
        auto result = line.getRepeats;
        twoTimes += result[0];
        threeTimes += result[1];
    }

    writeln("Level 1: ", twoTimes * threeTimes);

    // Level 2

    foreach(line1; lines) {
        foreach(line2; lines) {
            if(line1 == line2)
                continue;

            string value = getDifference(line1, line2);
            if(value) {
                writeln("Level 2: ", value);
                return;
            }
        }
    }
}

Tuple!(int, int) getRepeats(string text) {
    int[char] repeats;
    foreach(c; text)
        repeats[c]++;

    int twoRepeat = 0;
    int threeRepeat = 0;
    foreach(key, value; repeats) {
        if(value == 2)
            twoRepeat = 1;
        else if(value == 3)
            threeRepeat = 1;
    }

    return tuple(twoRepeat, threeRepeat);
}

string getDifference(string text1, string text2) {
    int diffCount = 0;
    int diffIndex = 0;
    foreach(i; 0 .. text1.length) {
        if(text1[i] != text2[i]) {
            diffIndex = i;
            diffCount++;
            if(diffCount >= 2)
                return null;
        }
    }

    if(diffCount == 1)
        return text1[0 .. diffIndex] ~ text1[diffIndex + 1 .. $];

    return null;
}