//
//  main.swift
//  Section1
//
//  Created by 强新宇 on 2024/3/6.
//

import Foundation

typealias Time = (start: Int, end: Int)


func checkTwoTimeConflict(_ time1: Time, _ time2: Time) -> Bool {
    
    if time1.end <= time2.start || time1.start >= time2.end ||
        time2.end <= time1.start || time2.start >= time1.end
    {
        return false
    }
    
    return true
    
}


/// O( n² )
@discardableResult
func checkCanAttendMeeting(times: [Time]) -> Bool {
    for (index1, time1) in times.enumerated() {
        for (index2, time2) in times.enumerated() {
            if index1 == index2 {
                continue
            }
            if checkTwoTimeConflict(time1, time2) {
                return false
            }
        }
    }
    
    return true
}

/// O( nlog(n) )
@discardableResult
func checkCanAttendMeeting2(times: [Time]) -> Bool {
    
    var sortTimes = [Time]()
    
    for time in times {
        if sortTimes.count == 0 {
            sortTimes.append(time)
            continue
        }
        
        var endIndex = sortTimes.count - 1
        var index = sortTimes.count / 2
        
        while true {
            let value = sortTimes[index]
            
            if checkTwoTimeConflict(time, value) {
                return false
            }
            
       
            if time.start >= value.end {
                if index == sortTimes.count - 1 {
                    sortTimes.append(time)
                    break
                }
                let right = sortTimes[index + 1]
                if right.start >= time.end {
                    sortTimes.insert(time, at: index + 1)
                    break
                }
                if checkTwoTimeConflict(time, right) {
                    return false
                }
                index += max((endIndex - index) / 2, 1)
                continue
            }
            
            if time.end <= value.start {
                if index == 0 {
                    sortTimes.insert(time, at: 0)
                    break
                }
                
                let left = sortTimes[index - 1]
                if left.end <= time.start {
                    sortTimes.insert(time, at: index)
                    break
                }
                
                if checkTwoTimeConflict(time, left) {
                    return false
                }
                
                index /= 2
                endIndex /= 2
                continue
            }
            
        }
    }
    
    return true
}


var testList = [
    [(1, 2), (4, 5), (10, 20), (8, 9)],
    [(0,30), (5,10), (15,20)],
    [(1,5), (8,9), (8,10)],
    [(1,5), (5,9)],
    [(2,5), (-2,1), (8, 12), (6, 7)],
    [(2,5), (-2,3), (8, 12), (6, 7)]
]

for _ in 0...400000 {
    var tmpList = [(Int, Int)]()
    for _ in 0...20 {
        let start = Int.random(in: 1...10000)
        let end = start + Int.random(in: 1...20)
        tmpList.append((start, end))
    }
    
    testList.append(tmpList)
}


testList.forEach {
    let r1 = checkCanAttendMeeting(times: $0)
    let r2 = checkCanAttendMeeting2(times: $0)
    
    if r1 != r2 {
        print("times", $0)
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!")
    }
}



var startTime = Date()


testList.forEach {  checkCanAttendMeeting(times: $0) }

// 47.42938196659088
print("checkCanAttendMeeting use time", Date().timeIntervalSince(startTime))




startTime = Date()

testList.forEach { checkCanAttendMeeting2(times: $0) }

// 6.1481709480285645
print("checkCanAttendMeeting2 use time", Date().timeIntervalSince(startTime))


