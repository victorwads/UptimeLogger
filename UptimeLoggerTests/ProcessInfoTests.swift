//
//  ProcessInfoTests.swift
//  UptimeLoggerTests
//
//  Created by Victor Wads on 18/04/23.
//

import XCTest

@testable import UptimeLogger

class ProcessInfoTests: XCTestCase {

    func testProcessFile() {
        let input = """
USER               PID  %CPU %MEM STARTED      TIME COMMAND
root                 1   1,1  0,1 11:42     2:35.88 /sbin/launchd
root                78   0,4  0,2 11:42     1:29.49 /usr/libexec/logd
root                80   0,0  0,1 11:42     0:04.43 /usr/libexec/UserEventAgent (System)
_windowserver      145   4,0  1,0 11:42    32:59.23 /System/Library/PrivateFrameworks/SkyLight.framework/Resources/WindowServer -daemon
_cmiodalassistants   253   0,0  0,0 11:42     0:00.94 /usr/sbin/distnoted agent
_installcoordinationd 16197   0,0  0,0  6:16     0:00.48 /usr/sbin/distnoted agent
victorwads       25544   0,0  0,1  8:12     0:00.10 /System/Library/Frameworks/CoreServices.framework/Frameworks/Metadata.framework/Versions/A/Support/mdworker_shared -s mdworker -c MDSImporterWorker -m com.apple.mdworker.shared
root             43331   0,0  0,0  4:57     0:00.01 login -pf victorwads
victorwads       43333   0,0  0,0  4:57     0:00.37 -zsh
root             25751   0,0  0,0  8:12     0:00.01 ps -ax -o user,pid,pcpu,pmem,start,time,command
root             46727   0,0  0,0  4:59     0:00.01 login -pfl victorwads /bin/bash -c exec -la zsh /bin/zsh
victorwads       46730   1,6  0,0  4:59     0:04.57 -zsh
"""

        let actualOutput = ProcessLogInfo.processFile(content: input)
        
        XCTAssertEqual(actualOutput.count, 12)
        
        XCTAssertEqual(actualOutput[0].user, "root")
        XCTAssertEqual(actualOutput[0].pid, 1)
        XCTAssertEqual(actualOutput[0].cpu, 1.1)
        XCTAssertEqual(actualOutput[0].mem, 0.1)
        XCTAssertEqual(actualOutput[0].started, "11:42")
        XCTAssertEqual(actualOutput[0].time, "2:35.88")
        XCTAssertEqual(actualOutput[0].command, "/sbin/launchd")
        
        XCTAssertEqual(actualOutput[1].user, "root")
        XCTAssertEqual(actualOutput[1].pid, 78)
        XCTAssertEqual(actualOutput[1].cpu, 0.4)
        XCTAssertEqual(actualOutput[1].mem, 0.2)
        XCTAssertEqual(actualOutput[1].started, "11:42")
        XCTAssertEqual(actualOutput[1].time, "1:29.49")
        XCTAssertEqual(actualOutput[1].command, "/usr/libexec/logd")
        
        XCTAssertEqual(actualOutput[2].user, "root")
        XCTAssertEqual(actualOutput[2].pid, 80)
        XCTAssertEqual(actualOutput[2].cpu, 0.0)
        XCTAssertEqual(actualOutput[2].mem, 0.1)
        XCTAssertEqual(actualOutput[2].started, "11:42")
        XCTAssertEqual(actualOutput[2].time, "0:04.43")
        XCTAssertEqual(actualOutput[2].command, "/usr/libexec/UserEventAgent (System)")

        XCTAssertEqual(actualOutput[3].user, "_windowserver")
        XCTAssertEqual(actualOutput[3].pid, 145)
        XCTAssertEqual(actualOutput[3].cpu, 4.0)
        XCTAssertEqual(actualOutput[3].mem, 1.0)
        XCTAssertEqual(actualOutput[3].started, "11:42")
        XCTAssertEqual(actualOutput[3].time, "32:59.23")
        XCTAssertEqual(actualOutput[3].command, "/System/Library/PrivateFrameworks/SkyLight.framework/Resources/WindowServer -daemon")

        XCTAssertEqual(actualOutput[4].user, "_cmiodalassistants")
        XCTAssertEqual(actualOutput[4].pid, 253)
        XCTAssertEqual(actualOutput[4].cpu, 0.0)
        XCTAssertEqual(actualOutput[4].mem, 0.0)
        XCTAssertEqual(actualOutput[4].started, "11:42")
        XCTAssertEqual(actualOutput[4].time, "0:00.94")
        XCTAssertEqual(actualOutput[4].command, "/usr/sbin/distnoted agent")

        XCTAssertEqual(actualOutput[5].user, "_installcoordinationd")
        XCTAssertEqual(actualOutput[5].pid, 16197)
        XCTAssertEqual(actualOutput[5].cpu, 0.0)
        XCTAssertEqual(actualOutput[5].mem, 0.0)
        XCTAssertEqual(actualOutput[5].started, "6:16")
        XCTAssertEqual(actualOutput[5].time, "0:00.48")
        XCTAssertEqual(actualOutput[5].command, "/usr/sbin/distnoted agent")

        XCTAssertEqual(actualOutput[6].user, "victorwads")
        XCTAssertEqual(actualOutput[6].pid, 25544)
        XCTAssertEqual(actualOutput[6].cpu, 0.0)
        XCTAssertEqual(actualOutput[6].mem, 0.1)
        XCTAssertEqual(actualOutput[6].started, "8:12")
        XCTAssertEqual(actualOutput[6].time, "0:00.10")
        XCTAssertEqual(actualOutput[6].command, "/System/Library/Frameworks/CoreServices.framework/Frameworks/Metadata.framework/Versions/A/Support/mdworker_shared -s mdworker -c MDSImporterWorker -m com.apple.mdworker.shared")
        
        XCTAssertEqual(actualOutput[7].user, "root")
        XCTAssertEqual(actualOutput[7].pid, 43331)
        XCTAssertEqual(actualOutput[7].cpu, 0.0)
        XCTAssertEqual(actualOutput[7].mem, 0.0)
        XCTAssertEqual(actualOutput[7].started, "4:57")
        XCTAssertEqual(actualOutput[7].time, "0:00.01")
        XCTAssertEqual(actualOutput[7].command, "login -pf victorwads")
        
        XCTAssertEqual(actualOutput[8].user, "victorwads")
        XCTAssertEqual(actualOutput[8].pid, 43333)
        XCTAssertEqual(actualOutput[8].cpu, 0.0)
        XCTAssertEqual(actualOutput[8].mem, 0.0)
        XCTAssertEqual(actualOutput[8].started, "4:57")
        XCTAssertEqual(actualOutput[8].time, "0:00.37")
        XCTAssertEqual(actualOutput[8].command, "-zsh")
        
        XCTAssertEqual(actualOutput[9].user, "root")
        XCTAssertEqual(actualOutput[9].pid, 25751)
        XCTAssertEqual(actualOutput[9].cpu, 0.0)
        XCTAssertEqual(actualOutput[9].mem, 0.0)
        XCTAssertEqual(actualOutput[9].started, "8:12")
        XCTAssertEqual(actualOutput[9].time, "0:00.01")
        XCTAssertEqual(actualOutput[9].command, "ps -ax -o user,pid,pcpu,pmem,start,time,command")
        
        XCTAssertEqual(actualOutput[10].user, "root")
        XCTAssertEqual(actualOutput[10].pid, 46727)
        XCTAssertEqual(actualOutput[10].cpu, 0.0)
        XCTAssertEqual(actualOutput[10].mem, 0.0)
        XCTAssertEqual(actualOutput[10].started, "4:59")
        XCTAssertEqual(actualOutput[10].time, "0:00.01")
        XCTAssertEqual(actualOutput[10].command, "login -pfl victorwads /bin/bash -c exec -la zsh /bin/zsh")

        XCTAssertEqual(actualOutput[11].user, "victorwads")
        XCTAssertEqual(actualOutput[11].pid, 46730)
        XCTAssertEqual(actualOutput[11].cpu, 1.6)
        XCTAssertEqual(actualOutput[11].mem, 0.0)
        XCTAssertEqual(actualOutput[11].started, "4:59")
        XCTAssertEqual(actualOutput[11].time, "0:04.57")
        XCTAssertEqual(actualOutput[11].command, "-zsh")

    }


}
