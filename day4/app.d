import std.stdio;
import std.array;
import std.algorithm;
import std.conv;
import std.typecons;
import std.regex;
import std.range;

enum EntryType {
    beginShift,
    fallAsleep,
    wakeUp,
}

struct Entry {
    int month;
    int day;
    int absoluteDay() { return month * 31 + day; }
    int hour;
    int minute;
    int time() { return hour * 60 + minute; }

    EntryType type;
    int guard;
}

struct Guard {
    int id;
    int hoursAsleep;
    int[int] sleepMinutes;
    int mostAsleepMinute = -1;
}

void main()
{
    auto f = File("input.txt", "r");
    auto lines = f.byLineCopy.array;

    // Preprocess the data

    Entry[] entries;
    Guard[int] guards;

    foreach(line; lines) {
        auto m = line.matchFirst(regex(r"\[[0-9]+-([0-9]{2})-([0-9]{2}) ([0-9]{2}):([0-9]{2})\]\s*(.+)"));
        Entry entry;
        entry.month = m[1].to!int;
        entry.day = m[2].to!int;
        entry.hour = m[3].to!int;
        entry.minute = m[4].to!int;

        if(m[5] == "falls asleep")
            entry.type = EntryType.fallAsleep;
        else if(m[5] == "wakes up")
            entry.type = EntryType.wakeUp;
        else {
            auto m2 = line.matchFirst(regex(r"#([0-9]+)"));
            int id = m2[1].to!int;
            entry.guard = id;

            if(id !in guards) {
                Guard guard;
                guard.id = id;

                guards[id] = guard;
            }
        }

        entries ~= entry;
    }

    entries = entries.sort!((a, b) => a.absoluteDay * 10000 + a.time < b.absoluteDay * 10000 + b.time).array;

    Guard* currentGuard;
    int sleepStart;
    foreach(entry; entries) {
        if(entry.type == EntryType.beginShift)
            currentGuard = &guards[entry.guard];
        else if(entry.type == EntryType.fallAsleep)
            sleepStart = entry.minute;
        else {
            foreach(i; sleepStart .. entry.minute) {
                currentGuard.sleepMinutes[i]++;
            }
            currentGuard.hoursAsleep += entry.minute - sleepStart;
        }

        //writefln("%s-%s %s:%s", entry.month, entry.day, entry.hour, entry.minute);
    }

    // Level 1

    {
        auto guard = guards.values.sort!((a, b) => a.hoursAsleep > b.hoursAsleep).front;
        auto minute = guard.sleepMinutes.keys.sort!((a, b) => guard.sleepMinutes[a] > guard.sleepMinutes[b]).front;
        
        writeln("Level 1: ", guard.id * minute);
    }

    // Level 2

    {
        foreach(ref guard; guards) {
            if(guard.sleepMinutes.length > 0)
                guard.mostAsleepMinute = guard.sleepMinutes.keys.sort!((a, b) => guard.sleepMinutes[a] > guard.sleepMinutes[b]).front;
        }

        auto guard = guards.values.filter!(g => g.mostAsleepMinute != -1).array.sort!((a, b) => a.sleepMinutes[a.mostAsleepMinute] > b.sleepMinutes[b.mostAsleepMinute]).front;

        writeln("Level 2: ", guard.id * guard.mostAsleepMinute);
    }
}